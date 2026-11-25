import prisma from "../lib/prisma.js";

const validateId = (id) => {
  return Number.isInteger(id) && id > 0;
};

const validateExamName = (examName) => {
  return (
    typeof examName === "string" &&
    examName.trim().length > 0
  );
};

const validateExamDate = (examDate) => {
  if (
    typeof examDate !== "string" ||
    !/^\d{4}-\d{2}-\d{2}$/.test(examDate)
  ) {
    return false;
  }

  const date = new Date(`${examDate}T00:00:00.000Z`);

  return (
    !Number.isNaN(date.getTime()) &&
    date.toISOString().slice(0, 10) === examDate
  );
};

const validateExamTime = (startTime, endTime) => {
  const pattern = /^([01]\d|2[0-3]):[0-5]\d$/;

  return (
    typeof startTime === "string" &&
    typeof endTime === "string" &&
    pattern.test(startTime) &&
    pattern.test(endTime) &&
    startTime < endTime
  );
};

const validateSubjects = (subjects) => {
  if (!Array.isArray(subjects) || subjects.length === 0) {
    throw new Error("SUBJECTS_REQUIRED");
  }

  for (const subject of subjects) {
    if (
      !subject ||
      typeof subject !== "object" ||
      Array.isArray(subject)
    ) {
      throw new Error("INVALID_EXAM_SCHEDULE");
    }
  }
  const subjectIds = subjects.map(
    (subject) => subject.classSubjectId
  );

  if (
    subjectIds.some((id) => !validateId(id)) ||
    new Set(subjectIds).size !== subjectIds.length
  ) { 
    throw new Error("INVALID_OR_DUPLICATE_SUBJECTS");
  }

  for (const subject of subjects) {
    if (!validateExamDate(subject.examDate)) {
      throw new Error("INVALID_EXAM_DATE");
    }

    if (
      !validateExamTime(
        subject.startTime,
        subject.endTime
      )
    ) {
      throw new Error("INVALID_EXAM_TIME");
    }
  }

  return subjectIds;
};

const validatePdfUrl = (pdfUrl) => {
  if (typeof pdfUrl !== "string" || !pdfUrl.trim()) {
    return false;
  }

  try {
    const url = new URL(pdfUrl);

    return url.protocol === "https:" || url.protocol === "http:";
  } catch {
    return false;
  }
};

const dateSheetInclude = {
  school: true,

  academicyear: true,

  academicclass: true,

  subjects: {
    include: {
      classSubject: {
        include: {
          subject: true,
        },
      },
    },

    orderBy: {
      examDate: "asc",
    },
  },
};

const prepareSubjectSchedules = (subjects) => {
  return subjects.map((subject) => ({
    classSubjectId: subject.classSubjectId,

    examDate: new Date(
      `${subject.examDate}T00:00:00.000Z`
    ),

    startTime: subject.startTime,
    endTime: subject.endTime,
  }));
};

const verifyClassSubjects = async (
  tx,
  subjectIds,
  classId,
  schoolId
) => {
  const validSubjects = await tx.classsubject.findMany({
    where: {
      id: {
        in: subjectIds,
      },
      classId,
    },

    include: {
      subject: {
        select: {
          schoolId: true,
        },
      },
    },
  });

  if (
    validSubjects.length !== subjectIds.length ||
    validSubjects.some(
      (item) => item.subject.schoolId !== schoolId
    )
  ) {
    throw new Error("INVALID_CLASS_SUBJECT");
  }
};

export const createManualDateSheet = async ({
  schoolId,
  academicYearId,
  classId,
  examName,
  subjects,
}) => {
  if (
    !validateId(schoolId) ||
    !validateId(academicYearId) ||
    !validateId(classId)
  ) {
    throw new Error("INVALID_REQUIRED_FIELDS");
  }

  if (!validateExamName(examName)) {
    throw new Error("EXAM_NAME_REQUIRED");
  }

  const subjectIds = validateSubjects(subjects);

  return prisma.$transaction(async (tx) => {

    const academicYear = await tx.academicyear.findFirst({
      where: {
        id: academicYearId,
        schoolId,
      },
    });

    if (!academicYear) {
      throw new Error("ACADEMIC_YEAR_NOT_FOUND");
    }

    const academicClass = await tx.academicclass.findFirst({
      where: {
        id: classId,
        schoolId,
      },
    });

    if (!academicClass) {
      throw new Error("CLASS_NOT_FOUND");
    }

    await verifyClassSubjects(
      tx,
      subjectIds,
      classId,
      schoolId
    );

    return tx.examdatesheet.create({
      data: {
        schoolId,
        academicYearId,
        classId,

        examName: examName.trim(),

        creationType: "MANUAL",
        status: "DRAFT",

        subjects: {
          create: prepareSubjectSchedules(subjects),
        },
      },

      include: dateSheetInclude,
    });
  });
};

