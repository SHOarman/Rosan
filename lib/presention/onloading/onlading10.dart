import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rosannalie/core/route/app_pages.dart';
import 'package:rosannalie/general_widget/custom_background.dart';
import 'package:rosannalie/general_widget/custombutton.dart';
import 'package:rosannalie/presention/onloading/widget/minicard.dart';
import 'package:rosannalie/presention/onloading/widget/onboarding_header.dart';
import 'package:rosannalie/utils/appString.dart';
import 'package:rosannalie/utils/appcolors.dart';

class Onlading10 extends StatefulWidget {
  const Onlading10({super.key});

  @override
  State<Onlading10> createState() => _Onlading10State();
}

class _Onlading10State extends State<Onlading10> {
  int? selectedIndex;

  Widget _buildMiniCard(Map<String, String> item, int index) {
    final isSelected = selectedIndex == index;
    return MiniCard(
      width: double.infinity,
      text: item["text"]!,
      emoji: item["emoji"]!,
      isSelected: isSelected,
      onTap: () {
        setState(() {
          if (selectedIndex == index) {
            selectedIndex = null;
          } else {
            selectedIndex = index;
          }
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> rewards = [
      {"text": "Relaxing evening", "emoji": "🛀"},
      {"text": "Movie night", "emoji": "🎬"},
      {"text": "Social time with friends", "emoji": "👫"},
      {"text": "Favorite meal", "emoji": "🍕"},
      {"text": "Buy something nice", "emoji": "🛍️"},
      {"text": "Rest — no guilt", "emoji": "😌"},
    ];

    return CustomBackground.onboarding(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            const OnboardingHeader(currentPage: 9),
            const SizedBox(height: 50),
            Text(
              "What reward would you love\n after a great week?",
              textAlign: TextAlign.start,
              style: AppTextStyles.plusJakartaSans(
                fontSize: 23,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF3D2E6B),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              "Little treats make big habits stick.",
              textAlign: TextAlign.start,
              style: AppTextStyles.plusJakartaSans(
                color: const Color(0xFF8B7DB5),
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 40),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    children: [
                      _buildMiniCard(rewards[0], 0),
                      const SizedBox(height: 12),
                      _buildMiniCard(rewards[1], 1),
                      const SizedBox(height: 12),
                      _buildMiniCard(rewards[2], 2),
                      const SizedBox(height: 12),
                      _buildMiniCard(rewards[5], 5),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    children: [
                      _buildMiniCard(rewards[3], 3),
                      const SizedBox(height: 12),
                      _buildMiniCard(rewards[4], 4),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 150),
            Center(
              child: CustomButton(
                text: "Continue",
                showIcon: true,
                gradientColors: const [
                  AppColors.primarygredent2,
                  AppColors.primarygredent1,
                ],
                isDisabled: selectedIndex == null,
                onTap: () {
                  Get.toNamed(AppRoutes.onborading11);
                },
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
