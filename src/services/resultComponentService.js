
import prisma from "../lib/prisma.js";

// ==================================================
// 1. COMMON VALIDATION HELPERS
// ==================================================

const validateId = (id, fieldName) => {
  const parsedId = Number(id);

  if (!Number.isSafeInteger(parsedId) || parsedId <= 0) {
    throw new Error(`INVALID_${fieldName.toUpperCase()}`);
  }

  return parsedId;
};

const validateTerm = (term) => {
  if (!["TERM_1", "TERM_2"].includes(term)) {
    throw new Error("INVALID_RESULT_TERM");
  }
};

const toMinorUnits = (value) => {
  return Math.round(Number(value) * 100);
};

const roundMarks = (value) => {
  return Math.round((Number(value) + Number.EPSILON) * 100) / 100;
};

const validateMarks = (value, maximumMarks) => {
  const obtainedMarks = Number(value);

  if (
    !Number.isFinite(obtainedMarks) ||
    obtainedMarks < 0 ||
    obtainedMarks > Number(maximumMarks)
  ) {
    throw new Error("INVALID_OBTAINED_MARKS");
  }

  if (
    Math.abs(
      obtainedMarks * 100 - Math.round(obtainedMarks * 100)
    ) > 0.000001
  ) {
    throw new Error("INVALID_OBTAINED_MARKS_PRECISION");
  }

  return roundMarks(obtainedMarks);
};

// Default grading policy.
// Change these values if the school follows a different grading system.
const PASS_PERCENTAGE = 33;

const GRADE_BANDS = [
  { grade: "A+", minimum: 90 },
  { grade: "A", minimum: 80 },
  { grade: "B", minimum: 70 },
  { grade: "C", minimum: 60 },
  { grade: "D", minimum: 50 },
  { grade: "E", minimum: 33 },
  { grade: "F", minimum: 0 },
];

const calculateGrade = (percentage) => {
  const value = Number(percentage);

  return (
    GRADE_BANDS.find((band) => value >= band.minimum)?.grade ?? "F"
  );
};

const calculatePassStatus = (percentage) => {
  return Number(percentage) >= PASS_PERCENTAGE ? "PASS" : "FAIL";
};

const calculatePercentage = (obtained, maximum) => {
  if (Number(maximum) <= 0) return 0;

  return roundMarks((Number(obtained) / Number(maximum)) * 100);
};

// ==================================================
// 2. COMPONENT VALIDATION
// ==================================================

const validateComponent = (component) => {
  if (
    !component ||
    typeof component !== "object" ||
    Array.isArray(component)
  ) {
    throw new Error("INVALID_COMPONENT");
  }

  const code =
    typeof component.code === "string"
      ? component.code.trim().toUpperCase()
      : "";

  const name =
    typeof component.name === "string"
      ? component.name.trim()
      : "";

  const maximumMarks = Number(component.maximumMarks);
  const displayOrder = Number(component.displayOrder ?? 0);

  if (!code || code.length > 30) {
    throw new Error("INVALID_COMPONENT_CODE");
  }

  if (!name || name.length > 100) {
    throw new Error("INVALID_COMPONENT_NAME");
  }

  if (
    !Number.isFinite(maximumMarks) ||
    maximumMarks <= 0 ||
    maximumMarks > 9999.99
  ) {
    throw new Error("INVALID_MAXIMUM_MARKS");
  }

  if (
    Math.abs(
      maximumMarks * 100 - Math.round(maximumMarks * 100)
    ) > 0.000001
  ) {
    throw new Error("INVALID_MAXIMUM_MARKS_PRECISION");
  }

  if (!Number.isInteger(displayOrder) || displayOrder < 0) {
    throw new Error("INVALID_DISPLAY_ORDER");
  }

  return {
    code,
    name,
    maximumMarks,
    displayOrder,
  };
};

