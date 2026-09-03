
import 'package:device_preview/device_preview.dart';
import 'package:flutter/foundation.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:purchases_flutter/models/purchases_configuration.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:rosannalie/utils/appString.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:audioplayers/audioplayers.dart';

import 'package:rosannalie/core/dependency_injection/injection.dart';
import 'package:rosannalie/core/route/app_routes.dart';
import 'package:rosannalie/core/route/app_pages.dart';
import 'package:rosannalie/utils/appcolors.dart';



final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
const AndroidNotificationChannel channel = AndroidNotificationChannel(
  'high_importance_channel_with_custom_sound_v3',
  'High Importance Notifications',
  description: 'This channel is used for important notifications.',
  importance: Importance.max,
  playSound: true,
  sound: RawResourceAndroidNotificationSound('notificitonsound'),
  enableVibration: true,
);

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  debugPrint("Handling a background message: ${message.messageId}");

  final String? title = message.notification?.title ?? message.data['title'];
  final String? body = message.notification?.body ?? message.data['body'] ?? message.data['message'];

  if (title != null || body != null) {
    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    await flutterLocalNotificationsPlugin.show(
      id: DateTime.now().millisecond,
      title: title ?? 'Rise',
      body: body ?? 'New Notification',
      notificationDetails: const NotificationDetails(
        android: AndroidNotificationDetails(
          'high_importance_channel_with_custom_sound_v3',
          'High Importance Notifications',
          icon: '@mipmap/ic_launcher',
          priority: Priority.high,
          importance: Importance.max,
          sound: RawResourceAndroidNotificationSound('notificitonsound'),
          playSound: true,
        ),
        iOS: DarwinNotificationDetails(
          sound: 'notificitonsound.mp3',
          presentSound: true,
        ),
      ),
    );
  }
}

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  DependencyInjection.bindings();

  runApp(const MyApp());
}

Future<void> _configureRevenueCat() async {
  // PurchasesConfiguration configuration = PurchasesConfiguration("test_qfMlKvrCEtoJxKwxSOOYmgYnQPH");
  // await Purchases.configure(configuration);
}

Future<void> _setupPushNotifications() async {
  // 1. Initialize the flutter_local_notifications plugin
  const AndroidInitializationSettings initializationSettingsAndroid = AndroidInitializationSettings('@mipmap/ic_launcher');
  const DarwinInitializationSettings initializationSettingsDarwin = DarwinInitializationSettings();
  const InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
    iOS: initializationSettingsDarwin,
  );
  await flutterLocalNotificationsPlugin.initialize(
      settings: initializationSettings,
      onDidReceiveNotificationResponse: (details) {
        debugPrint('Notification clicked: ${details.payload}');
      }
  );

  // Listen to Firebase Messages
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    RemoteNotification? notification = message.notification;
    final String? title = notification?.title ?? message.data['title'];
    final String? body = notification?.body ?? message.data['body'] ?? message.data['message'];

    if (title != null || body != null) {
      flutterLocalNotificationsPlugin.show(
        id: DateTime.now().millisecond,
        title: title ?? 'Rise',
        body: body ?? 'New Notification',
        notificationDetails: const NotificationDetails(
          android: AndroidNotificationDetails(
            'high_importance_channel_with_custom_sound_v3',
            'High Importance Notifications',
            icon: '@mipmap/ic_launcher',
            priority: Priority.high,
            importance: Importance.max,
            sound: RawResourceAndroidNotificationSound('notificitonsound'),
            playSound: true,
          ),
          iOS: DarwinNotificationDetails(
            sound: 'notificitonsound.mp3',
            presentSound: true,
          ),
        ),
      );
    }
  });

  FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
    debugPrint('Notification clicked and app opened: ${message.data}');
  });

  // 1. First check the current permission status
  final FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
  NotificationSettings currentSettings = await firebaseMessaging.getNotificationSettings();

  // 2. If it is NOT authorized, then we request permission
  bool isGranted = currentSettings.authorizationStatus == AuthorizationStatus.authorized;

  if (!isGranted) {
    NotificationSettings settings = await firebaseMessaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    bool androidPermissionGranted = false;
    if (defaultTargetPlatform == TargetPlatform.android) {
      androidPermissionGranted = await flutterLocalNotificationsPlugin
              .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
              ?.requestNotificationsPermission() ?? false;
    }

    isGranted = settings.authorizationStatus == AuthorizationStatus.authorized || androidPermissionGranted;

    if (!isGranted) {
      debugPrint("User permanently denied notification permissions.");
    } else {
      debugPrint('User just granted FCM push notification permission');
    }
  } else {
    debugPrint('User ALREADY granted push notification permission, skipped request.');
  }

  if (isGranted) {
    String? token = await firebaseMessaging.getToken();
    debugPrint("FCM Registration Token: $token");
  } else {
    debugPrint("FCM Token generation skipped because user denied permission.");
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      useInheritedMediaQuery: true,
      locale: DevicePreview.locale(context),
      builder: DevicePreview.appBuilder,
      debugShowCheckedModeBanner: false,
      title: 'Rise',
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.primary,
          surface: Colors.white,
          brightness: Brightness.light,
        ),
        textTheme: GoogleFonts.plusJakartaSansTextTheme(
          ThemeData.light().textTheme,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.secondary,
            foregroundColor: Colors.white,
          ),
        ),
      ),
      home: const SplashScreen(),
      getPages: AppPages.routes,
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    try {
      await Firebase.initializeApp();
      FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

      // Create channel
      await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
          ?.createNotificationChannel(channel);

      await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
        alert: true,
        badge: true,
        sound: true,
      );

      await _setupPushNotifications();
    } catch (e) {
      debugPrint("Firebase init or push notification error: $e");
    }

    final prefs = await SharedPreferences.getInstance();
    final String savedToken = prefs.getString('accessToken') ?? '';
    final bool isLoggedIn = savedToken.isNotEmpty || (prefs.getBool('isLoggedIn') ?? false);
    final bool isOnboardingCompleted = prefs.getBool('isOnboardingCompleted') ?? false;

    await _configureRevenueCat();
    
    // Smooth delay for branding
    await Future.delayed(const Duration(milliseconds: 1500));

    if (!mounted) return;

    if (isLoggedIn) {
      Get.offAllNamed(AppRoutes.subscriptionPromotion);
    } else if (isOnboardingCompleted) {
      Get.offAllNamed(AppRoutes.singin);
    } else {
      Get.offAllNamed(AppRoutes.onborading);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F5FB),
      body: Center(
        child: Text(
          "Rise",
          textAlign: TextAlign.center,
          style: GoogleFonts.playfairDisplay(
            fontSize: 50,
            fontStyle: FontStyle.italic,
            fontWeight: FontWeight.bold,
            color: const Color(0xFF5E4B8B),
            letterSpacing: 1.5,
            height: 1.3,
          ),
        ),
      ),
    );
  }
}