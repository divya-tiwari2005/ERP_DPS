import express from "express";
import {
  getMyHomeworkController,
  createHomeworkController,
} from "../controllers/homework_controller.js";
import authMiddleware from "../middleware/authMiddleware.js";

const router = express.Router();

router.get("/my", authMiddleware, getMyHomeworkController);

router.post("/", authMiddleware, createHomeworkController);

export default router;