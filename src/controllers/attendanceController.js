import prisma from "../lib/prisma.js";

import {
  getAttendanceDayStatus,
  getStudentsForAttendance,
  markAttendance,
  getMyAttendanceSummary,
  getMyAttendanceCalendar,
} from "../services/attendanceService.js";

export const checkAttendanceDay = async (req, res) => {
  try {
    const { schoolId, date } = req.query;

    if (!schoolId || !date) {
      return res.status(400).json({
        message: "schoolId and date are required.",
      });
    }

    const parsedSchoolId = Number(schoolId);

    if (!Number.isInteger(parsedSchoolId)) {
      return res.status(400).json({
        message: "Invalid schoolId.",
      });
    }

    const parsedDate = new Date(`${date}T00:00:00`);

    if (Number.isNaN(parsedDate.getTime())) {
      return res.status(400).json({
        message: "Invalid date.",
      });
    }

    const result = await getAttendanceDayStatus(
      parsedSchoolId,
      parsedDate
    );

    return res.status(200).json(result);
  } catch (error) {
    console.error("Check attendance day error:", error);

    return res.status(500).json({
      message: "Unable to check attendance day.",
    });
  }
};
export const getStudentsForAttendanceController = async (req, res) => {
  try {
    const { sectionId, date } = req.query;

    if (!sectionId || !date) {
      return res.status(400).json({
        message: "sectionId and date are required.",
      });
    }

    const parsedSectionId = Number(sectionId);

    if (!Number.isInteger(parsedSectionId)) {
      return res.status(400).json({
        message: "Invalid sectionId.",
      });
    }

    const parsedDate = new Date(`${date}T00:00:00`);

    if (Number.isNaN(parsedDate.getTime())) {
      return res.status(400).json({
        message: "Invalid date.",
      });
    }

    const students = await getStudentsForAttendance(
      parsedSectionId,
      parsedDate,
    );

    return res.status(200).json({
      date,
      students,
    });
  } catch (error) {
    console.error("Get students for attendance error:", error);

    return res.status(500).json({
      message: "Unable to fetch students for attendance.",
    });
  }
};
export const markAttendanceController = async (req, res) => {
  try {
    const { date, attendance } = req.body;

    if (!date || !Array.isArray(attendance) || attendance.length === 0) {
      return res.status(400).json({
        message: "date and attendance are required.",
      });
    }

    const parsedDate = new Date(`${date}T00:00:00`);

    if (Number.isNaN(parsedDate.getTime())) {
      return res.status(400).json({
        message: "Invalid date.",
      });
    }

    const studentIds = attendance.map((record) => Number(record.studentId));

    if (studentIds.some((id) => !Number.isInteger(id))) {
      return res.status(400).json({
        message: "Invalid studentId.",
      });
    }

    // Get the school through the students being marked.
    const students = await prisma.student.findMany({
      where: {
        id: {
          in: studentIds,
        },
      },
      select: {
        id: true,
        schoolId: true,
      },
    });

    if (students.length !== studentIds.length) {
      return res.status(404).json({
        message: "One or more students were not found.",
      });
    }

    const schoolIds = [
      ...new Set(students.map((student) => student.schoolId)),
    ];

    if (schoolIds.length !== 1 || schoolIds[0] == null) {
      return res.status(400).json({
        message: "Students must belong to the same school.",
      });
    }

    const dayStatus = await getAttendanceDayStatus(
      schoolIds[0],
      parsedDate,
    );

    if (!dayStatus.isAttendanceRequired) {
      return res.status(400).json({
        message: `Attendance cannot be marked. ${dayStatus.reason ?? "This is not a working day."}`,
      });
    }

    const result = await markAttendance(
      parsedDate,
      attendance.map((record) => ({
        studentId: Number(record.studentId),
        status: record.status,
      })),
    );

    return res.status(200).json({
      message: "Attendance saved successfully.",
      date,
      count: result.length,
    });
  } catch (error) {
    if (error.message === "INVALID_ATTENDANCE_STATUS") {
      return res.status(400).json({
        message: "Invalid attendance status.",
      });
    }

    console.error("Mark attendance error:", error);

    return res.status(500).json({
      message: "Unable to save attendance.",
    });
  }
};
export const getMyAttendanceSummaryController = async (req, res) => {
  try {
    const { startDate, endDate } = req.query;

    if (!startDate || !endDate) {
      return res.status(400).json({
        message: "startDate and endDate are required.",
      });
    }

    const parsedStartDate = new Date(`${startDate}T00:00:00`);
    const parsedEndDate = new Date(`${endDate}T23:59:59`);

    if (
      Number.isNaN(parsedStartDate.getTime()) ||
      Number.isNaN(parsedEndDate.getTime())
    ) {
      return res.status(400).json({
        message: "Invalid date range.",
      });
    }

    if (parsedStartDate > parsedEndDate) {
      return res.status(400).json({
        message: "startDate cannot be after endDate.",
      });
    }

    const user = await prisma.user.findUnique({
      where: {
        id: req.user.userId,
      },
      select: {
        studentId: true,
      },
    });

    if (!user || !user.studentId) {
      return res.status(404).json({
        message: "Student profile not found.",
      });
    }

    const result = await getMyAttendanceSummary(
      user.studentId,
      parsedStartDate,
      parsedEndDate,
    );

    return res.status(200).json(result);
  } catch (error) {
    console.error("Get attendance summary error:", error);

    return res.status(500).json({
      message: "Unable to fetch attendance summary.",
    });
  }
};
export const getMyAttendanceCalendarController =
  async (req, res) => {
    try {
      const { month } = req.query;

      if (!month) {
        return res.status(400).json({
          message: "Month is required.",
        });
      }

      const calendar =
        await getMyAttendanceCalendar(
          req.user.userId,
          month,
        );

      return res.status(200).json(calendar);
    } catch (error) {
      console.error(
        "Get attendance calendar error:",
        error,
      );

      if (error.message === "INVALID_MONTH") {
        return res.status(400).json({
          message:
            "Invalid month. Use YYYY-MM format.",
        });
      }

      if (
        error.message === "STUDENT_NOT_FOUND" ||
        error.message ===
          "STUDENT_SCHOOL_NOT_FOUND"
      ) {
        return res.status(404).json({
          message: error.message,
        });
      }

      return res.status(500).json({
        message:
          "Unable to fetch attendance calendar.",
      });
    }
  };