import 'package:flutter/material.dart';
import 'package:rosannalie/utils/appString.dart';

class Stackcard extends StatelessWidget {
  final int streakCount;
  final int goalsCount;
  final int gratitudeCount;
  final int winsCount;

  const Stackcard({
    super.key,
    this.streakCount = 7,
    this.goalsCount = 12,
    this.gratitudeCount = 34,
    this.winsCount = 52,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 130.0,
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.8),
        borderRadius: BorderRadius.circular(28.0),
        border: Border.all(
          color: Colors.white.withOpacity(0.4),
          width: 1.0,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF6C586D).withOpacity(0.05),
            blurRadius: 32.0,
            spreadRadius: 0,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildStatItem(
            icon: Icons.local_fire_department_outlined,
            iconColor: const Color(0xFF7B64B0), // Purple
            value: streakCount.toString(),
            label: "Streak",
          ),
          _buildStatItem(
            icon: Icons.flag_outlined,
            iconColor: const Color(0xFF00A896), // Teal/Blue
            value: goalsCount.toString(),
            label: "Goals",
          ),
          _buildStatItem(
            icon: Icons.favorite_border,
            iconColor: const Color(0xFF161022), // Dark grey
            value: gratitudeCount.toString(),
            label: "Gratitude",
          ),
          _buildStatItem(
            icon: Icons.emoji_events_outlined,
            iconColor: const Color(0xFFB38F4D), // Gold/Brown
            value: winsCount.toString(),
            label: "Wins",
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem({
    required IconData icon,
    required Color iconColor,
    required String value,
    required String label,
  }) {
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            color: iconColor,
            size: 24.0,
          ),
          const SizedBox(height: 6.0),
          Text(
            value,
            style: AppTextStyles.plusJakartaSans(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF161022),
            ),
          ),
          const SizedBox(height: 2.0),
          Text(
            label,
            style: AppTextStyles.inter(
              fontSize: 11,
              fontWeight: FontWeight.w500,
              color: const Color(0xFF8F7DB5),
            ),
          ),
        ],
      ),
    );
  }
}
