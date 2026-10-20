#!/usr/bin/env bash
# ------------------------------------------------------------
# occ-helper.sh
# این فایل مشخص می‌کند دستور occ نکست‌کلود چطور اجرا شود.
# بسته به نوع نصبت، مقدار NC_MODE را ست کن:
#   aio    -> نصب Nextcloud AIO (داخل Docker)
#   snap   -> نصب با snap
#   manual -> نصب دستی روی مسیر /var/www/nextcloud
#
# استفاده:  NC_MODE=aio ./set-language.sh
# یا متغیر را اینجا پیش‌فرض بگذار.
# ------------------------------------------------------------

NC_MODE="${NC_MODE:-aio}"

# نام کانتینر AIO (در صورت تفاوت عوضش کن)
AIO_CONTAINER="${AIO_CONTAINER:-nextcloud-aio-nextcloud}"
# مسیر نصب دستی
MANUAL_PATH="${MANUAL_PATH:-/var/www/nextcloud}"

occ() {
  case "$NC_MODE" in
    aio)
      docker exec --user www-data "$AIO_CONTAINER" php occ "$@"
      ;;
    snap)
      nextcloud.occ "$@"
      ;;
    manual)
      sudo -u www-data php "$MANUAL_PATH/occ" "$@"
      ;;
    *)
      echo "NC_MODE نامعتبر است: $NC_MODE (باید aio یا snap یا manual باشد)" >&2
      return 1
      ;;
  esac
}
