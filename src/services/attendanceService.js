import prisma from "../lib/prisma.js";
import {
  getSchoolDate,
  schoolDateToUtc,
} from "../utils/schoolDate.js";

/**
 * Get the attendance/calendar status for a specific school date.
 *
 * Priority:
 * 1. Sunday -> always OFF
 * 2. Specific calendar event/override
 * 3. Saturday working-day policy
 * 4. Normal weekday -> WORKING_DAY
 */
export const getAttendanceDayStatus = async (
  schoolId,
  date,
  classId = null,
) => {
  const schoolDate = getSchoolDate(date);
  const databaseDate = schoolDateToUtc(schoolDate);

  const dayOfWeek = new Date(
    `${schoolDate}T00:00:00Z`,
  ).getUTCDay();

  // 1. Sunday is always OFF
  if (dayOfWeek === 0) {
    return {
      date: schoolDate,
      isAttendanceRequired: false,
      status: "OFF",
      reason: "Sunday",
    };
  }

  // 2. Check new calendar events first
  const events = await prisma.calendarevent.findMany({
    where: {
      schoolId,
      dates: {
        some: {
          date: databaseDate,
        },
      },
      OR: [
        {
          targetType: "ALL_CLASSES",
        },
        {
          targetType: "SELECTED_CLASSES",
          classes: classId
            ? {
                some: {
                  classId,
                },
              }
            : {
                none: {},
              },
        },
      ],
    },
    orderBy: {
      id: "desc",
    },
  });

  if (events.length > 0) {
    const event = events[0];

    // Explicit working-day override
    if (event.type === "WORKING_DAY") {
      return {
        date: schoolDate,
        isAttendanceRequired: true,
        status: "WORKING_DAY",
        reason: event.title,
      };
    }

    // Holiday / vacation / other non-working event
    return {
      date: schoolDate,
      isAttendanceRequired: false,
      status: event.type,
      reason: event.title,
    };
  }

  // 3. Check existing schoolcalendar holidays
  const schoolCalendarEntry =
    await prisma.schoolcalendar.findFirst({
      where: {
        schoolId,
        date: databaseDate,
      },
    });

  if (schoolCalendarEntry) {
    return {
      date: schoolDate,
      isAttendanceRequired: false,
      status: schoolCalendarEntry.status,
      reason: schoolCalendarEntry.title,
    };
  }

  // 4. Saturday policy
 // 4. Saturday policy
if (dayOfWeek === 6) {
  const saturdayRule =
    await prisma.schoolworkingday.findUnique({
      where: {
        schoolId_dayOfWeek: {
          schoolId,
          dayOfWeek: 6,
        },
      },
    });

  // Default: Saturday is working
  if (!saturdayRule) {
    return {
      date: schoolDate,
      isAttendanceRequired: true,
      status: "WORKING_DAY",
      reason: null,
    };
  }

  // First check for a specific Saturday override
  const saturdayOverride =
    await prisma.schoolsaturday.findUnique({
      where: {
        schoolId_date: {
          schoolId,
          date: databaseDate,
        },
      },
    });

  if (saturdayOverride) {
    return {
      date: schoolDate,
      isAttendanceRequired:
        saturdayOverride.isWorking,
      status: saturdayOverride.isWorking
        ? "WORKING_DAY"
        : "OFF",
      reason: saturdayOverride.isWorking
        ? "Saturday working override"
        : "Saturday off override",
    };
  }

  const pattern =
    saturdayRule.saturdayPattern ||
    "ALL_WORKING";

  // Calculate which Saturday of the month this is.
  const dayOfMonth = Number(
    schoolDate.slice(8, 10),
  );

  const saturdayOccurrence =
    Math.ceil(dayOfMonth / 7);

  let isWorking = true;

  switch (pattern) {
    case "ALL_OFF":
      isWorking = false;
      break;

    case "FIRST_THIRD_WORKING":
      isWorking =
        saturdayOccurrence === 1 ||
        saturdayOccurrence === 3;
      break;

    case "SECOND_FOURTH_WORKING":
      isWorking =
        saturdayOccurrence === 2 ||
        saturdayOccurrence === 4;
      break;

    case "FIRST_THIRD_OFF":
      isWorking =
        saturdayOccurrence !== 1 &&
        saturdayOccurrence !== 3;
      break;

    case "SECOND_FOURTH_OFF":
      isWorking =
        saturdayOccurrence !== 2 &&
        saturdayOccurrence !== 4;
      break;

    case "ALL_WORKING":
    default:
      isWorking = true;
      break;
  }

  return {
    date: schoolDate,
    isAttendanceRequired: isWorking,
    status: isWorking
      ? "WORKING_DAY"
      : "OFF",
    reason: isWorking
      ? null
      : "Saturday off",
  };
}

  // 5. Normal working day
  return {
    date: schoolDate,
    isAttendanceRequired: true,
    status: "WORKING_DAY",
    reason: null,
  };
};

/**
 * Get all students of a section and their attendance
 * for a specific school date.
 */
export const getStudentsForAttendance = async (
  sectionId,
  date,
) => {
  const schoolDate = getSchoolDate(date);
  const databaseDate = schoolDateToUtc(schoolDate);

  const students = await prisma.student.findMany({
    where: {
      sectionId,
    },

    orderBy: {
      name: "asc",
    },

    include: {
      attendance: {
        where: {
          date: databaseDate,
        },
      },
    },
  });

  return students.map((student) => ({
    id: student.id,
    studentId: student.studentId,
    name: student.name,
    status: student.attendance[0]?.status ?? null,
  }));
};