export const getDateSheets = async ({
  schoolId,
  academicYearId,
  classId,
  status,
}) => {
  if (!validateId(schoolId)) {
    throw new Error("INVALID_SCHOOL_ID");
  }

  if (
    academicYearId !== undefined &&
    !validateId(academicYearId)
  ) {
    throw new Error("INVALID_ACADEMIC_YEAR_ID");
  }

  if (
    classId !== undefined &&
    !validateId(classId)
  ) {
    throw new Error("INVALID_CLASS_ID");
  }

  if (
    status !== undefined &&
    !["DRAFT", "PUBLISHED"].includes(status)
  ) {
    throw new Error("INVALID_DATE_SHEET_STATUS");
  }

  return prisma.examdatesheet.findMany({
    where: {
      schoolId,

      ...(academicYearId !== undefined
        ? { academicYearId }
        : {}),

      ...(classId !== undefined
        ? { classId }
        : {}),

      ...(status !== undefined
        ? { status }
        : {}),
    },

    include: dateSheetInclude,

    orderBy: {
      createdAt: "desc",
    },
  });
};

export const getDateSheetById = async ({
  schoolId,
  dateSheetId,
}) => {
  if (
    !validateId(schoolId) ||
    !validateId(dateSheetId)
  ) {
    throw new Error("INVALID_REQUIRED_FIELDS");
  }

  const dateSheet = await prisma.examdatesheet.findFirst({
    where: {
      id: dateSheetId,
      schoolId,
    },

    include: dateSheetInclude,
  });

  if (!dateSheet) {
    throw new Error("DATE_SHEET_NOT_FOUND");
  }

  return dateSheet;
};

export const updateDateSheet = async ({
  schoolId,
  dateSheetId,
  examName,
  subjects,
}) => {
  if (
    !validateId(schoolId) ||
    !validateId(dateSheetId)
  ) {
    throw new Error("INVALID_REQUIRED_FIELDS");
  }

  if (!validateExamName(examName)) {
    throw new Error("EXAM_NAME_REQUIRED");
  }

  const subjectIds = validateSubjects(subjects);

  return prisma.$transaction(async (tx) => {

    const existingDateSheet =
      await tx.examdatesheet.findFirst({
        where: {
          id: dateSheetId,
          schoolId,
        },
      });

    if (!existingDateSheet) {
      throw new Error("DATE_SHEET_NOT_FOUND");
    }

    if (existingDateSheet.status !== "DRAFT") {
      throw new Error(
        "PUBLISHED_DATE_SHEET_CANNOT_BE_EDITED"
      );
    }

    if (existingDateSheet.creationType !== "MANUAL") {
      throw new Error(
        "ONLY_MANUAL_DATE_SHEETS_CAN_BE_EDITED_HERE"
      );
    }

    await verifyClassSubjects(
      tx,
      subjectIds,
      existingDateSheet.classId,
      schoolId
    );

    await tx.examdatesheetsubject.deleteMany({
      where: {
        dateSheetId,
      },
    });

    return tx.examdatesheet.update({
      where: {
        id: dateSheetId,
      },

      data: {
        examName: examName.trim(),

        subjects: {
          create: prepareSubjectSchedules(subjects),
        },
      },

      include: dateSheetInclude,
    });
  });
};

export const deleteDateSheet = async ({
  schoolId,
  dateSheetId,
}) => {
  if (
    !validateId(schoolId) ||
    !validateId(dateSheetId)
  ) {
    throw new Error("INVALID_REQUIRED_FIELDS");
  }

  return prisma.$transaction(async (tx) => {

    const dateSheet = await tx.examdatesheet.findFirst({
      where: {
        id: dateSheetId,
        schoolId,
      },
    });

    if (!dateSheet) {
      throw new Error("DATE_SHEET_NOT_FOUND");
    }

    if (dateSheet.status !== "DRAFT") {
      throw new Error(
        "PUBLISHED_DATE_SHEET_CANNOT_BE_DELETED"
      );
    }

    await tx.examdatesheet.delete({
      where: {
        id: dateSheetId,
      },
    });

    return {
      message: "Exam date sheet deleted successfully.",
      dateSheetId,
    };
  });
};


export const publishDateSheet = async ({
  schoolId,
  dateSheetId,
}) => {
  // Convert IDs into numbers
  schoolId = Number(schoolId);
  dateSheetId = Number(dateSheetId);

  if (
    !validateId(schoolId) ||
    !validateId(dateSheetId)
  ) {
    throw new Error("INVALID_REQUIRED_FIELDS");
  }

  return prisma.$transaction(async (tx) => {

    const dateSheet = await tx.examdatesheet.findFirst({
      where: {
        id: dateSheetId,
        schoolId,
      },

      include: {
        subjects: true,
      },
    });

    if (!dateSheet) {
      throw new Error("DATE_SHEET_NOT_FOUND");
    }

    if (dateSheet.status === "PUBLISHED") {
      throw new Error("DATE_SHEET_ALREADY_PUBLISHED");
    }

    if (dateSheet.creationType === "MANUAL") {

      if (
        !dateSheet.subjects ||
        dateSheet.subjects.length === 0
      ) {
        throw new Error("SUBJECTS_REQUIRED");
      }

    } else if (dateSheet.creationType === "PDF") {

      if (!validatePdfUrl(dateSheet.pdfUrl)) {
        throw new Error("PDF_REQUIRED");
      }

    } else {
      throw new Error("INVALID_DATE_SHEET_TYPE");
    }

    return tx.examdatesheet.update({
      where: {
        id: dateSheetId,
      },

      data: {
        status: "PUBLISHED",
        publishedAt: new Date(),
      },

      include: dateSheetInclude,
    });
  });
};


