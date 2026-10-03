import {
  createCalendarEvent,
  getCalendarEvents,
  updateCalendarEvent,
  deleteCalendarEvent,
  getSaturdayPolicy,
  updateSaturdayPolicy,
  getSelectedSaturdayRules,
  updateSelectedSaturdayRules,
} from "../services/calendarService.js";

export const createCalendar = async (req, res) => {
  try {
    const {
      schoolId,
      academicYearId,
      title,
      type,
      targetType = "ALL_CLASSES",
      dates,
      classIds = [],
    } = req.body;

    // Required fields
    if (
      !schoolId ||
      !academicYearId ||
      !title ||
      !type ||
      !dates
    ) {
      return res.status(400).json({
        message:
          "schoolId, academicYearId, title, type and dates are required.",
      });
    }

    // Validate IDs
    const parsedSchoolId = Number(schoolId);
    const parsedAcademicYearId = Number(academicYearId);

    if (
      !Number.isInteger(parsedSchoolId) ||
      !Number.isInteger(parsedAcademicYearId)
    ) {
      return res.status(400).json({
        message: "Invalid schoolId or academicYearId.",
      });
    }

    // Validate target type
    const allowedTargetTypes = [
      "ALL_CLASSES",
      "SELECTED_CLASSES",
    ];

    if (!allowedTargetTypes.includes(targetType)) {
      return res.status(400).json({
        message: "Invalid targetType.",
      });
    }

    // Validate dates
    if (!Array.isArray(dates) || dates.length === 0) {
      return res.status(400).json({
        message: "dates must be a non-empty array.",
      });
    }

    const parsedDates = dates.map((date) => {
      if (
        typeof date !== "string" ||
        !/^\d{4}-\d{2}-\d{2}$/.test(date)
      ) {
        throw new Error("INVALID_DATE");
      }

      const parsedDate = new Date(
        `${date}T00:00:00+05:30`,
      );

      if (Number.isNaN(parsedDate.getTime())) {
        throw new Error("INVALID_DATE");
      }

      return parsedDate;
    });

    // Selected classes require class IDs
    if (targetType === "SELECTED_CLASSES") {
      if (
        !Array.isArray(classIds) ||
        classIds.length === 0
      ) {
        return res.status(400).json({
          message:
            "classIds are required for SELECTED_CLASSES.",
        });
      }
    }

    const parsedClassIds = classIds.map(Number);

    if (
      parsedClassIds.some(
        (classId) => !Number.isInteger(classId),
      )
    ) {
      return res.status(400).json({
        message: "Invalid classIds.",
      });
    }

    const calendarEvent = await createCalendarEvent({
      schoolId: parsedSchoolId,
      academicYearId: parsedAcademicYearId,
      title: title.trim(),
      type: type.trim(),
      targetType,
      dates: parsedDates,
      classIds: parsedClassIds,
    });

    return res.status(201).json({
      message:
        "Calendar event created successfully.",
      calendar: calendarEvent,
    });
  } catch (error) {
    console.error(
      "Create calendar event error:",
      error,
    );

    if (error.message === "INVALID_DATE") {
      return res.status(400).json({
        message:
          "Invalid date. Use YYYY-MM-DD format.",
      });
    }

    return res.status(500).json({
      message:
        "Unable to create calendar event.",
    });
  }
};

export const getCalendar = async (req, res) => {
  try {
    const { schoolId, academicYearId } = req.query;

    if (!schoolId) {
      return res.status(400).json({
        message: "schoolId is required.",
      });
    }

    const parsedSchoolId = Number(schoolId);

    if (!Number.isInteger(parsedSchoolId)) {
      return res.status(400).json({
        message: "Invalid schoolId.",
      });
    }

    let parsedAcademicYearId;

    if (academicYearId) {
      parsedAcademicYearId = Number(academicYearId);

      if (!Number.isInteger(parsedAcademicYearId)) {
        return res.status(400).json({
          message: "Invalid academicYearId.",
        });
      }
    }

    const events = await getCalendarEvents({
      schoolId: parsedSchoolId,
      academicYearId: parsedAcademicYearId,
    });

    return res.status(200).json({
      schoolId: parsedSchoolId,
      academicYearId:
        parsedAcademicYearId ?? null,
      events,
    });
  } catch (error) {
    console.error(
      "Get calendar events error:",
      error,
    );

    return res.status(500).json({
      message:
        "Unable to fetch calendar events.",
    });
  }
};

