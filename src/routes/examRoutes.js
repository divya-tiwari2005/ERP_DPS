
import express from "express";
import authMiddleware from "../middleware/authMiddleware.js";

import {
  getStudentExamDateSheets,
  getStudentExamDateSheetById,
  createManualDateSheet,
  createPdfDateSheet,
  publishDateSheet,
} from "../controllers/examdatesheetController.js";

const router = express.Router();

// Get all published date sheets for logged-in student
router.get(
  "/student",
  authMiddleware,
  getStudentExamDateSheets
);

// Get one published date sheet
router.get(
  "/student/:dateSheetId",
  authMiddleware,
  getStudentExamDateSheetById
);

// Create manual date sheet
router.post(
  "/manual",
  authMiddleware,
  createManualDateSheet
);

// Create PDF date sheet
router.post(
  "/pdf",
  authMiddleware,
  createPdfDateSheet
);


router.patch(
  "/:dateSheetId/publish",
  authMiddleware,
  publishDateSheet
);

export default router;
