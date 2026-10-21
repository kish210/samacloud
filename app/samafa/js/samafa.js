/* ============================================================
   Sama FA — فعال‌سازی تاریخ شمسی (تجربی) برای Nextcloud
   ------------------------------------------------------------
   کتابخانه‌ی moment-jalaali به‌صورت محلی (js/vendor/moment-jalaali.js)
   قبل از این اسکریپت بارگذاری می‌شود؛ اینجا فقط moment سراسری را به
   حالت فارسی/شمسی می‌بریم. بدون نیاز به CDN خارجی (مناسب ایران).

   هشدار: نسخه‌های جدید Nextcloud، moment را داخل ماژول‌های خود bundle
   می‌کنند؛ بنابراین این override فقط روی بخش‌هایی که از moment سراسری
   استفاده می‌کنند اثر می‌گذارد و ممکن است همه‌جا اعمال نشود.
   ============================================================ */
(function () {
    "use strict";

    function enablePersian() {
        if (typeof window.moment === "undefined" ||
            typeof window.moment.loadPersian !== "function") {
            return false;
        }
        try {
            window.moment.loadPersian({
                usePersianDigits: true,
                dialect: "persian-modern"
            });
            console.info("[SamaFA] تاریخ شمسی فعال شد.");
            return true;
        } catch (e) {
            console.warn("[SamaFA] فعال‌سازی تاریخ شمسی ناموفق بود:", e);
            return false;
        }
    }

    function start() {
        if (enablePersian()) {
            return;
        }
        // اگر کتابخانه هنوز آماده نشده، چند بار با فاصله تلاش کن
        var tries = 0;
        var timer = setInterval(function () {
            tries += 1;
            if (enablePersian() || tries > 20) {
                clearInterval(timer);
            }
        }, 300);
    }

    if (document.readyState === "loading") {
        document.addEventListener("DOMContentLoaded", start);
    } else {
        start();
    }
})();
