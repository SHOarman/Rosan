// import 'package:device_preview/device_preview.dart';
// import 'package:flutter/foundation.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:flutter/services.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:shared_preferences/shared_preferences.dart';
//
// import 'package:rosannalie/core/dependency_injection/injection.dart';
// import 'package:rosannalie/core/route/app_routes.dart';
// import 'package:rosannalie/core/route/app_pages.dart';
// import 'package:rosannalie/utils/appcolors.dart';
//
// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   try {
//     await Firebase.initializeApp();
//   } catch (e) {
//     debugPrint("Firebase init error: $e");
//   }
//   SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
//   await SystemChrome.setPreferredOrientations([
//     DeviceOrientation.portraitUp,
//     DeviceOrientation.portraitDown,
//   ]);
//
//   final prefs = await SharedPreferences.getInstance();
//   final String savedToken = prefs.getString('accessToken') ?? '';
//   final bool isLoggedIn = savedToken.isNotEmpty || (prefs.getBool('isLoggedIn') ?? false);
//
//   final bool isOnboardingCompleted = prefs.getBool('isOnboardingCompleted') ?? false;
//
//   String initialRoute;
//   if (isLoggedIn) {
//     initialRoute = AppRoutes.subscriptionPromotion;
//   } else if (isOnboardingCompleted) {
//     initialRoute = AppRoutes.singin;
//   } else {
//     initialRoute = AppRoutes.onborading;
//   }
//
//   DependencyInjection.bindings();
//
//   runApp(
//     // DevicePreview(
//     //   enabled: !kReleaseMode,
//     //   builder: (context) => MyApp(initialRoute: initialRoute),
//     // ),
//       MyApp(initialRoute: initialRoute)
//   );
// }
//
// class MyApp extends StatelessWidget {
//   final String initialRoute;
//   const MyApp({super.key, required this.initialRoute});
//
//   @override
//   Widget build(BuildContext context) {
//     return GetMaterialApp(
//       useInheritedMediaQuery: true,
//       locale: DevicePreview.locale(context),
//       builder: DevicePreview.appBuilder,
//       debugShowCheckedModeBanner: false,
//       title: 'Rise',
//       theme: ThemeData(
//         scaffoldBackgroundColor: Colors.white,
//         colorScheme: ColorScheme.fromSeed(
//           seedColor: AppColors.primary,
//           surface: Colors.white,
//           brightness: Brightness.light,
//         ),
//         textTheme: GoogleFonts.plusJakartaSansTextTheme(
//           ThemeData.light().textTheme,
//         ),
//         elevatedButtonTheme: ElevatedButtonThemeData(
//           style: ElevatedButton.styleFrom(
//             backgroundColor: AppColors.secondary,
//             foregroundColor: Colors.white,
//           ),
//         ),
//       ),
//       initialRoute: initialRoute,
//       getPages: AppPages.routes,
//     );
//   }
// }


import 'package:device_preview/device_preview.dart';
import 'package:flutter/foundation.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart'; 
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:rosannalie/core/dependency_injection/injection.dart';
import 'package:rosannalie/core/route/app_routes.dart';
import 'package:rosannalie/core/route/app_pages.dart';
import 'package:rosannalie/utils/appcolors.dart';


@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  debugPrint("Handling a background message: ${message.messageId}");
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await Firebase.initializeApp();


    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
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

  runApp(
    // DevicePreview(
    //   enabled: !kReleaseMode,
    //   builder: (context) => MyApp(initialRoute: initialRoute),
    // ),
      MyApp(initialRoute: initialRoute)
  );
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
    } else {
      debugPrint('User declined or has not accepted permission');
    }

    String? token = await _firebaseMessaging.getToken();
    debugPrint("FCM Registration Token: $token");

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      debugPrint('Foreground message received: ${message.notification?.title}');

      if (message.notification != null) {
        Get.snackbar(
          message.notification?.title ?? 'Notification',
          message.notification?.body ?? '',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.black87,
          colorText: Colors.white,
          margin: const EdgeInsets.all(10),
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