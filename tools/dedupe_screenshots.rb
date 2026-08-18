#!/usr/bin/env ruby
# frozen_string_literal: true
#
# Remove duplicate App Store screenshots.
#
# `deliver` runs its upload pass twice, so every `fastlane ios screenshots` run
# leaves two copies of each file in the set. The listing then shows the same
# image twice, which looks like a mistake because it is one.
#
#   bundle exec ruby tools/dedupe_screenshots.rb
require_relative 'asc_env'

APP = asc_app_id
_, b = asc_get("/v1/apps/#{APP}/appStoreVersions?limit=1")
vid = (b['data'] || []).first['id']
_, b = asc_get("/v1/appStoreVersions/#{vid}/appStoreVersionLocalizations")
loc = (b['data'] || []).find { |l| l.dig('attributes', 'locale') == 'en-US' }
_, b = asc_get("/v1/appStoreVersionLocalizations/#{loc['id']}/appScreenshotSets?include=appScreenshots")

shots = (b['included'] || []).select { |i| i['type'] == 'appScreenshots' }
removed = 0
shots.group_by { |s| s.dig('attributes', 'fileName') }.each do |name, group|
  group.drop(1).each do |dup|
    code, _ = asc_api(:delete, "/v1/appScreenshots/#{dup['id']}")
    puts "  removed duplicate #{name} (HTTP #{code})"
    removed += 1
  end
end
puts removed.zero? ? '✓ no duplicates' : "✓ removed #{removed}"
