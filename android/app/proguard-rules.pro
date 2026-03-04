# Flutter specific
# ⚠️ تم تعليق السطرين اللذين كانا يسببان المشكلة
# -keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.**  { *; }
-keep class io.flutter.util.**  { *; }
-keep class io.flutter.view.**  { *; }
# -keep class io.flutter.**  { *; }  # ❌ هذا السطر كان المشكلة الكبرى
-keep class io.flutter.plugins.**  { *; }

# Firebase
-keep class com.google.firebase.** { *; }
-keep class com.google.android.gms.** { *; }

# PDF
-keep class com.shockwave.**

# ✅ القواعد المطلوبة من missing_rules.txt
-keep class com.google.android.play.core.** { *; }
-dontwarn com.google.android.play.core.**