# flutter_local_notifications
-keep class com.dexterous.flutterlocalnotifications.** { *; }
-keep class androidx.core.app.NotificationCompat$** { *; }
-keep class androidx.core.app.NotificationManagerCompat$** { *; }
-keep class androidx.core.app.NotificationChannelCompat$** { *; }

# الحفاظ على الأنواع العامة (generic types)
-keepattributes Signature
-keepattributes *Annotation*

# منع إزالة الكلاسات المستخدمة بواسطة الانعكاس
-keep class com.dexterous.flutterlocalnotifications.FlutterLocalNotificationsPlugin { *; }
-keep class com.dexterous.flutterlocalnotifications.FlutterLocalNotificationsPlugin$** { *; }
-keep class com.dexterous.flutterlocalnotifications.FlutterLocalNotificationsPlugin$**$** { *; }

# الحفاظ على TypeToken
-keep class com.google.gson.reflect.TypeToken { *; }
-keep class * extends com.google.gson.reflect.TypeToken

# الحفاظ على الكلاسات المستخدمة بواسطة الانعكاس في الإشعارات
-keep class androidx.core.app.NotificationCompat { *; }
-keep class androidx.core.app.NotificationManagerCompat { *; }
-keep class androidx.core.app.NotificationChannelCompat { *; }

# الحفاظ على كافة الكلاسات في حزمة flutter_local_notifications
-keep class io.flutter.plugins.** { *; }