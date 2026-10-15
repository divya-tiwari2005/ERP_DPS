import express from "express";
import cors from "cors";
import authRoutes from "./routes/authRoute.js";
import studentRoutes from "./routes/studentRoute.js";
import attendanceRoutes from "./routes/attendanceRoute.js";
import calendarRoutes from "./routes/calendarRoute.js";
import timetableRoutes from "./routes/timetableRoutes.js";
import homeworkRoutes from "./routes/homeworkRoute.js";
import subjectRoutes from "./routes/subjectRoutes.js";
import syllabusRoutes from "./routes/syllabusRoutes.js";

const app = express();

app.use(cors());
app.use(express.json()); 

app.get("/", (req, res) => {
  res.json({
    message: "School ERP Backend is running",
  });
});

// Authentication routes
app.use("/auth", authRoutes);

// Student routes
app.use("/student", studentRoutes);

// Attendance routes
app.use("/attendance", attendanceRoutes);

// Calendar routes
app.use("/calendar", calendarRoutes);

// Timetable routes
app.use("/timetable", timetableRoutes);

// Homework routes
app.use("/homework", homeworkRoutes);

// Subject routes
app.use("/subjects", subjectRoutes);

// Syllabus routes
app.use("/syllabus", syllabusRoutes);

const PORT = 3000;

app.listen(PORT, () => {
  console.log(`Server running on http://localhost:${PORT}`);
});