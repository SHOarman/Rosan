import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rosannalie/core/route/app_pages.dart';
import 'package:rosannalie/general_widget/custom_background.dart';
import 'package:rosannalie/general_widget/custombutton.dart';
import 'package:rosannalie/presention/onloading/widget/minicard.dart';
import 'package:rosannalie/presention/onloading/widget/onboarding_header.dart';
import 'package:rosannalie/utils/appString.dart';
import 'package:rosannalie/utils/appcolors.dart';

class Onlading6 extends StatefulWidget {
  const Onlading6({super.key});

  @override
  State<Onlading6> createState() => _Onlading6State();
}

class _Onlading6State extends State<Onlading6> {
  final Set<int> selectedIndices = {};

  final List<String> options = [
    "Rarely — I'm fairly focused",
    "Sometimes — on big tasks",
    "Often — it's a real challenge",
    "Almost always",
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
            const OnboardingHeader(currentPage: 5),
            const SizedBox(height: 50),
            Text(
              "How often do you\nprocrastinate?",
              textAlign: TextAlign.start,
              style: AppTextStyles.plusJakartaSans(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF3D2E6B),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              "Honest answers help us help you better.",
              textAlign: TextAlign.start,
              style: AppTextStyles.plusJakartaSans(
                color: const Color(0xFF8B7DB5),
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 40),
            Column(
              children: List.generate(options.length, (index) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12.0),
                  child: MiniCard(
                    text: options[index],
                    width: double.infinity,
                    isSelected: selectedIndices.contains(index),
                    onTap: () {
                      setState(() {
                        if (selectedIndices.contains(index)) {
                          selectedIndices.remove(index);
                        } else {
                          selectedIndices.add(index);
                        }
                      });
                    },
                  ),
                );
              }),
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
                  Get.toNamed(AppRoutes.onborading7);
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
