import prisma from "../lib/prisma.js";

export const getStudentProfile = async (userId) => {
  const user = await prisma.user.findUnique({
    where: {
      id: userId,
    },
    include: {
      student: {
        include: {
          school: true,
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

  return {
    id: student.id,
    studentId: student.studentId,
    name: student.name,
    email: student.email,
    phone: student.phone,
    profileImageUrl: student.profileImageUrl,

    school: student.school
      ? {
          id: student.school.id,
          name: student.school.name,
          code: student.school.code,
        }
      : null,

    class: student.section?.academicclass
      ? {
          id: student.section.academicclass.id,
          name: student.section.academicclass.name,
        }
      : null,

    section: student.section
      ? {
          id: student.section.id,
          name: student.section.name,
        }
      : null,
  };
};