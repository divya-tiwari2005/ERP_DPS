import { getStudentProfile } from "../services/studentService.js";

export const getMyProfile = async (req, res) => {
  try {
    const student = await getStudentProfile(req.user.userId);

    return res.status(200).json({
      student,
    });
  } catch (error) {
    if (error.message === "STUDENT_NOT_FOUND") {
      return res.status(404).json({
        message: "Student profile not found.",
      });
    }

    console.error("Get student profile error:", error);

    return res.status(500).json({
      message: "Unable to fetch student profile.",
    });
  }
};