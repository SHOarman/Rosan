import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rosannalie/core/route/app_pages.dart';
import 'package:rosannalie/general_widget/custom_background.dart';

class Onlading extends StatefulWidget {
  const Onlading({super.key});

  @override
  State<Onlading> createState() => _OnladingState();
}

class _OnladingState extends State<Onlading> {
  @override
  void initState() {
    super.initState();
    // Navigate to onboarding 1 after 3 seconds
    Future.delayed(const Duration(seconds: 3), () {
      Get.offNamed(AppRoutes.onborading1);
    });
  }

  @override
  Widget build(BuildContext context) {
    return CustomBackground.auth(
      useSafeArea: false,
      child: Center(
        child: TweenAnimationBuilder<double>(
          tween: Tween<double>(begin: 0.8, end: 1.0),
          duration: const Duration(milliseconds: 1200),
          curve: Curves.easeOutBack,
          builder: (context, scale, child) {
            return Transform.scale(
              scale: scale,
              child: TweenAnimationBuilder<double>(
                tween: Tween<double>(begin: 0.0, end: 1.0),
                duration: const Duration(milliseconds: 800),
                builder: (context, opacity, child) {
                  return Opacity(
                    opacity: opacity,
                    child: child,
                  );
                },
                child: child,
              ),
            );
          },
          child: Container(
            width: 180.0,
            height: 180.0,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(36.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.25),
                  blurRadius: 25.0,
                  offset: const Offset(0, 10),
                ),
                BoxShadow(
                  color: const Color(0xFF9B85CF).withValues(alpha: 0.3),
                  blurRadius: 35.0,
                  spreadRadius: 2.0,
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(36.0),
              child: Image.asset(
                'assets/icon/LOGO (2) 1.png',
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