export const updateCalendar = async (req, res) => {
  try {
    const { id } = req.params;

    const {
      title,
      type,
      targetType = "ALL_CLASSES",
      dates,
      classIds = [],
    } = req.body;

    const eventId = Number(id);

    if (!Number.isInteger(eventId)) {
      return res.status(400).json({
        message: "Invalid calendar event ID.",
      });
    }

    if (
      !title ||
      !type ||
      !dates
    ) {
      return res.status(400).json({
        message:
          "title, type and dates are required.",
      });
    }

    const allowedTargetTypes = [
      "ALL_CLASSES",
      "SELECTED_CLASSES",
    ];

    if (!allowedTargetTypes.includes(targetType)) {
      return res.status(400).json({
        message: "Invalid targetType.",
      });
    }

    if (
      !Array.isArray(dates) ||
      dates.length === 0
    ) {
      return res.status(400).json({
        message:
          "dates must be a non-empty array.",
      });
    }

    const parsedDates = dates.map((date) => {
      if (
        typeof date !== "string" ||
        !/^\d{4}-\d{2}-\d{2}$/.test(date)
      ) {
        throw new Error("INVALID_DATE");
      }

      const parsedDate = new Date(
        `${date}T00:00:00+05:30`,
      );

      if (Number.isNaN(parsedDate.getTime())) {
        throw new Error("INVALID_DATE");
      }

      return parsedDate;
    });

    if (targetType === "SELECTED_CLASSES") {
      if (
        !Array.isArray(classIds) ||
        classIds.length === 0
      ) {
        return res.status(400).json({
          message:
            "classIds are required for SELECTED_CLASSES.",
        });
      }
    }

    const parsedClassIds = classIds.map(Number);

    if (
      parsedClassIds.some(
        (classId) => !Number.isInteger(classId),
      )
    ) {
      return res.status(400).json({
        message: "Invalid classIds.",
      });
    }

    const updatedEvent =
      await updateCalendarEvent({
        eventId,
        title: title.trim(),
        type: type.trim(),
        targetType,
        dates: parsedDates,
        classIds: parsedClassIds,
      });

    return res.status(200).json({
      message:
        "Calendar event updated successfully.",
      calendar: updatedEvent,
    });
  } catch (error) {
    console.error(
      "Update calendar event error:",
      error,
    );

    if (
      error.message ===
      "CALENDAR_EVENT_NOT_FOUND"
    ) {
      return res.status(404).json({
        message: "Calendar event not found.",
      });
    }

    if (error.message === "INVALID_DATE") {
      return res.status(400).json({
        message:
          "Invalid date. Use YYYY-MM-DD format.",
      });
    }

    return res.status(500).json({
      message:
        "Unable to update calendar event.",
    });
  }
};

export const deleteCalendar = async (req, res) => {
  try {
    const { id } = req.params;

    const eventId = Number(id);

    if (!Number.isInteger(eventId)) {
      return res.status(400).json({
        message: "Invalid calendar event ID.",
      });
    }

    await deleteCalendarEvent(eventId);

    return res.status(200).json({
      message:
        "Calendar event deleted successfully.",
    });
  } catch (error) {
    console.error(
      "Delete calendar event error:",
      error,
    );

    if (
      error.message ===
      "CALENDAR_EVENT_NOT_FOUND"
    ) {
      return res.status(404).json({
        message: "Calendar event not found.",
      });
    }

    return res.status(500).json({
      message:
        "Unable to delete calendar event.",
    });
  }
};

export const getSaturdayPolicyController = async (
  req,
  res,
) => {
  try {
    const schoolId = Number(req.query.schoolId);

    if (!Number.isInteger(schoolId)) {
      return res.status(400).json({
        message: "Invalid school ID.",
      });
    }

    const policy = await getSaturdayPolicy(schoolId);

    return res.status(200).json({
      schoolId,
      dayOfWeek: 6,
      isWorking: policy
        ? policy.isWorking
        : true,
      saturdayPattern:
        policy?.saturdayPattern ??
        "ALL_WORKING",
    });
  } catch (error) {
    console.error(
      "Get Saturday policy error:",
      error,
    );

    return res.status(500).json({
      message:
        "Unable to fetch Saturday policy.",
    });
  }
};

