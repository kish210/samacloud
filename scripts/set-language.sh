#!/usr/bin/env bash
# ------------------------------------------------------------
# فارسی‌کردن کامل محیط Nextcloud + فعال‌کردن RTL پیش‌فرض
# ------------------------------------------------------------
set -euo pipefail
cd "$(dirname "$0")"
# shellcheck source=occ-helper.sh
source ./occ-helper.sh

echo ">> ست کردن زبان پیش‌فرض روی فارسی..."
occ config:system:set default_language   --value fa
occ config:system:set default_locale     --value fa_IR

echo ">> اجبار همه‌ی کاربرها به زبان فارسی (اختیاری)..."
# اگر می‌خواهی کاربرها خودشان زبان را عوض کنند، دو خط زیر را کامنت کن.
occ config:system:set force_language --value fa
occ config:system:set force_locale   --value fa_IR

echo ">> پاک‌سازی کش..."
occ maintenance:repair --include-expensive >/dev/null 2>&1 || true

echo "✅ زبان فارسی اعمال شد. (Nextcloud برای فارسی، چیدمان راست‌به‌چپ را خودکار فعال می‌کند)"
