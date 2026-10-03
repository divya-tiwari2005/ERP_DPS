class AttendanceSummary {
  final int present;
  final int absent;
  final int total;
  final double percentage;
  final List<AttendanceRecord> records;

  AttendanceSummary({
    required this.present,
    required this.absent,
    required this.total,
    required this.percentage,
    required this.records,
  });

  factory AttendanceSummary.fromJson(
      Map<String, dynamic> json,
      ) {
    final summary = json['summary'];

    return AttendanceSummary(
      present: summary['present'],
      absent: summary['absent'],
      total: summary['total'],
      percentage:
      (summary['percentage'] as num).toDouble(),
      records: (json['records'] as List)
          .map(
            (record) =>
            AttendanceRecord.fromJson(record),
      )
          .toList(),
    );
  }
}

class AttendanceRecord {
  final DateTime date;
  final String status;

  AttendanceRecord({
    required this.date,
    required this.status,
  });

  factory AttendanceRecord.fromJson(
      Map<String, dynamic> json,
      ) {
    return AttendanceRecord(
      date: DateTime.parse(json['date']),
      status: json['status'],
    );
  }
}


// --------------------------------------------------
// Monthly Attendance Calendar
// --------------------------------------------------

class AttendanceCalendar {
  final String month;
  final AttendanceCalendarSummary summary;
  final List<AttendanceCalendarDay> days;

  AttendanceCalendar({
    required this.month,
    required this.summary,
    required this.days,
  });

  factory AttendanceCalendar.fromJson(
      Map<String, dynamic> json,
      ) {
    return AttendanceCalendar(
      month: json['month'],
      summary:
      AttendanceCalendarSummary.fromJson(
        json['summary'],
      ),
      days: (json['days'] as List)
          .map(
            (day) =>
            AttendanceCalendarDay.fromJson(day),
      )
          .toList(),
    );
  }
}


// --------------------------------------------------
// Monthly Summary
// --------------------------------------------------

class AttendanceCalendarSummary {
  final int present;
  final int absent;
  final int total;
  final int attendanceRequiredDays;
  final double percentage;

  AttendanceCalendarSummary({
    required this.present,
    required this.absent,
    required this.total,
    required this.attendanceRequiredDays,
    required this.percentage,
  });

  factory AttendanceCalendarSummary.fromJson(
      Map<String, dynamic> json,
      ) {
    return AttendanceCalendarSummary(
      present: json['present'],
      absent: json['absent'],
      total: json['total'],
      attendanceRequiredDays:
      json['attendanceRequiredDays'],
      percentage:
      (json['percentage'] as num).toDouble(),
    );
  }
}


// --------------------------------------------------
// Individual Calendar Day
// --------------------------------------------------

class AttendanceCalendarDay {
  final DateTime date;
  final String status;
  final bool isAttendanceRequired;
  final String? reason;

  AttendanceCalendarDay({
    required this.date,
    required this.status,
    required this.isAttendanceRequired,
    required this.reason,
  });

  factory AttendanceCalendarDay.fromJson(
      Map<String, dynamic> json,
      ) {
    return AttendanceCalendarDay(
      date: DateTime.parse(json['date']),
      status: json['status'],
      isAttendanceRequired:
      json['isAttendanceRequired'],
      reason: json['reason'],
    );
  }
}