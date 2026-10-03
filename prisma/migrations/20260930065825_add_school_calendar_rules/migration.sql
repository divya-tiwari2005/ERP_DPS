-- CreateTable
CREATE TABLE `schoolworkingday` (
    `id` INTEGER NOT NULL AUTO_INCREMENT,
    `schoolId` INTEGER NOT NULL,
    `dayOfWeek` INTEGER NOT NULL,
    `isWorking` BOOLEAN NOT NULL DEFAULT true,
    `createdAt` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
    `updatedAt` DATETIME(3) NOT NULL,

    INDEX `schoolworkingday_schoolId_idx`(`schoolId`),
    UNIQUE INDEX `schoolworkingday_schoolId_dayOfWeek_key`(`schoolId`, `dayOfWeek`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `calendarevent` (
    `id` INTEGER NOT NULL AUTO_INCREMENT,
    `schoolId` INTEGER NOT NULL,
    `academicYearId` INTEGER NOT NULL,
    `title` VARCHAR(191) NOT NULL,
    `type` VARCHAR(191) NOT NULL,
    `targetType` VARCHAR(191) NOT NULL DEFAULT 'ALL_CLASSES',
    `createdAt` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
    `updatedAt` DATETIME(3) NOT NULL,

    INDEX `calendarevent_schoolId_idx`(`schoolId`),
    INDEX `calendarevent_academicYearId_idx`(`academicYearId`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `calendareventdate` (
    `id` INTEGER NOT NULL AUTO_INCREMENT,
    `eventId` INTEGER NOT NULL,
    `date` DATETIME(3) NOT NULL,
    `createdAt` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),

    INDEX `calendareventdate_date_idx`(`date`),
    UNIQUE INDEX `calendareventdate_eventId_date_key`(`eventId`, `date`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `calendareventclass` (
    `eventId` INTEGER NOT NULL,
    `classId` INTEGER NOT NULL,

    INDEX `calendareventclass_classId_idx`(`classId`),
    PRIMARY KEY (`eventId`, `classId`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- AddForeignKey
ALTER TABLE `schoolworkingday` ADD CONSTRAINT `schoolworkingday_schoolId_fkey` FOREIGN KEY (`schoolId`) REFERENCES `school`(`id`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `calendarevent` ADD CONSTRAINT `calendarevent_schoolId_fkey` FOREIGN KEY (`schoolId`) REFERENCES `school`(`id`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `calendarevent` ADD CONSTRAINT `calendarevent_academicYearId_fkey` FOREIGN KEY (`academicYearId`) REFERENCES `academicyear`(`id`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `calendareventdate` ADD CONSTRAINT `calendareventdate_eventId_fkey` FOREIGN KEY (`eventId`) REFERENCES `calendarevent`(`id`) ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `calendareventclass` ADD CONSTRAINT `calendareventclass_eventId_fkey` FOREIGN KEY (`eventId`) REFERENCES `calendarevent`(`id`) ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `calendareventclass` ADD CONSTRAINT `calendareventclass_classId_fkey` FOREIGN KEY (`classId`) REFERENCES `academicclass`(`id`) ON DELETE CASCADE ON UPDATE CASCADE;
