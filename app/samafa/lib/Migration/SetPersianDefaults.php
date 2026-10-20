<?php

declare(strict_types=1);

namespace OCA\SamaFa\Migration;

use OCP\IConfig;
use OCP\Migration\IOutput;
use OCP\Migration\IRepairStep;

/**
 * هنگام نصب/فعال‌سازی اپ، زبان و locale پیش‌فرض را روی فارسی تنظیم می‌کند.
 */
class SetPersianDefaults implements IRepairStep {
    private IConfig $config;

    public function __construct(IConfig $config) {
        $this->config = $config;
    }

    public function getName(): string {
        return 'Sama FA: تنظیم زبان و locale پیش‌فرض روی فارسی';
    }

    public function run(IOutput $output): void {
        $this->config->setSystemValue('default_language', 'fa');
        $this->config->setSystemValue('default_locale', 'fa_IR');

        // اگر می‌خواهی همه‌ی کاربرها اجباراً فارسی شوند، دو خط زیر را از کامنت دربیاور:
        // $this->config->setSystemValue('force_language', 'fa');
        // $this->config->setSystemValue('force_locale', 'fa_IR');

        $output->info('زبان پیش‌فرض روی فارسی (fa) و locale روی fa_IR تنظیم شد.');
    }
}
