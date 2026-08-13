import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rosannalie/core/route/app_pages.dart';
import 'package:video_player/video_player.dart';
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
      backgroundColor: Colors.black,
      body: _isInitialized && _controller != null
          ? SizedBox.expand(
              child: FittedBox(
                fit: BoxFit.cover,
                child: SizedBox(
                  width: _controller!.value.size.width,
                  height: _controller!.value.size.height,
                  child: VideoPlayer(_controller!),
                ),
              ),
            )
          : const SizedBox.shrink(),
    );
  }
}