export const updateSaturdayPolicyController = async (
  req,
  res,
) => {
  try {
    const schoolId = Number(req.body.schoolId);
    const {
      saturdayPattern,
    } = req.body;

    const allowedPatterns = [
      "ALL_WORKING",
      "ALL_OFF",
      "FIRST_THIRD_WORKING",
      "SECOND_FOURTH_WORKING",
      "FIRST_THIRD_OFF",
      "SECOND_FOURTH_OFF",
    ];

    if (!Number.isInteger(schoolId)) {
      return res.status(400).json({
        message: "Invalid school ID.",
      });
    }

    if (
      !allowedPatterns.includes(
        saturdayPattern,
      )
    ) {
      return res.status(400).json({
        message:
          "Invalid Saturday pattern.",
      });
    }

    const isWorking =
      saturdayPattern === "ALL_WORKING";

    const policy =
      await updateSaturdayPolicy({
        schoolId,
        isWorking,
        saturdayPattern,
      });

    return res.status(200).json({
      message:
        "Saturday policy updated successfully.",
      schoolId,
      dayOfWeek: 6,
      isWorking: policy.isWorking,
      saturdayPattern:
        policy.saturdayPattern,
    });
  } catch (error) {
    console.error(
      "Update Saturday policy error:",
      error,
    );

    return res.status(500).json({
      message:
        "Unable to update Saturday policy.",
    });
  }
};

export const getSelectedSaturdayRulesController = async (
  req,
  res,
) => {
  try {
    const schoolId = Number(req.query.schoolId);

    if (!Number.isInteger(schoolId)) {
      return res.status(400).json({
        message: "Invalid school ID.",
      });
    }

    const rules = await getSelectedSaturdayRules(
      schoolId,
      new Date("2000-01-01T00:00:00+05:30"),
      new Date("2100-12-31T23:59:59+05:30"),
    );

    return res.status(200).json({
      schoolId,
      rules: rules.map((rule) => ({
        date: rule.date,
        isWorking: rule.isWorking,
      })),
    });
  } catch (error) {
    console.error(
      "Get selected Saturday rules error:",
      error,
    );

    return res.status(500).json({
      message:
        "Unable to fetch selected Saturday rules.",
    });
  }
};

export const updateSelectedSaturdayRulesController =
  async (req, res) => {
    try {
      const schoolId = Number(req.body.schoolId);
      const { rules } = req.body;

      if (!Number.isInteger(schoolId)) {
        return res.status(400).json({
          message: "Invalid school ID.",
        });
      }

      if (!Array.isArray(rules)) {
        return res.status(400).json({
          message: "rules must be an array.",
        });
      }

      const parsedRules = rules.map((rule) => {
        if (
          typeof rule.date !== "string" ||
          !/^\d{4}-\d{2}-\d{2}$/.test(rule.date)
        ) {
          throw new Error("INVALID_DATE");
        }

        if (typeof rule.isWorking !== "boolean") {
          throw new Error("INVALID_WORKING_VALUE");
        }

        const date = new Date(
          `${rule.date}T00:00:00+05:30`,
        );

        const dayOfWeek = new Date(
          `${rule.date}T00:00:00Z`,
        ).getUTCDay();

        if (dayOfWeek !== 6) {
          throw new Error("NOT_SATURDAY");
        }

        return {
          date,
          isWorking: rule.isWorking,
        };
      });

      const updatedRules =
        await updateSelectedSaturdayRules({
          schoolId,
          rules: parsedRules,
        });

      return res.status(200).json({
        message:
          "Selected Saturday rules updated successfully.",
        schoolId,
        rules: updatedRules.map((rule) => ({
          date: rule.date,
          isWorking: rule.isWorking,
        })),
      });
    } catch (error) {
      console.error(
        "Update selected Saturday rules error:",
        error,
      );

      if (error.message === "INVALID_DATE") {
        return res.status(400).json({
          message:
            "Invalid date. Use YYYY-MM-DD format.",
        });
      }

      if (
        error.message === "INVALID_WORKING_VALUE"
      ) {
        return res.status(400).json({
          message:
            "isWorking must be true or false.",
        });
      }

      if (error.message === "NOT_SATURDAY") {
        return res.status(400).json({
          message:
            "Selected Saturday rules can only contain Saturdays.",
        });
      }

      return res.status(500).json({
        message:
          "Unable to update selected Saturday rules.",
      });
    }
  };