import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rosannalie/core/route/app_pages.dart';
import 'package:rosannalie/general_widget/custom_background.dart';
import 'package:rosannalie/general_widget/custombutton.dart';
import 'package:rosannalie/presention/onloading/widget/minicard.dart';
import 'package:rosannalie/presention/onloading/widget/onboarding_header.dart';
import 'package:rosannalie/utils/appString.dart';
import 'package:rosannalie/utils/appcolors.dart';

class Onlading5 extends StatefulWidget {
  const Onlading5({super.key});

  @override
  State<Onlading5> createState() => _Onlading5State();
}

class _Onlading5State extends State<Onlading5> {
  final Set<int> selectedIndices = {};

  final List<Map<String, String>> items = [
    {"text": "Early morning", "emoji": "🌅"},
    {"text": "Mid-morning", "emoji": "☕"},
    {"text": "Afternoon", "emoji": "☀️"},
    {"text": "Evening", "emoji": "🌙"},
    {"text": "Night owl", "emoji": "🦉"},
  ];

  @override
  Widget build(BuildContext context) {
    return CustomBackground.onboarding(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            const OnboardingHeader(currentPage: 4),
            const SizedBox(height: 50),
            Text(
              "When do you usually have the\n most energy?",
              textAlign: TextAlign.start,
              style: AppTextStyles.plusJakartaSans(
                fontSize: 23,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF3D2E6B),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              "We'll schedule your most important tasks then.",
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
                      MiniCard(
                        width: double.infinity,
                        text: items[0]["text"]!,
                        emoji: items[0]["emoji"]!,
                        isSelected: selectedIndices.contains(0),
                        onTap: () {
                          setState(() {
                            if (selectedIndices.contains(0)) {
                              selectedIndices.remove(0);
                            } else {
                              selectedIndices.add(0);
                            }
                          });
                        },
                      ),
                      const SizedBox(height: 12),
                      MiniCard(
                        width: double.infinity,
                        text: items[2]["text"]!,
                        emoji: items[2]["emoji"]!,
                        isSelected: selectedIndices.contains(2),
                        onTap: () {
                          setState(() {
                            if (selectedIndices.contains(2)) {
                              selectedIndices.remove(2);
                            } else {
                              selectedIndices.add(2);
                            }
                          });
                        },
                      ),
                      const SizedBox(height: 12),
                      MiniCard(
                        width: double.infinity,
                        text: items[4]["text"]!,
                        emoji: items[4]["emoji"]!,
                        isSelected: selectedIndices.contains(4),
                        onTap: () {
                          setState(() {
                            if (selectedIndices.contains(4)) {
                              selectedIndices.remove(4);
                            } else {
                              selectedIndices.add(4);
                            }
                          });
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    children: [
                      MiniCard(
                        width: double.infinity,
                        text: items[1]["text"]!,
                        emoji: items[1]["emoji"]!,
                        isSelected: selectedIndices.contains(1),
                        onTap: () {
                          setState(() {
                            if (selectedIndices.contains(1)) {
                              selectedIndices.remove(1);
                            } else {
                              selectedIndices.add(1);
                            }
                          });
                        },
                      ),
                      const SizedBox(height: 12),
                      MiniCard(
                        width: double.infinity,
                        text: items[3]["text"]!,
                        emoji: items[3]["emoji"]!,
                        isSelected: selectedIndices.contains(3),
                        onTap: () {
                          setState(() {
                            if (selectedIndices.contains(3)) {
                              selectedIndices.remove(3);
                            } else {
                              selectedIndices.add(3);
                            }
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 200),
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
                  Get.toNamed(AppRoutes.onborading6);
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
