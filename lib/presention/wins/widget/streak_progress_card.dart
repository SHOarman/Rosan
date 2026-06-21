import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:rosannalie/utils/appString.dart';

class StreakProgressCard extends StatelessWidget {
  const StreakProgressCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 110.0,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 10,
            spreadRadius: 0,
            offset: Offset.zero,
          ),
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.10),
            blurRadius: 4,
            spreadRadius: 0,
            offset: Offset.zero,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
          child: Container(
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  const Color(0xFFFFB74D).withValues(alpha: 0.85),
                  const Color(0xFFFFD59D).withValues(alpha: 0.45),
                ],
              ),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.40),
                width: 1.2,
              ),
            ),
            child: Row(
              children: [
                // Flame Icon Container
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                   gradient:LinearGradient(colors: [
                     Color(0xffFFB74D),
                     Color(0xffFF8A65)
                   ]),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Center(
                    child: SvgPicture.asset(
                      'assets/icon/Icon (10).svg',
                      width: 24,
                      height: 24,
                      colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
                    ),
                  ),
                ),
                const SizedBox(width: 16.0),
                // Title and Subtitle Text Column
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '3–Day Streak! 🔥',
                        style: AppTextStyles.plusJakartaSans(
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                          color: const Color(0xFF161022),
                        ),
                      ),
                      const SizedBox(height: 4.0),
                      Text(
                        'Keep going — 4 more days to your next badge!',
                        style: AppTextStyles.plusJakartaSans(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: const Color(0xFF444054),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
