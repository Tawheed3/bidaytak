// lib/services/ai_service.dart

import '../core/models/question_model.dart';
import 'advice_service.dart';

class AIService {
  static Future<Map<String, dynamic>> analyzeResults({
    required List<Question> questions,
    required Map<String, int> answers,
    required Map<String, double> categoryScores,
    required String gender,
  }) async {
    try {
      // حساب متوسط الدرجات
      double totalScore = categoryScores.values.reduce((a, b) => a + b);
      double overallScore = totalScore / categoryScores.length;

      // تحديد نقاط القوة والضعف مع النصائح
      List<Map<String, dynamic>> strengths = [];
      List<Map<String, dynamic>> weaknesses = [];

      for (var question in questions) {
        int score = answers[question.id] ?? 0;

        // جلب النصيحة المناسبة
        String advice = await AdviceService.getAdviceForQuestion(
          question.id,
          gender: gender,
          isStrength: score >= 3,
        );

        if (score >= 3) {
          strengths.add({
            'question': question.text,
            'score': score,
            'advice': advice,
          });
        } else if (score <= 2) {
          weaknesses.add({
            'question': question.text,
            'score': score,
            'advice': advice,
          });
        }
      }

      // ترتيب نقاط القوة والضعف
      strengths.sort((a, b) => b['score'].compareTo(a['score']));
      weaknesses.sort((a, b) => a['score'].compareTo(b['score']));

      // إنشاء خطة تطوير بسيطة
      List<String> developmentPlan = [];
      if (overallScore < 70) {
        developmentPlan.add('ركز على تحسين المجالات التي حصلت فيها على أقل من 50%.');
        developmentPlan.add('خصص وقتاً أسبوعياً للقراءة والتطوير الذاتي.');
        developmentPlan.add('استشر متخصصاً في المجالات التي تحتاج دعماً.');
      } else {
        developmentPlan.add('استمر في تطوير نقاط قوتك.');
        developmentPlan.add('كن قدوة للآخرين في المجالات التي تتميز بها.');
      }

      // نصيحة عامة
      String generalAdvice = _generateGeneralAdvice(overallScore, categoryScores);

      // تحديد الحالة
      String status;
      if (overallScore >= 85) {
        status = 'مؤهل للزواج';
      } else if (overallScore >= 70) {
        status = 'مؤهل جزئياً - جيد';
      } else if (overallScore >= 50) {
        status = 'مؤهل جزئياً';
      } else if (overallScore >= 30) {
        status = 'غير مؤهل - يحتاج تحسين';
      } else {
        status = 'غير مؤهل تماماً';
      }

      return {
        'overallScore': overallScore,
        'status': status,
        'categoryScores': categoryScores,
        'strengths': strengths.take(12).toList(),
        'weaknesses': weaknesses.take(12).toList(),
        'developmentPlan': developmentPlan,
        'advice': generalAdvice,
        'detailedStrengths': strengths,
        'detailedWeaknesses': weaknesses,
      };
    } catch (e) {
      print('❌ خطأ في تحليل الذكاء الاصطناعي: $e');
      return {
        'overallScore': 0,
        'status': 'خطأ في التحليل',
        'categoryScores': categoryScores,
        'strengths': [],
        'weaknesses': [],
        'developmentPlan': ['حدث خطأ في التحليل. يرجى المحاولة مرة أخرى.'],
        'advice': 'نأسف، حدث خطأ في تحليل نتائجك.',
        'detailedStrengths': [],
        'detailedWeaknesses': [],
      };
    }
  }

  static String _generateGeneralAdvice(double overallScore, Map<String, double> categoryScores) {
    if (overallScore >= 85) {
      return 'مبروك! أنت مؤهل بشكل ممتاز للزواج. حافظ على استمراريتك في تطوير نفسك وعلاقاتك.';
    } else if (overallScore >= 70) {
      return 'أنت مؤهل جيداً للزواج. واصل العمل على نقاط القوة وحاول تحسين نقاط الضعف البسيطة.';
    } else if (overallScore >= 50) {
      return 'أنت مؤهل جزئياً. تحتاج للعمل على بعض المجالات قبل الزواج. لا تيأس، التغيير ممكن.';
    } else if (overallScore >= 30) {
      return 'أنت غير مؤهل حالياً. نوصيك بالتركيز على تطوير نفسك والاستعانة بمختصين.';
    } else {
      return 'أنت غير مؤهل تماماً. ننصحك بالتوقف وطلب المساعدة المهنية لتحديد المشاكل والعمل عليها.';
    }
  }
}