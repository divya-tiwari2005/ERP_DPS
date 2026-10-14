-- CreateTable
CREATE TABLE `schoolsubject` (
    `id` INTEGER NOT NULL AUTO_INCREMENT,
    `schoolId` INTEGER NOT NULL,
    `name` VARCHAR(191) NOT NULL,
    `code` VARCHAR(191) NULL,
    `category` VARCHAR(191) NULL,
    `createdAt` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
    `updatedAt` DATETIME(3) NOT NULL,

    INDEX `schoolsubject_schoolId_idx`(`schoolId`),
    UNIQUE INDEX `schoolsubject_schoolId_name_key`(`schoolId`, `name`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `classsubject` (
    `id` INTEGER NOT NULL AUTO_INCREMENT,
    `classId` INTEGER NOT NULL,
    `subjectId` INTEGER NOT NULL,
    `createdAt` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
    `updatedAt` DATETIME(3) NOT NULL,

    INDEX `classsubject_subjectId_idx`(`subjectId`),
    UNIQUE INDEX `classsubject_classId_subjectId_key`(`classId`, `subjectId`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `syllabus` (
    `id` INTEGER NOT NULL AUTO_INCREMENT,
    `classSubjectId` INTEGER NOT NULL,
    `academicYearId` INTEGER NOT NULL,
    `createdAt` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
    `updatedAt` DATETIME(3) NOT NULL,

    INDEX `syllabus_academicYearId_idx`(`academicYearId`),
    UNIQUE INDEX `syllabus_classSubjectId_academicYearId_key`(`classSubjectId`, `academicYearId`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `syllabusunit` (
    `id` INTEGER NOT NULL AUTO_INCREMENT,
    `syllabusId` INTEGER NOT NULL,
    `title` VARCHAR(191) NOT NULL,
    `position` INTEGER NOT NULL DEFAULT 0,
    `createdAt` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
    `updatedAt` DATETIME(3) NOT NULL,

    INDEX `syllabusunit_syllabusId_position_idx`(`syllabusId`, `position`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `syllabuschapter` (
    `id` INTEGER NOT NULL AUTO_INCREMENT,
    `unitId` INTEGER NULL,
    `syllabusId` INTEGER NOT NULL,
    `title` VARCHAR(191) NOT NULL,
    `position` INTEGER NOT NULL DEFAULT 0,
    `status` VARCHAR(191) NOT NULL DEFAULT 'PENDING',
    `createdAt` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
    `updatedAt` DATETIME(3) NOT NULL,

    INDEX `syllabuschapter_syllabusId_position_idx`(`syllabusId`, `position`),
    INDEX `syllabuschapter_unitId_position_idx`(`unitId`, `position`),
    INDEX `syllabuschapter_status_idx`(`status`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `syllabustopic` (
    `id` INTEGER NOT NULL AUTO_INCREMENT,
    `chapterId` INTEGER NOT NULL,
    `title` VARCHAR(191) NOT NULL,
    `position` INTEGER NOT NULL DEFAULT 0,
    `createdAt` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
    `updatedAt` DATETIME(3) NOT NULL,

    INDEX `syllabustopic_chapterId_position_idx`(`chapterId`, `position`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- AddForeignKey
ALTER TABLE `schoolsubject` ADD CONSTRAINT `schoolsubject_schoolId_fkey` FOREIGN KEY (`schoolId`) REFERENCES `school`(`id`) ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `classsubject` ADD CONSTRAINT `classsubject_classId_fkey` FOREIGN KEY (`classId`) REFERENCES `academicclass`(`id`) ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `classsubject` ADD CONSTRAINT `classsubject_subjectId_fkey` FOREIGN KEY (`subjectId`) REFERENCES `schoolsubject`(`id`) ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `syllabus` ADD CONSTRAINT `syllabus_classSubjectId_fkey` FOREIGN KEY (`classSubjectId`) REFERENCES `classsubject`(`id`) ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `syllabus` ADD CONSTRAINT `syllabus_academicYearId_fkey` FOREIGN KEY (`academicYearId`) REFERENCES `academicyear`(`id`) ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `syllabusunit` ADD CONSTRAINT `syllabusunit_syllabusId_fkey` FOREIGN KEY (`syllabusId`) REFERENCES `syllabus`(`id`) ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `syllabuschapter` ADD CONSTRAINT `syllabuschapter_unitId_fkey` FOREIGN KEY (`unitId`) REFERENCES `syllabusunit`(`id`) ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `syllabuschapter` ADD CONSTRAINT `syllabuschapter_syllabusId_fkey` FOREIGN KEY (`syllabusId`) REFERENCES `syllabus`(`id`) ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `syllabustopic` ADD CONSTRAINT `syllabustopic_chapterId_fkey` FOREIGN KEY (`chapterId`) REFERENCES `syllabuschapter`(`id`) ON DELETE CASCADE ON UPDATE CASCADE;
