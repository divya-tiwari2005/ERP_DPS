import prisma from "../lib/prisma.js";

export const createCalendarEvent = async ({
  schoolId,
  academicYearId,
  title,
  type,
  targetType,
  dates,
  classIds = [],
}) => {
  return await prisma.$transaction(async (tx) => {
    const now = new Date();

    const event = await tx.calendarevent.create({
      data: {
        schoolId,
        academicYearId,
        title,
        type,
        targetType,
        updatedAt: now,
      },
    });

    await tx.calendareventdate.createMany({
      data: dates.map((date) => ({
        eventId: event.id,
        date,
        createdAt: now,
      })),
    });

    if (
      targetType === "SELECTED_CLASSES" &&
      classIds.length > 0
    ) {
      await tx.calendareventclass.createMany({
        data: classIds.map((classId) => ({
          eventId: event.id,
          classId,
        })),
      });
    }

    return await tx.calendarevent.findUnique({
      where: {
        id: event.id,
      },
      include: {
        dates: true,
        classes: true,
      },
    });
  });
};
export const getCalendarEvents = async ({
  schoolId,
  academicYearId,
}) => {
  return await prisma.calendarevent.findMany({
    where: {
      schoolId,
      ...(academicYearId
        ? {
            academicYearId,
          }
        : {}),
    },
    include: {
      dates: {
        orderBy: {
          date: "asc",
        },
      },
      classes: {
        include: {
          academicclass: true,
        },
      },
    },
    orderBy: [
      {
        id: "desc",
      },
    ],
  });
};
export const updateCalendarEvent = async ({
  eventId,
  title,
  type,
  targetType,
  dates,
  classIds = [],
}) => {
  return await prisma.$transaction(async (tx) => {
    const existingEvent =
      await tx.calendarevent.findUnique({
        where: {
          id: eventId,
        },
      });

    if (!existingEvent) {
      throw new Error("CALENDAR_EVENT_NOT_FOUND");
    }

    const now = new Date();

    await tx.calendarevent.update({
      where: {
        id: eventId,
      },
      data: {
        title,
        type,
        targetType,
        updatedAt: now,
      },
    });

    // Replace existing dates
    await tx.calendareventdate.deleteMany({
      where: {
        eventId,
      },
    });

    await tx.calendareventdate.createMany({
      data: dates.map((date) => ({
        eventId,
        date,
        createdAt: now,
      })),
    });

    // Replace existing class targeting
    await tx.calendareventclass.deleteMany({
      where: {
        eventId,
      },
    });

    if (
      targetType === "SELECTED_CLASSES" &&
      classIds.length > 0
    ) {
      await tx.calendareventclass.createMany({
        data: classIds.map((classId) => ({
          eventId,
          classId,
        })),
      });
    }

    return await tx.calendarevent.findUnique({
      where: {
        id: eventId,
      },
      include: {
        dates: {
          orderBy: {
            date: "asc",
          },
        },
        classes: true,
      },
    });
  });
};
export const deleteCalendarEvent = async (eventId) => {
  return await prisma.$transaction(async (tx) => {
    const existingEvent =
      await tx.calendarevent.findUnique({
        where: {
          id: eventId,
        },
      });

    if (!existingEvent) {
      throw new Error("CALENDAR_EVENT_NOT_FOUND");
    }

    // Delete class targeting
    await tx.calendareventclass.deleteMany({
      where: {
        eventId,
      },
    });

    // Delete event dates
    await tx.calendareventdate.deleteMany({
      where: {
        eventId,
      },
    });

    // Delete the event
    await tx.calendarevent.delete({
      where: {
        id: eventId,
      },
    });

    return existingEvent;
  });
};
export const getSaturdayPolicy = async (schoolId) => {
  return await prisma.schoolworkingday.findUnique({
    where: {
      schoolId_dayOfWeek: {
        schoolId,
        dayOfWeek: 6,
      },
    },
  });
};

export const updateSaturdayPolicy = async ({
  schoolId,
  isWorking,
  saturdayPattern,
}) => {
  return await prisma.schoolworkingday.upsert({
    where: {
      schoolId_dayOfWeek: {
        schoolId,
        dayOfWeek: 6,
      },
    },
    update: {
      isWorking,
      saturdayPattern,
      updatedAt: new Date(),
    },
    create: {
      schoolId,
      dayOfWeek: 6,
      isWorking,
      saturdayPattern,
      updatedAt: new Date(),
    },
  });
};
export const getSelectedSaturdayRules = async (
  schoolId,
  startDate,
  endDate,
) => {
  return await prisma.schoolsaturday.findMany({
    where: {
      schoolId,
      date: {
        gte: startDate,
        lte: endDate,
      },
    },
    orderBy: {
      date: "asc",
    },
  });
};

export const updateSelectedSaturdayRules = async ({
  schoolId,
  rules,
}) => {
  return await prisma.$transaction(async (tx) => {
    for (const rule of rules) {
      await tx.schoolsaturday.upsert({
        where: {
          schoolId_date: {
            schoolId,
            date: rule.date,
          },
        },
        update: {
          isWorking: rule.isWorking,
          updatedAt: new Date(),
        },
        create: {
          schoolId,
          date: rule.date,
          isWorking: rule.isWorking,
          updatedAt: new Date(),
        },
      });
    }

    return await tx.schoolsaturday.findMany({
      where: {
        schoolId,
      },
      orderBy: {
        date: "asc",
      },
    });
  });
};