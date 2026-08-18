#!/usr/bin/env ruby
# frozen_string_literal: true
#
# Show what each review submission actually contains. Useful when the App
# Store Connect UI reports "To submit your items for review, add an app
# version for the selected platform" — that means a submission holds only
# in-app purchases with no appStoreVersion alongside them.

require 'jwt'
require 'openssl'
require 'net/http'
require 'json'

require_relative 'asc_env'
APP = asc_app_id




_, body = asc_get("/v1/apps/#{APP}/reviewSubmissions?limit=10")
(body['data'] || []).each do |s|
  puts "submission #{s['id']}  state=#{s.dig('attributes', 'state')}"
  _, items = asc_get("/v1/reviewSubmissions/#{s['id']}/items")
  (items['data'] || []).each do |it|
    rels = (it['relationships'] || {}).reject { |_, v| v['data'].nil? }
    rels.each do |name, v|
      puts "    #{name}: #{v.dig('data', 'id')}  (state=#{it.dig('attributes', 'state')})"
    end
    puts "    (no populated relationship)" if rels.empty?
  end
  puts '    (empty)' if (items['data'] || []).empty?
end
