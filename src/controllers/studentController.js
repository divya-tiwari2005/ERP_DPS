
import { getStudentProfile } from "../services/studentService.js";
import prisma from "../lib/prisma.js";

export const getMyProfile = async (req, res) => {
  try {
    const student = await getStudentProfile(req.user.userId);

    return res.status(200).json({
      student,
    });
  } catch (error) {
    if (error.message === "STUDENT_NOT_FOUND") {
      return res.status(404).json({
        message: "Student profile not found.",
      });
    }

    console.error("Get student profile error:", error);

    return res.status(500).json({
      message: "Unable to fetch student profile.",
    });
  }
};

// Resolve the student linked to the authenticated user.
const getAuthenticatedStudent = async (userId) => {
  if (userId === undefined || userId === null) {
    throw new Error("AUTHENTICATED_USER_ID_MISSING");
  }

  const account = await prisma.user.findUnique({
    where: {
      id: Number(userId),
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

  if (!account || account.status !== "ACTIVE" || !account.student) {
    return null;
  }

  return account.student;
};

// GET /student/subjects
export const getMySubjects = async (req, res) => {
  try {
    const student = await getAuthenticatedStudent(req.user.userId);

    if (!student) {
      return res.status(404).json({
        message: "Student profile or enrollment not found.",
      });
    }

    if (!student.schoolId || !student.section?.academicclass) {
      return res.status(409).json({
        message: "Student school, class, or section is not configured.",
      });
    }

    const classId = student.section.academicclass.id;

    const subjects = await prisma.classsubject.findMany({
      where: {
        classId,
        subject: {
          schoolId: student.schoolId,
        },
      },
      include: {
        subject: true,
        syllabi: {
          where: {
            academicYear: {
              schoolId: student.schoolId,
              status: "ACTIVE",
            },
          },
          include: {
            academicYear: {
              select: {
                id: true,
                name: true,
              },
            },
          },
        },
      },
      orderBy: {
        subject: {
          name: "asc",
        },
      },
    });

    return res.status(200).json({
      class: student.section.academicclass.name,
      section: student.section.name,
      subjects: subjects.map((item) => ({
        id: item.subject.id,
        name: item.subject.name,
        code: item.subject.code,
        category: item.subject.category,
        syllabus: item.syllabi[0]
          ? {
              id: item.syllabi[0].id,
              academicYear: item.syllabi[0].academicYear,
            }
          : null,
      })),
    });
  } catch (error) {
    console.error("Get student subjects error:", error);

    if (error.message === "AUTHENTICATED_USER_ID_MISSING") {
      return res.status(401).json({
        message: "Authenticated user ID is missing.",
      });
    }

    return res.status(500).json({
      message: "Unable to fetch subjects.",
    });
  }
};
