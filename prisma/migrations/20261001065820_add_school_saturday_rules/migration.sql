-- CreateTable
CREATE TABLE `schoolsaturday` (
    `id` INTEGER NOT NULL AUTO_INCREMENT,
    `schoolId` INTEGER NOT NULL,
    `date` DATETIME(3) NOT NULL,
    `isWorking` BOOLEAN NOT NULL DEFAULT true,
    `createdAt` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
    `updatedAt` DATETIME(3) NOT NULL,

    INDEX `schoolsaturday_schoolId_date_idx`(`schoolId`, `date`),
    UNIQUE INDEX `schoolsaturday_schoolId_date_key`(`schoolId`, `date`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- AddForeignKey
ALTER TABLE `schoolsaturday` ADD CONSTRAINT `schoolsaturday_schoolId_fkey` FOREIGN KEY (`schoolId`) REFERENCES `school`(`id`) ON DELETE CASCADE ON UPDATE CASCADE;
