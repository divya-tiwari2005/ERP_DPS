
import express from "express";

import authMiddleware from "../middleware/authMiddleware.js";
import {
  getMyProfile,
  getMySubjects,
} from "../controllers/studentController.js";

const router = express.Router();

router.get("/me", authMiddleware, getMyProfile);

router.get("/subjects", authMiddleware, getMySubjects);

export default router;