const validateTotalMaximumMarks = (components) => {
  const total = components.reduce(
    (sum, component) =>
      sum + toMinorUnits(component.maximumMarks),
    0
  );

  if (total !== 10000) {
    throw new Error("COMPONENT_TOTAL_MUST_BE_100");
  }
};

const validateUniqueCodes = (components) => {
  const codes = components.map((component) => component.code);

  if (new Set(codes).size !== codes.length) {
    throw new Error("DUPLICATE_COMPONENT_CODES");
  }
};

// ==================================================
// 3. ACADEMIC SCOPE VALIDATION
// ==================================================

const verifyAcademicScope = async (
  tx,
  schoolId,
  academicYearId,
  classId
) => {
  const [school, academicYear, academicClass] = await Promise.all([
    tx.school.findUnique({
      where: { id: schoolId },
      select: { id: true, status: true },
    }),

    tx.academicyear.findFirst({
      where: { id: academicYearId, schoolId },
      select: { id: true },
    }),

    tx.academicclass.findFirst({
      where: { id: classId, schoolId },
      select: { id: true },
    }),
  ]);

  if (!school || school.status !== "ACTIVE") {
    throw new Error("SCHOOL_NOT_FOUND_OR_INACTIVE");
  }

  if (!academicYear) {
    throw new Error("ACADEMIC_YEAR_NOT_FOUND");
  }

  if (!academicClass) {
    throw new Error("CLASS_NOT_FOUND");
  }
};

const verifySectionScope = async (
  tx,
  schoolId,
  classId,
  sectionId
) => {
  const section = await tx.section.findFirst({
    where: {
      id: sectionId,
      classId,
      academicclass: {
        schoolId,
      },
    },
    select: {
      id: true,
      classId: true,
    },
  });

  if (!section) {
    throw new Error("SECTION_NOT_FOUND");
  }

  return section;
};

// ==================================================
// 4. CONFIGURATION EDITABILITY
// ==================================================

const ensureConfigurationEditable = async (tx, component) => {
  const [marksUsed, existingResults] = await Promise.all([
    tx.resultcomponentmarks.count({
      where: {
        componentConfigId: component.id,
      },
    }),

    tx.result.count({
      where: {
        schoolId: component.schoolId,
        academicYearId: component.academicYearId,
        classId: component.classId,
        term: component.term,
      },
    }),
  ]);

  if (marksUsed > 0 || existingResults > 0) {
    throw new Error("COMPONENT_ALREADY_USED");
  }
};

// ==================================================
// 5. CREATE COMPONENT CONFIGURATION
// ==================================================

export const createResultComponentConfig = async ({
  schoolId,
  academicYearId,
  classId,
  term,
  components,
}) => {
  schoolId = validateId(schoolId, "schoolId");
  academicYearId = validateId(academicYearId, "academicYearId");
  classId = validateId(classId, "classId");

  validateTerm(term);

  if (!Array.isArray(components) || components.length === 0) {
    throw new Error("COMPONENTS_REQUIRED");
  }

  if (components.length > 30) {
    throw new Error("TOO_MANY_COMPONENTS");
  }

  const validatedComponents = components.map(validateComponent);

  validateUniqueCodes(validatedComponents);
  validateTotalMaximumMarks(validatedComponents);

  return prisma.$transaction(async (tx) => {
    await verifyAcademicScope(
      tx,
      schoolId,
      academicYearId,
      classId
    );

    const existingConfig = await tx.resultcomponentconfig.count({
      where: {
        schoolId,
        academicYearId,
        classId,
        term,
      },
    });

    if (existingConfig > 0) {
      throw new Error("COMPONENT_CONFIG_ALREADY_EXISTS");
    }

    await tx.resultcomponentconfig.createMany({
      data: validatedComponents.map((component) => ({
        schoolId,
        academicYearId,
        classId,
        term,
        ...component,
      })),
    });

    const createdComponents =
      await tx.resultcomponentconfig.findMany({
        where: {
          schoolId,
          academicYearId,
          classId,
          term,
        },
        orderBy: {
          displayOrder: "asc",
        },
      });

    return {
      message: "Result component configuration created successfully.",
      count: createdComponents.length,
      totalMaximumMarks: 100,
      components: createdComponents,
    };
  });
};

