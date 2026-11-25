
import {
  createResultComponentConfig,
  getResultComponentConfigs,
  updateResultComponentConfig,
  deleteResultComponentConfig,
  getStudentResults,
  getStudentResultById,
  createSectionResultDrafts,
  saveResultMarks,
  publishStudentResult,
  publishSectionResults,
} from "../services/resultComponentService.js";

// ==================================================
// 1. AUTHORIZATION
// ==================================================

const getAuthorizedSchoolId = (req, res) => {
  const schoolId = req.user?.schoolId;
  const permissions = req.user?.permissions;

  if (!schoolId) {
    res.status(403).json({
      success: false,
      message: "School access is not configured for this account.",
    });
    return null;
  }

  if (
    !Array.isArray(permissions) ||
    !permissions.includes("RESULT_COMPONENT_CONFIG_MANAGE")
  ) {
    res.status(403).json({
      success: false,
      message: "You do not have permission to manage result components.",
    });
    return null;
  }

  return schoolId;
};

// ==================================================
// 2. COMMON ERROR HANDLER
// ==================================================

const handleResultComponentError = (res, error, operation) => {
  console.error(`${operation} error:`, error);

  const message = error?.message || "An unexpected error occurred.";

  const badRequestErrors = [
    "INVALID_SCHOOLID",
    "INVALID_ACADEMICYEARID",
    "INVALID_CLASSID",
    "INVALID_SECTIONID",
    "INVALID_RESULTID",
    "INVALID_CLASSSUBJECTID",
    "INVALID_COMPONENTID",
    "INVALID_RESULT_TERM",
    "COMPONENTS_REQUIRED",
    "TOO_MANY_COMPONENTS",
    "INVALID_COMPONENT",
    "INVALID_COMPONENT_CODE",
    "INVALID_COMPONENT_NAME",
    "INVALID_MAXIMUM_MARKS",
    "INVALID_MAXIMUM_MARKS_PRECISION",
    "INVALID_DISPLAY_ORDER",
    "DUPLICATE_COMPONENT_CODES",
    "COMPONENT_TOTAL_MUST_BE_100",
    "INVALID_COMPONENT_DATA",
    "INVALID_OBTAINED_MARKS",
    "INVALID_OBTAINED_MARKS_PRECISION",
    "SUBJECT_MARKS_REQUIRED",
    "INVALID_SUBJECT_MARKS",
    "DUPLICATE_SUBJECT_MARKS",
    "INCOMPLETE_COMPONENT_MARKS",
    "DUPLICATE_COMPONENT_MARKS",
    "INVALID_CLASS_SUBJECT",
    "INCOMPLETE_RESULT_MARKS",
    "INVALID_SUBJECT_RESULT",
  ];

  const notFoundErrors = [
    "ACADEMIC_YEAR_NOT_FOUND",
    "CLASS_NOT_FOUND",
    "SECTION_NOT_FOUND",
    "COMPONENT_NOT_FOUND",
    "SCHOOL_NOT_FOUND_OR_INACTIVE",
    "RESULT_NOT_FOUND",
    "RESULT_SUBJECT_NOT_FOUND",
    "USER_NOT_FOUND",
    "STUDENT_PROFILE_NOT_FOUND",
    "NO_STUDENTS_FOUND",
    "CLASS_SUBJECTS_NOT_FOUND",
    "COMPONENT_CONFIG_NOT_FOUND",
    "RESULT_SUBJECTS_REQUIRED",
    "INCOMPLETE_RESULT_SUBJECTS",
  ];

  const conflictErrors = [
    "COMPONENT_CONFIG_ALREADY_EXISTS",
    "COMPONENT_ALREADY_USED",
    "RESULT_ALREADY_PUBLISHED",
    "SECTION_RESULTS_INCOMPLETE",
    "EXISTING_RESULT_SCOPE_MISMATCH",
  ];

  let statusCode = 500;

  if (badRequestErrors.includes(message)) {
    statusCode = 400;
  } else if (notFoundErrors.includes(message)) {
    statusCode = 404;
  } else if (conflictErrors.includes(message)) {
    statusCode = 409;
  }

  return res.status(statusCode).json({
    success: false,
    message,
    ...(error?.details ? { details: error.details } : {}),
  });
};

// ==================================================
// 3. RESULT COMPONENT CONFIGURATION
// ==================================================

export const createComponentConfig = async (req, res) => {
  const schoolId = getAuthorizedSchoolId(req, res);
  if (!schoolId) return;

  try {
    const result = await createResultComponentConfig({
      schoolId,
      ...req.body,
    });

    return res.status(201).json({
      success: true,
      message: "Result component configuration created successfully.",
      result,
    });
  } catch (error) {
    return handleResultComponentError(
      res,
      error,
      "Create result component configuration"
    );
  }
};

