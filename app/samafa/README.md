# Sama FA — اپ فارسی و تقویم شمسی برای Nextcloud

یک اپ واقعی Nextcloud که با یک بار نصب و فعال‌سازی:

- 🌐 زبان و locale پیش‌فرض را روی **فارسی (fa / fa_IR)** می‌گذارد
- 📞 منطقه‌ی پیش‌فرض شماره تلفن را روی **ایران (IR)** می‌گذارد
- ↔️ استایل **راست‌به‌چپ (RTL)** و فونت **Vazirmatn** را روی کل محیط اعمال می‌کند
- 🇮🇷 فونت و کتابخانه‌ی تاریخ **به‌صورت محلی داخل اپ** میزبانی می‌شوند (بدون وابستگی به CDN خارجی — مناسب ایران)
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
├── js/
│   ├── samafa.js                        # فعال‌سازی تاریخ شمسی
│   └── vendor/moment-jalaali.js         # کتابخانه‌ی شمسی (محلی)
└── css/
    ├── samafa.css                       # RTL + فونت Vazirmatn (محلی)
    └── fonts/vazirmatn-{400,500,700}.woff2
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

## فونت و کتابخانه‌ی محلی (مناسب ایران)
از نسخه‌ی ۱.۱.۰، فونت **Vazirmatn** (۳ وزن woff2) و کتابخانه‌ی **moment-jalaali**
داخل خودِ اپ قرار دارند و از همان‌جا سرو می‌شوند؛ **هیچ درخواستی به Google Fonts یا CDN خارجی**
زده نمی‌شود. این برای شبکه‌های داخل ایران که دسترسی به CDNهای خارجی کند/مسدود است مهم است.
