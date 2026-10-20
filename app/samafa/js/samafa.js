/* ============================================================
   Sama FA — تاریخ شمسی (تجربی) برای Nextcloud
   ------------------------------------------------------------
   این اسکریپت moment-jalaali را بارگذاری می‌کند و moment سراسری
   را به حالت فارسی/شمسی می‌برد.
   هشدار: نسخه‌های جدید Nextcloud، moment را داخل ماژول‌های خود
   bundle می‌کنند؛ بنابراین این override فقط روی بخش‌هایی که از
   moment سراسری استفاده می‌کنند اثر می‌گذارد و ممکن است همه‌جا
   اعمال نشود.
   ============================================================ */
(function () {
    "use strict";

    var MOMENT_JALAALI_CDN =
        "https://cdn.jsdelivr.net/npm/moment-jalaali@0.10.4/build/moment-jalaali.js";

    function enablePersian() {
        if (typeof window.moment === "undefined") {
            return false;
        }
        if (typeof window.moment.loadPersian !== "function") {
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

    function loadLibrary() {
        if (enablePersian()) {
            return;
        }
        var s = document.createElement("script");
        s.src = MOMENT_JALAALI_CDN;
        s.async = true;
        s.onload = function () {
            var tries = 0;
            var timer = setInterval(function () {
                tries += 1;
                if (enablePersian() || tries > 20) {
                    clearInterval(timer);
                }
            }, 500);
        };
        s.onerror = function () {
            console.warn("[SamaFA] بارگذاری moment-jalaali از CDN ناموفق بود (دسترسی اینترنت؟).");
        };
        document.head.appendChild(s);
    }

    if (document.readyState === "loading") {
        document.addEventListener("DOMContentLoaded", loadLibrary);
    } else {
        loadLibrary();
    }
})();