// ==================================================
// 6. GET COMPONENT CONFIGURATION
// ==================================================

export const getResultComponentConfigs = async ({
  schoolId,
  academicYearId,
  classId,
  term,
}) => {
  schoolId = validateId(schoolId, "schoolId");
  academicYearId = validateId(academicYearId, "academicYearId");
  classId = validateId(classId, "classId");

  validateTerm(term);

  await verifyAcademicScope(
    prisma,
    schoolId,
    academicYearId,
    classId
  );

  const components = await prisma.resultcomponentconfig.findMany({
    where: {
      schoolId,
      academicYearId,
      classId,
      term,
    },
    orderBy: {
      displayOrder: "asc",
    },
  });

  const activeComponents = components.filter(
    (component) => component.isActive
  );

  const totalMaximumMarks = activeComponents.reduce(
    (sum, component) => sum + Number(component.maximumMarks),
    0
  );

  return {
    count: components.length,
    totalMaximumMarks,
    isConfigurationComplete:
      activeComponents.length > 0 &&
      toMinorUnits(totalMaximumMarks) === 10000,
    components,
  };
};

// ==================================================
// 7. UPDATE COMPONENT CONFIGURATION
// ==================================================

export const updateResultComponentConfig = async ({
  schoolId,
  componentId,
  data,
}) => {
  schoolId = validateId(schoolId, "schoolId");
  componentId = validateId(componentId, "componentId");

  if (
    !data ||
    typeof data !== "object" ||
    Array.isArray(data)
  ) {
    throw new Error("INVALID_COMPONENT_DATA");
  }

  const allowedFields = [
    "code",
    "name",
    "maximumMarks",
    "displayOrder",
  ];

  const invalidFields = Object.keys(data).filter(
    (key) => !allowedFields.includes(key)
  );

  if (invalidFields.length > 0) {
    throw new Error("INVALID_COMPONENT_DATA");
  }

  return prisma.$transaction(async (tx) => {
    const existingData =
      await tx.resultcomponentconfig.findFirst({
        where: {
          id: componentId,
          schoolId,
        },
      });

    if (!existingData) {
      throw new Error("COMPONENT_NOT_FOUND");
    }

    await ensureConfigurationEditable(tx, existingData);

    const validatedData = validateComponent({
      code: data.code ?? existingData.code,
      name: data.name ?? existingData.name,
      maximumMarks:
        data.maximumMarks ?? existingData.maximumMarks,
      displayOrder:
        data.displayOrder ?? existingData.displayOrder,
    });

    const allComponents =
      await tx.resultcomponentconfig.findMany({
        where: {
          schoolId,
          academicYearId: existingData.academicYearId,
          classId: existingData.classId,
          term: existingData.term,
        },
      });

    const updatedComponents = allComponents.map((component) =>
      component.id === componentId
        ? { ...component, ...validatedData }
        : component
    );

    validateUniqueCodes(updatedComponents);
    validateTotalMaximumMarks(updatedComponents);

    return tx.resultcomponentconfig.update({
      where: { id: componentId },
      data: validatedData,
    });
  });
};

// ==================================================
// 8. DELETE COMPONENT CONFIGURATION
// ==================================================

export const deleteResultComponentConfig = async ({
  schoolId,
  componentId,
}) => {
  schoolId = validateId(schoolId, "schoolId");
  componentId = validateId(componentId, "componentId");

  return prisma.$transaction(async (tx) => {
    const component =
      await tx.resultcomponentconfig.findFirst({
        where: {
          id: componentId,
          schoolId,
        },
      });

    if (!component) {
      throw new Error("COMPONENT_NOT_FOUND");
    }

    await ensureConfigurationEditable(tx, component);

    const remainingComponents =
      await tx.resultcomponentconfig.findMany({
        where: {
          schoolId,
          academicYearId: component.academicYearId,
          classId: component.classId,
          term: component.term,
          id: {
            not: componentId,
          },
        },
      });

    validateTotalMaximumMarks(remainingComponents);

    await tx.resultcomponentconfig.delete({
      where: { id: componentId },
    });

    return {
      message: "Result component deleted successfully.",
    };
  });
};

