import nodemailer from "nodemailer";

const transporter = nodemailer.createTransport({
  service: "gmail",
  auth: {
    user: process.env.MAIL_USER,
    pass: process.env.MAIL_APP_PASSWORD,
  },
});

export async function sendOtpEmail(toEmail, otp) {
  await transporter.sendMail({
    from: `"School ERP" <${process.env.MAIL_USER}>`,
    to: toEmail,
    subject: "School ERP - Password Reset OTP",
    text: `Your School ERP password reset OTP is ${otp}. This OTP is valid for 5 minutes.`,
    html: `
      <div style="font-family: Arial, sans-serif;">
        <h2>School ERP</h2>
        <p>You requested to reset your password.</p>

        <p>Your OTP is:</p>

        <h1 style="letter-spacing: 6px;">${otp}</h1>

        <p>This OTP is valid for 5 minutes.</p>

        <p>If you did not request this, please ignore this email.</p>
      </div>
    `,
  });
}