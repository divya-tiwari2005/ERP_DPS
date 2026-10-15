
import {
  createSyllabus,
  getSyllabusByClassSubject,
  createSyllabusUnit,
  createSyllabusChapter,
  createSyllabusTopic,
} from "../services/syllabusService.js";

export const createSyllabusController = async (req, res) => {
  try {
    const { classSubjectId, academicYearId } = req.body;

    if (
      !Number.isInteger(Number(classSubjectId)) ||
      Number(classSubjectId) <= 0 ||
      !Number.isInteger(Number(academicYearId)) ||
      Number(academicYearId) <= 0
    ) {
      return res.status(400).json({
        message: "Valid classSubjectId and academicYearId are required.",
      });
    }

    const syllabus = await createSyllabus({
      classSubjectId,
      academicYearId,
    });

    return res.status(201).json({
      message: "Syllabus created successfully.",
      syllabus,
    });
  } catch (error) {
    if (error.code === "P2002") {
      return res.status(409).json({
        message: "A syllabus already exists for this class-subject and academic year.",
      });
    }

    if (error.code === "P2003" || error.code === "P2025") {
      return res.status(400).json({
        message: "The specified class-subject or academic year does not exist.",
      });
    }

    console.error("Create syllabus error:", error);

    return res.status(500).json({
      message: "Unable to create syllabus.",
    });
  }
};

export const getSyllabusController = async (req, res) => {
  try {
    const { classSubjectId, academicYearId } = req.query;

    if (
      !Number.isInteger(Number(classSubjectId)) ||
      Number(classSubjectId) <= 0 ||
      !Number.isInteger(Number(academicYearId)) ||
      Number(academicYearId) <= 0
    ) {
      return res.status(400).json({
        message: "Valid classSubjectId and academicYearId query parameters are required.",
      });
    }

    const syllabus = await getSyllabusByClassSubject({
      classSubjectId,
      academicYearId,
    });

    if (!syllabus) {
      return res.status(404).json({
        message: "Syllabus not found.",
      });
    }

    return res.status(200).json({ syllabus });
  } catch (error) {
    console.error("Get syllabus error:", error);

    return res.status(500).json({
      message: "Unable to retrieve syllabus.",
    });
  }
};

export const createSyllabusUnitController = async (req, res) => {
  try {
    const { syllabusId, title, position } = req.body;

    if (
      !Number.isInteger(Number(syllabusId)) ||
      Number(syllabusId) <= 0
    ) {
      return res.status(400).json({
        message: "A valid syllabusId is required.",
      });
    }

    if (typeof title !== "string" || !title.trim()) {
      return res.status(400).json({
        message: "Unit title is required.",
      });
    }

    if (
      position !== undefined &&
      (!Number.isInteger(Number(position)) || Number(position) < 0)
    ) {
      return res.status(400).json({
        message: "Position must be a non-negative integer.",
      });
    }

    const unit = await createSyllabusUnit({
      syllabusId,
      title,
      position,
    });

    return res.status(201).json({
      message: "Syllabus unit created successfully.",
      unit,
    });
  } catch (error) {
    if (error.code === "P2003" || error.code === "P2025") {
      return res.status(400).json({
        message: "The specified syllabus does not exist.",
      });
    }

    console.error("Create syllabus unit error:", error);

    return res.status(500).json({
      message: "Unable to create syllabus unit.",
    });
  }
};

export const createSyllabusChapterController = async (req, res) => {
  try {
    const { syllabusId, unitId, title, position } = req.body;

    if (
      !Number.isInteger(Number(syllabusId)) ||
      Number(syllabusId) <= 0 ||
      !Number.isInteger(Number(unitId)) ||
      Number(unitId) <= 0
    ) {
      return res.status(400).json({
        message: "Valid syllabusId and unitId are required.",
      });
    }

    if (typeof title !== "string" || !title.trim()) {
      return res.status(400).json({
        message: "Chapter title is required.",
      });
    }

    if (
      position !== undefined &&
      (!Number.isInteger(Number(position)) || Number(position) < 0)
    ) {
      return res.status(400).json({
        message: "Position must be a non-negative integer.",
      });
    }

    const chapter = await createSyllabusChapter({
      syllabusId,
      unitId,
      title,
      position,
    });

    return res.status(201).json({
      message: "Syllabus chapter created successfully.",
      chapter,
    });
  } catch (error) {
    if (error.code === "P2003" || error.code === "P2025") {
      return res.status(400).json({
        message: "The specified syllabus or unit does not exist.",
      });
    }

    console.error("Create syllabus chapter error:", error);

    return res.status(500).json({
      message: "Unable to create syllabus chapter.",
    });
  }
};

export const createSyllabusTopicController = async (req, res) => {
  try {
    const { chapterId, title, position } = req.body;

    if (
      !Number.isInteger(Number(chapterId)) ||
      Number(chapterId) <= 0
    ) {
      return res.status(400).json({
        message: "A valid chapterId is required.",
      });
    }

    if (typeof title !== "string" || !title.trim()) {
      return res.status(400).json({
        message: "Topic title is required.",
      });
    }

    if (
      position !== undefined &&
      (!Number.isInteger(Number(position)) || Number(position) < 0)
    ) {
      return res.status(400).json({
        message: "Position must be a non-negative integer.",
      });
    }

    const topic = await createSyllabusTopic({
      chapterId,
      title,
      position,
    });

    return res.status(201).json({
      message: "Syllabus topic created successfully.",
      topic,
    });
  } catch (error) {
    if (error.code === "P2003" || error.code === "P2025") {
      return res.status(400).json({
        message: "The specified chapter does not exist.",
      });
    }

    console.error("Create syllabus topic error:", error);

    return res.status(500).json({
      message: "Unable to create syllabus topic.",
    });
  }
};
