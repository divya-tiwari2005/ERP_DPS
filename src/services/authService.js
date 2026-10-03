import bcrypt from "bcryptjs";
import jwt from "jsonwebtoken";
import prisma from "../lib/prisma.js";
import { generateOtp, verifyOtp } from "./otpService.js";
import { sendOtpEmail } from "./email_service.js";

export const loginUser = async (loginId, password) => {
  const user = await prisma.user.findUnique({
    where: {
      loginId,
    },
  });

  if (!user) {
    throw new Error("INVALID_CREDENTIALS");
  }

  const passwordMatch = await bcrypt.compare(
    password,
    user.passwordHash
  );

  if (!passwordMatch) {
    throw new Error("INVALID_CREDENTIALS");
  }

  if (user.status !== "ACTIVE") {
    throw new Error("ACCOUNT_INACTIVE");
  }

  const token = jwt.sign(
    {
      userId: user.id,
      loginId: user.loginId,
    },
    process.env.JWT_SECRET,
    {
      expiresIn: "7d",
    }
  );

  return {
    token,
    user: {
      id: user.id,
      loginId: user.loginId,
    },
  };
};

export const forgotPassword = async (loginId) => {
  const user = await prisma.user.findUnique({
    where: {
      loginId,
    },
    include: {
      student: true,
    },
  });

  if (!user) {
    throw new Error("USER_NOT_FOUND");
  }

  if (!user.student || !user.student.email) {
    throw new Error("EMAIL_NOT_FOUND");
  }

  const otp = generateOtp(loginId);

  await sendOtpEmail(
    user.student.email,
    otp
  );

  return {
    message: "OTP sent successfully.",
  };
};

export const verifyPasswordOtp = (loginId, otp) => {
  const isValid = verifyOtp(loginId, otp);

  if (!isValid) {
    throw new Error("INVALID_OTP");
  }

  return {
    message: "OTP verified successfully.",
  };
};
export const resetPassword = async (loginId, newPassword) => {
  const user = await prisma.user.findUnique({
    where: {
      loginId,
    },
  });

  if (!user) {
    throw new Error("USER_NOT_FOUND");
  }

  const passwordHash = await bcrypt.hash(newPassword, 10);

  await prisma.user.update({
    where: {
      loginId,
    },
    data: {
      passwordHash,
    },
  });

  return {
    message: "Password reset successfully.",
  };
};
