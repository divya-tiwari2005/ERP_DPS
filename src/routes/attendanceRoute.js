import express from "express";
import authMiddleware from "../middleware/authMiddleware.js";
import {
  checkAttendanceDay,
  getStudentsForAttendanceController,
  markAttendanceController,
  getMyAttendanceSummaryController,
  getMyAttendanceCalendarController,
} from "../controllers/attendanceController.js";

const router = express.Router();

router.get("/day", authMiddleware, checkAttendanceDay);

router.post("/mark", authMiddleware, markAttendanceController);

router.get(
  "/students",
  authMiddleware,
  getStudentsForAttendanceController,
);

router.get( 
  "/my-summary",
  authMiddleware,
  getMyAttendanceSummaryController,
);

router.get(
  "/my-calendar",
  authMiddleware,
  getMyAttendanceCalendarController,
);

export default router;