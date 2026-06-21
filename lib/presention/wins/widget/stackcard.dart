import 'package:flutter/material.dart';
import 'package:rosannalie/utils/appString.dart';

class StackCard extends StatelessWidget {
  final List<Color> gradientColors;
  final Widget icon;
  final String title;
  final String subtitle;
  final Widget? trailing;
  final List<BoxShadow>? customShadows;
  final bool showBorder;
  final Color? titleColor;
  final Color? subtitleColor;
  final double? titleFontSize;
  final double? subtitleFontSize;
  final EdgeInsetsGeometry? padding;
  final double? width;
  final double? height;

  const StackCard({
    super.key,
    required this.gradientColors,
    required this.icon,
    required this.title,
    required this.subtitle,
    this.trailing,
    this.customShadows,
    this.showBorder = true,
    this.titleColor,
    this.subtitleColor,
    this.titleFontSize,
    this.subtitleFontSize,
    this.padding,
    this.width,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    final defaultShadows = customShadows ?? [
      BoxShadow(
        color: Colors.black.withValues(alpha: 0.06),
        blurRadius: 10,
        offset: const Offset(0, 0),
      ),
      BoxShadow(
        color: Colors.black.withValues(alpha: 0.10),
        blurRadius: 4,
        offset: const Offset(0, 0),
      ),
    ];

    return Container(
      width: width,
      height: height ?? 110,
      padding: padding ?? const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: gradientColors.map((c) => c.withValues(alpha: 0.85)).toList(),
        ),
        border: showBorder
            ? Border.all(
                color: const Color(0xFFFFFFFF),
                width: 1.2,
              )
            : null,
        boxShadow: defaultShadows,
      ),
      child: Stack(
        children: [
          if (trailing != null)
            Positioned(
              top: 0,
              right: 0,
              child: trailing!,
            ),

          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                icon,
                const SizedBox(height: 6),
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: AppTextStyles.plusJakartaSans(
                    fontWeight: FontWeight.bold,
                    fontSize: titleFontSize ?? 14,
                    color: titleColor ?? Colors.black87,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  textAlign: TextAlign.center,
                  style: AppTextStyles.plusJakartaSans(
                    fontSize: subtitleFontSize ?? 12,
                    color: subtitleColor ?? const Color(0xFF575B61),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}