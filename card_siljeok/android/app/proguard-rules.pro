# Flutter Wrapper
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.**  { *; }
-keep class io.flutter.util.**  { *; }
-keep class io.flutter.view.**  { *; }
-keep class io.flutter.**  { *; }
-keep class plugins.flutter.io.**  { *; }

# Workmanager
-keep class dev.fluttercommunity.workmanager.** { *; }

# Firebase
-keep class com.google.firebase.** { *; }

# Avoid obfuscating models or native channels if used via reflection
-keepattributes *Annotation*
-keepattributes Signature
-keepattributes InnerClasses
-keepattributes EnclosingMethod

# Flutter SplitCompat / Play Core issue
-dontwarn com.google.android.play.core.**
