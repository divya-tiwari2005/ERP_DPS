import prisma from "./lib/prisma.js";

async function createTestStudent() {
  try {
    const user = await prisma.user.findUnique({
      where: {
        loginId: "STU001",
      },
    });

    if (!user) {
      throw new Error("STU001 user not found.");
    }

    const student = await prisma.student.create({
      data: {
        studentId: "STU001",
        name: "Divya Tiwari",
        email: "YOUR_EMAIL@gmail.com",
        phone: null,
      },
    });

    await prisma.user.update({
      where: {
        id: user.id,
      },
      data: {
        studentId: student.id,
      },
    });

    console.log("Student created and connected successfully.");
    console.log("Student ID:", student.studentId);
    console.log("Student DB ID:", student.id);
    console.log("User ID:", user.id);
    console.log("Email:", student.email);
  } catch (error) {
    console.error("Failed to create student:");
    console.error(error);
  } finally {
    await prisma.$disconnect();
  }
}

createTestStudent();