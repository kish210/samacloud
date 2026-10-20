# Sama Cloud — فارسی‌سازی و برندینگ Nextcloud

مجموعه‌ای از اسکریپت‌ها و فایل‌ها برای:

- ✅ فعال‌کردن **زبان فارسی** به‌صورت پیش‌فرض + چیدمان **راست‌به‌چپ (RTL)**
- ✅ **override ترجمه** برای عبارت‌های دلخواه (قابل گسترش)
- ✅ **رفع ایرادهای UI در حالت فارسی** با CSS سفارشی
- ✅ **برندینگ Sama Cloud** (نام، رنگ، شعار)
- ✅ اسکریپت **آپدیت از روی همین گیت**

> نکته‌ی مهم: بخش عمده‌ی ترجمه‌ی فارسی از خودِ Nextcloud (رسمی، جامعه‌محور) می‌آید.
> این پروژه آن را فعال می‌کند و امکان **override و رفع ایراد** را اضافه می‌کند؛ ترجمه‌ی کامل از صفر نیست.

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
├── l10n/
│   └── core/
│       ├── fa.json            # override ترجمه (سمت سرور)
│       └── fa.js              # override ترجمه (سمت مرورگر)
└── scripts/
    ├── occ-helper.sh          # تعیین نحوه‌ی اجرای occ (aio/snap/manual)
    ├── set-language.sh        # فعال‌کردن فارسی + RTL
    ├── setup-branding.sh      # برندینگ + نصب Custom CSS
    ├── apply-translations.sh  # اعمال override ترجمه
    └── update.sh              # آپدیت کامل از روی گیت
```

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

برای خوانایی بهتر، فونت‌هایی مثل **Vazirmatn** در `rtl-fixes.css` پیشنهاد شده‌اند.
اگر می‌خواهی فونت را هاست کنی، آن را به CSS با `@font-face` اضافه کن.
