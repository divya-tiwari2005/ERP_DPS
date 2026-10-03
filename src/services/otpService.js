const otpStore = new Map();

export const generateOtp = (loginId) => {
  const otp = Math.floor(100000 + Math.random() * 900000).toString();

  const expiresAt = Date.now() + 5 * 60 * 1000;

  otpStore.set(loginId, {
    otp,
    expiresAt,
  });

  return otp;
};

export const verifyOtp = (loginId, otp) => {
  const storedOtp = otpStore.get(loginId);

  if (!storedOtp) {
    return false;
  }

  if (Date.now() > storedOtp.expiresAt) {
    otpStore.delete(loginId);
    return false;
  }

  if (storedOtp.otp !== otp) {
    return false;
  }

  otpStore.delete(loginId);

  return true;
};