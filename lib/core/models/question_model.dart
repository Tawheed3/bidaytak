// lib/core/models/question_model.dart

import 'answer_model.dart';

class Question {
  final String id;
  final String text; // النص المستخدم عند العرض (حسب الجنس)
  final String textMale;
  final String textFemale;
  final String category;
  final double importance;
  final List<String> keywords;
  final String type;
  final List<Answer> answers;

  Question({
    required this.id,
    required this.text,
    required this.textMale,
    required this.textFemale,
    required this.category,
    required this.importance,
    required this.keywords,
    required this.type,
    required this.answers,
  });

  factory Question.fromJson(Map<String, dynamic> json, {String gender = 'male'}) {
    // التعامل مع القيم null بشكل آمن
    String textMale = json['text_male']?.toString() ?? '';
    String textFemale = json['text_female']?.toString() ?? '';

    // اختيار النص حسب الجنس
    String displayText;
    if (gender == 'male') {
      displayText = textMale.isNotEmpty ? textMale : textFemale;
    } else {
      displayText = textFemale.isNotEmpty ? textFemale : textMale;
    }

    // إذا كان النص فارغاً، استخدم معرف السؤال كبديل
    if (displayText.isEmpty) {
      displayText = 'سؤال ${json['id'] ?? ''}';
    }

    // تحويل answers مع التأكد من عدم وجود null
    List<Answer> answersList = [];
    if (json['answers'] != null && json['answers'] is List) {
      answersList = (json['answers'] as List)
          .where((a) => a != null)
          .map((a) => Answer.fromJson(a))
          .toList();
    }

    // التعامل مع keywords
    List<String> keywordsList = [];
    if (json['keywords'] != null && json['keywords'] is List) {
      keywordsList = (json['keywords'] as List)
          .where((k) => k != null)
          .map((k) => k.toString())
          .toList();
    }

    return Question(
      id: json['id']?.toString() ?? '',
      text: displayText,
      textMale: textMale,
      textFemale: textFemale,
      category: json['category']?.toString() ?? '',
      importance: (json['importance'] as num?)?.toDouble() ?? 0.0,
      keywords: keywordsList,
      type: json['type']?.toString() ?? 'scale',
      answers: answersList,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'text_male': textMale,
      'text_female': textFemale,
      'category': category,
      'importance': importance,
      'keywords': keywords,
      'type': type,
      'answers': answers.map((a) => a.toJson()).toList(),
    };
  }

  int getScoreForAnswer(String answerText) {
    try {
      var answer = answers.firstWhere(
            (a) => a.text == answerText,
        orElse: () => Answer(text: '', score: 1, weight: 0.25),
      );
      return answer.score;
    } catch (e) {
      return 1;
    }
  }

  Question copyWithGender(String gender) {
    return Question(
      id: id,
      text: gender == 'male'
          ? (textMale.isNotEmpty ? textMale : textFemale)
          : (textFemale.isNotEmpty ? textFemale : textMale),
      textMale: textMale,
      textFemale: textFemale,
      category: category,
      importance: importance,
      keywords: keywords,
      type: type,
      answers: answers,
    );
  }
}