import prisma from "./lib/prisma.js";

const setupSchoolData = async () => {
  try {
    // 1. Create or find school
    const school = await prisma.school.upsert({
      where: {
        code: "SCH001",
      },
      update: {},
      create: {
        name: "Demo School",
        code: "SCH001",
        status: "ACTIVE",
      },
    });

    console.log("School:", school.name);

    // 2. Create or find Class 10
    const academicClass = await prisma.academicClass.upsert({
      where: {
        schoolId_name: {
          schoolId: school.id,
          name: "Class 10",
        },
      },
      update: {},
      create: {
        name: "Class 10",
        schoolId: school.id,
      },
    });

    console.log("Class:", academicClass.name);

    // 3. Create or find Section A
    const section = await prisma.section.upsert({
      where: {
        classId_name: {
          classId: academicClass.id,
          name: "A",
        },
      },
      update: {},
      create: {
        name: "A",
        classId: academicClass.id,
      },
    });

    console.log("Section:", section.name);

    // 4. Connect existing student STU001
    const student = await prisma.student.update({
      where: {
        studentId: "STU001",
      },
      data: {
        schoolId: school.id,
        sectionId: section.id,
      },
    });

    console.log("Student:", student.studentId);
    console.log("Student name:", student.name);
    console.log("Student successfully connected to school/class/section.");

  } catch (error) {
    console.error("Setup failed:", error);
  } finally {
    await prisma.$disconnect();
  }
};

setupSchoolData();