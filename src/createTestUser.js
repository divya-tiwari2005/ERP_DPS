// import bcrypt from "bcryptjs";
// import prisma from "./lib/prisma.js";

// const loginId = "STU001";
// const password = "Test@123";

// async function createTestUser() {
//   try {
//     const passwordHash = await bcrypt.hash(password, 10);

//     const user = await prisma.user.create({
//       data: {
//         loginId,
//         passwordHash,
//         status: "ACTIVE",
//       },
//     });

//     console.log("Test user created successfully.");
//     console.log("Login ID:", user.loginId);
//     console.log("Password:", password);
//   } catch (error) {
//   console.error("Failed to create test user:");
//   console.error(error);

//   console.log("\n========== DETAILED DATABASE ERROR ==========");
//   console.dir(
//     error?.meta?.driverAdapterError?.cause,
//     { depth: null }
//   );
//   console.log("=============================================");

//   } finally {
//     await prisma.$disconnect();
//   }
// }

// createTestUser();

