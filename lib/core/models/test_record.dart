// lib/core/models/test_record.dart

import 'dart:convert';

class TestRecord {
  final int? id;
  final String userId; // ✅ إضافة userId
  final String name;
  final int age;
  final String phone;
  final String gender;
  final DateTime testDate;
  final double overallScore;
  final String status;
  final Map<String, double> categoryScores;
  final List<Map<String, dynamic>> strengths;
  final List<Map<String, dynamic>> weaknesses;
  final String advice;
  final Map<String, int> answers;
  final List<String> questions;

  TestRecord({
    this.id,
    required this.userId, // ✅ إضافة userId
    required this.name,
    required this.age,
    required this.phone,
    required this.gender,
    required this.testDate,
    required this.overallScore,
    required this.status,
    required this.categoryScores,
    required this.strengths,
    required this.weaknesses,
    required this.advice,
    required this.answers,
    required this.questions,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId, // ✅ إضافة userId
      'name': name,
      'age': age,
      'phone': phone,
      'gender': gender,
      'testDate': testDate.toIso8601String(),
      'overallScore': overallScore,
      'status': status,
      'categoryScores': jsonEncode(categoryScores),
      'strengths': jsonEncode(strengths),
      'weaknesses': jsonEncode(weaknesses),
      'advice': advice,
      'answers': jsonEncode(answers),
      'questions': jsonEncode(questions),
    };
  }

  factory TestRecord.fromMap(Map<String, dynamic> map) {
    return TestRecord(
      id: map['id'],
      userId: map['userId'] ?? '', // ✅ قراءة userId
      name: map['name'],
      age: map['age'],
      phone: map['phone'],
      gender: map['gender'] ?? 'male',
      testDate: DateTime.parse(map['testDate']),
      overallScore: map['overallScore'],
      status: map['status'],
      categoryScores: Map<String, double>.from(jsonDecode(map['categoryScores'])),
      strengths: List<Map<String, dynamic>>.from(jsonDecode(map['strengths'])),
      weaknesses: List<Map<String, dynamic>>.from(jsonDecode(map['weaknesses'])),
      advice: map['advice'],
      answers: Map<String, int>.from(jsonDecode(map['answers'])),
      questions: List<String>.from(jsonDecode(map['questions'])),
    );
  }

  // for display in list
  String get formattedDate {
    return '${testDate.day}/${testDate.month}/${testDate.year}';
  }

  String get formattedTime {
    return '${testDate.hour}:${testDate.minute.toString().padLeft(2, '0')}';
  }
}