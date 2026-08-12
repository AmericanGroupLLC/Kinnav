<?php
/**
 * kinnav.com form handler — contact + waitlist.
 *
 * Both forms POST JSON here and everything is delivered to one mailbox
 * (INBOX below), which is a cPanel account on this same server. Mail is
 * handed to the local MTA with mail(), so no SMTP password lives on disk;
 * the outgoing message is signed with the domain's DKIM key and passes SPF
 * because it originates from the host listed in the SPF record.
 *
 * Replies go to the visitor via Reply-To, so hitting Reply in webmail works.
 */

declare(strict_types=1);

const INBOX      = 'support@kinnav.com';
const FROM       = 'support@kinnav.com'; // must be a local mailbox for SPF/DKIM
const MAX_PER_IP = 5;                    // submissions per hour
const MAX_LEN    = 5000;

header('Content-Type: application/json; charset=utf-8');
header('Cache-Control: no-store');

if (($_SERVER['REQUEST_METHOD'] ?? '') !== 'POST') {
    http_response_code(405);
    header('Allow: POST');
    exit(json_encode(['ok' => false, 'error' => 'Method not allowed']));
}

$payload = json_decode((string) file_get_contents('php://input'), true);
if (!is_array($payload)) {
    fail(400, 'Malformed request.');
}

// Honeypot: a real visitor never fills a hidden field. Pretend it worked so
// the bot does not learn to work around it.
if (trim((string) ($payload['website'] ?? '')) !== '') {
    exit(json_encode(['ok' => true]));
}

$name    = clean($payload['name'] ?? '');
$email   = clean($payload['email'] ?? '');
$subject = clean($payload['subject'] ?? 'Kinnav website enquiry');
$body    = (string) ($payload['body'] ?? '');

if ($name === '' || $email === '' || trim($body) === '') {
    fail(422, 'Please fill in your name, email, and message.');
}
if (!filter_var($email, FILTER_VALIDATE_EMAIL)) {
    fail(422, 'That email address does not look valid.');
}
if (strlen($body) > MAX_LEN) {
    fail(422, 'That message is too long.');
}

if (!rate_limit_ok()) {
    fail(429, 'Too many messages from this connection. Please try again later.');
}

$ip = $_SERVER['REMOTE_ADDR'] ?? 'unknown';
$body .= "\n\nSubmitted: " . gmdate('Y-m-d H:i:s') . " UTC\nIP: {$ip}";

$headers = [
    'From: Kinnav Website <' . FROM . '>',
    'Reply-To: ' . mime_header($name) . ' <' . $email . '>',
    'MIME-Version: 1.0',
    'Content-Type: text/plain; charset=UTF-8',
    'X-Mailer: kinnav-web',
];

$sent = mail(
    INBOX,
    mime_header($subject),
    $body,
    implode("\r\n", $headers),
    '-f' . FROM
);

if (!$sent) {
    // The caller falls back to opening the visitor's mail client.
    fail(502, 'The mail server rejected the message.');
}

echo json_encode(['ok' => true]);

/**
 * Strips CR/LF so a submitted value cannot inject extra mail headers.
 */
function clean($value): string
{
    return trim(str_replace(["\r", "\n", "\0"], ' ', (string) $value));
}

/**
 * Encodes a header value that may contain non-ASCII (names, subjects).
 * mbstring is normally enabled on cPanel, but fall back to base64 rather than
 * fatally erroring if it is not.
 */
function mime_header(string $value): string
{
    if (preg_match('/[^\x20-\x7E]/', $value) !== 1) {
        return $value;
    }
    if (function_exists('mb_encode_mimeheader')) {
        return mb_encode_mimeheader($value, 'UTF-8');
    }

    return '=?UTF-8?B?' . base64_encode($value) . '?=';
}

function fail(int $status, string $error): void
{
    http_response_code($status);
    exit(json_encode(['ok' => false, 'error' => $error]));
}

/**
 * Per-IP hourly cap, kept in a temp file. Best-effort only — it exists to blunt
 * naive flooding, not to be an authoritative counter.
 */
function rate_limit_ok(): bool
{
    $ip   = $_SERVER['REMOTE_ADDR'] ?? 'unknown';
    $file = sys_get_temp_dir() . '/kinnav-form-' . sha1($ip) . '.txt';
    $now  = time();

    $hits = [];
    if (is_readable($file)) {
        $hits = array_filter(
            array_map('intval', explode(',', (string) file_get_contents($file))),
            static fn(int $t): bool => $t > $now - 3600
        );
    }

    if (count($hits) >= MAX_PER_IP) {
        return false;
    }

    $hits[] = $now;
    @file_put_contents($file, implode(',', $hits), LOCK_EX);

    return true;
}
