import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rosannalie/core/services/controller/authcontroller.dart';
import 'package:rosannalie/utils/appString.dart';

class Feelingcard extends StatefulWidget {
  const Feelingcard({super.key});

  @override
  State<Feelingcard> createState() => _FeelingcardState();
}

class _FeelingcardState extends State<Feelingcard> {
  static const _moods = [
    _MoodItem(
      imageAsset: 'assets/images/amazing.png',
      label: 'Amazing',
      value: 'amazing',
    ),
    _MoodItem(
      imageAsset: 'assets/images/good.png',
      label: 'Good',
      value: 'good',
    ),
    _MoodItem(
      imageAsset: 'assets/images/ok.png',
      label: 'Okay',
      value: 'okay',
    ),
    _MoodItem(
      imageAsset: 'assets/images/low.png',
      label: 'Low',
      value: 'low',
    ),
    _MoodItem(
      imageAsset: 'assets/images/darient.png',
      label: 'Drained',
      value: 'drained',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final Authcontroller authController = Get.find<Authcontroller>();

    return Container(
      width: double.infinity,
      height: 130.0,
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.8),
        borderRadius: BorderRadius.circular(20.0),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.9),
          width: 1.0,
        ),
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'How are you feeling right now?',
            style: AppTextStyles.plusJakartaSans(
              fontSize: 15.0,
              fontWeight: FontWeight.w500,
              color: const Color(0xFF8F7DB5),
            ),
          ),
          const Spacer(),
          Obx(() {
            final activeMood = authController.currentMood.value.toLowerCase();
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(_moods.length, (index) {
                final item = _moods[index];
                final bool isSelected = activeMood == item.value ||
                    (activeMood.isEmpty && index == 1);

                return GestureDetector(
                  onTap: () {
                    authController.updateUserMood(item.value);
                  },
                  behavior: HitTestBehavior.opaque,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10.0, vertical: 6.0),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? const Color(0xFFEFE8FF)
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Image.asset(
                          item.imageAsset,
                          width: 28.0,
                          height: 28.0,
                        ),
                        const SizedBox(height: 4.0),
                        Text(
                          item.label,
                          style: AppTextStyles.inter(
                            fontSize: 11.5,
                            fontWeight:
                                isSelected ? FontWeight.w600 : FontWeight.w400,
                            color: isSelected
                                ? const Color(0xFF4A3E75)
                                : const Color(0xFF8F7DB5),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),
            );
          }),
        ],
      ),
    );
  }
}

class _MoodItem {
  final String imageAsset;
  final String label;
  final String value;

  const _MoodItem({
    required this.imageAsset,
    required this.label,
    required this.value,
  });
}
