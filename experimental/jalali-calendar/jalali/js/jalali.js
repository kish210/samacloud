/* ============================================================
   Jalali Calendar — تزریق تجربی تاریخ شمسی به Nextcloud
   ------------------------------------------------------------
   هشدار: این یک راهکار تجربی است. Nextcloud در نسخه‌های جدید،
   moment را داخل ماژول‌های خودش bundle می‌کند؛ بنابراین این
   override سراسری فقط روی بخش‌هایی که از moment سراسری استفاده
   می‌کنند اثر می‌گذارد و ممکن است همه‌جا اعمال نشود.
   ============================================================ */
(function () {
    "use strict";

    var MOMENT_JALAALI_CDN =
        "https://cdn.jsdelivr.net/npm/moment-jalaali@0.10.4/build/moment-jalaali.js";

    function applyJalali() {
        try {
            if (typeof window.moment === "undefined") {
                // moment هنوز لود نشده؛ کمی بعد دوباره امتحان کن
                return;
            }
            // اگر قبلاً moment-jalaali لود شده باشد
            if (typeof window.moment.loadPersian === "function") {
                window.moment.loadPersian({
                    usePersianDigits: true,
                    dialect: "persian-modern"
                });
                console.info("[jalali] تاریخ شمسی فعال شد.");
                return true;
            }
            return false;
        } catch (e) {
            console.warn("[jalali] اعمال تاریخ شمسی ناموفق بود:", e);
            return false;
        }
    }

    function loadLibAndApply() {
        if (applyJalali()) {
            return;
        }
        var s = document.createElement("script");
        s.src = MOMENT_JALAALI_CDN;
        s.onload = function () {
            // چند بار تلاش کن تا moment سراسری آماده شود
            var tries = 0;
            var timer = setInterval(function () {
                tries++;
                if (applyJalali() || tries > 20) {
                    clearInterval(timer);
                }
            }, 500);
        };
        s.onerror = function () {
            console.warn("[jalali] بارگذاری moment-jalaali از CDN ناموفق بود.");
        };
        document.head.appendChild(s);
    }

    if (document.readyState === "complete" || document.readyState === "interactive") {
        loadLibAndApply();
    } else {
        document.addEventListener("DOMContentLoaded", loadLibAndApply);
    }
})();
