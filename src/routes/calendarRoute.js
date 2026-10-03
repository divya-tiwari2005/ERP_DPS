import express from "express";
import authMiddleware from "../middleware/authMiddleware.js";
import {
  createCalendar,
  getCalendar,
  updateCalendar,
  deleteCalendar,
  getSaturdayPolicyController,
  updateSaturdayPolicyController,
  getSelectedSaturdayRulesController,
  updateSelectedSaturdayRulesController,
} from "../controllers/calendarController.js";

const router = express.Router();

router.post(
  "/",
  authMiddleware,
  createCalendar,
);

router.get(
  "/",
  authMiddleware,
  getCalendar,
);

router.get(
  "/saturday-policy",
  authMiddleware,
  getSaturdayPolicyController,
);

router.put(
  "/saturday-policy",
  authMiddleware,
  updateSaturdayPolicyController,
);

router.get(
  "/selected-saturdays",
  authMiddleware,
  getSelectedSaturdayRulesController,
);

router.put(
  "/selected-saturdays",
  authMiddleware,
  updateSelectedSaturdayRulesController,
);

router.put(
  "/:id",
  authMiddleware,
  updateCalendar,
);

router.delete(
  "/:id",
  authMiddleware,
  deleteCalendar,
);

export default router;