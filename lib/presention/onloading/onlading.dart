import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rosannalie/core/route/app_pages.dart';
import 'package:video_player/video_player.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Onlading extends StatefulWidget {
  const Onlading({super.key});

  @override
  State<Onlading> createState() => _OnladingState();
}

class _OnladingState extends State<Onlading> {
  VideoPlayerController? _controller;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.asset('assets/icon/Splash.mp4')
      ..initialize().then((_) {
        setState(() {
          _isInitialized = true;
        });
        _controller?.setVolume(0.0);
        _controller?.play();


        Future.delayed(const Duration(seconds: 8), () async {
          final prefs = await SharedPreferences.getInstance();
          final bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
          final bool isOnboardingCompleted = prefs.getBool('isOnboardingCompleted') ?? false;

          if (isLoggedIn) {
            Get.offNamed(AppRoutes.subscriptionPromotion);
          } else if (isOnboardingCompleted) {
            Get.offNamed(AppRoutes.singin);
          } else {
            Get.offNamed(AppRoutes.onborading1);
          }
        });
      });
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F5FB),
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 800),
        child: _isInitialized && _controller != null
            ? SizedBox.expand(
                key: const ValueKey('video_player'),
                child: FittedBox(
                fit: BoxFit.cover,
                child: SizedBox(
                  width: _controller!.value.size.width,
                  height: _controller!.value.size.height,
                  child: VideoPlayer(_controller!),
                ),
              ),
            )
          : Container(
              key: const ValueKey('splash_text'),
              color: const Color(0xFFF6F5FB),
              child: Center(
                child: Text(
                  "Manifest\nRise",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.playfairDisplay(
                    fontSize: 40,
                    fontStyle: FontStyle.italic,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF5E4B8B),
                    letterSpacing: 1.5,
                    height: 1.3,
                  ),
                ),
              ),
            ),
      ),
    );
  }
}
