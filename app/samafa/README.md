# Sama FA — اپ فارسی و تقویم شمسی برای Nextcloud

یک اپ واقعی Nextcloud که با یک بار نصب و فعال‌سازی:

- 🌐 زبان و locale پیش‌فرض را روی **فارسی (fa / fa_IR)** می‌گذارد
- ↔️ استایل **راست‌به‌چپ (RTL)** و فونت **Vazirmatn** را روی کل محیط اعمال می‌کند
- 📅 تلاش می‌کند تاریخ‌ها را به **شمسی** تبدیل کند (تجربی)

> ⚠️ **درباره‌ی تاریخ شمسی:** Nextcloud از تقویم شمسی پشتیبانی رسمی ندارد. این اپ با
> تزریق `moment-jalaali` تاریخ‌ها را شمسی می‌کند، اما چون نسخه‌های جدید Nextcloud کتابخانه‌ی
> moment را داخل ماژول‌های خود bundle می‌کنند، ممکن است در برخی بخش‌ها/نسخه‌ها کامل اعمال نشود.
> حتماً اول روی محیط تست بررسی کن.

---

## ساختار اپ

```
samafa/
├── appinfo/info.xml                     # شناسه، نسخه، repair-step
├── lib/
│   ├── AppInfo/Application.php          # بارگذاری css و js روی همه صفحات
│   └── Migration/SetPersianDefaults.php # ست کردن زبان/locale فارسی موقع نصب
├── js/samafa.js                         # تزریق moment-jalaali (تاریخ شمسی)
└── css/samafa.css                       # RTL + فونت Vazirmatn
```

---

## نصب

### حالت AIO (Docker)
```bash
# کپی اپ به custom_apps داخل کانتینر
docker cp app/samafa nextcloud-aio-nextcloud:/var/www/html/custom_apps/samafa
docker exec --user root nextcloud-aio-nextcloud \
  chown -R www-data:www-data /var/www/html/custom_apps/samafa

# فعال‌سازی
docker exec --user www-data nextcloud-aio-nextcloud php occ app:enable samafa
```

### حالت snap
```bash
sudo cp -r app/samafa /var/snap/nextcloud/current/nextcloud/extra-apps/samafa
sudo nextcloud.occ app:enable samafa
```

### حالت manual (/var/www/nextcloud)
```bash
sudo cp -r app/samafa /var/www/nextcloud/apps/samafa
sudo chown -R www-data:www-data /var/www/nextcloud/apps/samafa
sudo -u www-data php /var/www/nextcloud/occ app:enable samafa
```

پس از فعال‌سازی، یک‌بار از حساب خارج و دوباره وارد شو (یا کش مرورگر را پاک کن)
تا استایل و اسکریپت بارگذاری شوند.

---

## غیرفعال‌سازی
```bash
# occ را مطابق حالت نصب خودت اجرا کن
occ app:disable samafa
```

## اجبار همه‌ی کاربرها به فارسی
در فایل `lib/Migration/SetPersianDefaults.php` دو خط `force_language` و `force_locale`
را از کامنت دربیاور و اپ را دوباره فعال کن (یا `occ maintenance:repair` بزن).

## حالت آفلاین فونت
خط `@import` در `css/samafa.css` فونت را از Google Fonts می‌گیرد. برای آفلاین،
فایل‌های `woff2` وزیرمتن را داخل `css/` بگذار و `@import` را با `@font-face` و مسیر محلی جایگزین کن.
