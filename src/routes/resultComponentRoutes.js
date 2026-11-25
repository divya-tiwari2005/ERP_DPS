
import express from "express";
import authMiddleware from "../middleware/authMiddleware.js";

import {
  createComponentConfig,
  getComponentConfigs,
  updateComponentConfig,
  deleteComponentConfig,

  generateSectionResultDrafts,
  saveStudentResultMarks,
  publishStudentResultHandler,
  publishSectionResultsHandler,

  getStudentResultsHandler,
  getStudentResultByIdHandler,
} from "../controllers/resultComponentController.js";

const router = express.Router();

router.use(authMiddleware);

router.get("/student", getStudentResultsHandler);

router.get("/student/:resultId", getStudentResultByIdHandler);

router.post("/section/drafts", generateSectionResultDrafts);

router.post("/section/publish", publishSectionResultsHandler);

router.patch("/:resultId/marks", saveStudentResultMarks);

router.patch("/:resultId/publish", publishStudentResultHandler);

router.post("/", createComponentConfig);

router.get("/", getComponentConfigs);

router.patch("/:componentId", updateComponentConfig);

router.delete("/:componentId", deleteComponentConfig);

export default router;
