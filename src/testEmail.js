import "dotenv/config";
import { sendOtpEmail } from "./services/email_service.js";

async function testEmail() {
  try {
    await sendOtpEmail(
      "wrkwithdivya@gmail.com",
      "123456"
    );

    console.log("Test email sent successfully.");
  } catch (error) {
    console.error("Failed to send test email:");
    console.error(error);
  }
}

testEmail();