import {
  loginUser,
  forgotPassword,
  verifyPasswordOtp,
  resetPassword,
} from "../services/authService.js";

export const login = async (req, res) => {
  console.log("LOGIN REQUEST:");
  console.log("Content-Type:", req.headers["content-type"]);
  console.log("Body:", req.body);
  try {
    const { loginId, password } = req.body;

    if (!loginId || !password) {
      return res.status(400).json({
        message: "Login ID and password are required.",
      });
    }

    const result = await loginUser(loginId, password);

    return res.status(200).json({
      message: "Login successful.",
      ...result,
    });
  } catch (error) {
    if (error.message === "INVALID_CREDENTIALS") {
      return res.status(401).json({
        message: "Invalid login ID or password.",
      });
    }

    if (error.message === "ACCOUNT_INACTIVE") {
      return res.status(403).json({
        message: "Account is inactive.",
      });
    }

    console.error("Login error:", error);

    return res.status(500).json({
      message: "Something went wrong.",
    });
  }
};
export const forgotPasswordRequest = async (req, res) => {
  try {
    const { loginId } = req.body;

    if (!loginId) {
      return res.status(400).json({
        message: "Login ID is required.",
      });
    }

    const result = await forgotPassword(loginId);

    return res.status(200).json(result);
  } catch (error) {
    if (error.message === "USER_NOT_FOUND") {
      return res.status(404).json({
        message: "Student account not found.",
      });
    }

    console.error("Forgot password error:", error);

    return res.status(500).json({
      message: "Something went wrong.",
    });
  }
};
export const verifyForgotPasswordOtp = async (req, res) => {
  try {
    const { loginId, otp } = req.body;

    if (!loginId || !otp) {
      return res.status(400).json({
        message: "Login ID and OTP are required.",
      });
    }

    const result = verifyPasswordOtp(loginId, otp);

    return res.status(200).json(result);
  } catch (error) {
    if (error.message === "INVALID_OTP") {
      return res.status(400).json({
        message: "Invalid or expired OTP.",
      });
    }

    console.error("OTP verification error:", error);

    return res.status(500).json({
      message: "Something went wrong.",
    });
  }
};
export const resetUserPassword = async (req, res) => {
  try {
    const { loginId, newPassword } = req.body;

    if (!loginId || !newPassword) {
      return res.status(400).json({
        message: "Login ID and new password are required.",
      });
    }

    if (newPassword.length < 6) {
      return res.status(400).json({
        message: "Password must be at least 6 characters long.",
      });
    }

    const result = await resetPassword(
      loginId,
      newPassword
    );

    return res.status(200).json(result);
  } catch (error) {
    if (error.message === "USER_NOT_FOUND") {
      return res.status(404).json({
        message: "Student account not found.",
      });
    }

    console.error("Reset password error:", error);

    return res.status(500).json({
      message: "Something went wrong.",
    });
  }
};