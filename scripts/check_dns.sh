#!/usr/bin/env bash
# Check whether kinnav.com DNS is correctly pointed at GitHub Pages.
#
#   ./scripts/check_dns.sh
#
# Run it after adding the records in HostGator's DNS tab. It is read-only —
# it changes nothing, it only reports. Propagation is usually minutes but can
# take up to 48 hours, so a failure right after saving records is normal.

set -uo pipefail

APEX="kinnav.com"
WWW="www.kinnav.com"
PAGES_HOST="americangroupllc.github.io"
EXPECTED_IPS=("185.199.108.153" "185.199.109.153" "185.199.110.153" "185.199.111.153")

pass=0; fail=0
ok()   { printf '  \033[32m✓\033[0m %s\n' "$1"; pass=$((pass+1)); }
bad()  { printf '  \033[31m✗\033[0m %s\n' "$1"; fail=$((fail+1)); }
info() { printf '    %s\n' "$1"; }

resolve() {  # resolve <name> -> IPv4 lines
  # Query a public resolver first. The local/system resolver caches aggressively
  # and will happily report a deleted record for hours, which makes this whole
  # script lie. Fall back to dig/getent only if the network call fails.
  local out
  out=$(curl -sS --max-time 15 "https://dns.google/resolve?name=$1&type=A" 2>/dev/null \
        | python3 -c 'import sys,json
try: d=json.load(sys.stdin)
except Exception: raise SystemExit
[print(a["data"]) for a in d.get("Answer",[]) if a.get("type")==1]' 2>/dev/null | sort -u)
  if [ -n "$out" ]; then printf '%s\n' "$out"; return; fi
  if command -v dig >/dev/null 2>&1; then
    dig +short "$1" A 2>/dev/null | grep -E '^[0-9]+\.' | sort -u
  else
    getent ahosts "$1" 2>/dev/null | awk '{print $1}' | grep -E '^[0-9]+\.' | sort -u
  fi
}

echo
echo "Checking DNS for $APEX -> GitHub Pages"
echo "======================================"
echo
# Step 0 matters: a registry hold removes the domain from DNS completely, so
# every lookup below returns NXDOMAIN and looks identical to "records missing".
# Check the registry first so the diagnosis is not misleading.
echo "0. Registry status (is the domain itself active?)"
rdap="$(curl -sS --max-time 20 -H 'Accept: application/rdap+json' \
        "https://rdap.verisign.com/com/v1/domain/$APEX" 2>/dev/null)"
if [ -z "$rdap" ]; then
  info "could not reach the registry (offline?) — skipping this check"
else
  dstatus="$(printf '%s' "$rdap" | python3 -c 'import sys,json
try: d=json.load(sys.stdin)
except Exception: raise SystemExit
print(",".join(d.get("status",[])))' 2>/dev/null)"
  if grep -qi "hold" <<<"$dstatus"; then
    bad "domain is SUSPENDED at the registry: $dstatus"
    info "A 'client hold' pulls the domain out of DNS, so nothing below can pass"
    info "no matter how correct your DNS records are."
    info "Usual cause on a new registration: the ICANN registrant-email"
    info "verification link was never clicked. Check the inbox (and spam) for"
    info "mail from HostGator, or contact HostGator support to lift the hold."
  elif [ -n "$dstatus" ]; then
    ok "domain active at registry (status: $dstatus)"
  fi
fi

echo
# DNSSEC: a zone whose DS is published at the parent but whose records are not
# correctly signed fails on validating resolvers (Cloudflare 1.1.1.1, Quad9).
# Symptom is intermittent SERVFAIL, which looks like a flaky network rather
# than a DNS misconfiguration — so test it explicitly, several times.
echo "0b. DNSSEC (published DS + does validation actually succeed?)"
ds_n=$(curl -sS --max-time 15 "https://dns.google/resolve?name=$APEX&type=DS" 2>/dev/null \
       | python3 -c 'import sys,json
try: d=json.load(sys.stdin)
except Exception: print(0); raise SystemExit
print(len([a for a in d.get("Answer",[]) if a.get("type")==43]))' 2>/dev/null || echo 0)
if [ "${ds_n:-0}" -eq 0 ]; then
  ok "DNSSEC not enabled (no DS at parent) — nothing to validate, safest default"
else
  servfail=0; total=5
  for _ in $(seq $total); do
    st=$(curl -sS --max-time 15 -H 'accept: application/dns-json' \
         "https://cloudflare-dns.com/dns-query?name=$APEX&type=A" 2>/dev/null \
         | python3 -c 'import sys,json
try: print(json.load(sys.stdin).get("Status"))
except Exception: print("err")' 2>/dev/null)
    [ "$st" = "2" ] && servfail=$((servfail+1))
  done
  if [ "$servfail" -gt 0 ]; then
    bad "DNSSEC is enabled but BROKEN — $servfail/$total queries to a validating resolver returned SERVFAIL"
    info "The DS record at .com says 'this zone is signed', but the zone's"
    info "answers do not validate. Validating resolvers (Cloudflare 1.1.1.1,"
    info "Quad9, many ISPs) therefore refuse to resolve the domain, so a share"
    info "of visitors get no site at all — intermittently."
    info "Fix: turn OFF 'Enable DNSSEC' in HostGator's DNS tab. It is optional"
    info "and not needed for GitHub Pages. Allow time for the DS to clear."
  else
    ok "DNSSEC enabled and validating cleanly ($total/$total queries OK)"
  fi
fi

echo
echo "1. Apex domain ($APEX)"
apex_ips="$(resolve "$APEX")"
if [ -z "$apex_ips" ]; then
  bad "$APEX does not resolve — no A record exists yet"
  info "Add four A records on host '@' in HostGator's DNS tab:"
  for ip in "${EXPECTED_IPS[@]}"; do info "    $ip"; done
else
  missing=()
  for ip in "${EXPECTED_IPS[@]}"; do
    grep -qx "$ip" <<<"$apex_ips" || missing+=("$ip")
  done
  extra="$(comm -23 <(echo "$apex_ips") <(printf '%s\n' "${EXPECTED_IPS[@]}" | sort -u))"
  [ ${#missing[@]} -eq 0 ] && ok "all four GitHub Pages A records present" \
    || bad "missing A record(s): ${missing[*]}"
  if [ -n "$extra" ]; then
    bad "unexpected extra A record(s) — these must be DELETED:"
    while read -r e; do [ -n "$e" ] && info "    $e  <-- not GitHub; will send some visitors elsewhere"; done <<<"$extra"
  else
    [ ${#missing[@]} -eq 0 ] && ok "no conflicting A records"
  fi
fi

echo
echo "2. www subdomain ($WWW)"
# Check for the CNAME explicitly. Comparing resolved IPs is not good enough:
# a www A record pointing at a parking server can coincidentally intersect
# whatever the Pages host resolves to during a flap, which produces a false pass.
www_cname="$(curl -sS --max-time 15 "https://dns.google/resolve?name=$WWW&type=CNAME" 2>/dev/null \
  | python3 -c 'import sys,json
try: d=json.load(sys.stdin)
except Exception: raise SystemExit
[print(a["data"].rstrip(".")) for a in d.get("Answer",[]) if a.get("type")==5]' 2>/dev/null)"
www_ips="$(resolve "$WWW")"
if [ -n "$www_cname" ]; then
  if [ "$www_cname" = "$PAGES_HOST" ]; then
    ok "$WWW is a CNAME to $PAGES_HOST"
  else
    bad "$WWW is a CNAME to '$www_cname' — expected $PAGES_HOST"
  fi
elif [ -n "$www_ips" ]; then
  bad "$WWW has an A record ($(tr '\n' ' ' <<<"$www_ips")) instead of a CNAME"
  info "Delete that A record, then add: CNAME  www  ->  $PAGES_HOST"
  info "A host cannot have both an A and a CNAME, so the A must go first."
else
  bad "$WWW does not resolve — no record exists yet"
  info "Add a CNAME record: host 'www'  ->  $PAGES_HOST"
fi

echo
echo "3. HTTPS response"
for host in "$APEX" "$WWW"; do
  # Note: on failure curl still writes "000", so do not append a fallback here
  # or the two concatenate into "000000".
  code="$(curl -sS -o /dev/null -w '%{http_code}' -L --max-time 15 "https://$host" 2>/dev/null)" || true
  [ -z "$code" ] && code="000"
  case "$code" in
    200) ok "https://$host returns 200" ;;
    000) bad "https://$host unreachable (expected until DNS resolves and the cert is issued)" ;;
    *)   bad "https://$host returned HTTP $code" ;;
  esac
done

echo
echo "4. Is GitHub serving it?"
srv="$(curl -sS -I -L --max-time 15 "https://$APEX" 2>/dev/null | grep -i '^server:' | head -1 | tr -d '\r')"
if grep -qi github <<<"$srv"; then
  ok "served by GitHub (${srv#*: })"
else
  bad "not served by GitHub — got '${srv:-no response}'"
  info "a tiny HTML page redirecting to /lander means the domain is still parked"
fi

echo
echo "======================================"
printf 'passed: %d   failed: %d\n' "$pass" "$fail"
if [ "$fail" -eq 0 ]; then
  echo "kinnav.com is correctly configured."
else
  echo "Not ready yet. Records go in HostGator -> Domains -> kinnav.com -> DNS."
  echo "Details: docs/DNS_KINNAV_COM.md"
fi
echo
[ "$fail" -eq 0 ]
