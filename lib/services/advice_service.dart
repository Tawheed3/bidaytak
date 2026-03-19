// lib/services/advice_service.dart

import 'dart:convert';
import 'package:flutter/services.dart';

class AdviceService {
  static Map<String, dynamic>? _adviceData;

  static Future<void> loadAdvice() async {
    try {
      final String response = await rootBundle.loadString('lib/data/advice_data.json');
      final data = json.decode(response);
      _adviceData = data['advice'];
      print('✅ تم تحميل النصائح بنجاح (${_adviceData?.length} نصيحة)');
    } catch (e) {
      print('❌ خطأ في تحميل النصائح: $e');
      _adviceData = {};
    }
  }

  static Future<String> getAdviceForQuestion(
      String questionId, {
        required String gender,
        required bool isStrength,
      }) async {
    if (_adviceData == null) {
      await loadAdvice();
    }

    try {
      final questionAdvice = _adviceData?[questionId];
      if (questionAdvice != null) {
        if (isStrength) {
          return gender == 'male'
              ? (questionAdvice['strength_male'] ?? 'استمر في تعزيز هذه الصفة.')
              : (questionAdvice['strength_female'] ?? 'استمري في تعزيز هذه الصفة.');
        } else {
          return gender == 'male'
              ? (questionAdvice['weakness_male'] ?? 'حاول تطوير هذه المهارة.')
              : (questionAdvice['weakness_female'] ?? 'حاولي تطوير هذه المهارة.');
        }
      }
    } catch (e) {
      print('❌ خطأ في جلب النصيحة: $e');
    }

    return isStrength
        ? 'استمر في تعزيز هذه الصفة، فهي تدل على نضجك.'
        : 'حاول تطوير هذه المهارة، فهي مهمة لنجاح العلاقات.';
  }

  static Map<String, dynamic>? get allAdvice => _adviceData;
}