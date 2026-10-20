#!/usr/bin/env bash
# ------------------------------------------------------------
# برندینگ Sama Cloud + نصب اپ Custom CSS برای رفع ایرادهای RTL
# ------------------------------------------------------------
set -euo pipefail
cd "$(dirname "$0")"
source ./occ-helper.sh

echo ">> ست کردن نام و برند..."
occ config:app:set theming name       --value "Sama Cloud"
occ config:app:set theming productName --value "Sama Cloud"
occ config:app:set theming slogan      --value "فضای ابری سما"
# رنگ اصلی (دلخواه تغییر بده)
occ config:app:set theming color       --value "#0b5cab"

echo ">> نصب و فعال‌سازی اپ Custom CSS (برای تزریق CSS رفع RTL)..."
occ app:install theming_customcss 2>/dev/null || true
occ app:enable  theming_customcss 2>/dev/null || true

echo ""
echo "✅ برندینگ اعمال شد."
echo "حالا محتوای فایل css/rtl-fixes.css را در این مسیر جای‌گذاری کن:"
echo "   Administration settings → Theming → Custom CSS"
