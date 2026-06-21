import 'package:flutter/material.dart';
import 'package:rosannalie/utils/appString.dart';

class Amazingworkcard extends StatelessWidget {
  final int currentPoints;
  final int totalPoints;
  final int winsCount;

  const Amazingworkcard({
    super.key,
    this.currentPoints = 120,
    this.totalPoints = 200,
    this.winsCount = 3,
  });

  @override
  Widget build(BuildContext context) {
    final double progress = currentPoints / totalPoints;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color(0xFFC5B8E8),
            Color(0xFFF4C0C0),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        border: const Border(
          top: BorderSide(
            color: Color(0x99FFFFFF),
            width: 1,
          ),
        ),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [

          const Text(
            '🎉',
            style: TextStyle(fontSize: 28),
          ),
          const SizedBox(height: 10),

          // Title
          Text(
            'Amazing work today, keep it up!',
            textAlign: TextAlign.center,
            style: AppTextStyles.plusJakartaSans(
              fontSize: 16,
              fontWeight: FontWeight.w800,
              color: const Color(0xFF161022),
            ),
          ),
          const SizedBox(height: 8),

          // Subtitle
          Text(
            "You've earned $currentPoints points and completed $winsCount wins.\nThat's something to be proud of.",
            textAlign: TextAlign.center,
            style: AppTextStyles.inter(
              fontSize: 13,
              fontWeight: FontWeight.w400,
              color: const Color(0xFF444054),
            ).copyWith(height: 1.5),
          ),
          const SizedBox(height: 16),

          // Progress bar
          Stack(
            children: [
              // Background track
              Container(
                width: double.infinity,
                height: 8,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.45),
                  borderRadius: BorderRadius.circular(100),
                ),
              ),
              // Filled portion
              FractionallySizedBox(
                widthFactor: progress.clamp(0.0, 1.0),
                child: Container(
                  height: 8,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [
                        Color(0xFF896CCD),
                        Color(0xFFE087A9),
                      ],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    ),
                    borderRadius: BorderRadius.circular(100),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),

          // Progress label
          Text(
            '$currentPoints/$totalPoints points to next level',
            style: AppTextStyles.inter(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: const Color(0xFF6B5F8A),
            ),
          ),
        ],
      ),
    );
  }
}
