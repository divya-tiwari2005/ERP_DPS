import prisma from "../lib/prisma.js";

export const getTimetableBySection = async (
  sectionId,
  academicYearId,
) => {
  return await prisma.timetable.findMany({
    where: {
      sectionId,
      academicYearId,
    },
    orderBy: [
      { dayOfWeek: "asc" },
      { periodNumber: "asc" },
    ],
    select: {
      id: true,
      sectionId: true,
      academicYearId: true,
      dayOfWeek: true,
      periodNumber: true,
      startTime: true,
      endTime: true,
      title: true,
      type: true,
    },
  });
};

export const createTimetableEntry = async (data) => {
  const {
    sectionId,
    academicYearId,
    dayOfWeek,
    periodNumber,
    startTime,
    endTime,
    title,
    type,
  } = data;

  // 1. Check that the section exists
  const section = await prisma.section.findUnique({
    where: {
      id: sectionId,
    },
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

  // 2. Check that the academic year exists
  const academicYear = await prisma.academicyear.findUnique({
    where: {
      id: academicYearId,
    },
    select: {
      id: true,
      schoolId: true,
    },
  });

  if (!academicYear) {
    throw new Error("ACADEMIC_YEAR_NOT_FOUND");
  }

  // 3. Section and academic year must belong to the same school
  if (section.academicclass.schoolId !== academicYear.schoolId) {
    throw new Error("SCHOOL_MISMATCH");
  }

  // 4. Check for duplicate period
  const existingEntry = await prisma.timetable.findUnique({
    where: {
      sectionId_academicYearId_dayOfWeek_periodNumber: {
        sectionId,
        academicYearId,
        dayOfWeek,
        periodNumber,
      },
    },
  });

  if (existingEntry) {
    throw new Error("TIMETABLE_ENTRY_EXISTS");
  }

  // 5. Create the timetable entry
  return await prisma.timetable.create({
    data: {
      sectionId,
      academicYearId,
      dayOfWeek,
      periodNumber,
      startTime,
      endTime,
      title,
      type,
    },
  });
};
export const getMyTimetable = async (userId) => {
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

  // 3. Get the timetable for the student's section
  const timetable = await prisma.timetable.findMany({
    where: {
      sectionId,
      academicYearId: academicYear.id,
    },
    orderBy: [
      {
        dayOfWeek: "asc",
      },
      {
        periodNumber: "asc",
      },
    ],
    select: {
      id: true,
      dayOfWeek: true,
      periodNumber: true,
      startTime: true,
      endTime: true,
      title: true,
      type: true,
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
    timetable,
  };
};