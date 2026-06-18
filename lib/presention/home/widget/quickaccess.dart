import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class Quickaccess extends StatelessWidget {
  final String title;
  final String subtitle;
  final String svgIconPath;
  final List<Color> gradientColors;
  final Color iconBackgroundColor;
  final VoidCallback onTap;

  const Quickaccess({
    Key? key,
    required this.title,
    required this.subtitle,
    required this.svgIconPath,
    required this.gradientColors,
    required this.iconBackgroundColor,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 167.0,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: gradientColors,
          ),
          border: const Border(
            top: BorderSide(
              color: Color(0xB3FFFFFF),
              width: 1,
            ),
          ),
          boxShadow: const [
            BoxShadow(
              color: Color(0x1A4A3870),
              offset: Offset(0, 8),
              blurRadius: 32,
              spreadRadius: 0,
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Icon Container
            Container(
              width: 40,
              height: 40,
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: iconBackgroundColor,
                borderRadius: BorderRadius.circular(12),
              ),
              child: SvgPicture.asset(
                svgIconPath,
              ),
            ),
            const SizedBox(width: 12),

            // Texts
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1E1E1E),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: const Color(0xFF1E1E1E).withValues(alpha: 0.6),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}