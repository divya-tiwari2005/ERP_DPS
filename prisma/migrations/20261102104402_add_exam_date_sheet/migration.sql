-- CreateTable
CREATE TABLE `examdatesheet` (
    `id` INTEGER NOT NULL AUTO_INCREMENT,
    `schoolId` INTEGER NOT NULL,
    `academicYearId` INTEGER NOT NULL,
    `classId` INTEGER NOT NULL,
    `examName` VARCHAR(191) NOT NULL,
    `creationType` ENUM('MANUAL', 'PDF') NOT NULL,
    `pdfUrl` VARCHAR(191) NULL,
    `status` ENUM('DRAFT', 'PUBLISHED') NOT NULL DEFAULT 'DRAFT',
    `publishedAt` DATETIME(3) NULL,
    `createdAt` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
    `updatedAt` DATETIME(3) NOT NULL,

    INDEX `examdatesheet_schoolId_academicYearId_classId_status_idx`(`schoolId`, `academicYearId`, `classId`, `status`),
    UNIQUE INDEX `examdatesheet_schoolId_academicYearId_classId_examName_key`(`schoolId`, `academicYearId`, `classId`, `examName`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `examdatesheetsubject` (
    `id` INTEGER NOT NULL AUTO_INCREMENT,
    `dateSheetId` INTEGER NOT NULL,
    `classSubjectId` INTEGER NOT NULL,
    `examDate` DATE NOT NULL,
    `startTime` VARCHAR(191) NOT NULL,
    `endTime` VARCHAR(191) NOT NULL,
    `createdAt` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
    `updatedAt` DATETIME(3) NOT NULL,

    INDEX `examdatesheetsubject_dateSheetId_examDate_idx`(`dateSheetId`, `examDate`),
    UNIQUE INDEX `examdatesheetsubject_dateSheetId_classSubjectId_key`(`dateSheetId`, `classSubjectId`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- AddForeignKey
ALTER TABLE `examdatesheet` ADD CONSTRAINT `examdatesheet_schoolId_fkey` FOREIGN KEY (`schoolId`) REFERENCES `school`(`id`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `examdatesheet` ADD CONSTRAINT `examdatesheet_academicYearId_fkey` FOREIGN KEY (`academicYearId`) REFERENCES `academicyear`(`id`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `examdatesheet` ADD CONSTRAINT `examdatesheet_classId_fkey` FOREIGN KEY (`classId`) REFERENCES `academicclass`(`id`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `examdatesheetsubject` ADD CONSTRAINT `examdatesheetsubject_dateSheetId_fkey` FOREIGN KEY (`dateSheetId`) REFERENCES `examdatesheet`(`id`) ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `examdatesheetsubject` ADD CONSTRAINT `examdatesheetsubject_classSubjectId_fkey` FOREIGN KEY (`classSubjectId`) REFERENCES `classsubject`(`id`) ON DELETE RESTRICT ON UPDATE CASCADE;
