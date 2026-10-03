class StudentModel {
  final int id;
  final String studentId;
  final String name;
  final String email;
  final String? phone;
  final String? profileImageUrl;

  final int? schoolId;
  final String? schoolName;
  final String? schoolCode;

  final int? classId;
  final String? className;

  final int? sectionId;
  final String? sectionName;

  StudentModel({
    required this.id,
    required this.studentId,
    required this.name,
    required this.email,
    this.phone,
    this.profileImageUrl,
    this.schoolId,
    this.schoolName,
    this.schoolCode,
    this.classId,
    this.className,
    this.sectionId,
    this.sectionName,
  });

  factory StudentModel.fromJson(Map<String, dynamic> json) {
    final school = json['school'];
    final academicClass = json['class'];
    final section = json['section'];

    return StudentModel(
      id: json['id'],
      studentId: json['studentId'],
      name: json['name'],
      email: json['email'],
      phone: json['phone'],
      profileImageUrl: json['profileImageUrl'],

      schoolId: school?['id'],
      schoolName: school?['name'],
      schoolCode: school?['code'],

      classId: academicClass?['id'],
      className: academicClass?['name'],

      sectionId: section?['id'],
      sectionName: section?['name'],
    );
  }
}