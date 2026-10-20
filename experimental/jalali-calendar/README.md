# تقویم شمسی (Jalali) — تجربی

> ⚠️ **هشدار صادقانه:** Nextcloud از تقویم شمسی **پشتیبانی رسمی ندارد**.
> تنظیم locale روی `fa_IR` فقط اعداد و نام ماه‌ها را فارسی می‌کند ولی تاریخ‌ها **میلادی** می‌مانند.
> این ماژول تلاش می‌کند با تزریق `moment-jalaali` تاریخ‌ها را شمسی کند، اما چون نسخه‌های جدید
> Nextcloud کتابخانه‌ی moment را داخل ماژول‌های خودشان bundle می‌کنند، این override سراسری
> فقط روی بخش‌هایی اثر می‌گذارد که از moment سراسری استفاده می‌کنند. یعنی ممکن است **همه‌جا
> اعمال نشود** و در برخی نسخه‌ها اصلاً اثر نکند. حتماً اول روی یک محیط تست بررسی کن.

## این ماژول چیست؟
یک اپ کوچک Nextcloud به نام `jalali` که یک اسکریپت سراسری بارگذاری می‌کند
(`js/jalali.js`) و `moment-jalaali` را از CDN می‌آورد و تاریخ‌ها را شمسی می‌کند.

## نصب

### حالت AIO (Docker)
```bash
# کپی پوشه‌ی اپ به داخل کانتینر
docker cp experimental/jalali-calendar/jalali \
  nextcloud-aio-nextcloud:/var/www/html/custom_apps/jalali

docker exec --user root nextcloud-aio-nextcloud \
  chown -R www-data:www-data /var/www/html/custom_apps/jalali

# فعال‌سازی
docker exec --user www-data nextcloud-aio-nextcloud php occ app:enable jalali
```

### حالت snap
```bash
sudo cp -r experimental/jalali-calendar/jalali \
  /var/snap/nextcloud/current/nextcloud/extra-apps/jalali
sudo nextcloud.occ app:enable jalali
```

### حالت manual
```bash
sudo cp -r experimental/jalali-calendar/jalali /var/www/nextcloud/apps/jalali
sudo chown -R www-data:www-data /var/www/nextcloud/apps/jalali
sudo -u www-data php /var/www/nextcloud/occ app:enable jalali
```

## غیرفعال‌سازی
```bash
# (occ را مطابق حالت نصب خودت اجرا کن)
occ app:disable jalali
```

## اگر جواب نداد چه کنم؟
- این یعنی آن بخش از moment سراسری استفاده نمی‌کند؛ راه رسمی و پایداری برای اجبار شمسی وجود ندارد.
- گزینه‌ی مطمئن‌تر: همان locale فارسی (`fa_IR`) که ماه و عدد فارسی نشان می‌دهد (میلادی).
- برای تقویم رویدادها، اپ **Calendar** نکست‌کلود تقویم شمسی ندارد؛ این ماژول روی نمایش تاریخ است نه رویدادها.