// ==================================================
// 9. GET ACTIVE COMPONENTS FOR RESULT PROCESSING
// ==================================================

const getActiveComponents = async (
  tx,
  { schoolId, academicYearId, classId, term }
) => {
  const components = await tx.resultcomponentconfig.findMany({
    where: {
      schoolId,
      academicYearId,
      classId,
      term,
      isActive: true,
    },
    orderBy: {
      displayOrder: "asc",
    },
  });

  if (components.length === 0) {
    throw new Error("COMPONENT_CONFIG_NOT_FOUND");
  }

  validateTotalMaximumMarks(components);

  return components;
};

// ==================================================
// 10. CREATE DRAFT RESULTS FOR A SECTION
// ==================================================

export const createSectionResultDrafts = async ({
  schoolId,
  academicYearId,
  classId,
  sectionId,
  term,
}) => {
  schoolId = validateId(schoolId, "schoolId");
  academicYearId = validateId(academicYearId, "academicYearId");
  classId = validateId(classId, "classId");
  sectionId = validateId(sectionId, "sectionId");

  validateTerm(term);

  return prisma.$transaction(async (tx) => {
    await verifyAcademicScope(
      tx,
      schoolId,
      academicYearId,
      classId
    );

    await verifySectionScope(
      tx,
      schoolId,
      classId,
      sectionId
    );

    // Verify that the component configuration is ready.
    const components = await getActiveComponents(tx, {
      schoolId,
      academicYearId,
      classId,
      term,
    });

    // Get all active students in the selected section.
    const students = await tx.student.findMany({
      where: {
        schoolId,
        sectionId,
      },
      select: {
        id: true,
        name: true,
        studentId: true,
      },
      orderBy: {
        id: "asc",
      },
    });

    if (students.length === 0) {
      throw new Error("NO_STUDENTS_FOUND");
    }

    // Get all subjects assigned to this class.
    const classSubjects = await tx.classsubject.findMany({
      where: {
        classId,
        subject: {
          schoolId,
        },
      },
      select: {
        id: true,
        subject: {
          select: {
            id: true,
            name: true,
          },
        },
      },
      orderBy: {
        id: "asc",
      },
    });

    if (classSubjects.length === 0) {
      throw new Error("CLASS_SUBJECTS_NOT_FOUND");
    }

    let createdCount = 0;
    let existingCount = 0;

    for (const student of students) {
      const existing = await tx.result.findUnique({
        where: {
          studentId_academicYearId_term: {
            studentId: student.id,
            academicYearId,
            term,
          },
        },
      });

      if (existing) {
        if (
          existing.schoolId !== schoolId ||
          existing.classId !== classId ||
          existing.sectionId !== sectionId
        ) {
          throw new Error("EXISTING_RESULT_SCOPE_MISMATCH");
        }

        if (existing.status === "PUBLISHED") {
          existingCount++;
          continue;
        }

        // Add any newly assigned class subjects to an existing draft.
        await tx.resultsubject.createMany({
          data: classSubjects.map((subject) => ({
            resultId: existing.id,
            classSubjectId: subject.id,
          })),
          skipDuplicates: true,
        });

        existingCount++;
        continue;
      }

      await tx.result.create({
        data: {
          schoolId,
          studentId: student.id,
          academicYearId,
          classId,
          sectionId,
          term,
          status: "DRAFT",
          totalObtained: 0,
          totalMaximum: 0,
          percentage: 0,

          subjects: {
            create: classSubjects.map((subject) => ({
              classSubjectId: subject.id,
              totalMarks: 0,
              maximumMarks: 0,
              percentage: 0,
            })),
          },
        },
      });

      createdCount++;
    }

    return {
      message: "Section result drafts generated successfully.",
      schoolId,
      academicYearId,
      classId,
      sectionId,
      term,
      studentCount: students.length,
      subjectCount: classSubjects.length,
      componentCount: components.length,
      createdCount,
      existingCount,
    };
  });
};

