<?php
/**
 * ادغام override فارسی با فایل ترجمه‌ی رسمیِ یک اپ (بدون پاک‌کردن رشته‌های رسمی).
 * fa.json رسمی را با override ادغام و fa.js را از همان داده بازتولید می‌کند.
 *
 * استفاده:
 *   php merge-fa.php <appId> <official_fa.json> <official_fa.js> <override_fa.json>
 */
$app    = $argv[1] ?? '';
$offJson = $argv[2] ?? '';
$offJs   = $argv[3] ?? '';
$ovr     = $argv[4] ?? '';

$load = function (string $f): array {
    if (!is_file($f)) return [];
    return json_decode(file_get_contents($f), true) ?: [];
};

$official = $load($offJson);
$over     = $load($ovr);

if (!isset($official['translations']) || !is_array($official['translations'])) {
    $official['translations'] = [];
}
$plural = $official['pluralForm'] ?? ($over['pluralForm'] ?? 'nplurals=2; plural=(n > 1);');

$official['translations'] = array_merge($official['translations'], $over['translations'] ?? []);
$official['pluralForm'] = $plural;

$jsonFlags = JSON_UNESCAPED_UNICODE | JSON_UNESCAPED_SLASHES | JSON_PRETTY_PRINT;
file_put_contents($offJson, json_encode($official, $jsonFlags));

$js = 'OC.L10N.register("' . $app . '", '
    . json_encode($official['translations'], JSON_UNESCAPED_UNICODE | JSON_UNESCAPED_SLASHES)
    . ', "' . $plural . '");' . "\n";
file_put_contents($offJs, $js);

fwrite(STDERR, 'merged ' . count($over['translations'] ?? []) . " strings into $app\n");
