// lib/screens/user_data_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../providers/test_provider.dart';
import 'questions_screen.dart';

class UserDataScreen extends StatefulWidget {
  const UserDataScreen({super.key});

  @override
  State<UserDataScreen> createState() => _UserDataScreenState();
}

class _UserDataScreenState extends State<UserDataScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _ageController = TextEditingController();
  final _phoneController = TextEditingController();

  String _selectedGender = 'male';

  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  }

  @override
  void dispose() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    _nameController.dispose();
    _ageController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      String cleanNumber = _phoneController.text.replaceAll(RegExp(r'[\s-]'), '');
      String fullPhoneNumber = '+966$cleanNumber';

      Provider.of<TestProvider>(context, listen: false).saveUserData(
        name: _nameController.text,
        age: int.parse(_ageController.text),
        phone: fullPhoneNumber,
        gender: _selectedGender,
      );

      Provider.of<TestProvider>(context, listen: false).loadQuestions();
      _showDisclaimerDialog();
    }
  }

  void _showDisclaimerDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => WillPopScope(
        onWillPop: () async => false,
        child: Dialog(
          backgroundColor: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: Colors.amber.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.info_outline, size: 40, color: Colors.amber),
                ),
                const SizedBox(height: 20),
                Text(
                  'تنبيه مهم',
                  style: GoogleFonts.cairo(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.teal,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'هذا التطبيق هو أداة تقييم شخصي ترفيهية وتعليمية، ولا يُعتبر بديلاً عن الاستشارة المهنية المتخصصة.',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.cairo(fontSize: 15, height: 1.6, color: Colors.grey[700]),
                ),
                const SizedBox(height: 16),
                Text(
                  'للاستشارات الجادة والموثوقة، يُرجى التواصل مع المختصين المعتمدين.',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.cairo(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.amber[800]),
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(ctx),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.grey,
                          side: const BorderSide(color: Colors.grey),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        child: Text('تراجع', style: GoogleFonts.cairo(fontSize: 15)),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pop(ctx);
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (context) => const QuestionsScreen()),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.teal,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        child: Text('أوافق وأبدأ', style: GoogleFonts.cairo(fontSize: 15, fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.teal,
        elevation: 0,
        title: Text(
          'بياناتك الشخصية',
          style: GoogleFonts.cairo(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            // أيقونة
            Center(
              child: Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: Colors.teal.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.person_outline, size: 50, color: Colors.teal),
              ),
            ),
            const SizedBox(height: 20),

            // نصوص الترحيب
            Center(
              child: Text(
                'مرحباً بك في اختبار التقييم',
                style: GoogleFonts.cairo(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 8),
            Center(
              child: Text(
                'يرجى إدخال بياناتك قبل البدء',
                style: GoogleFonts.cairo(fontSize: 14, color: Colors.grey[600]),
              ),
            ),
            const SizedBox(height: 30),

            // حقل الاسم
            Text('الاسم الكامل', style: GoogleFonts.cairo(fontSize: 14, fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            TextFormField(
              controller: _nameController,
              decoration: InputDecoration(
                hintText: 'أدخل اسمك الثلاثي',
                prefixIcon: const Icon(Icons.person, color: Colors.teal),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                filled: true,
                fillColor: Colors.white,
              ),
              validator: (value) => value == null || value.isEmpty ? 'الرجاء إدخال الاسم' : null,
            ),
            const SizedBox(height: 20),

            // حقل العمر
            Text('العمر', style: GoogleFonts.cairo(fontSize: 14, fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            TextFormField(
              controller: _ageController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                hintText: 'أدخل عمرك',
                prefixIcon: const Icon(Icons.cake, color: Colors.teal),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                filled: true,
                fillColor: Colors.white,
              ),
              validator: (value) {
                if (value == null || value.isEmpty) return 'الرجاء إدخال العمر';
                final age = int.tryParse(value);
                if (age == null) return 'الرجاء إدخال رقم صحيح';
                if (age < 16 || age > 80) return 'العمر يجب أن يكون بين 16 و 80 سنة';
                return null;
              },
            ),
            const SizedBox(height: 20),

            // اختيار الجنس
            Text('الجنس', style: GoogleFonts.cairo(fontSize: 14, fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: RadioListTile<String>(
                      title: Text('ذكر', style: GoogleFonts.cairo()),
                      value: 'male',
                      groupValue: _selectedGender,
                      onChanged: (value) => setState(() => _selectedGender = value!),
                      activeColor: Colors.teal,
                      contentPadding: EdgeInsets.zero,
                    ),
                  ),
                  Expanded(
                    child: RadioListTile<String>(
                      title: Text('أنثى', style: GoogleFonts.cairo()),
                      value: 'female',
                      groupValue: _selectedGender,
                      onChanged: (value) => setState(() => _selectedGender = value!),
                      activeColor: Colors.teal,
                      contentPadding: EdgeInsets.zero,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // حقل الهاتف
            Text('رقم الهاتف', style: GoogleFonts.cairo(fontSize: 14, fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Container(
                    width: 80,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    decoration: BoxDecoration(
                      color: Colors.teal.shade50,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(12),
                        bottomLeft: Radius.circular(12),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('🇸🇦', style: TextStyle(fontSize: 20)),
                        const SizedBox(width: 4),
                        Flexible(
                          child: Text(
                            '+966',
                            style: GoogleFonts.cairo(fontSize: 12, color: Colors.teal, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: TextFormField(
                      controller: _phoneController,
                      keyboardType: TextInputType.phone,
                      textDirection: TextDirection.ltr,
                      decoration: InputDecoration(
                        hintText: '5xxxxxxxx',
                        hintTextDirection: TextDirection.ltr,
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) return 'الرجاء إدخال رقم الهاتف';
                        String cleanNumber = value.replaceAll(RegExp(r'[\s-]'), '');
                        if (!RegExp(r'^5[0-9]{8}$').hasMatch(cleanNumber)) {
                          return 'رقم الهاتف غير صحيح (يجب أن يبدأ بـ 5 ويتكون من 9 أرقام)';
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),

            // زر البدء
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _submitForm,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: Text('ابدأ الاختبار', style: GoogleFonts.cairo(fontSize: 16, fontWeight: FontWeight.bold)),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}