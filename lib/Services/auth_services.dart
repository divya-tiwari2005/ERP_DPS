import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config.dart';
import '../models/student_model.dart';
import '../models/attendance_model.dart';

class ApiService {
  static Future<Map<String, dynamic>> login(
      String loginId,
      String password,
      ) async {
    final response = await http.post(
      Uri.parse('$baseUrl/auth/login'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'loginId': loginId,
        'password': password,
      }),
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 200) {
      return data;
    }

    throw Exception(
      data['message'] ?? 'Login failed',
    );
  }

  // Forgot Password
  static Future<Map<String, dynamic>> forgotPassword(
      String loginId,
      ) async {
    final response = await http.post(
      Uri.parse('$baseUrl/auth/forgot-password'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'loginId': loginId,
      }),
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 200) {
      return data;
    }

    throw Exception(
      data['message'] ?? 'Unable to send OTP',
    );
  }
  // Verify OTP
  static Future<Map<String, dynamic>> verifyOtp(
      String loginId,
      String otp,
      ) async {
    final response = await http.post(
      Uri.parse('$baseUrl/auth/verify-otp'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'loginId': loginId,
        'otp': otp,
      }),
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 200) {
      return data;
    }

    throw Exception(
      data['message'] ?? 'OTP verification failed',
    );
  }
  // Reset Password
  static Future<Map<String, dynamic>> resetPassword(
      String loginId,
      String newPassword,
      ) async {
    final response = await http.post(
      Uri.parse('$baseUrl/auth/reset-password'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'loginId': loginId,
        'newPassword': newPassword,
      }),
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 200) {
      return data;
    }

    throw Exception(
      data['message'] ?? 'Password reset failed',
    );
  }
  static Future<StudentModel> getMyProfile(
      String token,
      ) async {
    final response = await http.get(
      Uri.parse('$baseUrl/student/me'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 200) {
      return StudentModel.fromJson(data['student']);
    }

    throw Exception(
      data['message'] ?? 'Unable to fetch student profile',
    );
  }
  static Future<AttendanceSummary> getMyAttendanceSummary(
      String token,
      String startDate,
      String endDate,
      ) async {
    final response = await http.get(
      Uri.parse(
        '$baseUrl/attendance/my-summary'
            '?startDate=$startDate&endDate=$endDate',
      ),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 200) {
      return AttendanceSummary.fromJson(data);
    }

    throw Exception(
      data['message'] ?? 'Unable to fetch attendance',
    );
  }
  static Future<AttendanceCalendar> getMyAttendanceCalendar(
      String token,
      String month,
      ) async {
    final response = await http.get(
      Uri.parse(
        '$baseUrl/attendance/my-calendar?month=$month',
      ),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 200) {
      return AttendanceCalendar.fromJson(data);
    }

    throw Exception(
      data['message'] ??
          'Unable to fetch attendance calendar',
    );
  }
}