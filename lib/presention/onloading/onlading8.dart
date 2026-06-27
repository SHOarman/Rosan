import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rosannalie/core/route/app_pages.dart';
import 'package:rosannalie/general_widget/custom_background.dart';
import 'package:rosannalie/general_widget/custombutton.dart';
import 'package:rosannalie/presention/onloading/widget/minicard.dart';
import 'package:rosannalie/presention/onloading/widget/onboarding_header.dart';
import 'package:rosannalie/utils/appString.dart';
import 'package:rosannalie/utils/appcolors.dart';

class Onlading8 extends StatefulWidget {
  const Onlading8({super.key});

  @override
  State<Onlading8> createState() => _Onlading8State();
}

class _Onlading8State extends State<Onlading8> {
  final Set<int> selectedIndices = {};

  Widget _buildMiniCard(Map<String, String> item, int index) {
    final isSelected = selectedIndices.contains(index);
    return MiniCard(
      width: double.infinity,
      text: item["text"]!,
      emoji: item["emoji"]!,
      isSelected: isSelected,
      onTap: () {
        setState(() {
          if (selectedIndices.contains(index)) {
            selectedIndices.remove(index);
          } else {
            selectedIndices.add(index);
          }
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> habits = [
      {"text": "Exercise regularly", "emoji": "🏃"},
      {"text": "Read daily", "emoji": "📚"},
      {"text": "Meditate", "emoji": "🧘"},
      {"text": "Journaling", "emoji": "✍️"},
      {"text": "Better sleep", "emoji": "😴"},
      {"text": "Drink more water", "emoji": "💧"},
      {"text": "Healthy eating", "emoji": "🥦"},
      {"text": "Focus time", "emoji": "🎯"},
    ];

    return CustomBackground.onboarding(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            const OnboardingHeader(currentPage: 7),
            const SizedBox(height: 50),
            Text(
              "What habits do you want to \n build?",
              textAlign: TextAlign.start,
              style: AppTextStyles.plusJakartaSans(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF3D2E6B),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              "Select all that you'd love to make consistent.",
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
                      _buildMiniCard(habits[0], 0),
                      const SizedBox(height: 12),
                      _buildMiniCard(habits[2], 2),
                      const SizedBox(height: 12),
                      _buildMiniCard(habits[4], 4),
                      const SizedBox(height: 12),
                      _buildMiniCard(habits[6], 6),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    children: [
                      _buildMiniCard(habits[1], 1),
                      const SizedBox(height: 12),
                      _buildMiniCard(habits[3], 3),
                      const SizedBox(height: 12),
                      _buildMiniCard(habits[5], 5),
                      const SizedBox(height: 12),
                      _buildMiniCard(habits[7], 7),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 120),
            Center(
              child: CustomButton(
                text: "Continue",
                showIcon: true,
                gradientColors: const [
                  AppColors.primarygredent2,
                  AppColors.primarygredent1,
                ],
                isDisabled: selectedIndices.isEmpty,
                onTap: () {
                  Get.toNamed(AppRoutes.onborading9);
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