// ==================================================
// 11. RECALCULATE ONE SUBJECT
// ==================================================

const recalculateSubject = async (tx, resultSubjectId) => {
  const subject = await tx.resultsubject.findUnique({
    where: {
      id: resultSubjectId,
    },
    include: {
      componentMarks: true,
    },
  });

  if (!subject) {
    throw new Error("RESULT_SUBJECT_NOT_FOUND");
  }

  const totalMarks = roundMarks(
    subject.componentMarks.reduce(
      (sum, mark) => sum + Number(mark.obtainedMarks),
      0
    )
  );

  const maximumMarks = roundMarks(
    subject.componentMarks.reduce(
      (sum, mark) => sum + Number(mark.maximumMarks),
      0
    )
  );

  const percentage = calculatePercentage(
    totalMarks,
    maximumMarks
  );

  return tx.resultsubject.update({
    where: {
      id: resultSubjectId,
    },
    data: {
      totalMarks,
      maximumMarks,
      percentage,
    },
  });
};

// ==================================================
// 12. RECALCULATE OVERALL STUDENT RESULT
// ==================================================

const recalculateOverallResult = async (tx, resultId) => {
  const result = await tx.result.findUnique({
    where: {
      id: resultId,
    },
    include: {
      subjects: true,
    },
  });

  if (!result) {
    throw new Error("RESULT_NOT_FOUND");
  }

  const totalObtained = roundMarks(
    result.subjects.reduce(
      (sum, subject) => sum + Number(subject.totalMarks),
      0
    )
  );

  const totalMaximum = roundMarks(
    result.subjects.reduce(
      (sum, subject) => sum + Number(subject.maximumMarks),
      0
    )
  );

  const percentage = calculatePercentage(
    totalObtained,
    totalMaximum
  );

  return tx.result.update({
    where: {
      id: resultId,
    },
    data: {
      totalObtained,
      totalMaximum,
      percentage,
    },
  });
};

// ==================================================
// 13. SAVE COMPONENT MARKS
// ==================================================

