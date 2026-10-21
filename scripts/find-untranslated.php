<?php
/**
 * عبارت‌های ترجمه‌نشده‌ی یک اپ را پیدا می‌کند:
 * کلیدهایی که در یک زبانِ (تقریباً) کامل مثل de.json هستند ولی در fa.json نیستند.
 *
 * استفاده:
 *   php find-untranslated.php <l10n-dir> [ref-lang=de] [limit=0]
 * مثال (داخل کانتینر AIO):
 *   php find-untranslated.php /var/www/html/apps/settings/l10n de 0
 */
$dir   = $argv[1] ?? '';
$ref   = $argv[2] ?? 'de';
$limit = (int)($argv[3] ?? 0);

$faFile  = "$dir/fa.json";
$refFile = "$dir/$ref.json";

$load = function (string $f): array {
    if (!is_file($f)) return [];
    $j = json_decode(file_get_contents($f), true);
    return $j['translations'] ?? [];
};

$fa  = $load($faFile);
$rf  = $load($refFile);
if (!$rf) { fwrite(STDERR, "reference file not found or empty: $refFile\n"); exit(1); }

$missing = array_values(array_diff(array_keys($rf), array_keys($fa)));
fwrite(STDERR, sprintf("fa=%d  %s=%d  missing=%d\n", count($fa), $ref, count($rf), count($missing)));

if ($limit > 0) $missing = array_slice($missing, 0, $limit);
foreach ($missing as $m) {
    echo $m . "\n";
}
