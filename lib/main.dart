import 'package:device_preview/device_preview.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:rosannalie/core/dependency_injection/injection.dart';
import 'package:rosannalie/core/route/app_routes.dart';
import 'package:rosannalie/core/route/app_pages.dart';
import 'package:rosannalie/utils/appcolors.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
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

class MyApp extends StatelessWidget {
  final String initialRoute;
  const MyApp({super.key, required this.initialRoute});

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
        textTheme: GoogleFonts.playfairDisplayTextTheme(
          ThemeData.light().textTheme,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.secondary,
            foregroundColor: Colors.white,
          ),
        ),
      ),
      initialRoute: initialRoute,
      getPages: AppPages.routes,
    );
  }
}
