import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rosannalie/core/services/controller/authcontroller.dart';
import 'package:rosannalie/general_widget/custombutton.dart';
import 'package:rosannalie/utils/appString.dart';
import 'package:rosannalie/utils/appcolors.dart';

class EmailVerfication extends StatelessWidget {
  const EmailVerfication({super.key});

  Widget _buildOtpField(int index, BuildContext context, Authcontroller authController) {
    return SizedBox(
      width: 46,
      height: 56,
      child: TextFormField(
        controller: authController.otpControllers[index],
        keyboardType: TextInputType.number,
        textAlign: TextAlign.center,
        maxLength: 1,
        style: AppTextStyles.plusJakartaSans(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: const Color(0xFF2E2252),
        ),
        decoration: InputDecoration(
          counterText: "",
          fillColor: Colors.white,
          filled: true,
          contentPadding: EdgeInsets.zero,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(
              color: Color(0xFFC5B8E8),
              width: 1.0,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(
              color: Color(0xFF5E4B8B),
              width: 1.5,
            ),
          ),
        ),
        onChanged: (value) {
          if (value.isNotEmpty) {
            if (index < 5) {
              FocusScope.of(context).nextFocus();
            } else {
              FocusScope.of(context).unfocus();
            }
          } else {
            if (index > 0) {
              FocusScope.of(context).previousFocus();
            }
          }
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final authController = Get.find<Authcontroller>();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Color(0xFF2E2252),
            size: 20,
          ),
          onPressed: () => Get.back(),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                Text(
                  "Verify your Email",
                  style: AppTextStyles.poppins(
                    color: AppColors.primarygredent1,
                    fontSize: 25,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  "Please enter 6 digit verification that have been sent\nto your email address",
                  style: AppTextStyles.inter(
                    color: const Color(0xff647276),
                    fontSize: 13,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                const SizedBox(height: 40),

                // OTP Row fields
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: List.generate(6, (index) => _buildOtpField(index, context, authController)),
                ),

                const SizedBox(height: 40),

                // Resend Code text
                Center(
                  child: Column(
                    children: [
                      Text(
                        "Don't receive code ?",
                        style: AppTextStyles.inter(
                          color: const Color(0xFF2E2252),
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 6),
                      GestureDetector(
                        onTap: () {
                          authController.resendOtpCode();
                        },
                        child: Text(
                          "Resend code",
                          style: AppTextStyles.inter(
                            color: const Color(0xFFFF5E5E),
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 48),

                // Next Button
                Obx(
                  () => Center(
                    child: CustomButton(
                      text: authController.isLoading.value
                          ? "Verifying..."
                          : "Next",
                      gradientColors: const [
                        AppColors.primarygredent2,
                        AppColors.primarygredent1,
                      ],
                      showIcon: !authController.isLoading.value,
                      isDisabled: authController.isLoading.value,
                      onTap: () {
                        authController.verifyOtp();
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
