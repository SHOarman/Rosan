import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rosannalie/core/route/app_pages.dart';
import 'package:rosannalie/general_widget/custom_background.dart';
import 'package:rosannalie/general_widget/custombutton.dart';
import 'package:rosannalie/presention/onloading/widget/minicard.dart';
import 'package:rosannalie/presention/onloading/widget/onboarding_header.dart';
import 'package:rosannalie/utils/appString.dart';
import 'package:rosannalie/utils/appcolors.dart';

class Onlading3 extends StatefulWidget {
  const Onlading3({super.key});

  @override
  State<Onlading3> createState() => _Onlading3State();
}

class _Onlading3State extends State<Onlading3> {
  int? selectedIndex;

  final List<Map<String, String>> items = [
    {"text": "Procrastinator", "emoji": "😅"},
    {"text": "Overthinker", "emoji": "🌀"},
    {"text": "Dreamer", "emoji": "💭"},
    {"text": "Juggler", "emoji": "📋"},
    {"text": "Burnt-out achiever", "emoji": "🛢️"},
    {"text": "Just starting fresh", "emoji": "🌱"},
  ];

  @override
  Widget build(BuildContext context) {
    return CustomBackground.onboarding(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start
          ,
          children: [
            const SizedBox(height: 20),
            const OnboardingHeader(currentPage: 2),
            const SizedBox(height: 50),
            Text(
              "Which description fits you\nbest?",
              textAlign: TextAlign.start,
              style: AppTextStyles.plusJakartaSans(
                fontSize: 25,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF3D2E6B),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              "No judgment — we're all figuring it out.",
              textAlign: TextAlign.start,
              style: AppTextStyles.plusJakartaSans(
                color: const Color(0xFF8B7DB5),
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 40),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    children: List.generate(4, (index) {
                      final item = items[index];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12.0),
                        child: MiniCard(
                          width: double.infinity,
                          text: item["text"]!,
                          emoji: item["emoji"]!,
                          isSelected: selectedIndex == index,
                          onTap: () {
                            setState(() {
                              if (selectedIndex == index) {
                                selectedIndex = null;
                              } else {
                                selectedIndex = index;
                              }
                            });
                          },
                        ),
                      );
                    }),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    children: List.generate(2, (index) {
                      final actualIndex = index + 4;
                      final item = items[actualIndex];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12.0),
                        child: MiniCard(
                          width: double.infinity,
                          text: item["text"]!,
                          emoji: item["emoji"]!,
                          isSelected: selectedIndex == actualIndex,
                          onTap: () {
                            setState(() {
                              if (selectedIndex == actualIndex) {
                                selectedIndex = null;
                              } else {
                                selectedIndex = actualIndex;
                              }
                            });
                          },
                        ),
                      );
                    }),
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
                isDisabled: selectedIndex == null,
                onTap: () {
                  Get.toNamed(AppRoutes.onborading4);
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
