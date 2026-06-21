import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rosannalie/core/route/app_pages.dart';
import 'package:video_player/video_player.dart';

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
    _controller = VideoPlayerController.asset('assets/icon/302098.mp4')
      ..initialize().then((_) {
        setState(() {
          _isInitialized = true;
        });
        _controller?.setVolume(0.0); // Mute the video to allow autoplay on Chrome (web)
        _controller?.play();

        // Navigate to onboarding 1 after 4 seconds of playback starting
        Future.delayed(const Duration(seconds: 4), () {
          Get.offNamed(AppRoutes.onborading1);
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
      backgroundColor: Colors.black, // Clean black background
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
