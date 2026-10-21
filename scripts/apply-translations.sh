#!/usr/bin/env bash
# ------------------------------------------------------------
# ادغام (merge) override ترجمه‌ی فارسی با فایل‌های رسمیِ هر اپ.
# برخلاف نسخه‌ی قبلی، فایل رسمی را جایگزین نمی‌کند؛ فقط عبارت‌های
# داخل ../l10n/<app>/fa.json را روی ترجمه‌ی رسمی سوار می‌کند
# (عبارت‌های ما برنده‌اند) و سپس fa.js را از همان داده بازتولید می‌کند.
#
# نکته: بعد از هر آپدیت Nextcloud باید دوباره اجرا شود.
# ------------------------------------------------------------
set -euo pipefail
cd "$(dirname "$0")"
source ./occ-helper.sh

L10N_DIR="$(cd ../l10n && pwd)"

case "$NC_MODE" in
  aio)    BASE="/var/www/html" ;;
  snap)   BASE="/var/snap/nextcloud/current/nextcloud/htdocs" ;;
  manual) BASE="$MANUAL_PATH" ;;
esac

dest_dir() { # مسیر l10n هر اپ
  if [ "$1" = "core" ]; then echo "$BASE/core/l10n"; else echo "$BASE/apps/$1/l10n"; fi
}

# اسکریپت PHP که official fa.json را با override ادغام و fa.js را بازتولید می‌کند.
# آرگومان‌ها: 1=appId 2=مسیر fa.json رسمی 3=مسیر fa.js رسمی 4=مسیر override fa.json
read -r -d '' MERGE_PHP <<'PHP' || true
$app=$argv[1]; $ofj=$argv[2]; $ofjs=$argv[3]; $ovr=$argv[4];
$off = is_file($ofj) ? (json_decode(file_get_contents($ofj), true) ?: []) : [];
$o   = json_decode(file_get_contents($ovr), true) ?: [];
if (!isset($off['translations'])) $off['translations'] = [];
$plural = $off['pluralForm'] ?? ($o['pluralForm'] ?? 'nplurals=2; plural=(n > 1);');
$off['translations'] = array_merge($off['translations'], $o['translations'] ?? []);
$off['pluralForm'] = $plural;
file_put_contents($ofj, json_encode($off, JSON_UNESCAPED_UNICODE|JSON_PRETTY_PRINT|JSON_UNESCAPED_SLASHES));
$js = 'OC.L10N.register("'.$app.'", '.json_encode($off['translations'], JSON_UNESCAPED_UNICODE|JSON_UNESCAPED_SLASHES).', "'.$plural.'");'."\n";
file_put_contents($ofjs, $js);
echo "merged ".count($o['translations'] ?? [])." strings into $app\n";
PHP

for app_dir in "$L10N_DIR"/*/; do
  app="$(basename "$app_dir")"
  ovr="$app_dir/fa.json"
  [ -f "$ovr" ] || continue
  dir="$(dest_dir "$app")"
  echo ">> ادغام ترجمه برای اپ: $app"
  case "$NC_MODE" in
    aio)
      docker cp "$ovr" "$AIO_CONTAINER":/tmp/ovr_fa.json
      docker exec --user www-data "$AIO_CONTAINER" bash -c "php -r '$(printf '%s' "$MERGE_PHP")' '$app' '$dir/fa.json' '$dir/fa.js' /tmp/ovr_fa.json"
      docker exec --user root "$AIO_CONTAINER" rm -f /tmp/ovr_fa.json
      ;;
    snap|manual)
      php -r "$MERGE_PHP" "$app" "$dir/fa.json" "$dir/fa.js" "$ovr"
      ;;
  esac
done

echo ">> پاک‌سازی کش..."
occ maintenance:repair >/dev/null 2>&1 || true
echo "✅ ادغام ترجمه انجام شد (ترجمه‌های رسمی حفظ شدند)."
