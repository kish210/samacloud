#!/usr/bin/env bash
# ------------------------------------------------------------
# اعمال override ترجمه‌ی فارسی روی اپ core نکست‌کلود
# (عبارت‌های داخل ../l10n/core/fa.* جایگزین پیش‌فرض می‌شوند)
# نکته: بعد از هر آپدیت نکست‌کلود باید دوباره اجرا شود (update.sh این‌کار را می‌کند).
# ------------------------------------------------------------
set -euo pipefail
cd "$(dirname "$0")"
source ./occ-helper.sh

SRC_DIR="$(cd ../l10n/core && pwd)"

case "$NC_MODE" in
  aio)
    echo ">> کپی فایل‌های ترجمه به داخل کانتینر AIO..."
    docker cp "$SRC_DIR/fa.json" "$AIO_CONTAINER":/var/www/html/core/l10n/fa.json
    docker cp "$SRC_DIR/fa.js"   "$AIO_CONTAINER":/var/www/html/core/l10n/fa.js
    docker exec --user root "$AIO_CONTAINER" chown www-data:www-data /var/www/html/core/l10n/fa.json /var/www/html/core/l10n/fa.js
    ;;
  snap)
    echo ">> کپی فایل‌های ترجمه (snap)..."
    sudo cp "$SRC_DIR/fa.json" /var/snap/nextcloud/current/nextcloud/htdocs/core/l10n/fa.json
    sudo cp "$SRC_DIR/fa.js"   /var/snap/nextcloud/current/nextcloud/htdocs/core/l10n/fa.js
    ;;
  manual)
    echo ">> کپی فایل‌های ترجمه (manual)..."
    sudo cp "$SRC_DIR/fa.json" "$MANUAL_PATH/core/l10n/fa.json"
    sudo cp "$SRC_DIR/fa.js"   "$MANUAL_PATH/core/l10n/fa.js"
    sudo chown www-data:www-data "$MANUAL_PATH/core/l10n/fa.json" "$MANUAL_PATH/core/l10n/fa.js"
    ;;
esac

echo ">> پاک‌سازی کش..."
occ maintenance:repair >/dev/null 2>&1 || true
echo "✅ override ترجمه اعمال شد."
