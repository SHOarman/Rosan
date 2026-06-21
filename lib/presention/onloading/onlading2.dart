import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rosannalie/core/route/app_pages.dart';
import 'package:rosannalie/general_widget/custom_background.dart';
import 'package:rosannalie/general_widget/custombutton.dart';
import 'package:rosannalie/presention/onloading/widget/onboarding_header.dart';
import 'package:rosannalie/utils/appString.dart';
import 'package:rosannalie/utils/appcolors.dart';

class Onlading2 extends StatefulWidget {
  const Onlading2({super.key});

  @override
  State<Onlading2> createState() => _Onlading2State();
}

class _Onlading2State extends State<Onlading2> {
  final TextEditingController _controller = TextEditingController();
  bool _hasText = false;

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      setState(() {
        _hasText = _controller.text.trim().isNotEmpty;
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomBackground.onboarding(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            const OnboardingHeader(currentPage: 1),
            const SizedBox(height: 50),
            Text(
              "How do you want to be\naddressed?",
              textAlign: TextAlign.start,
              style: AppTextStyles.plusJakartaSans(
                fontSize: 25,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF3D2E6B),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              "We'll use this to make everything feel personal.",
              textAlign: TextAlign.start,
              style: AppTextStyles.inter(
                color: const Color(0xFF8B7DB5),
                fontSize: 13,
              ),
            ),
            const SizedBox(height: 40),
            TextField(
              controller: _controller,
              decoration: InputDecoration(
                hintText: "Your first name...",
                hintStyle: AppTextStyles.plusJakartaSans(
                  color: const Color(0xFF8B7DB5).withValues(alpha: 0.5),
                  fontSize: 15,
                ),
                fillColor: Colors.white.withValues(alpha: 0.55),
                filled: true,
                contentPadding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14.0),
                  borderSide: BorderSide(
                    color: const Color(0xFFC5B8E8).withValues(alpha: 0.5),
                    width: 1.0,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14.0),
                  borderSide: BorderSide(
                    color: const Color(0xFFC5B8E8).withValues(alpha: 0.5),
                    width: 1.0,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14.0),
                  borderSide: const BorderSide(
                    color: Color(0xFF7B64B0),
                    width: 1.5,
                  ),
                ),
              ),
              style: AppTextStyles.plusJakartaSans(
                color: const Color(0xFF2E2252),
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 300),
            Center(
              child: CustomButton(
                text: "Continue",
                showIcon: true,
                gradientColors: const [
                  AppColors.primarygredent2,
                  AppColors.primarygredent1,
                ],
                isDisabled: !_hasText,
                onTap: () {
                  Get.toNamed(AppRoutes.onborading3);
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
