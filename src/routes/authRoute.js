import express from "express";
import {
  login,
  forgotPasswordRequest,
  verifyForgotPasswordOtp,
  resetUserPassword,
} from "../controllers/authController.js";
const router = express.Router();

router.post("/login", login);
router.post("/forgot-password", forgotPasswordRequest);
router.post("/verify-otp", verifyForgotPasswordOtp);
router.post("/reset-password", resetUserPassword);

export default router;