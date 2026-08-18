#!/usr/bin/env ruby
# frozen_string_literal: true
#
# Pull a version back out of review.
#
#   bundle exec ruby tools/cancel_review_submission.rb              # list only
#   bundle exec ruby tools/cancel_review_submission.rb --cancel ID  # one target
#
# Equivalent of "Remove from Review" in App Store Connect. Needed when a
# version was submitted without its in-app purchases attached.
#
# The submission ID is REQUIRED. An earlier version of this script cancelled
# every cancellable submission it found, which pulled a live WAITING_FOR_REVIEW
# submission out of review while trying to clear an unrelated stale one.

require 'jwt'
require 'openssl'
require 'net/http'
require 'json'

require_relative 'asc_env'
APP = asc_app_id

DO_CANCEL = ARGV.include?('--cancel')
TARGET_ID = ARGV[ARGV.index('--cancel') + 1] if DO_CANCEL
if DO_CANCEL && (TARGET_ID.nil? || TARGET_ID.start_with?('--'))
  abort "✗ --cancel requires a submission id: --cancel <reviewSubmission-id>\n" \
        '  Run without arguments to list them.'
end




_, body = asc_api(:get, "/v1/apps/#{APP}/reviewSubmissions?limit=10")
subs = body['data'] || []
puts "review submissions: #{subs.size}"
subs.each { |s| puts "  #{s['id']} state=#{s.dig('attributes', 'state')}" }

exit 0 unless DO_CANCEL

subs.each do |s|
  next unless s['id'] == TARGET_ID # only ever touch the one asked for

  state = s.dig('attributes', 'state')
  unless %w[WAITING_FOR_REVIEW IN_REVIEW READY_FOR_REVIEW].include?(state)
    abort "✗ #{s['id']} is #{state} — not cancellable"
  end

  # Preferred: mark the submission canceled.
  code, resp = asc_api(:patch, "/v1/reviewSubmissions/#{s['id']}",
                   { data: { type: 'reviewSubmissions', id: s['id'],
                             attributes: { canceled: true } } })
  if %w[200 201].include?(code)
    puts "✓ canceled #{s['id']}"
    next
  end
  puts "  PATCH canceled -> #{code}\n    #{asc_errors(resp)}"

  # Fallback: an unsubmitted submission can simply be deleted.
  code, resp = asc_api(:delete, "/v1/reviewSubmissions/#{s['id']}")
  if %w[200 204].include?(code)
    puts "✓ deleted #{s['id']}"
  else
    puts "  DELETE -> #{code}\n    #{asc_errors(resp)}"
  end
end

_, body = asc_api(:get, "/v1/apps/#{APP}/appStoreVersions?limit=1")
v = (body['data'] || []).first
puts "\nversion #{v.dig('attributes', 'versionString')} state=" \
     "#{v.dig('attributes', 'appStoreState') || v.dig('attributes', 'appVersionState')}"
