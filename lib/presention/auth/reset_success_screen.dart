import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rosannalie/core/route/app_pages.dart';
import 'package:rosannalie/general_widget/custombutton.dart';
import 'package:rosannalie/utils/appString.dart';
import 'package:rosannalie/utils/appcolors.dart';

class ResetSuccessScreen extends StatelessWidget {
  const ResetSuccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Spacer(),

              // Circular Shield and Checkmark Decoration
              Center(
                child: Container(
                  width: 180,
                  height: 180,
                  decoration: const BoxDecoration(
                    color: Color(0xFFF6F4FD), // Very light purple/lavender circle
                    shape: BoxShape.circle,
                  ),
                  alignment: Alignment.center,
                  child: Container(
                    width: 140,
                    height: 140,
                    decoration: const BoxDecoration(
                      color: Color(0xFFECE6F9), // Slightly darker lavender circle
                      shape: BoxShape.circle,
                    ),
                    alignment: Alignment.center,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        // Shield shape container
                        Container(
                          width: 84,
                          height: 84,
                          decoration: const BoxDecoration(
                            color: Color(0xFF7E69B5), // Shield purple base color
                            shape: BoxShape.circle, // Rounded circle backdrop for check
                          ),
                        ),
                        // Verified User Shield Icon
                        const Icon(
                          Icons.verified_user_rounded,
                          color: Colors.white,
                          size: 52,
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 40),

              // Title "Success!"
              Text(
                "Success!",
                style: AppTextStyles.poppins(
                  color: AppColors.primarygredent1,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 12),

              // Description Text
              Text(
                "You password has been changed. Please\nlog in again with a new password.",
                textAlign: TextAlign.center,
                style: AppTextStyles.inter(
                  color: const Color(0xff647276),
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                ),
              ),

              const Spacer(),

              // Back to Login Button
              Center(
                child: CustomButton(
                  text: "Back to Login",
                  gradientColors: const [
                    AppColors.primarygredent2,
                    AppColors.primarygredent1,
                  ],
                  showIcon: true,
                  onTap: () {
                    Get.offAllNamed(AppRoutes.singin);
                  },
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
