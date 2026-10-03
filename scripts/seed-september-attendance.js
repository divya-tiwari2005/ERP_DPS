import prisma from "../src/lib/prisma.js";
import {
  getAttendanceDayStatus,
  markAttendance,
} from "../src/services/attendanceService.js";

const YEAR = 2026;
const MONTH = 9; // September

const formatDate = (day) =>
  `${YEAR}-${String(MONTH).padStart(2, "0")}-${String(day).padStart(2, "0")}`;

const sleep = (ms) =>
  new Promise((resolve) => setTimeout(resolve, ms));

async function main() {
  console.log("🌱 Seeding September 2026 attendance...\n");

  // Pick the first active student account.
  // This should be your demo student.
  const user = await prisma.user.findFirst({
    where: {
      status: "ACTIVE",
      studentId: {
        not: null,
      },
    },
    include: {
      student: true,
    },
    orderBy: {
      id: "asc",
    },
  });

  if (!user?.student) {
    throw new Error(
      "No active student account found."
    );
  }

  const student = user.student;

  if (!student.schoolId) {
    throw new Error(
      "Demo student does not have a schoolId."
    );
  }

  console.log(
    `Student: ${student.name}`
  );

  console.log(
    `Student ID: ${student.studentId}`
  );

  console.log(
    `School ID: ${student.schoolId}\n`
  );

  /*
   * These are deliberately scattered absences.
   *
   * We are NOT manually creating Sundays,
   * holidays or non-working Saturdays.
   *
   * Your existing school calendar logic decides
   * whether attendance is actually required.
   */
  const absentDates = new Set([
    "2026-09-07",
    "2026-09-16",
    "2026-09-24",
  ]);

  let presentCount = 0;
  let absentCount = 0;
  let skippedCount = 0;

  for (let day = 1; day <= 30; day++) {
    const dateString = formatDate(day);

    // Use IST midnight, matching your school-date handling.
    const date = new Date(
      `${dateString}T00:00:00+05:30`
    );

    const dayStatus =
      await getAttendanceDayStatus(
        student.schoolId,
        date
      );

    // Sunday / holiday / non-working Saturday
    if (!dayStatus.isAttendanceRequired) {
      console.log(
        `⏭️  ${dateString} → OFF (${dayStatus.reason ?? "Not required"})`
      );

      skippedCount++;
      continue;
    }

    const status = absentDates.has(dateString)
      ? "ABSENT"
      : "PRESENT";

    await markAttendance(
      date,
      [
        {
          studentId: student.id,
          status,
        },
      ]
    );

    if (status === "PRESENT") {
      presentCount++;
      console.log(
        `✅ ${dateString} → PRESENT`
      );
    } else {
      absentCount++;
      console.log(
        `❌ ${dateString} → ABSENT`
      );
    }

    // Small delay just to keep console output readable.
    await sleep(20);
  }

  console.log("\n--------------------------------");
  console.log("September 2026 demo attendance");
  console.log("--------------------------------");
  console.log(`Present : ${presentCount}`);
  console.log(`Absent  : ${absentCount}`);
  console.log(`Skipped : ${skippedCount}`);
  console.log("--------------------------------\n");

  console.log(
    "✅ September attendance seeded successfully."
  );
}

main()
  .catch((error) => {
    console.error(
      "\n❌ Seed failed:",
      error
    );
    process.exit(1);
  })
  .finally(async () => {
    await prisma.$disconnect();
  });