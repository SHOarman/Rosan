import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rosannalie/core/route/app_pages.dart';
import 'package:rosannalie/general_widget/custom_background.dart';
import 'package:rosannalie/general_widget/custombutton.dart';
import 'package:rosannalie/presention/onloading/widget/customcard.dart';
import 'package:rosannalie/utils/appString.dart';
import 'package:rosannalie/utils/appcolors.dart';

class Onlading1 extends StatelessWidget {
  const Onlading1({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomBackground.onboarding(
      useSafeArea: true,
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 40),
            // Logo in the center
            Center(
              child: Container(
                width: 100.0,
                height: 100.0,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF7B64B0).withValues(alpha: 0.2),
                      blurRadius: 20.0,
                      spreadRadius: 2.0,
                    ),
                  ],
                ),
                child: Image.asset(
                  "assets/icon/LOGO (2) 1.png",
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 30),
            // Title
            Text(
              "Build the life you've\nalways imagined.",
              textAlign: TextAlign.center,
              style: AppTextStyles.plusJakartaSans(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF3D2E6B),
              ),
            ),
            const SizedBox(height: 8),
            // Subtitle
            Text(
              "Your personal coach for achieving your goals,\norganize your life and daily motivation.",
              textAlign: TextAlign.center,
              style: AppTextStyles.plusJakartaSans(
                color: const Color(0xFF8B7DB5),
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 30),
            // Feature list cards
            CustomCard(
              imageAsset: "assets/icon/geail.png",
              text: "Build goals that stick",
            ),
            const SizedBox(height: 10),
            CustomCard(
              imageAsset: "assets/icon/star.png",
              text: "Daily motivation & coaching",
            ),
            const SizedBox(height: 10),
            CustomCard(
              imageAsset: "assets/icon/achive.png",
              text: "Earn rewards for progress",
            ),
            const SizedBox(height: 60),
            // Continue button
            CustomButton(
              text: "Continue",
              gradientColors: const [
                AppColors.primarygredent2,
                AppColors.primarygredent1,
              ],
              onTap: () {
                Get.toNamed(AppRoutes.onborading2);
              },
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
