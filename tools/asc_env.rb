# frozen_string_literal: true
#
# Shared App Store Connect access for the Kinnav release tools.
#
# CalcMaster's tools each hardcoded `APP = '6781554668'`. Kinnav has no app
# record yet, so there is no id to hardcode — this resolves it from the bundle
# id at runtime and fails with a clear message when the record is missing.
#
# Overridable: ASC_KEY_PATH, ASC_KEY_ID, ASC_ISSUER_ID, ASC_BUNDLE_ID.

require 'jwt'
require 'openssl'
require 'net/http'
require 'json'

ASC_KEY_ID    = ENV.fetch('ASC_KEY_ID', 'UV8NYF9767')
ASC_ISSUER_ID = ENV.fetch('ASC_ISSUER_ID', 'ec93cc91-97c2-4b03-860b-697d7ec5d1fb')
ASC_BUNDLE_ID = ENV.fetch('ASC_BUNDLE_ID', 'com.americangroupllc.kinnav')

ASC_KEY_PATH = [
  ENV['ASC_KEY_PATH'],
  File.expand_path("../AuthKey_#{ASC_KEY_ID}.p8", __dir__),
  File.expand_path("~/Downloads/AuthKey_#{ASC_KEY_ID}.p8"),
  File.expand_path("~/agl/CalcMaster/AuthKey_#{ASC_KEY_ID}.p8")
].compact.find { |p| File.exist?(p) }

if ASC_KEY_PATH.nil?
  abort "✗ No AuthKey_#{ASC_KEY_ID}.p8 found. Put it in the repo root or set ASC_KEY_PATH."
end

ASC_PK = OpenSSL::PKey::EC.new(File.read(ASC_KEY_PATH))

def asc_token
  now = Time.now.to_i
  JWT.encode({ iss: ASC_ISSUER_ID, iat: now, exp: now + 900,
               aud: 'appstoreconnect-v1' },
             ASC_PK, 'ES256', { kid: ASC_KEY_ID, typ: 'JWT' })
end

def asc_api(method, path, body = nil)
  uri = URI("https://api.appstoreconnect.apple.com#{path}")
  klass = { get: Net::HTTP::Get, post: Net::HTTP::Post,
            patch: Net::HTTP::Patch, delete: Net::HTTP::Delete }.fetch(method)
  req = klass.new(uri)
  req['Authorization'] = "Bearer #{asc_token}"
  req['Content-Type'] = 'application/json'
  req.body = JSON.dump(body) if body
  res = Net::HTTP.start(uri.host, uri.port, use_ssl: true) { |h| h.request(req) }
  [res.code, (JSON.parse(res.body) rescue {})]
end

def asc_get(path)
  asc_api(:get, path)
end

def asc_errors(body)
  (body['errors'] || []).map { |e| "#{e['status']} #{e['code']}: #{e['detail']}" }.join("\n    ")
end

def asc_ok?(code)
  %w[200 201 204].include?(code)
end

# Resolve the numeric app id from the bundle id, memoized for the process.
def asc_app_id
  return @asc_app_id if defined?(@asc_app_id) && @asc_app_id

  code, body = asc_get("/v1/apps?filter[bundleId]=#{ASC_BUNDLE_ID}&limit=1")
  abort "✗ Could not list apps (HTTP #{code})" unless code == '200'
  app = (body['data'] || []).first
  if app.nil?
    abort "✗ No App Store Connect record for #{ASC_BUNDLE_ID}.\n" \
          "  Create it once: App Store Connect → My Apps → + → New App.\n" \
          "  (The public API cannot create app records; `produce` needs an\n" \
          "  Apple ID with interactive 2FA.)"
  end
  @asc_app_id = app['id']
end
