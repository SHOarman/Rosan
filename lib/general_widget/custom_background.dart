import 'package:flutter/material.dart';

class CustomBackground extends StatelessWidget {
  final Widget child;
  final Color? backgroundColor;
  final Gradient? gradient;
  final String? backgroundImageAsset;
  final bool useSafeArea;

  const CustomBackground({
    super.key,
    required this.child,
    this.backgroundColor,
    this.gradient,
    this.backgroundImageAsset,
    this.useSafeArea = true,
  });

  factory CustomBackground.onboarding({
    required Widget child,
    bool useSafeArea = true,
    Color? customColor,
    Gradient? customGradient,
    String? backgroundImageAsset,
  }) {
    return CustomBackground(
      useSafeArea: useSafeArea,
      backgroundColor: customColor,
      backgroundImageAsset: backgroundImageAsset,
      gradient: customColor != null || backgroundImageAsset != null
          ? null 
          : (customGradient ?? const LinearGradient(
              colors: [
                Color(0xFFFFFFFF),
                Color(0xFFF7F0FC),
                Color(0xFFEADBFC),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            )),
      child: child,
    );
  }

  factory CustomBackground.auth({
    required Widget child,
    bool useSafeArea = true,
    Color? customColor,
    Gradient? customGradient,
    String? backgroundImageAsset,
  }) {
    return CustomBackground(
      useSafeArea: useSafeArea,
      backgroundColor: customColor,
      backgroundImageAsset: backgroundImageAsset,
      gradient: customColor != null || backgroundImageAsset != null
          ? null 
          : (customGradient ?? const LinearGradient(
              colors: [
                Color(0xFF9B85CF), // Light purple
                Color(0xFF5E4B8B), // Dark purple
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            )),
      child: child,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent, // Let container decoration shine through
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          color: backgroundColor,
          gradient: gradient,
          image: backgroundImageAsset != null
              ? DecorationImage(
                  image: AssetImage(backgroundImageAsset!),
                  fit: BoxFit.cover,
                )
              : null,
        ),
        child: useSafeArea ? SafeArea(child: child) : child,
      ),
    );
  }
}
