<?php
/**
 * Test harness for public/api/contact.php.
 *
 * PHP's CLI SAPI does not emit HTTP status codes, so the status is printed to
 * stderr on shutdown and the test asserts on it. Request method, remote address
 * and the JSON body come from the environment / stdin, exactly as they would
 * from Apache.
 */
register_shutdown_function(static function (): void {
    $code = http_response_code();
    fwrite(STDERR, 'STATUS=' . ($code === false ? 200 : $code) . "\n");
});

require dirname(__DIR__, 2) . '/public/api/contact.php';
