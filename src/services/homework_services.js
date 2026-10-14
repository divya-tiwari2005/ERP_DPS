import prisma from "../lib/prisma.js";

export const getMyHomework = async (userId) => {
  // 1. Find the logged-in student's profile
  const user = await prisma.user.findUnique({
    where: {
      id: userId,
    },
    select: {
      student: {
        select: {
          id: true,
          sectionId: true,
          schoolId: true,
        },
      },
    },
  });

  if (!user || !user.student) {
    throw new Error("STUDENT_NOT_FOUND");
  }

  const { sectionId, schoolId } = user.student;

  if (!sectionId) {
    throw new Error("STUDENT_SECTION_NOT_FOUND");
  }

  if (!schoolId) {
    throw new Error("STUDENT_SCHOOL_NOT_FOUND");
  }

  // 2. Find the active academic year for the student's school
  const academicYear = await prisma.academicyear.findFirst({
    where: {
      schoolId,
      status: "ACTIVE",
    },
    orderBy: {
      startDate: "desc",
    },
    select: {
      id: true,
      name: true,
      startDate: true,
      endDate: true,
    },
  });

  if (!academicYear) {
    throw new Error("ACTIVE_ACADEMIC_YEAR_NOT_FOUND");
  }

  // 3. Get homework for the student's section and active academic year
  const homework = await prisma.homework.findMany({
    where: {
      schoolId,
      sectionId,
      academicYearId: academicYear.id,
      status: "ACTIVE",
    },
    orderBy: [
      {
        assignedDate: "desc",
      },
      {
        dueDate: "asc",
      },
    ],
    select: {
      id: true,
      subject: true,
      title: true,
      description: true,
      assignedDate: true,
      dueDate: true,
      status: true,
    },
  });

  return {
    sectionId,
    academicYear: {
      id: academicYear.id,
      name: academicYear.name,
      startDate: academicYear.startDate,
      endDate: academicYear.endDate,
    },
    homework,
  };
};
export const createHomework = async (data) => {
  const {
    schoolId,
    sectionId,
    academicYearId,
    subject,
    title,
    description,
    assignedDate,
    dueDate,
  } = data;

  const section = await prisma.section.findUnique({
    where: { id: sectionId },
    select: {
      id: true,
      academicclass: {
        select: {
          schoolId: true,
        },
      },
    },
  });

  if (!section) {
    throw new Error("SECTION_NOT_FOUND");
  }

  const academicYear = await prisma.academicyear.findUnique({
    where: { id: academicYearId },
    select: {
      id: true,
      schoolId: true,
    },
  });

  if (!academicYear) {
    throw new Error("ACADEMIC_YEAR_NOT_FOUND");
  }

  if (section.academicclass.schoolId !== schoolId) {
    throw new Error("SCHOOL_MISMATCH");
  }

  if (academicYear.schoolId !== schoolId) {
    throw new Error("SCHOOL_MISMATCH");
  }

  return await prisma.homework.create({
    data: {
      schoolId,
      sectionId,
      academicYearId,
      subject,
      title,
      description: description || null,
      assignedDate: new Date(assignedDate),
      dueDate: dueDate ? new Date(dueDate) : null,
      status: "ACTIVE",
    },
  });
};