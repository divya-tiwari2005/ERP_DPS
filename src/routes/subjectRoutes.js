import express from "express";
import authMiddleware from "../middleware/authMiddleware.js";
import {
  createSubjectController,
  getSchoolSubjectsController,
} from "../controllers/subjectController.js";

const router = express.Router();

router.post("/", authMiddleware, createSubjectController);
router.get("/", authMiddleware, getSchoolSubjectsController);

export default router;