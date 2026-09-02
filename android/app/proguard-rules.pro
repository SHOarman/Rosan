# Flutter Wrapper
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.**  { *; }
-keep class io.flutter.util.**  { *; }
-keep class io.flutter.view.**  { *; }
-keep class io.flutter.** { *; }
-keep class io.flutter.plugins.** { *; }

# Flutter Local Notifications
-keep class com.dexterous.** { *; }
-keep class * extends java.util.ListResourceBundle {
    protected Object[][] getContents();
}

# Firebase & Messaging
-keep class com.google.firebase.** { *; }
-dontwarn com.google.firebase.**

# RevenueCat
-keep class com.revenuecat.purchases.** { *; }
-dontwarn com.revenuecat.**

# Google Sign In / Play Services
-keep class com.google.android.gms.** { *; }
-dontwarn com.google.android.gms.**

# Audioplayers
-keep class xyz.luan.audioplayers.** { *; }

# Google Play Core
-dontwarn com.google.android.play.core.**
-keep class com.google.android.play.core.** { *; }

# Vibration Plugin
-keep class com.benjaminabel.vibration.** { *; }
