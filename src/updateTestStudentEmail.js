import prisma from "./lib/prisma.js";

async function updateTestStudentEmail() {
  try {
    const student = await prisma.student.update({
      where: {
        studentId: "STU001",
      },
      data: {
        email: "wrkwithdivya@gmail.com",
      },
    });

    console.log("Student email updated successfully.");
    console.log("Student ID:", student.studentId);
    console.log("Email:", student.email);
  } catch (error) {
    console.error("Failed to update student email:");
    console.error(error);
  } finally {
    await prisma.$disconnect();
  }
}

updateTestStudentEmail();