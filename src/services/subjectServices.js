import prisma from "../lib/prisma.js";

export const createSubject = async ({
  schoolId,
  name,
  code,
  category,
}) => {
  return prisma.schoolsubject.create({
    data: {
      schoolId,
      name,
      ...(code ? { code } : {}),
      ...(category ? { category } : {}),
    },
  });
};

export const getSchoolSubjects = async (schoolId) => {
  return prisma.schoolsubject.findMany({
    where: {
      schoolId,
    },
    orderBy: {
      name: "asc",
    },
  });
};

export const assignSubjectToClass = async ({
  classId,
  subjectId,
}) => {
  return prisma.classsubject.create({
    data: {
      classId,
      subjectId,
    },
    include: {
      academicclass: true,
      schoolsubject: true,
    },
  });
};