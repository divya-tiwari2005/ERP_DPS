import express from "express";
import authMiddleware from "../middleware/authMiddleware.js";

import {
  getTimetableController,
  createTimetableController,
  getMyTimetableController,
} from "../controllers/timetableController.js";

const router = express.Router();

router.get("/", authMiddleware, getTimetableController);

router.post("/", authMiddleware, createTimetableController);

router.get(
  "/my",
  authMiddleware,
  getMyTimetableController,
);

export default router;