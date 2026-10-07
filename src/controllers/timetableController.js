import {
  getTimetableBySection,
  createTimetableEntry,
  getMyTimetable,
} from "../services/timetableService.js";

export const getTimetableController = async (req, res) => {
  try {
    const { sectionId, academicYearId } = req.query;

    if (!sectionId || !academicYearId) {
      return res.status(400).json({
        message: "sectionId and academicYearId are required.",
      });
    }

    const parsedSectionId = Number(sectionId);
    const parsedAcademicYearId = Number(academicYearId);

    if (
      !Number.isInteger(parsedSectionId) ||
      !Number.isInteger(parsedAcademicYearId)
    ) {
      return res.status(400).json({
        message: "Invalid sectionId or academicYearId.",
      });
    }

    const timetable = await getTimetableBySection(
      parsedSectionId,
      parsedAcademicYearId,
    );

    return res.status(200).json({
      sectionId: parsedSectionId,
      academicYearId: parsedAcademicYearId,
      timetable,
    });
  } catch (error) {
    console.error("Get timetable error:", error);

    return res.status(500).json({
      message: "Unable to fetch timetable.",
    });
  }
};
export const createTimetableController = async (req, res) => {
  try {
    const {
      sectionId,
      academicYearId,
      dayOfWeek,
      periodNumber,
      startTime,
      endTime,
      title,
      type,
    } = req.body;

    // Basic required-field validation
    if (
      sectionId === undefined ||
      academicYearId === undefined ||
      dayOfWeek === undefined ||
      periodNumber === undefined ||
      !startTime ||
      !endTime ||
      !title
    ) {
      return res.status(400).json({
        message: "All timetable fields are required.",
      });
    }

    const parsedSectionId = Number(sectionId);
    const parsedAcademicYearId = Number(academicYearId);
    const parsedDayOfWeek = Number(dayOfWeek);
    const parsedPeriodNumber = Number(periodNumber);

    if (
      !Number.isInteger(parsedSectionId) ||
      !Number.isInteger(parsedAcademicYearId) ||
      !Number.isInteger(parsedDayOfWeek) ||
      !Number.isInteger(parsedPeriodNumber)
    ) {
      return res.status(400).json({
        message: "Invalid timetable values.",
      });
    }

    // Day must be Monday-Sunday
    if (parsedDayOfWeek < 1 || parsedDayOfWeek > 7) {
      return res.status(400).json({
        message: "dayOfWeek must be between 1 and 7.",
      });
    }

    // Period number must be positive
    if (parsedPeriodNumber < 1) {
      return res.status(400).json({
        message: "periodNumber must be greater than 0.",
      });
    }

    const allowedTypes = [
      "SUBJECT",
      "BREAK",
      "LUNCH",
      "ACTIVITY",
    ];

    const timetableType = type
      ? String(type).toUpperCase()
      : "SUBJECT";

    if (!allowedTypes.includes(timetableType)) {
      return res.status(400).json({
        message: "Invalid timetable type.",
      });
    }

    const timetable = await createTimetableEntry({
      sectionId: parsedSectionId,
      academicYearId: parsedAcademicYearId,
      dayOfWeek: parsedDayOfWeek,
      periodNumber: parsedPeriodNumber,
      startTime,
      endTime,
      title: String(title).trim(),
      type: timetableType,
    });

    return res.status(201).json({
      message: "Timetable entry created successfully.",
      timetable,
    });
  } catch (error) {
    if (error.message === "SECTION_NOT_FOUND") {
      return res.status(404).json({
        message: "Section not found.",
      });
    }

    if (error.message === "ACADEMIC_YEAR_NOT_FOUND") {
      return res.status(404).json({
        message: "Academic year not found.",
      });
    }

    if (error.message === "SCHOOL_MISMATCH") {
      return res.status(400).json({
        message:
          "Section and academic year must belong to the same school.",
      });
    }

    if (error.message === "TIMETABLE_ENTRY_EXISTS") {
      return res.status(409).json({
        message:
          "A timetable entry already exists for this period.",
      });
    }

    console.error("Create timetable error:", error);

    return res.status(500).json({
      message: "Unable to create timetable entry.",
    });
  }
};
export const getMyTimetableController = async (req, res) => {
  try {
    const timetable = await getMyTimetable(req.user.userId);

    return res.status(200).json(timetable);
  } catch (error) {
    if (error.message === "STUDENT_NOT_FOUND") {
      return res.status(404).json({
        message: "Student profile not found.",
      });
    }

    if (error.message === "STUDENT_SECTION_NOT_FOUND") {
      return res.status(404).json({
        message: "Student section not found.",
      });
    }

    if (error.message === "STUDENT_SCHOOL_NOT_FOUND") {
      return res.status(404).json({
        message: "Student school not found.",
      });
    }

    if (error.message === "ACTIVE_ACADEMIC_YEAR_NOT_FOUND") {
      return res.status(404).json({
        message: "Active academic year not found.",
      });
    }

    console.error("Get my timetable error:", error);

    return res.status(500).json({
      message: "Unable to fetch timetable.",
    });
  }
};