export const saveResultMarks = async ({
  schoolId,
  resultId,
  subjects,
}) => {
  schoolId = validateId(schoolId, "schoolId");
  resultId = validateId(resultId, "resultId");

  if (!Array.isArray(subjects) || subjects.length === 0) {
    throw new Error("SUBJECT_MARKS_REQUIRED");
  }

  return prisma.$transaction(async (tx) => {
    const result = await tx.result.findFirst({
      where: {
        id: resultId,
        schoolId,
      },
    });

    if (!result) {
      throw new Error("RESULT_NOT_FOUND");
    }

    if (result.status !== "DRAFT") {
      throw new Error("RESULT_ALREADY_PUBLISHED");
    }

    const configuredComponents = await getActiveComponents(tx, {
      schoolId,
      academicYearId: result.academicYearId,
      classId: result.classId,
      term: result.term,
    });

    const configMap = new Map(
      configuredComponents.map((component) => [
        component.id,
        component,
      ])
    );

    const submittedSubjectIds = new Set();

    for (const submittedSubject of subjects) {
      if (
        !submittedSubject ||
        typeof submittedSubject !== "object"
      ) {
        throw new Error("INVALID_SUBJECT_MARKS");
      }

      const classSubjectId = validateId(
        submittedSubject.classSubjectId,
        "classSubjectId"
      );

      if (submittedSubjectIds.has(classSubjectId)) {
        throw new Error("DUPLICATE_SUBJECT_MARKS");
      }

      submittedSubjectIds.add(classSubjectId);

      if (
        !Array.isArray(submittedSubject.componentMarks) ||
        submittedSubject.componentMarks.length !==
          configuredComponents.length
      ) {
        throw new Error("INCOMPLETE_COMPONENT_MARKS");
      }

      const resultSubject = await tx.resultsubject.findFirst({
        where: {
          resultId,
          classSubjectId,
        },
      });

      if (!resultSubject) {
        throw new Error("RESULT_SUBJECT_NOT_FOUND");
      }

      const classSubject = await tx.classsubject.findFirst({
        where: {
          id: classSubjectId,
          classId: result.classId,
          subject: {
            schoolId,
          },
        },
      });

      if (!classSubject) {
        throw new Error("INVALID_CLASS_SUBJECT");
      }

      const submittedComponentIds = new Set();

      for (const submittedMark of submittedSubject.componentMarks) {
        const componentConfigId = validateId(
          submittedMark.componentConfigId,
          "componentId"
        );

        if (submittedComponentIds.has(componentConfigId)) {
          throw new Error("DUPLICATE_COMPONENT_MARKS");
        }

        submittedComponentIds.add(componentConfigId);

        const config = configMap.get(componentConfigId);

        if (!config) {
          throw new Error("COMPONENT_NOT_FOUND");
        }

        const obtainedMarks = validateMarks(
          submittedMark.obtainedMarks,
          config.maximumMarks
        );

        await tx.resultcomponentmarks.upsert({
          where: {
            resultSubjectId_componentConfigId: {
              resultSubjectId: resultSubject.id,
              componentConfigId,
            },
          },
          create: {
            resultSubjectId: resultSubject.id,
            componentConfigId,
            componentName: config.name,
            obtainedMarks,
            maximumMarks: config.maximumMarks,
          },
          update: {
            componentName: config.name,
            obtainedMarks,
            maximumMarks: config.maximumMarks,
          },
        });
      }

      // Ensure every active configured component was submitted.
      if (
        submittedComponentIds.size !== configuredComponents.length ||
        configuredComponents.some(
          (component) =>
            !submittedComponentIds.has(component.id)
        )
      ) {
        throw new Error("INCOMPLETE_COMPONENT_MARKS");
      }

      await recalculateSubject(tx, resultSubject.id);
    }

    const updatedResult = await recalculateOverallResult(
      tx,
      resultId
    );

    return {
      message: "Result marks saved successfully.",
      resultId,
      subjectsUpdated: subjects.length,
      totalObtained: Number(updatedResult.totalObtained),
      totalMaximum: Number(updatedResult.totalMaximum),
      percentage: Number(updatedResult.percentage),
      grade: calculateGrade(updatedResult.percentage),
      passStatus: calculatePassStatus(updatedResult.percentage),
    };
  });
};

// ==================================================
// 14. VALIDATE RESULT COMPLETENESS
// ==================================================

