CREATE TABLE `AcademicYear` (
    `id` INTEGER NOT NULL AUTO_INCREMENT,
    `schoolId` INTEGER NOT NULL,
    `name` VARCHAR(191) NOT NULL,
    `startDate` DATETIME(3) NOT NULL,
    `endDate` DATETIME(3) NOT NULL,
    `status` VARCHAR(191) NOT NULL DEFAULT 'ACTIVE',
    `createdAt` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
    `updatedAt` DATETIME(3) NOT NULL,

    INDEX `AcademicYear_schoolId_idx`(`schoolId`),
    UNIQUE INDEX `AcademicYear_schoolId_name_key`(`schoolId`, `name`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

ALTER TABLE `AcademicYear`
ADD CONSTRAINT `AcademicYear_schoolId_fkey`
FOREIGN KEY (`schoolId`) REFERENCES `School`(`id`)
ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE `SchoolCalendar`
ADD COLUMN `academicYearId` INTEGER NULL;

CREATE INDEX `SchoolCalendar_academicYearId_date_idx`
ON `SchoolCalendar`(`academicYearId`, `date`);

ALTER TABLE `SchoolCalendar`
ADD CONSTRAINT `SchoolCalendar_academicYearId_fkey`
FOREIGN KEY (`academicYearId`) REFERENCES `AcademicYear`(`id`)
ON DELETE RESTRICT ON UPDATE CASCADE;