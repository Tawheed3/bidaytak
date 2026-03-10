import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../providers/auth_provider.dart';
import 'login_screen.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _darkModeEnabled = false;
  bool _showAbout = false;
  bool _showContact = false;
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.teal,
        elevation: 0,
        title: Text(
          'الإعدادات',
          style: GoogleFonts.cairo(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              // ✅ profile card
              _buildProfileCard(authProvider),
              const SizedBox(height: 20),

              // ✅ about section
              _buildAboutSection(),
              const SizedBox(height: 8),

              // ✅ contact us section (Email only)
              _buildContactSection(),
              const SizedBox(height: 20),

              // ✅ logout button
              _buildLogoutButton(authProvider),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  // ==================== profile card ====================
  Widget _buildProfileCard(AuthProvider authProvider) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          // user image
          Stack(
            children: [
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.teal,
                    width: 3,
                  ),
                  image: authProvider.userPhotoUrl != null
                      ? DecorationImage(
                    image: NetworkImage(authProvider.userPhotoUrl!),
                    fit: BoxFit.cover,
                  )
                      : null,
                ),
                child: authProvider.userPhotoUrl == null
                    ? CircleAvatar(
                  backgroundColor: Colors.teal.shade100,
                  child: Text(
                    authProvider.userName?[0].toUpperCase() ?? 'U',
                    style: GoogleFonts.cairo(
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                      color: Colors.teal,
                    ),
                  ),
                )
                    : null,
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: Colors.teal,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2),
                  ),
                  child: const Icon(
                    Icons.camera_alt,
                    size: 16,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // user name
          Text(
            authProvider.userName ?? 'مستخدم',
            style: GoogleFonts.cairo(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.teal.shade800,
            ),
          ),
          const SizedBox(height: 4),

          // email
          Text(
            authProvider.userEmail ?? 'example@email.com',
            style: GoogleFonts.cairo(
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  // ==================== about section ====================
  Widget _buildAboutSection() {
    return Column(
      children: [
        GestureDetector(
          onTap: () {
            setState(() {
              _showAbout = !_showAbout;
            });
          },
          child: _buildSectionHeader(
            icon: Icons.info_outline,
            title: 'About',
            color: Colors.green,
            isExpanded: _showAbout,
          ),
        ),
        const SizedBox(height: 8),

        if (_showAbout) ...[
          Card(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // school name
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.amber.shade50,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.amber.shade200),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.school,
                          color: Colors.amber.shade700,
                          size: 28,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'مدرسة العقيق الأهلية النموذجية',
                            style: GoogleFonts.cairo(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // students list title
                  Text(
                    '👩‍🎓 Participating Students:',
                    style: GoogleFonts.cairo(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.purple,
                    ),
                  ),
                  const SizedBox(height: 12),

                  // show/hide students button
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _isExpanded = !_isExpanded;
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.purple.shade50,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            _isExpanded ? Icons.expand_less : Icons.expand_more,
                            color: Colors.purple.shade700,
                            size: 20,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            _isExpanded ? 'Hide Names' : 'Show Names',
                            style: GoogleFonts.cairo(
                              color: Colors.purple.shade700,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // students names
                  if (_isExpanded) ...[
                    const SizedBox(height: 12),
                    _buildStudentCard('غيداء القرشي'),
                    _buildStudentCard('وتين الصائغ'),
                    _buildStudentCard('حلا ثروة '),
                    _buildStudentCard('ليان ضمرة '),
                    _buildStudentCard(' سجى القرني'),
                  ],
                  const SizedBox(height: 12),

                  // app description
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade50,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.info,
                              size: 18,
                              color: Colors.grey.shade600,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'About the app:',
                              style: GoogleFonts.cairo(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'This app helps you assess your readiness for marriage through a comprehensive test covering five main areas: emotional maturity, responsibility, conflict management, financial independence, and communication skills. The app provides you with a detailed analysis of your answers with personalized advice and a development plan to help you improve your weaknesses and enhance your strengths.',
                          style: GoogleFonts.cairo(
                            fontSize: 14,
                            height: 1.5,
                          ),
                          textAlign: TextAlign.justify,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ],
    );
  }

  // ==================== contact us section (Email only) ====================
  Widget _buildContactSection() {
    return Column(
      children: [
        GestureDetector(
          onTap: () {
            setState(() {
              _showContact = !_showContact;
            });
          },
          child: _buildSectionHeader(
            icon: Icons.contact_mail,
            title: 'Contact Us',
            color: Colors.orange,
            isExpanded: _showContact,
          ),
        ),
        const SizedBox(height: 8),

        if (_showContact) ...[
          Card(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  // ✅ Email only - removed phone and whatsapp
                  _buildContactTile(
                    icon: Icons.email,
                    iconColor: Colors.red,
                    title: 'Email',
                    subtitle: 'ghayda650@gmail.com', // ضع الإيميل المطلوب هنا
                    onTap: () => _launchEmail('ghayda650@gmail.com'), // ضع الإيميل المطلوب هنا
                  ),
                ],
              ),
            ),
          ),
        ],
      ],
    );
  }

  // ==================== logout button ====================
  Widget _buildLogoutButton(AuthProvider authProvider) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: ListTile(
        leading: Icon(Icons.logout, color: Colors.red),
        title: Text(
          'تسجيل الخروج',
          style: GoogleFonts.cairo(
            fontSize: 14,
            color: Colors.red,
          ),
        ),
        onTap: () => _showLogoutDialog(context, authProvider),
      ),
    );
  }

  // ==================== helper functions ====================

  Widget _buildSectionHeader({
    required IconData icon,
    required String title,
    required Color color,
    required bool isExpanded,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: color,
              size: 18,
            ),
          ),
          const SizedBox(width: 8),
          Text(
            title,
            style: GoogleFonts.cairo(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.grey.shade800,
            ),
          ),
          const Spacer(),
          Icon(
            isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
            color: Colors.grey.shade400,
            size: 20,
          ),
        ],
      ),
    );
  }

  Widget _buildContactTile({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: iconColor.withOpacity(0.1),
          shape: BoxShape.circle,
        ),
        child: Icon(
          icon,
          color: iconColor,
          size: 20,
        ),
      ),
      title: Text(
        title,
        style: GoogleFonts.cairo(fontSize: 14),
      ),
      subtitle: Text(
        subtitle,
        style: GoogleFonts.cairo(fontSize: 12),
      ),
      trailing: const Icon(Icons.arrow_forward_ios, size: 14),
      onTap: onTap,
    );
  }

  Widget _buildStudentCard(String name) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.purple.withOpacity(0.05),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.purple.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.person,
            color: Colors.purple,
            size: 18,
          ),
          const SizedBox(width: 12),
          Text(
            name,
            style: GoogleFonts.cairo(
              fontSize: 14,
              color: Colors.purple,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  // ✅ logout confirmation dialog
  void _showLogoutDialog(BuildContext context, AuthProvider authProvider) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(
          'تسجيل الخروج',
          style: GoogleFonts.cairo(fontWeight: FontWeight.bold),
        ),
        content: Text(
          'هل أنت متأكد من تسجيل الخروج؟',
          style: GoogleFonts.cairo(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(
              'إلغاء',
              style: GoogleFonts.cairo(color: Colors.grey),
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(ctx);
              await authProvider.signOut();
              if (context.mounted) {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                      (route) => false,
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: Text(
              'تسجيل الخروج',
              style: GoogleFonts.cairo(),
            ),
          ),
        ],
      ),
    );
  }

  // ✅ email launcher function
  Future<void> _launchEmail(String email) async {
    final Uri uri = Uri.parse('mailto:$email?subject=استفسار&body=مرحباً');
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }
}