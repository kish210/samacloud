#!/usr/bin/env bash
# ------------------------------------------------------------
# اعمال override ترجمه‌ی فارسی روی همه‌ی اپ‌های داخل ../l10n/
# هر زیرپوشه در l10n/ نام یک اپ است (core, files, settings, ...).
# نکته: بعد از هر آپدیت نکست‌کلود باید دوباره اجرا شود (update.sh این‌کار را می‌کند).
# ------------------------------------------------------------
set -euo pipefail
cd "$(dirname "$0")"
source ./occ-helper.sh

L10N_DIR="$(cd ../l10n && pwd)"

# مسیر پایه‌ی نصب نکست‌کلود داخل هر حالت
case "$NC_MODE" in
  aio)    BASE="/var/www/html" ;;
  snap)   BASE="/var/snap/nextcloud/current/nextcloud/htdocs" ;;
  manual) BASE="$MANUAL_PATH" ;;
esac

# مسیر مقصد l10n برای یک اپ (core جداست، بقیه زیر apps/ هستند)
dest_for() {
  local app="$1"
  if [ "$app" = "core" ]; then
    echo "$BASE/core/l10n"
  else
    echo "$BASE/apps/$app/l10n"
  fi
}

# کپی یک فایل به داخل نصب، بسته به حالت
copy_in() {
  local src="$1" dst="$2"
  case "$NC_MODE" in
    aio)
      docker cp "$src" "$AIO_CONTAINER":"$dst"
      docker exec --user root "$AIO_CONTAINER" chown www-data:www-data "$dst"
      ;;
    snap)
      sudo cp "$src" "$dst"
      ;;
    manual)
      sudo cp "$src" "$dst"
      sudo chown www-data:www-data "$dst"
      ;;
  esac
}

for app_dir in "$L10N_DIR"/*/; do
  app="$(basename "$app_dir")"
  dst_dir="$(dest_for "$app")"
  echo ">> اعمال ترجمه برای اپ: $app"
  for f in fa.json fa.js; do
    if [ -f "$app_dir/$f" ]; then
      copy_in "$app_dir/$f" "$dst_dir/$f"
    fi
  done
done

echo ">> پاک‌سازی کش..."
occ maintenance:repair >/dev/null 2>&1 || true
echo "✅ override ترجمه برای همه‌ی اپ‌ها اعمال شد."
