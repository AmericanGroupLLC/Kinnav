<?php
/**
 * Exercises the form-tagging helpers from public/api/contact.php.
 *
 * The handler cannot show its work over HTTP: the tag ends up in a mail header
 * and a subject line, and mail() never succeeds under php-wasm, so an HTTP test
 * can only prove the request was not rejected. Calling the real functions
 * directly is what proves a waitlist signup is actually labelled differently
 * from a support enquiry.
 *
 * As with php-rate-limit.php the source is lifted out of the handler rather
 * than duplicated, so this fails if the implementation drifts.
 */

$source = file_get_contents(dirname(__DIR__, 2) . '/public/api/contact.php');

$extracted = '';
foreach ([
    'clean\(\$value\): string',
    'form_kind\(\$value\): string',
    'tag_subject\(string \$subject, string \$form\): string',
] as $signature) {
    if (!preg_match('/^function ' . $signature . '\s*\{.*?^\}/ms', $source, $fn)) {
        fwrite(STDERR, "EXTRACT_FAILED: {$signature}\n");
        exit(1);
    }
    $extracted .= $fn[0] . "\n";
}

foreach (['FORM_PREFIXES' => '/^const FORM_PREFIXES = \[.*?^\];/ms', 'DEFAULT_FORM' => "/^const DEFAULT_FORM = '[a-z]+';/m"] as $name => $pattern) {
    if (!preg_match($pattern, $source, $const)) {
        fwrite(STDERR, "CONST_NOT_FOUND: {$name}\n");
        exit(1);
    }
    eval($const[0]);
}

eval($extracted);

// label => [submitted form, submitted subject]
$cases = [
    'contact'       => ['contact', 'General Inquiry — Kinnav'],
    'waitlist'      => ['waitlist', 'Kinnav waitlist — Ada (Guardian)'],
    'unknown'       => ['nope', 'General Inquiry — Kinnav'],
    'missing'       => ['', 'General Inquiry — Kinnav'],
    'uppercase'     => ['WAITLIST', 'Kinnav waitlist — Ada'],
    'pretagged'     => ['waitlist', '[Waitlist] Kinnav waitlist — Ada'],
    'injected'      => ["waitlist\r\nBcc: attacker@evil.example", 'Kinnav waitlist — Ada'],
];

foreach ($cases as $label => [$form, $subject]) {
    $kind = form_kind($form);
    echo $label . ' kind=' . $kind . ' subject=' . tag_subject(clean($subject), $kind) . "\n";
}
