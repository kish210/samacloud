<?php

declare(strict_types=1);

namespace OCA\SamaFa\AppInfo;

use OCP\AppFramework\App;
use OCP\AppFramework\Bootstrap\IBootContext;
use OCP\AppFramework\Bootstrap\IBootstrap;
use OCP\AppFramework\Bootstrap\IRegistrationContext;
use OCP\Util;

class Application extends App implements IBootstrap {
    public const APP_ID = 'samafa';

    public function __construct() {
        parent::__construct(self::APP_ID);
    }

    public function register(IRegistrationContext $context): void {
        // چیزی برای ثبت لازم نیست
    }

    public function boot(IBootContext $context): void {
        // استایل راست‌به‌چپ + فونت فارسی روی همه‌ی صفحات
        Util::addStyle(self::APP_ID, 'samafa');
        // اسکریپت تاریخ شمسی روی همه‌ی صفحات
        Util::addScript(self::APP_ID, 'samafa');
    }
}
