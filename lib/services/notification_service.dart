// lib/services/notification_service.dart

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:permission_handler/permission_handler.dart';
import 'package:intl/intl.dart';
import '../core/models/test_record.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();

  // معرف ثابت للإشعار المتكرر
  static const int recurringNotificationId = 9999;

  // تهيئة الإشعارات
  Future<void> init() async {
    // طلب الصلاحيات
    await _requestPermissions();

    // إعدادات Android
    const AndroidInitializationSettings androidInitializationSettings =
    AndroidInitializationSettings('@mipmap/ic_launcher');

    // إعدادات iOS
    final DarwinInitializationSettings iosInitializationSettings =
    DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
      onDidReceiveLocalNotification: _onDidReceiveLocalNotification,
    );

    final InitializationSettings initializationSettings = InitializationSettings(
      android: androidInitializationSettings,
      iOS: iosInitializationSettings,
    );

    // تهيئة الوقت
    tz.initializeTimeZones();

    await _flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: _onNotificationTap,
    );

    // إنشاء قناة للإشعارات
    await _createNotificationChannel();
  }

  // طلب الصلاحيات
  Future<void> _requestPermissions() async {
    if (await Permission.notification.isDenied) {
      await Permission.notification.request();
    }
  }

  // معالجة الإشعارات على iOS (للإصدارات القديمة)
  void _onDidReceiveLocalNotification(int id, String? title, String? body, String? payload) {
    print('📱 iOS Notification: $title');
  }

  // عند الضغط على الإشعار
  void _onNotificationTap(NotificationResponse response) {
    print('📱 تم الضغط على الإشعار: ${response.payload}');
  }

  // إنشاء قناة للإشعارات (لـ Android)
  Future<void> _createNotificationChannel() async {
    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'recurring_reminder_channel',
      'تذكير متكرر كل 3 أيام',
      description: 'قناة التذكير المتكرر كل 3 أيام لإعادة الاختبار',
      importance: Importance.high,
      playSound: true,
      enableVibration: true,
    );

    await _flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);
  }

  // ✅ دالة جدولة تذكير بعد 3 أيام (مخصص بناءً على آخر نتيجة)
  Future<void> scheduleThreeDayReminder(TestRecord lastResult) async {
    final lastScore = lastResult.overallScore.toStringAsFixed(1);

    String title;
    String body;

    if (lastResult.overallScore >= 75) {
      title = '🌟 حافظ على تميزك';
      body = 'منذ 3 أيام حصلت على $lastScore% في اختبار التقييم. جرب الاختبار مرة أخرى لتتأكد من تطورك!';
    } else if (lastResult.overallScore >= 50) {
      title = '📈 تقدم مستمر';
      body = 'آخر نتيجة لك كانت $lastScore%. اختبر نفسك مرة أخرى ولاحظ تحسن مستواك!';
    } else {
      title = '💪 طور نفسك';
      body = 'نتيجتك السابقة $lastScore%. حان الوقت لتقييم تطورك بإعادة الاختبار!';
    }

    final now = DateTime.now();

    // جدولة 40 إشعار (كل 3 أيام لمدة 4 أشهر تقريباً)
    for (int i = 0; i < 40; i++) {
      final reminderDate = now.add(Duration(days: (i + 1) * 3));
      final reminderDateTime = DateTime(
        reminderDate.year,
        reminderDate.month,
        reminderDate.day,
        10,
        0,
        0,
      );

      final tzReminderDate = tz.TZDateTime.from(reminderDateTime, tz.local);

      const AndroidNotificationDetails androidPlatformChannelSpecifics =
      AndroidNotificationDetails(
        'recurring_reminder_channel',
        'تذكير متكرر كل 3 أيام',
        channelDescription: 'قناة التذكير المتكرر كل 3 أيام لإعادة الاختبار',
        importance: Importance.high,
        priority: Priority.high,
        playSound: true,
        enableVibration: true,
      );

      const DarwinNotificationDetails iosPlatformChannelSpecifics =
      DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      );

      const NotificationDetails platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics,
        iOS: iosPlatformChannelSpecifics,
      );

      await _flutterLocalNotificationsPlugin.zonedSchedule(
        recurringNotificationId + i + 1,
        title,
        body,
        tzReminderDate,
        platformChannelSpecifics,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        uiLocalNotificationDateInterpretation:
        UILocalNotificationDateInterpretation.absoluteTime,
      );
    }

    print('✅ تم جدولة 40 إشعار مخصص كل 3 أيام');
  }

  // ✅ دالة جدولة إشعار عام متكرر كل 3 أيام
  Future<void> startRecurringReminders() async {
    // إلغاء أي إشعارات سابقة
    await cancelAllNotifications();

    final now = DateTime.now();

    // جدولة 40 إشعار (كل 3 أيام لمدة 4 أشهر)
    for (int i = 0; i < 40; i++) {
      final reminderDate = now.add(Duration(days: (i + 1) * 3));
      final reminderDateTime = DateTime(
        reminderDate.year,
        reminderDate.month,
        reminderDate.day,
        10,
        0,
        0,
      );

      final tzReminderDate = tz.TZDateTime.from(reminderDateTime, tz.local);

      const AndroidNotificationDetails androidPlatformChannelSpecifics =
      AndroidNotificationDetails(
        'recurring_reminder_channel',
        'تذكير متكرر كل 3 أيام',
        channelDescription: 'قناة التذكير المتكرر كل 3 أيام لإعادة الاختبار',
        importance: Importance.high,
        priority: Priority.high,
        playSound: true,
        enableVibration: true,
      );

      const DarwinNotificationDetails iosPlatformChannelSpecifics =
      DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      );

      const NotificationDetails platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics,
        iOS: iosPlatformChannelSpecifics,
      );

      await _flutterLocalNotificationsPlugin.zonedSchedule(
        recurringNotificationId + i + 1,
        '📊 تقييم الاستعداد للزواج',
        'حان الوقت لتقييم تطورك! جرب اختبار بدايتك مرة أخرى.',
        tzReminderDate,
        platformChannelSpecifics,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        uiLocalNotificationDateInterpretation:
        UILocalNotificationDateInterpretation.absoluteTime,
      );
    }

    print('✅ تم تشغيل الإشعارات المتكررة كل 3 أيام (40 إشعار)');
  }

  // عرض إشعار فوري
  Future<void> showInstantNotification({
    required String title,
    required String body,
  }) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
    AndroidNotificationDetails(
      'recurring_reminder_channel',
      'تذكير متكرر كل 3 أيام',
      channelDescription: 'قناة التذكير المتكرر كل 3 أيام لإعادة الاختبار',
      importance: Importance.high,
      priority: Priority.high,
    );

    const DarwinNotificationDetails iosPlatformChannelSpecifics =
    DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    const NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: iosPlatformChannelSpecifics,
    );

    await _flutterLocalNotificationsPlugin.show(
      DateTime.now().millisecondsSinceEpoch ~/ 1000,
      title,
      body,
      platformChannelSpecifics,
    );
  }

  // جدولة إشعار محدد
  Future<void> scheduleNotification({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledDate,
  }) async {
    // التأكد أن الوقت في المستقبل
    DateTime finalScheduledDate = scheduledDate;
    if (scheduledDate.isBefore(DateTime.now())) {
      finalScheduledDate = DateTime.now().add(const Duration(days: 3));
    }

    final tzScheduledDate = tz.TZDateTime.from(finalScheduledDate, tz.local);

    const AndroidNotificationDetails androidPlatformChannelSpecifics =
    AndroidNotificationDetails(
      'recurring_reminder_channel',
      'تذكير متكرر كل 3 أيام',
      channelDescription: 'قناة التذكير المتكرر كل 3 أيام لإعادة الاختبار',
      importance: Importance.high,
      priority: Priority.high,
      playSound: true,
      enableVibration: true,
    );

    const DarwinNotificationDetails iosPlatformChannelSpecifics =
    DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    const NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: iosPlatformChannelSpecifics,
    );

    await _flutterLocalNotificationsPlugin.zonedSchedule(
      id,
      title,
      body,
      tzScheduledDate,
      platformChannelSpecifics,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
      UILocalNotificationDateInterpretation.absoluteTime,
    );
  }

  // إلغاء جميع الإشعارات
  Future<void> cancelAllNotifications() async {
    await _flutterLocalNotificationsPlugin.cancelAll();
    print('✅ تم إلغاء جميع الإشعارات');
  }

  // إلغاء إشعار معين
  Future<void> cancelNotification(int id) async {
    await _flutterLocalNotificationsPlugin.cancel(id);
    print('✅ تم إلغاء الإشعار رقم $id');
  }

  // التحقق من حالة الصلاحية
  Future<bool> isPermissionGranted() async {
    return await Permission.notification.isGranted;
  }

  // فتح إعدادات التطبيق
  Future<void> openSettings() async {
    await openAppSettings();
  }
}