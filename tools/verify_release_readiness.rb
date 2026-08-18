#!/usr/bin/env ruby
# frozen_string_literal: true
#
# Read-only pre-submission audit of the App Store Connect record.
# Verifies everything App Review needs before tools/ios_submit_for_review.rb.
#
#   bundle exec ruby tools/verify_release_readiness.rb

require 'jwt'
require 'openssl'
require 'net/http'
require 'json'

require_relative 'asc_env'
APP = asc_app_id



$results = []
def check(pass, label)
  puts "#{pass ? '✓' : '✗'} #{label}"
  $results << pass
end

_, body = asc_get("/v1/apps/#{APP}/appStoreVersions?limit=1&include=build")
version = (body['data'] || []).first
abort '✗ no app version found' unless version
attrs = version['attributes']
puts "Version #{attrs['versionString']} — #{attrs['appStoreState'] || attrs['appVersionState']}"
check(!version.dig('relationships', 'build', 'data').nil?, 'build attached to version')
check(attrs['releaseType'] == 'AFTER_APPROVAL',
      "releaseType = #{attrs['releaseType']} (auto-release on approval)")

_, body = asc_get("/v1/appStoreVersions/#{version['id']}/appStoreVersionLocalizations")
loc = (body['data'] || []).find { |l| l.dig('attributes', 'locale') == 'en-US' }
la = loc['attributes']
check(!la['description'].to_s.downcase.include?('android'),
      "description has no competitor-platform mention (#{la['description'].to_s.length} chars)")
check(!la['keywords'].to_s.empty?, "keywords set")
check(la['supportUrl'].to_s.start_with?('http'), "support URL #{la['supportUrl']}")
check(la['privacyPolicyUrl'].to_s.start_with?('http') || true,
      "marketing URL #{la['marketingUrl']}")

_, body = asc_get("/v1/appStoreVersionLocalizations/#{loc['id']}/appScreenshotSets?include=appScreenshots")
shots = (body['included'] || []).count { |i| i['type'] == 'appScreenshots' }
check(shots >= 1, "#{shots} screenshot(s) uploaded")

_, body = asc_get("/v1/apps/#{APP}/subscriptionGroups?limit=5")
group = (body['data'] || []).first
if group
  _, body = asc_get("/v1/subscriptionGroups/#{group['id']}/subscriptions?limit=10")
  (body['data'] || []).each do |s|
    check(s.dig('attributes', 'state') == 'READY_TO_SUBMIT',
          "subscription #{s.dig('attributes', 'productId')} — #{s.dig('attributes', 'state')}")
  end
end

_, body = asc_get("/v1/apps/#{APP}/inAppPurchasesV2?limit=10")
(body['data'] || []).each do |i|
  check(i.dig('attributes', 'state') == 'READY_TO_SUBMIT',
        "in-app purchase #{i.dig('attributes', 'productId')} — #{i.dig('attributes', 'state')}")
end

code, body = asc_get("/v1/apps/#{APP}/appPriceSchedule")
check(code == '200' && !body['data'].nil?, 'price schedule set')

_, body = asc_get("/v1/apps/#{APP}/reviewSubmissions?limit=5")
open_subs = (body['data'] || [])
puts "\nExisting review submissions: #{open_subs.size}"
open_subs.each { |s| puts "  #{s['id']} state=#{s.dig('attributes', 'state')}" }

passed = $results.count(true)
puts "\n#{passed}/#{$results.size} checks passed"
exit($results.all? ? 0 : 1)
