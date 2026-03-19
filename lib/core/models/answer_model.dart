// lib/core/models/answer_model.dart

class Answer {
  final String text;
  final int score;
  final double weight;

  Answer({
    required this.text,
    required this.score,
    required this.weight,
  });

  factory Answer.fromJson(Map<String, dynamic> json) {
    return Answer(
      text: json['text']?.toString() ?? '',
      score: json['score'] as int? ?? 1,
      weight: (json['weight'] as num?)?.toDouble() ?? 0.25,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'text': text,
      'score': score,
      'weight': weight,
    };
  }
}