import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:rosannalie/utils/appString.dart';

class Futuredcard extends StatelessWidget {
  const Futuredcard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 24.0),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            const Color(0xFFD7C3FF).withValues(alpha: 0.40),
            const Color(0xFFFFC3D7).withValues(alpha: 0.35),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20.0),
        border: Border.all(color: Color(0xffFFFFFFE5),width: 1),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF4A3870).withValues(alpha: 0.1),
            blurRadius: 32.0,
            spreadRadius: 0,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 64.0,
            height: 64.0,
            decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
              gradient: const LinearGradient(
                colors: [Color(0xFFF4A0C0), Color(0xFFC9A8E0)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFFC9A8E0).withValues(alpha: 0.3),
                  blurRadius: 12.0,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            alignment: Alignment.center,
            child: SvgPicture.asset(
              "assets/images/SparkleIcon.svg",
              width: 24.0,
              height: 24.0,
            ),
          ),
          const SizedBox(height: 12.0),
          // Futured Title
          Text(
            "Futured ✨",
            style: AppTextStyles.plusJakartaSans(
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF3D2E6B),

            ),
          ),
          const SizedBox(height: 12.0),
          // Description text centered directly
          Text(
            "Your vision, growth and progress",
            style: AppTextStyles.plusJakartaSans(
              fontSize: 15.0,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF575B61),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
