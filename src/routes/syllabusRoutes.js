
import express from "express";
import authMiddleware from "../middleware/authMiddleware.js";

import {
  createSyllabusController,
  getSyllabusController,
  createSyllabusUnitController,
  createSyllabusChapterController,
  createSyllabusTopicController,
} from "../controllers/syllabusController.js";

const router = express.Router();

// Create a syllabus
router.post("/", authMiddleware, createSyllabusController);

// Get a syllabus by class-subject and academic year
router.get("/", authMiddleware, getSyllabusController);

// Create a syllabus unit
router.post(
  "/units",
  authMiddleware,
  createSyllabusUnitController
);

// Create a syllabus chapter
router.post(
  "/chapters",
  authMiddleware,
  createSyllabusChapterController
);

// Create a syllabus topic
router.post(
  "/topics",
  authMiddleware,
  createSyllabusTopicController
);

export default router;