import {
  createSubject,
  getSchoolSubjects,
  assignSubjectToClass,
} from "../services/subjectServices.js";

export const createSubjectController = async (req, res) => {
  try {
    const { name, code, category, schoolId } = req.body;

    if (!name || !String(name).trim()) {
      return res.status(400).json({
        message: "Subject name is required.",
      });
    }

    if (!schoolId || !Number.isInteger(Number(schoolId))) {
      return res.status(400).json({
        message: "A valid schoolId is required.",
      });
    }

    const subject = await createSubject({
      schoolId: Number(schoolId),
      name: String(name).trim(),
      code: code ? String(code).trim() : undefined,
      category: category ? String(category).trim() : undefined,
    });

    return res.status(201).json({
      message: "Subject created successfully.",
      subject,
    });
  } catch (error) {
    console.error("Create subject error:", error);

    if (error.code === "P2002") {
      return res.status(409).json({
        message: "A subject with this unique value already exists.",
      });
    }

    return res.status(500).json({
      message: "Unable to create subject.",
    });
  }
};

export const getSchoolSubjectsController = async (req, res) => {
  try {
    const { schoolId } = req.query;

    if (!schoolId || !Number.isInteger(Number(schoolId))) {
      return res.status(400).json({
        message: "A valid schoolId query parameter is required.",
      });
    }

    const subjects = await getSchoolSubjects(Number(schoolId));

    return res.status(200).json({
      subjects,
    });
  } catch (error) {
    console.error("Get school subjects error:", error);

    return res.status(500).json({
      message: "Unable to fetch subjects.",
    });
  }
};
export const assignSubjectToClassController = async (req, res) => {
  try {
    const classId = Number(req.body.classId);
    const subjectId = Number(req.body.subjectId);

    if (
      !Number.isInteger(classId) ||
      classId <= 0 ||
      !Number.isInteger(subjectId) ||
      subjectId <= 0
    ) {
      return res.status(400).json({
        message: "Valid classId and subjectId are required.",
      });
    }

    // assigning subjects to the class by calling the service function
    const assignment = await assignSubjectToClass({
      classId,
      subjectId,
    });

    return res.status(201).json({
      message: "Subject assigned to class successfully.",
      assignment,
    });
  } catch (error) {
    console.error("Assign subject to class error:", error);

    if (error.code === "P2002") {
      return res.status(409).json({
        message: "This subject is already assigned to the class.",
      });
    }

    if (error.code === "P2003" || error.code === "P2025") {
      return res.status(400).json({
        message: "The specified class or subject does not exist.",
      });
    }

    return res.status(500).json({
      message: "Unable to assign subject to class.",
    });
  }
};