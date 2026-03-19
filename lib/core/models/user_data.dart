// lib/core/models/user_data.dart

class UserData {
  final String name;
  final int age;
  final String phone;
  final String gender; // 'male' or 'female'
  final DateTime testDate;

  UserData({
    required this.name,
    required this.age,
    required this.phone,
    required this.gender,
    required this.testDate,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'age': age,
      'phone': phone,
      'gender': gender,
      'testDate': testDate.toIso8601String(),
    };
  }

  factory UserData.fromJson(Map<String, dynamic> json) {
    return UserData(
      name: json['name'],
      age: json['age'],
      phone: json['phone'],
      gender: json['gender'] ?? 'male',
      testDate: DateTime.parse(json['testDate']),
    );
  }
}