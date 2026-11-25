-- CreateTable
CREATE TABLE `result` (
    `id` INTEGER NOT NULL AUTO_INCREMENT,
    `schoolId` INTEGER NOT NULL,
    `studentId` INTEGER NOT NULL,
    `academicYearId` INTEGER NOT NULL,
    `classId` INTEGER NOT NULL,
    `sectionId` INTEGER NOT NULL,
    `term` ENUM('TERM_1', 'TERM_2') NOT NULL,
    `totalObtained` DECIMAL(8, 2) NOT NULL DEFAULT 0,
    `totalMaximum` DECIMAL(8, 2) NOT NULL DEFAULT 0,
    `percentage` DECIMAL(6, 2) NOT NULL DEFAULT 0,
    `gpa` DECIMAL(4, 2) NULL,
    `status` ENUM('DRAFT', 'PUBLISHED') NOT NULL DEFAULT 'DRAFT',
    `publishedAt` DATETIME(3) NULL,
    `createdAt` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
    `updatedAt` DATETIME(3) NOT NULL,

    INDEX `result_schoolId_academicYearId_classId_sectionId_term_idx`(`schoolId`, `academicYearId`, `classId`, `sectionId`, `term`),
    INDEX `result_studentId_academicYearId_idx`(`studentId`, `academicYearId`),
    UNIQUE INDEX `result_studentId_academicYearId_term_key`(`studentId`, `academicYearId`, `term`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `resultsubject` (
    `id` INTEGER NOT NULL AUTO_INCREMENT,
    `resultId` INTEGER NOT NULL,
    `classSubjectId` INTEGER NOT NULL,
    `totalMarks` DECIMAL(8, 2) NOT NULL DEFAULT 0,
    `maximumMarks` DECIMAL(8, 2) NOT NULL DEFAULT 0,
    `percentage` DECIMAL(6, 2) NOT NULL DEFAULT 0,
    `createdAt` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
    `updatedAt` DATETIME(3) NOT NULL,

    INDEX `resultsubject_classSubjectId_idx`(`classSubjectId`),
    UNIQUE INDEX `resultsubject_resultId_classSubjectId_key`(`resultId`, `classSubjectId`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `resultcomponentconfig` (
    `id` INTEGER NOT NULL AUTO_INCREMENT,
    `schoolId` INTEGER NOT NULL,
    `academicYearId` INTEGER NOT NULL,
    `classId` INTEGER NOT NULL,
    `term` ENUM('TERM_1', 'TERM_2') NOT NULL,
    `code` VARCHAR(191) NOT NULL,
    `name` VARCHAR(191) NOT NULL,
    `maximumMarks` DECIMAL(6, 2) NOT NULL,
    `displayOrder` INTEGER NOT NULL DEFAULT 0,
    `isActive` BOOLEAN NOT NULL DEFAULT true,
    `createdAt` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
    `updatedAt` DATETIME(3) NOT NULL,

    INDEX `resultcomponentconfig_schoolId_academicYearId_classId_term_idx`(`schoolId`, `academicYearId`, `classId`, `term`),
    UNIQUE INDEX `resultcomponentconfig_schoolId_academicYearId_classId_term_c_key`(`schoolId`, `academicYearId`, `classId`, `term`, `code`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `resultcomponentmarks` (
    `id` INTEGER NOT NULL AUTO_INCREMENT,
    `resultSubjectId` INTEGER NOT NULL,
    `componentConfigId` INTEGER NOT NULL,
    `componentName` VARCHAR(191) NOT NULL,
    `obtainedMarks` DECIMAL(6, 2) NOT NULL,
    `maximumMarks` DECIMAL(6, 2) NOT NULL,
    `createdAt` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
    `updatedAt` DATETIME(3) NOT NULL,

    INDEX `resultcomponentmarks_componentConfigId_idx`(`componentConfigId`),
    UNIQUE INDEX `resultcomponentmarks_resultSubjectId_componentConfigId_key`(`resultSubjectId`, `componentConfigId`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- AddForeignKey
ALTER TABLE `result` ADD CONSTRAINT `result_schoolId_fkey` FOREIGN KEY (`schoolId`) REFERENCES `school`(`id`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `result` ADD CONSTRAINT `result_studentId_fkey` FOREIGN KEY (`studentId`) REFERENCES `student`(`id`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `result` ADD CONSTRAINT `result_academicYearId_fkey` FOREIGN KEY (`academicYearId`) REFERENCES `academicyear`(`id`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `result` ADD CONSTRAINT `result_classId_fkey` FOREIGN KEY (`classId`) REFERENCES `academicclass`(`id`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `result` ADD CONSTRAINT `result_sectionId_fkey` FOREIGN KEY (`sectionId`) REFERENCES `section`(`id`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `resultsubject` ADD CONSTRAINT `resultsubject_resultId_fkey` FOREIGN KEY (`resultId`) REFERENCES `result`(`id`) ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `resultsubject` ADD CONSTRAINT `resultsubject_classSubjectId_fkey` FOREIGN KEY (`classSubjectId`) REFERENCES `classsubject`(`id`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `resultcomponentconfig` ADD CONSTRAINT `resultcomponentconfig_schoolId_fkey` FOREIGN KEY (`schoolId`) REFERENCES `school`(`id`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `resultcomponentconfig` ADD CONSTRAINT `resultcomponentconfig_academicYearId_fkey` FOREIGN KEY (`academicYearId`) REFERENCES `academicyear`(`id`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `resultcomponentconfig` ADD CONSTRAINT `resultcomponentconfig_classId_fkey` FOREIGN KEY (`classId`) REFERENCES `academicclass`(`id`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `resultcomponentmarks` ADD CONSTRAINT `resultcomponentmarks_resultSubjectId_fkey` FOREIGN KEY (`resultSubjectId`) REFERENCES `resultsubject`(`id`) ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `resultcomponentmarks` ADD CONSTRAINT `resultcomponentmarks_componentConfigId_fkey` FOREIGN KEY (`componentConfigId`) REFERENCES `resultcomponentconfig`(`id`) ON DELETE RESTRICT ON UPDATE CASCADE;
