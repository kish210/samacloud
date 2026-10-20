# Sama Cloud — فارسی‌سازی و برندینگ Nextcloud

مجموعه‌ای از اسکریپت‌ها و فایل‌ها برای:

- ✅ فعال‌کردن **زبان فارسی** به‌صورت پیش‌فرض + چیدمان **راست‌به‌چپ (RTL)**
- ✅ **override ترجمه** برای عبارت‌های دلخواه (قابل گسترش)
- ✅ **رفع ایرادهای UI در حالت فارسی** با CSS سفارشی
- ✅ **برندینگ Sama Cloud** (نام، رنگ، شعار)
- ✅ فونت فارسی **Vazirmatn**
- ✅ ترجمه‌ی اپ‌های **core / files / settings**
- ✅ ماژول **تجربی تقویم شمسی**
- ✅ اسکریپت **آپدیت از روی همین گیت**

> نکته‌ی مهم: بخش عمده‌ی ترجمه‌ی فارسی از خودِ Nextcloud (رسمی، جامعه‌محور) می‌آید.
> این پروژه آن را فعال می‌کند و امکان **override و رفع ایراد** را اضافه می‌کند؛ ترجمه‌ی کامل از صفر نیست.

---

## ⭐ راه پیشنهادی: اپ یکجای «Sama FA»

اگه نمی‌خوای با اسکریپت‌ها درگیر شی، یه **اپ واقعی Nextcloud** ساخته شده که با یک بار
نصب و فعال‌سازی، **زبان فارسی + RTL + فونت Vazirmatn + تاریخ شمسی (تجربی)** را با هم اعمال می‌کند:

📁 [`app/samafa/`](app/samafa/) — روش نصب کامل در [README همان پوشه](app/samafa/README.md)

نصب سریع (AIO):
```bash
docker cp app/samafa nextcloud-aio-nextcloud:/var/www/html/custom_apps/samafa
docker exec --user root nextcloud-aio-nextcloud chown -R www-data:www-data /var/www/html/custom_apps/samafa
docker exec --user www-data nextcloud-aio-nextcloud php occ app:enable samafa
```

> بقیه‌ی بخش‌های این README (اسکریپت‌های جدا) برای کسانی است که کنترل دستی بیشتری می‌خواهند.

---

## نوع نصب خود را مشخص کن

قبل از اجرای اسکریپت‌ها، متغیر `NC_MODE` را بر اساس نصب خودت ست کن:

| نوع نصب | مقدار |
|---|---|
| Nextcloud AIO (Docker) | `aio` |
| نصب با snap | `snap` |
| نصب دستی (`/var/www/nextcloud`) | `manual` |

---

## نصب اولیه روی سرور

```bash
# ۱) کلون کردن از گیت خودت
git clone https://github.com/kish210/samacloud.git
cd samacloud

# ۲) اجرایی‌کردن اسکریپت‌ها
chmod +x scripts/*.sh

# ۳) فعال‌کردن فارسی + RTL
NC_MODE=aio bash scripts/set-language.sh

# ۴) برندینگ Sama Cloud + نصب اپ Custom CSS
NC_MODE=aio bash scripts/setup-branding.sh

# ۵) اعمال override ترجمه
NC_MODE=aio bash scripts/apply-translations.sh
```

سپس محتوای فایل [`css/rtl-fixes.css`](css/rtl-fixes.css) را در این مسیر جای‌گذاری کن:

```
Administration settings → Theming → Custom CSS
```

---

## 🔄 دستور آپدیت زبان و UI از روی گیت خودت

هر وقت چیزی را در ریپو تغییر دادی و push کردی، روی سرور فقط این را بزن:

```bash
cd samacloud
NC_MODE=aio bash scripts/update.sh
```

این اسکریپت:
1. `git pull` می‌زند (آخرین تغییرات را می‌گیرد)
2. زبان فارسی را دوباره اعمال می‌کند
3. override ترجمه را دوباره کپی می‌کند

> بعد از هر **آپدیت نکست‌کلود**، چون فایل‌های core بازنویسی می‌شوند،
> حتماً یک‌بار `scripts/apply-translations.sh` (یا همان `update.sh`) را اجرا کن.

---

## ساختار پروژه

```
samacloud/
├── README.md
├── css/
│   └── rtl-fixes.css          # رفع ایرادهای UI در حالت فارسی/RTL
├── l10n/                      # override ترجمه (هر زیرپوشه = یک اپ)
│   ├── core/     (fa.json, fa.js)
│   ├── files/    (fa.json, fa.js)
│   └── settings/ (fa.json, fa.js)
├── experimental/
│   └── jalali-calendar/       # ماژول تجربی تاریخ شمسی (README جدا دارد)
└── scripts/
    ├── occ-helper.sh          # تعیین نحوه‌ی اجرای occ (aio/snap/manual)
    ├── set-language.sh        # فعال‌کردن فارسی + RTL + locale fa_IR
    ├── setup-branding.sh      # برندینگ + نصب Custom CSS
    ├── apply-translations.sh  # اعمال override ترجمه برای همه‌ی اپ‌ها
    └── update.sh              # آپدیت کامل از روی گیت
```

> اسکریپت `apply-translations.sh` حالا **خودکار همه‌ی اپ‌های داخل `l10n/`** را اعمال می‌کند.
> برای اپ جدید کافی است پوشه‌ی `l10n/<app>/` با فایل‌های `fa.json` و `fa.js` بسازی.

---

## گسترش ترجمه

برای تغییر یا اضافه‌کردن عبارت‌ها، کلید/مقدارها را در **هر دو** فایل زیر ویرایش کن
(ساختارشان باید یکی باشد):

- `l10n/core/fa.json`
- `l10n/core/fa.js`

برای override ترجمه‌ی اپ‌های دیگر (مثل `files`, `settings`)، همان ساختار
`l10n/<app>/fa.json` و `fa.js` را بساز و مسیر کپی در `apply-translations.sh` را اضافه کن.

---

## نکته درباره‌ی AIO

در Nextcloud AIO چون کانتینرها مدیریت‌شده‌اند، override ترجمه با `docker cp` انجام می‌شود
و بعد از هر آپدیت باید دوباره اعمال شود. برای تغییرات عمیق‌تر UI، نصب snap/manual انعطاف بیشتری دارد.

---

## فونت فارسی

فونت **Vazirmatn** به‌صورت پیش‌فرض از Google Fonts در `css/rtl-fixes.css` با `@import`
بارگذاری می‌شود (نیاز به دسترسی اینترنت سمت مرورگر کاربر دارد).
اگر می‌خواهی **آفلاین/محلی** باشد، فایل‌های `woff2` را روی سرور بگذار و خط `@import`
را با `@font-face` و مسیر محلی جایگزین کن.

## 📅 تقویم شمسی (تجربی)

> Nextcloud از تقویم شمسی پشتیبانی رسمی ندارد. تنظیم `fa_IR` فقط اعداد و نام ماه را
> فارسی می‌کند ولی تاریخ‌ها میلادی می‌مانند.

یک ماژول تجربی برای تبدیل تاریخ‌ها به شمسی در پوشه‌ی
[`experimental/jalali-calendar/`](experimental/jalali-calendar/) هست.
روش نصب و هشدارهای مهمش را در README همان پوشه بخوان (ممکن است در برخی نسخه‌ها کامل اعمال نشود).
