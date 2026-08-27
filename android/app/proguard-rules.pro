# Flutter Local Notifications
-keep class com.dexterous.** { *; }

# Firebase Messaging
-keep class com.google.firebase.messaging.** { *; }
-dontwarn com.google.firebase.messaging.**

# Keep models needed by flutter_local_notifications if any
-keep class * extends java.util.ListResourceBundle {
    protected Object[][] getContents();
}
