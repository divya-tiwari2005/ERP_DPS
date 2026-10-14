import {
  getMyHomework,
  createHomework,
} from "../services/homework_services.js";

export const getMyHomeworkController = async (req, res) => {
  try {
    const homework = await getMyHomework(req.user.userId);

    return res.status(200).json(homework);
  } catch (error) {
    console.error("Get my homework error:", error);

    switch (error.message) {
      case "STUDENT_NOT_FOUND":
        return res.status(404).json({
          message: "Student not found.",
        });

      case "STUDENT_SECTION_NOT_FOUND":
        return res.status(400).json({
          message: "Student section not found.",
        });

      case "STUDENT_SCHOOL_NOT_FOUND":
        return res.status(400).json({
          message: "Student school not found.",
        });

      case "ACTIVE_ACADEMIC_YEAR_NOT_FOUND":
        return res.status(404).json({
          message: "Active academic year not found.",
        });

      default:
        return res.status(500).json({
          message: "Unable to fetch homework.",
        });
    }
  }
};
export const createHomeworkController = async (req, res) => {
  try {
    const {
      schoolId,
      sectionId,
      academicYearId,
      subject,
      title,
      description,
      assignedDate,
      dueDate,
    } = req.body;

    if (
      !schoolId ||
      !sectionId ||
      !academicYearId ||
      !subject ||
      !title ||
      !assignedDate
    ) {
      return res.status(400).json({
        message: "Required homework fields are missing.",
      });
    }

    const homework = await createHomework({
      schoolId: Number(schoolId),
      sectionId: Number(sectionId),
      academicYearId: Number(academicYearId),
      subject,
      title,
      description,
      assignedDate,
      dueDate,
    });

    return res.status(201).json(homework);
  } catch (error) {
    console.error("Create homework error:", error);

    switch (error.message) {
      case "SECTION_NOT_FOUND":
        return res.status(404).json({
          message: "Section not found.",
        });

      case "ACADEMIC_YEAR_NOT_FOUND":
        return res.status(404).json({
          message: "Academic year not found.",
        });

      case "SCHOOL_MISMATCH":
        return res.status(400).json({
          message: "Section or academic year does not belong to this school.",
        });

      default:
        return res.status(500).json({
          message: "Unable to create homework.",
        });
    }
  }
};