const validateResultCompleteness = async (tx, result) => {
  const components = await getActiveComponents(tx, {
    schoolId: result.schoolId,
    academicYearId: result.academicYearId,
    classId: result.classId,
    term: result.term,
  });

  const resultSubjects = await tx.resultsubject.findMany({
    where: {
      resultId: result.id,
    },
    include: {
      componentMarks: true,
      classSubject: {
        include: {
          subject: true,
        },
      },
    },
  });

  if (resultSubjects.length === 0) {
    throw new Error("RESULT_SUBJECTS_REQUIRED");
  }

  const expectedSubjectCount = await tx.classsubject.count({
    where: {
      classId: result.classId,
      subject: {
        schoolId: result.schoolId,
      },
    },
  });

  if (resultSubjects.length !== expectedSubjectCount) {
    throw new Error("INCOMPLETE_RESULT_SUBJECTS");
  }

  const incompleteSubjects = [];

  for (const subject of resultSubjects) {
    const markMap = new Map(
      subject.componentMarks.map((mark) => [
        mark.componentConfigId,
        mark,
      ])
    );

    const missingComponents = components.filter(
      (component) => !markMap.has(component.id)
    );

    if (
      missingComponents.length > 0 ||
      subject.componentMarks.length !== components.length
    ) {
      incompleteSubjects.push({
        subject: subject.classSubject.subject.name,
        missingComponents: missingComponents.map(
          (component) => component.name
        ),
      });

      continue;
    }

    const totalMaximum = components.reduce(
      (sum, component) =>
        sum + Number(component.maximumMarks),
      0
    );

    const totalObtained = components.reduce(
      (sum, component) =>
        sum +
        Number(markMap.get(component.id).obtainedMarks),
      0
    );

    if (
      toMinorUnits(totalMaximum) !== 10000 ||
      totalObtained < 0
    ) {
      throw new Error("INVALID_SUBJECT_RESULT");
    }

    await recalculateSubject(tx, subject.id);
  }

  if (incompleteSubjects.length > 0) {
    const error = new Error("INCOMPLETE_RESULT_MARKS");
    error.details = incompleteSubjects;
    throw error;
  }

  const updatedResult = await recalculateOverallResult(
    tx,
    result.id
  );

  return {
    result: updatedResult,
    subjects: resultSubjects,
  };
};

// ==================================================
// 15. PUBLISH A STUDENT RESULT
// ==================================================

export const publishStudentResult = async ({
  schoolId,
  resultId,
}) => {
  schoolId = validateId(schoolId, "schoolId");
  resultId = validateId(resultId, "resultId");

  return prisma.$transaction(async (tx) => {
    const result = await tx.result.findFirst({
      where: {
        id: resultId,
        schoolId,
      },
    });

    if (!result) {
      throw new Error("RESULT_NOT_FOUND");
    }

    if (result.status === "PUBLISHED") {
      throw new Error("RESULT_ALREADY_PUBLISHED");
    }

    const { result: calculatedResult } =
      await validateResultCompleteness(tx, result);

    const publishedAt = new Date();

    const updatedResult = await tx.result.update({
      where: {
        id: resultId,
      },
      data: {
        status: "PUBLISHED",
        publishedAt,
      },
    });

    return {
      message: "Student result published successfully.",
      resultId: updatedResult.id,
      studentId: updatedResult.studentId,
      totalObtained: Number(calculatedResult.totalObtained),
      totalMaximum: Number(calculatedResult.totalMaximum),
      percentage: Number(calculatedResult.percentage),
      grade: calculateGrade(calculatedResult.percentage),
      passStatus: calculatePassStatus(calculatedResult.percentage),
      status: updatedResult.status,
      publishedAt: updatedResult.publishedAt,
    };
  });
};

// ==================================================
// 16. PUBLISH ALL RESULTS FOR A SECTION
// ==================================================

export const publishSectionResults = async ({
  schoolId,
  academicYearId,
  classId,
  sectionId,
  term,
}) => {
  schoolId = validateId(schoolId, "schoolId");
  academicYearId = validateId(academicYearId, "academicYearId");
  classId = validateId(classId, "classId");
  sectionId = validateId(sectionId, "sectionId");

  validateTerm(term);

  return prisma.$transaction(async (tx) => {
    await verifyAcademicScope(
      tx,
      schoolId,
      academicYearId,
      classId
    );

    await verifySectionScope(
      tx,
      schoolId,
      classId,
      sectionId
    );

    const students = await tx.student.findMany({
      where: {
        schoolId,
        sectionId,
      },
      select: {
        id: true,
      },
    });

    if (students.length === 0) {
      throw new Error("NO_STUDENTS_FOUND");
    }

    const results = await tx.result.findMany({
      where: {
        schoolId,
        academicYearId,
        classId,
        sectionId,
        term,
        status: "DRAFT",
      },
    });

    if (results.length !== students.length) {
      throw new Error("SECTION_RESULTS_INCOMPLETE");
    }

    // Validate every result before publishing any of them.
    for (const result of results) {
      await validateResultCompleteness(tx, result);
    }

    const publishedAt = new Date();

    await tx.result.updateMany({
      where: {
        id: {
          in: results.map((result) => result.id),
        },
        schoolId,
        status: "DRAFT",
      },
      data: {
        status: "PUBLISHED",
        publishedAt,
      },
    });

    return {
      message: "Section results published successfully.",
      academicYearId,
      classId,
      sectionId,
      term,
      publishedCount: results.length,
      publishedAt,
    };
  });
};