export const getComponentConfigs = async (req, res) => {
  const schoolId = getAuthorizedSchoolId(req, res);
  if (!schoolId) return;

  try {
    const result = await getResultComponentConfigs({
      schoolId,
      academicYearId: req.query.academicYearId,
      classId: req.query.classId,
      term: req.query.term,
    });

    return res.status(200).json({
      success: true,
      message: "Result component configurations fetched successfully.",
      result,
    });
  } catch (error) {
    return handleResultComponentError(
      res,
      error,
      "Get result component configurations"
    );
  }
};

export const updateComponentConfig = async (req, res) => {
  const schoolId = getAuthorizedSchoolId(req, res);
  if (!schoolId) return;

  try {
    const result = await updateResultComponentConfig({
      schoolId,
      componentId: req.params.componentId,
      ...req.body,
    });

    return res.status(200).json({
      success: true,
      message: "Result component configuration updated successfully.",
      result,
    });
  } catch (error) {
    return handleResultComponentError(
      res,
      error,
      "Update result component configuration"
    );
  }
};

export const deleteComponentConfig = async (req, res) => {
  const schoolId = getAuthorizedSchoolId(req, res);
  if (!schoolId) return;

  try {
    const result = await deleteResultComponentConfig({
      schoolId,
      componentId: req.params.componentId,
    });

    return res.status(200).json({
      success: true,
      message: "Result component configuration deleted successfully.",
      result,
    });
  } catch (error) {
    return handleResultComponentError(
      res,
      error,
      "Delete result component configuration"
    );
  }
};

// ==================================================
// 4. GENERATE SECTION RESULT DRAFTS
// ==================================================

export const generateSectionResultDrafts = async (req, res) => {
  const schoolId = getAuthorizedSchoolId(req, res);
  if (!schoolId) return;

  try {
    const { academicYearId, classId, sectionId, term } = req.body;

    const result = await createSectionResultDrafts({
      schoolId,
      academicYearId,
      classId,
      sectionId,
      term,
    });

    return res.status(201).json({
      success: true,
      message: "Section result drafts generated successfully.",
      result,
    });
  } catch (error) {
    return handleResultComponentError(
      res,
      error,
      "Generate section result drafts"
    );
  }
};

// ==================================================
// 5. SAVE STUDENT MARKS
// ==================================================

export const saveStudentResultMarks = async (req, res) => {
  const schoolId = getAuthorizedSchoolId(req, res);
  if (!schoolId) return;

  try {
    const result = await saveResultMarks({
      schoolId,
      resultId: req.params.resultId,
      subjects: req.body.subjects,
    });

    return res.status(200).json({
      success: true,
      message: "Student result marks saved successfully.",
      result,
    });
  } catch (error) {
    return handleResultComponentError(
      res,
      error,
      "Save student result marks"
    );
  }
};

// ==================================================
// 6. PUBLISH INDIVIDUAL STUDENT RESULT
// ==================================================

export const publishStudentResultHandler = async (req, res) => {
  const schoolId = getAuthorizedSchoolId(req, res);
  if (!schoolId) return;

  try {
    const result = await publishStudentResult({
      schoolId,
      resultId: req.params.resultId,
    });

    return res.status(200).json({
      success: true,
      message: "Student result published successfully.",
      result,
    });
  } catch (error) {
    return handleResultComponentError(
      res,
      error,
      "Publish student result"
    );
  }
};

// ==================================================
// 7. PUBLISH ALL RESULTS FOR A SECTION
// ==================================================

export const publishSectionResultsHandler = async (req, res) => {
  const schoolId = getAuthorizedSchoolId(req, res);
  if (!schoolId) return;

  try {
    const { academicYearId, classId, sectionId, term } = req.body;

    const result = await publishSectionResults({
      schoolId,
      academicYearId,
      classId,
      sectionId,
      term,
    });

    return res.status(200).json({
      success: true,
      message: "Section results published successfully.",
      result,
    });
  } catch (error) {
    return handleResultComponentError(
      res,
      error,
      "Publish section results"
    );
  }
};

// ==================================================
// 8. STUDENT RESULT APIs
// ==================================================

export const getStudentResultsHandler = async (req, res) => {
  try {
    const userId = req.user?.userId;

    if (!userId) {
      return res.status(401).json({
        success: false,
        message: "User authentication is required.",
      });
    }

    const result = await getStudentResults({ userId });

    return res.status(200).json({
      success: true,
      message: "Student results fetched successfully.",
      ...result,
    });
  } catch (error) {
    return handleResultComponentError(
      res,
      error,
      "Get student results"
    );
  }
};


export const getStudentResultByIdHandler = async (req, res) => {
  try {
    const userId = req.user?.userId;

    if (!userId) {
      return res.status(401).json({
        success: false,
        message: "User authentication is required.",
      });
    }

    const result = await getStudentResultById({
      userId,
      resultId: req.params.resultId,
    });

    return res.status(200).json({
      success: true,
      message: "Student result fetched successfully.",
      result,
    });
  } catch (error) {
    return handleResultComponentError(
      res,
      error,
      "Get student result by ID"
    );
  }
};
