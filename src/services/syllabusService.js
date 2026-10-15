
import prisma from "../lib/prisma.js";

export const createSyllabus = async ({
  classSubjectId,
  academicYearId,
}) => {
  return prisma.syllabus.create({
    data: {
      classSubjectId: Number(classSubjectId),
      academicYearId: Number(academicYearId),
    },
    include: {
      classSubject: {
        include: {
          academicclass: true,
          subject: true,
        },
      },
      academicYear: true,
    },
  });
};

export const getSyllabusByClassSubject = async ({
  classSubjectId,
  academicYearId,
}) => {
  return prisma.syllabus.findUnique({
    where: {
      classSubjectId_academicYearId: {
        classSubjectId: Number(classSubjectId),
        academicYearId: Number(academicYearId),
      },
    },
    include: {
      classSubject: {
        include: {
          academicclass: true,
          subject: true,
        },
      },
      academicYear: true,
      units: {
        orderBy: {
          position: "asc",
        },
        include: {
          chapters: {
            orderBy: {
              position: "asc",
            },
            include: {
              topics: {
                orderBy: {
                  position: "asc",
                },
              },
            },
          },
        },
      },
      syllabuschapters: {
        where: {
          unitId: null,
        },
        orderBy: {
          position: "asc",
        },
        include: {
          topics: {
            orderBy: {
              position: "asc",
            },
          },
        },
      },
    },
  });
};

export const createSyllabusUnit = async ({
  syllabusId,
  title,
  position,
}) => {
  return prisma.syllabusunit.create({
    data: {
      syllabusId: Number(syllabusId),
      title: title.trim(),
      ...(position !== undefined
        ? { position: Number(position) }
        : {}),
    },
  });
};

export const createSyllabusChapter = async ({
  syllabusId,
  unitId,
  title,
  position,
}) => {
  return prisma.syllabuschapter.create({
    data: {
      syllabusId: Number(syllabusId),
      unitId: Number(unitId),
      title: title.trim(),
      ...(position !== undefined
        ? { position: Number(position) }
        : {}),
    },
  });
};

export const createSyllabusTopic = async ({
  chapterId,
  title,
  position,
}) => {
  return prisma.syllabustopic.create({
    data: {
      chapterId: Number(chapterId),
      title: title.trim(),
      ...(position !== undefined
        ? { position: Number(position) }
        : {}),
    },
  });
};