export const getPublishedDateSheets = async ({
  schoolId,
  classId,
  academicYearId,
}) => {
  if (
    !validateId(schoolId) ||
    !validateId(classId)
  ) {
    throw new Error("INVALID_REQUIRED_FIELDS");
  }

  if (
    academicYearId !== undefined &&
    !validateId(academicYearId)
  ) {
    throw new Error("INVALID_ACADEMIC_YEAR_ID");
  }

  return prisma.examdatesheet.findMany({
    where: {
      schoolId,
      classId,
      status: "PUBLISHED",

      ...(academicYearId !== undefined
        ? { academicYearId }
        : {}),
    },

    include: dateSheetInclude,

    orderBy: {
      publishedAt: "desc",
    },
  });
};

export const createPdfDateSheet = async ({
  schoolId,
  academicYearId,
  classId,
  examName,
  pdfUrl,
}) => {
  if (
    !validateId(schoolId) ||
    !validateId(academicYearId) ||
    !validateId(classId)
  ) {
    throw new Error("INVALID_REQUIRED_FIELDS");
  }

  if (!validateExamName(examName)) {
    throw new Error("EXAM_NAME_REQUIRED");
  }

  if (!validatePdfUrl(pdfUrl)) {
    throw new Error("PDF_REQUIRED");
  }

  return prisma.$transaction(async (tx) => {

    const academicYear = await tx.academicyear.findFirst({
      where: {
        id: academicYearId,
        schoolId,
      },
    });

    if (!academicYear) {
      throw new Error("ACADEMIC_YEAR_NOT_FOUND");
    }

    const academicClass = await tx.academicclass.findFirst({
      where: {
        id: classId,
        schoolId,
      },
    });

    if (!academicClass) {
      throw new Error("CLASS_NOT_FOUND");
    }

    return tx.examdatesheet.create({
      data: {
        schoolId,
        academicYearId,
        classId,

        examName: examName.trim(),

        creationType: "PDF",
        pdfUrl: pdfUrl.trim(),
        status: "DRAFT",
      },

      include: dateSheetInclude,
    });
  });
};

const getStudentDetails = async (userId) => {
  const numericUserId = Number(userId);

  if (!validateId(numericUserId)) {
    throw new Error("INVALID_USER_ID");
  }

  const user = await prisma.user.findUnique({
    where: {
      id: numericUserId,
    },

    include: {
      student: {
        include: {
          section: {
            include: {
              academicclass: true,
            },
          },
        },
      },
    },
  });

  if (!user || !user.student) {
    throw new Error("STUDENT_NOT_FOUND");
  }

  const student = user.student;

  if (!student.schoolId || !student.section) {
    throw new Error("STUDENT_CLASS_NOT_ASSIGNED");
  }

  const academicClass = student.section.academicclass;

  if (academicClass.schoolId !== student.schoolId) {
    throw new Error("STUDENT_SCHOOL_MISMATCH");
  }

  return {
  studentId: student.studentId,
  studentDbId: student.id,
  schoolId: student.schoolId,
  classId: academicClass.id,
  className: academicClass.name,
};
};

export const getStudentExamDateSheets = async (userId) => {

  const student = await getStudentDetails(userId);

  const dateSheets = await prisma.examdatesheet.findMany({
    where: {
      schoolId: student.schoolId,
      classId: student.classId,
      status: "PUBLISHED",
    },

    include: dateSheetInclude,

    orderBy: {
      publishedAt: "desc",
    },
  });

  return {
    student: {
      studentId: student.studentId,
      className: student.className,
    },

    dateSheets,
  };
};

export const getStudentExamDateSheetById = async (
  userId,
  dateSheetId
) => {

  if (!validateId(Number(dateSheetId))) {
    throw new Error("INVALID_DATE_SHEET_ID");
  }

  const student = await getStudentDetails(userId);

  const dateSheet = await prisma.examdatesheet.findFirst({
    where: {
      id: Number(dateSheetId),

      schoolId: student.schoolId,
      classId: student.classId,
      status: "PUBLISHED",
    },

    include: dateSheetInclude,
  });

  if (!dateSheet) {
    throw new Error("EXAM_DATE_SHEET_NOT_FOUND");
  }

  return dateSheet;
};