/**
 * Mark or update student attendance for a school date.
 */
export const markAttendance = async (
  date,
  attendanceList,
) => {
  const schoolDate = getSchoolDate(date);
  const databaseDate = schoolDateToUtc(schoolDate);

  const allowedStatuses = [
    "PRESENT",
    "ABSENT",
  ];

  for (const record of attendanceList) {
    if (!allowedStatuses.includes(record.status)) {
      throw new Error(
        "INVALID_ATTENDANCE_STATUS",
      );
    }
  }

  const operations = attendanceList.map(
    (record) =>
      prisma.attendance.upsert({
        where: {
          studentId_date: {
            studentId: record.studentId,
            date: databaseDate,
          },
        },

        update: {
          status: record.status,
          updatedAt: new Date(),
        },

        create: {
          studentId: record.studentId,
          date: databaseDate,
          status: record.status,
          updatedAt: new Date(),
        },
      }),
  );

  return await prisma.$transaction(operations);
};

/**
 * Get a student's attendance summary for a date range.
 */
export const getMyAttendanceSummary = async (
  studentId,
  startDate,
  endDate,
) => {
  const startSchoolDate =
    getSchoolDate(startDate);

  const endSchoolDate =
    getSchoolDate(endDate);

  const databaseStartDate =
    schoolDateToUtc(startSchoolDate);

  // End date should include the entire school day.
  const databaseEndDate = new Date(
    `${endSchoolDate}T23:59:59.999+05:30`,
  );

  const records = await prisma.attendance.findMany({
    where: {
      studentId,

      date: {
        gte: databaseStartDate,
        lte: databaseEndDate,
      },
    },

    orderBy: {
      date: "asc",
    },
  });

  const present = records.filter(
    (record) =>
      record.status === "PRESENT",
  ).length;

  const absent = records.filter(
    (record) =>
      record.status === "ABSENT",
  ).length;

  const total = present + absent;

  const percentage =
    total === 0
      ? 0
      : Number(
          ((present / total) * 100).toFixed(2),
        );

  return {
    summary: {
      present,
      absent,
      total,
      percentage,
    },

    records: records.map((record) => ({
      date: record.date,
      status: record.status,
    })),
  };
};
export const getMyAttendanceCalendar = async (
  studentId,
  month,
) => {
  // Expected format: YYYY-MM
  if (!/^\d{4}-\d{2}$/.test(month)) {
    throw new Error("INVALID_MONTH");
  }

  const [year, monthNumber] = month
    .split("-")
    .map(Number);

  const firstDay = `${year}-${String(monthNumber).padStart(2, "0")}-01`;

  const lastDayNumber = new Date(
    Date.UTC(year, monthNumber, 0),
  ).getUTCDate();

  const lastDay =
    `${year}-${String(monthNumber).padStart(2, "0")}-${String(lastDayNumber).padStart(2, "0")}`;

  // Get student + school/class information
  const student = await prisma.student.findUnique({
    where: {
      id: studentId,
    },
    select: {
      id: true,
      schoolId: true,
      sectionId: true,
    },
  });

  if (!student) {
    throw new Error("STUDENT_NOT_FOUND");
  }

  if (!student.schoolId) {
    throw new Error("STUDENT_SCHOOL_NOT_FOUND");
  }

  const startDate = schoolDateToUtc(firstDay);

  const endDate = new Date(
    `${lastDay}T23:59:59.999+05:30`,
  );

  // Get attendance records for the entire month
  const attendanceRecords =
    await prisma.attendance.findMany({
      where: {
        studentId,
        date: {
          gte: startDate,
          lte: endDate,
        },
      },
      orderBy: {
        date: "asc",
      },
    });

  // Convert attendance records into quick lookup
  const attendanceMap = new Map();

  for (const record of attendanceRecords) {
    const recordDate = getSchoolDate(record.date);

    attendanceMap.set(
      recordDate,
      record.status,
    );
  }

  const days = [];

  let present = 0;
  let absent = 0;
  let attendanceRequiredDays = 0;

  const totalDays = lastDayNumber;

  for (let day = 1; day <= totalDays; day++) {
    const currentDate =
      `${year}-${String(monthNumber).padStart(2, "0")}-${String(day).padStart(2, "0")}`;

    const dayStatus =
      await getAttendanceDayStatus(
        student.schoolId,
        currentDate,
        student.sectionId
          ? (
              await prisma.section.findUnique({
                where: {
                  id: student.sectionId,
                },
                select: {
                  classId: true,
                },
              })
            )?.classId ?? null
          : null,
      );

    const attendanceStatus =
      attendanceMap.get(currentDate) ?? null;

    let finalStatus = dayStatus.status;

    if (dayStatus.isAttendanceRequired) {
      attendanceRequiredDays++;

      if (attendanceStatus === "PRESENT") {
        finalStatus = "PRESENT";
        present++;
      } else if (attendanceStatus === "ABSENT") {
        finalStatus = "ABSENT";
        absent++;
      } else {
        finalStatus = "NOT_MARKED";
      }
    }

    days.push({
      date: currentDate,
      status: finalStatus,
      isAttendanceRequired:
        dayStatus.isAttendanceRequired,
      reason: dayStatus.reason,
    });
  }

  const markedAttendance =
    present + absent;

  const percentage =
    markedAttendance === 0
      ? 0
      : Number(
          ((present / markedAttendance) * 100).toFixed(2),
        );

  return {
    month,
    summary: {
      present,
      absent,
      total: markedAttendance,
      attendanceRequiredDays,
      percentage,
    },
    days,
  };
};