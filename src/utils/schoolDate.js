const INDIA_OFFSET = "+05:30";

export const getSchoolDate = (date) => {
  if (typeof date === "string") {
    return date.slice(0, 10);
  }

  if (date instanceof Date) {
    return new Intl.DateTimeFormat("en-CA", {
      timeZone: "Asia/Kolkata",
      year: "numeric",
      month: "2-digit",
      day: "2-digit",
    }).format(date);
  }

  throw new Error("INVALID_DATE");
};

export const schoolDateToUtc = (date) => {
  const schoolDate = getSchoolDate(date);

  return new Date(
    `${schoolDate}T00:00:00${INDIA_OFFSET}`,
  );
};