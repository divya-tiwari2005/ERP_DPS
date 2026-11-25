
import {
  getStudentExamDateSheets as fetchStudentDateSheets,
  getStudentExamDateSheetById as fetchStudentDateSheetById,
  createManualDateSheet as createManualDateSheetService,
  createPdfDateSheet as createPdfDateSheetService,
  publishDateSheet as publishDateSheetService,
} from "../services/examDateSheetService.js";

const handleDateSheetError = (res, error, action) => {
  console.error(`${action} error:`, error);

  const badRequestErrors = [
    "INVALID_REQUIRED_FIELDS",
    "INVALID_ID",
    "INVALID_SCHOOL_ID",
    "INVALID_ACADEMIC_YEAR_ID",
    "INVALID_CLASS_ID",
    "EXAM_NAME_REQUIRED",
    "SUBJECTS_REQUIRED",
    "INVALID_EXAM_SCHEDULE",
    "INVALID_OR_DUPLICATE_SUBJECTS",
    "INVALID_EXAM_DATE",
    "INVALID_EXAM_TIME",
    "PDF_REQUIRED",
    "INVALID_PDF_URL",
    "INVALID_DATE_SHEET_ID",
    "INVALID_CLASS_SUBJECT",
  ];

  if (badRequestErrors.includes(error.message)) {
    return res.status(400).json({
      message: error.message,
    });
  }

  if (
    error.message === "ACADEMIC_YEAR_NOT_FOUND" ||
    error.message === "CLASS_NOT_FOUND" ||
    error.message === "EXAM_DATE_SHEET_NOT_FOUND"
  ) {
    return res.status(404).json({
      message: error.message,
    });
  }

  if (error.code === "P2002") {
    return res.status(409).json({
      message: "An exam date sheet with this name already exists for this class and academic year.",
    });
  }

  return res.status(500).json({
    message: `Something went wrong while ${action.toLowerCase()}.`,
  });
};

// 
export const getStudentExamDateSheets = async (req, res) => {
  try {
    const userId = req.user?.userId;

    if (!userId) {
      return res.status(401).json({
        message: "Authentication required.",
      });
    }

    const result = await fetchStudentDateSheets(userId);

    return res.status(200).json({
      message: "Exam date sheets fetched successfully.",
      ...result,
    });

  } catch (error) {
    console.error("Get student exam date sheets error:", error);

    if (error.message === "INVALID_USER_ID") {
      return res.status(401).json({
        message: "Invalid user authentication.",
      });
    }

    if (error.message === "STUDENT_NOT_FOUND") {
      return res.status(404).json({
        message: "Student account not found.",
      });
    }

    if (
      error.message === "STUDENT_CLASS_NOT_ASSIGNED" ||
      error.message === "STUDENT_SCHOOL_MISMATCH"
    ) {
      return res.status(403).json({
        message: "Student class or school assignment is invalid.",
      });
    }

    return res.status(500).json({
      message: "Something went wrong while fetching exam date sheets.",
    });
  }
};

export const getStudentExamDateSheetById = async (req, res) => {
  try {
    const userId = req.user?.userId;
    const { dateSheetId } = req.params;

    if (!userId) {
      return res.status(401).json({
        message: "Authentication required.",
      });
    }

    const dateSheet = await fetchStudentDateSheetById(
      userId,
      dateSheetId
    );

    return res.status(200).json({
      message: "Exam date sheet fetched successfully.",
      dateSheet,
    });

  } catch (error) {
    console.error("Get student exam date sheet error:", error);

    if (error.message === "INVALID_USER_ID") {
      return res.status(401).json({
        message: "Invalid user authentication.",
      });
    }

    if (error.message === "INVALID_DATE_SHEET_ID") {
      return res.status(400).json({
        message: "Invalid exam date sheet ID.",
      });
    }

    if (error.message === "STUDENT_NOT_FOUND") {
      return res.status(404).json({
        message: "Student account not found.",
      });
    }

    if (
      error.message === "STUDENT_CLASS_NOT_ASSIGNED" ||
      error.message === "STUDENT_SCHOOL_MISMATCH"
    ) {
      return res.status(403).json({
        message: "Student class or school assignment is invalid.",
      });
    }

    if (error.message === "EXAM_DATE_SHEET_NOT_FOUND") {
      return res.status(404).json({
        message: "Exam date sheet not found.",
      });
    }

    return res.status(500).json({
      message: "Something went wrong while fetching the exam date sheet.",
    });
  }
};


// ==========================================
// 3. CREATE MANUAL EXAM DATE SHEET
// ==========================================

export const createManualDateSheet = async (req, res) => {
  try {
    const {
      schoolId,
      academicYearId,
      classId,
      examName,
      subjects,
    } = req.body;

    const dateSheet = await createManualDateSheetService({
      schoolId,
      academicYearId,
      classId,
      examName,
      subjects,
    });

    return res.status(201).json({
      message: "Manual exam date sheet created successfully.",
      dateSheet,
    });

  } catch (error) {
    return handleDateSheetError(
      res,
      error,
      "Creating manual exam date sheet"
    );
  }
};


// ==========================================
// 4. CREATE PDF EXAM DATE SHEET
// ==========================================

export const createPdfDateSheet = async (req, res) => {
  try {
    const {
      schoolId,
      academicYearId,
      classId,
      examName,
      pdfUrl,
    } = req.body;

    const dateSheet = await createPdfDateSheetService({
      schoolId,
      academicYearId,
      classId,
      examName,
      pdfUrl,
    });

    return res.status(201).json({
      message: "PDF exam date sheet created successfully.",
      dateSheet,
    });

  } catch (error) {
    return handleDateSheetError(
      res,
      error,
      "Creating PDF exam date sheet"
    );
  }
};

export const publishDateSheet = async (req, res) => {
  try {
    const { dateSheetId } = req.params;
    const { schoolId } = req.body;

    const dateSheet = await publishDateSheetService({
      schoolId,
      dateSheetId,
    });

    return res.status(200).json({
      message: "Exam date sheet published successfully.",
      dateSheet,
    });

  } catch (error) {
    return handleDateSheetError(
      res,
      error,
      "Publishing exam date sheet"
    );
  }
};
