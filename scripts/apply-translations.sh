#!/usr/bin/env bash
# ------------------------------------------------------------
# ادغام (merge) override ترجمه‌ی فارسی با فایل‌های رسمیِ هر اپ.
# فایل رسمی را جایگزین نمی‌کند؛ فقط عبارت‌های داخل ../l10n/<app>/fa.json
# را روی ترجمه‌ی رسمی سوار می‌کند (عبارت‌های ما برنده‌اند) و fa.js را
# از همان داده بازتولید می‌کند. منطق ادغام در scripts/merge-fa.php است.
#
# نکته: بعد از هر آپدیت Nextcloud باید دوباره اجرا شود.
# ------------------------------------------------------------
set -euo pipefail
cd "$(dirname "$0")"
source ./occ-helper.sh

L10N_DIR="$(cd ../l10n && pwd)"
MERGE_PHP="$(pwd)/merge-fa.php"

case "$NC_MODE" in
  aio)    BASE="/var/www/html" ;;
  snap)   BASE="/var/snap/nextcloud/current/nextcloud/htdocs" ;;
  manual) BASE="$MANUAL_PATH" ;;
esac

dest_dir() { # مسیر l10n هر اپ (core جداست، بقیه زیر apps/ هستند)
  if [ "$1" = "core" ]; then echo "$BASE/core/l10n"; else echo "$BASE/apps/$1/l10n"; fi
}

for app_dir in "$L10N_DIR"/*/; do
  app="$(basename "$app_dir")"
  ovr="$app_dir/fa.json"
  [ -f "$ovr" ] || continue
  dir="$(dest_dir "$app")"
  echo ">> ادغام ترجمه برای اپ: $app"
  case "$NC_MODE" in
    aio)
      docker cp "$MERGE_PHP" "$AIO_CONTAINER":/tmp/merge-fa.php
      docker cp "$ovr"       "$AIO_CONTAINER":/tmp/ovr-fa.json
      docker exec --user www-data "$AIO_CONTAINER" php /tmp/merge-fa.php "$app" "$dir/fa.json" "$dir/fa.js" /tmp/ovr-fa.json
      docker exec --user root "$AIO_CONTAINER" rm -f /tmp/merge-fa.php /tmp/ovr-fa.json
      ;;
    snap|manual)
      php "$MERGE_PHP" "$app" "$dir/fa.json" "$dir/fa.js" "$ovr"
      ;;
  esac
done

echo ">> پاک‌سازی کش..."
occ maintenance:repair >/dev/null 2>&1 || true
echo "✅ ادغام ترجمه انجام شد (ترجمه‌های رسمی حفظ شدند)."