// ==================================================
// 17. STUDENT RESULT CONTEXT
// ==================================================

const getStudentContext = async (userId) => {
  userId = validateId(userId, "userId");

  const user = await prisma.user.findUnique({
    where: {
      id: userId,
    },
    select: {
      id: true,
      student: {
        select: {
          id: true,
          schoolId: true,
        },
      },
    },
  });

  if (!user) {
    throw new Error("USER_NOT_FOUND");
  }

  if (!user.student) {
    throw new Error("STUDENT_PROFILE_NOT_FOUND");
  }

  return {
    userId: user.id,
    studentId: user.student.id,
    schoolId: user.student.schoolId,
  };
};

// ==================================================
// 18. STUDENT RESULT RESPONSE FORMAT
// ==================================================

const studentResultInclude = {
  academicyear: true,
  academicclass: true,
  section: true,

  subjects: {
    orderBy: {
      id: "asc",
    },

    include: {
      classSubject: {
        include: {
          subject: true,
        },
      },

      componentMarks: {
        orderBy: {
          id: "asc",
        },
      },
    },
  },
};

const formatStudentResult = (result) => {
  const subjects = result.subjects.map((subject) => {
    const percentage = Number(subject.percentage);

    return {
      ...subject,
      totalMarks: Number(subject.totalMarks),
      maximumMarks: Number(subject.maximumMarks),
      percentage,
      grade: calculateGrade(percentage),
      passStatus: calculatePassStatus(percentage),

      subject: subject.classSubject.subject,

      componentMarks: subject.componentMarks.map((mark) => ({
        ...mark,
        obtainedMarks: Number(mark.obtainedMarks),
        maximumMarks: Number(mark.maximumMarks),
      })),
    };
  });

  const percentage = Number(result.percentage);

  return {
    ...result,
    totalObtained: Number(result.totalObtained),
    totalMaximum: Number(result.totalMaximum),
    percentage,
    grade: calculateGrade(percentage),
    passStatus: calculatePassStatus(percentage),
    subjects,
  };
};

// ==================================================
// 19. GET ALL PUBLISHED RESULTS OF LOGGED-IN STUDENT
// ==================================================

export const getStudentResults = async ({ userId }) => {
  const student = await getStudentContext(userId);

  const results = await prisma.result.findMany({
    where: {
      studentId: student.studentId,
      schoolId: student.schoolId,
      status: "PUBLISHED",
    },

    include: studentResultInclude,

    orderBy: [
      {
        academicYearId: "desc",
      },
      {
        createdAt: "desc",
      },
    ],
  });

  return {
    studentId: student.studentId,
    count: results.length,
    results: results.map(formatStudentResult),
  };
};

// ==================================================
// 20. GET ONE PUBLISHED RESULT BY ID
// ==================================================

export const getStudentResultById = async ({
  userId,
  resultId,
}) => {
  const student = await getStudentContext(userId);

  resultId = validateId(resultId, "resultId");

  const result = await prisma.result.findFirst({
    where: {
      id: resultId,
      studentId: student.studentId,
      schoolId: student.schoolId,
      status: "PUBLISHED",
    },

    include: studentResultInclude,
  });

  if (!result) {
    throw new Error("RESULT_NOT_FOUND");
  }

  return formatStudentResult(result);
};
