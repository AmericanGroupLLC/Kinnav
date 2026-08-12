<?php
/**
 * Exercises rate_limit_ok() from public/api/contact.php inside a single PHP
 * process.
 *
 * It cannot be driven over HTTP under php-wasm: each request there gets a
 * fresh in-memory filesystem, so the counter file never survives between
 * requests. Running the real function repeatedly in one process tests the
 * logic that matters — the counter, the cap, and the hourly window.
 *
 * The function source is lifted out of the handler rather than duplicated, so
 * this test fails if the implementation changes.
 */

$source = file_get_contents(dirname(__DIR__, 2) . '/public/api/contact.php');

$extracted = '';
foreach (['rate_limit_dir\(\): string', 'rate_limit_ok\(\): bool'] as $signature) {
    if (!preg_match('/^function ' . $signature . '\s*\{.*?^\}/ms', $source, $fn)) {
        fwrite(STDERR, "EXTRACT_FAILED: {$signature}\n");
        exit(1);
    }
    $extracted .= $fn[0] . "\n";
}
if (!preg_match('/const MAX_PER_IP\s*=\s*(\d+)/', $source, $cap)) {
    fwrite(STDERR, "CAP_NOT_FOUND\n");
    exit(1);
}

define('MAX_PER_IP', (int) $cap[1]);
$_SERVER['REMOTE_ADDR'] = getenv('TEST_IP') ?: '198.51.100.7';

eval($extracted);

$results = [];
for ($i = 0; $i < MAX_PER_IP + 2; $i++) {
    $results[] = rate_limit_ok() ? 'ok' : 'blocked';
}

echo 'cap=' . MAX_PER_IP . ' ' . implode(',', $results) . "\n";

// Clean up the counter directory. php-wasm has no writable system temp dir, so
// the handler falls back to public/api/.state — which must never be left behind
// for `vite build` to copy into the deployable output.
$state = dirname(__DIR__, 2) . '/public/api/.state';
if (is_dir($state)) {
    foreach (glob($state . '/*') ?: [] as $file) {
        @unlink($file);
    }
    @rmdir($state);
}
