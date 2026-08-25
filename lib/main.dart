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
import 'package:shared_preferences/shared_preferences.dart';
import 'package:audioplayers/audioplayers.dart';

import 'package:rosannalie/core/dependency_injection/injection.dart';
import 'package:rosannalie/core/route/app_routes.dart';
import 'package:rosannalie/core/route/app_pages.dart';
import 'package:rosannalie/utils/appcolors.dart';



final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
const AndroidNotificationChannel channel = AndroidNotificationChannel(
  'high_importance_channel_with_sound',
  'High Importance Notifications',
  description: 'This channel is used for important notifications.',
  importance: Importance.max,
  playSound: true,
  sound: RawResourceAndroidNotificationSound('notificitonsound'),
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
            'high_importance_channel_with_sound',
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

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

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
  } catch (e) {
    debugPrint("Firebase init error: $e");
  }

  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  final prefs = await SharedPreferences.getInstance();
  final String savedToken = prefs.getString('accessToken') ?? '';
  final bool isLoggedIn = savedToken.isNotEmpty || (prefs.getBool('isLoggedIn') ?? false);

  final bool isOnboardingCompleted = prefs.getBool('isOnboardingCompleted') ?? false;

  String initialRoute;
  if (isLoggedIn) {
    initialRoute = AppRoutes.subscriptionPromotion;
  } else if (isOnboardingCompleted) {
    initialRoute = AppRoutes.singin;
  } else {
    initialRoute = AppRoutes.onborading;
  }

  DependencyInjection.bindings();

  await _configureRevenueCat();

  runApp(
    // DevicePreview(
    //   enabled: !kReleaseMode,
    //   builder: (context) => MyApp(initialRoute: initialRoute),
    // ),
      MyApp(initialRoute: initialRoute)
  );
}

Future<void> _configureRevenueCat() async {
  // PurchasesConfiguration configuration = PurchasesConfiguration("test_qfMlKvrCEtoJxKwxSOOYmgYnQPH");
  // await Purchases.configure(configuration);
}

class MyApp extends StatefulWidget {
  final String initialRoute;
  const MyApp({super.key, required this.initialRoute});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  @override
  void initState() {
    super.initState();
    _setupPushNotifications();
  }

  void _setupPushNotifications() async {
    NotificationSettings settings = await _firebaseMessaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      debugPrint('User granted push notification permission');
    }

    String? token = await _firebaseMessaging.getToken();
    debugPrint("FCM Registration Token: $token");

    //=============================================Initialize the flutter_local_notifications plugin==============================================
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

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification? notification = message.notification;
      
      final String? title = notification?.title ?? message.data['title'];
      final String? body = notification?.body ?? message.data['body'] ?? message.data['message'];

      debugPrint('Moin: Foreground message triggered!');

      if (title != null || body != null) {
        flutterLocalNotificationsPlugin.show(
          id: DateTime.now().millisecond,
          title: title ?? 'Rise',
          body: body ?? 'New Notification',
          notificationDetails: const NotificationDetails(
            android: AndroidNotificationDetails(
              'high_importance_channel_with_sound',
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
  }

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
      initialRoute: widget.initialRoute,
      getPages: AppPages.routes,
    );
  }
}