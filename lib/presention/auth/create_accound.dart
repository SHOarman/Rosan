import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:rosannalie/core/route/app_pages.dart';
import 'package:rosannalie/core/services/controller/authcontroller.dart';
import 'package:rosannalie/presention/auth/widget/customtextfeild.dart';
import 'package:rosannalie/utils/appString.dart';
import 'package:rosannalie/utils/appcolors.dart';
import '../../general_widget/custombutton.dart';

class CreateAccound extends StatelessWidget {
  const CreateAccound({super.key});

  @override
  Widget build(BuildContext context) {
    final authController = Get.find<Authcontroller>();

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const SizedBox(height: 40),

                Text(
                  "Register Account",
                  style: AppTextStyles.poppins(
                    color: AppColors.primarygredent1,
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                  ),
                ),

                const SizedBox(height: 8),
                Text(
                  "Sign Up with your name, email and setup password\nor social media to continue",
                  style: AppTextStyles.inter(
                    color: const Color(0xff647276),
                    fontWeight: FontWeight.w400,
                    fontSize: 13,
                  ),
                ),

                const SizedBox(height: 32),
                
                const CustomTextField(
                  labelText: "Full Name",
                  hintText: "Full Name",
                ),
                const SizedBox(height: 8),
                const CustomTextField(
                  labelText: "Email",
                  hintText: "Enter your e-mail",
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 8),
                const CustomTextField(
                  labelText: "Password",
                  hintText: "********",
                  isPassword: true,
                ),
                const SizedBox(height: 8),
                const CustomTextField(
                  labelText: "Confirm Password",
                  hintText: "********",
                  isPassword: true,
                ),
                const SizedBox(height: 16),

                // Agree with terms and privacy checkbox Row
                Obx(
                  () => GestureDetector(
                    onTap: () {
                      authController.agreeToTerms.value =
                          !authController.agreeToTerms.value;
                    },
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 18,
                          height: 18,
                          decoration: BoxDecoration(
                            color: authController.agreeToTerms.value
                                ? const Color(0xFF1B1233)
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(4),
                            border: Border.all(
                              color: authController.agreeToTerms.value
                                  ? const Color(0xFF1B1233)
                                  : const Color(0xFFC5B8E8),
                              width: 1.5,
                            ),
                          ),
                          child: authController.agreeToTerms.value
                              ? const Icon(
                                  Icons.check,
                                  color: Colors.white,
                                  size: 12,
                                )
                              : null,
                        ),
                        const SizedBox(width: 10),
                        Text.rich(
                          TextSpan(
                            text: "Agree with ",
                            style: AppTextStyles.inter(
                              fontSize: 14,
                              color: const Color(0xFF2E2252),
                              fontWeight: FontWeight.w500,
                            ),
                            children: [
                              TextSpan(
                                text: "terms",
                                style: AppTextStyles.inter(
                                  fontSize: 14,
                                  color: const Color(0xFF2E2252),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              TextSpan(
                                text: " and ",
                                style: AppTextStyles.inter(
                                  fontSize: 14,
                                  color: const Color(0xFF2E2252),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              TextSpan(
                                text: "privacy",
                                style: AppTextStyles.inter(
                                  fontSize: 14,
                                  color: const Color(0xFF2E2252),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 32),
                
                Center(
                  child: CustomButton(
                    text: "Sign Up",
                    gradientColors: const [
                      AppColors.primarygredent2,
                      AppColors.primarygredent1,
                    ],
                    onTap: () {
                      Get.toNamed(AppRoutes.singin);

                    },
                  ),
                ),
                const SizedBox(height: 30),

                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () {},
                      child: Container(
                        width: 56,
                        height: 56,
                        decoration: const BoxDecoration(
                          color: Color(0xFFECE9F4),
                          shape: BoxShape.circle,
                        ),
                        alignment: Alignment.center,
                        child: SvgPicture.asset(
                          "assets/icon/google (1) 1.svg",
                          width: 28,
                          height: 28,
                        ),
                      ),
                    ),
                    const SizedBox(width: 14),
                    GestureDetector(
                      onTap: () {},
                      child: Container(
                        width: 56,
                        height: 56,
                        decoration: const BoxDecoration(
                          color: Color(0xFFECE9F4),
                          shape: BoxShape.circle,
                        ),
                        alignment: Alignment.center,
                        child: SvgPicture.asset(
                          "assets/icon/Vector (1).svg",
                          width: 24,
                          height: 24,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 30),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Already have an account?  ",
                      style: AppTextStyles.inter(
                        fontSize: 14,
                        color: const Color(0xFF2E2252),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Get.toNamed(AppRoutes.singin);
                      },
                      child: Text(
                        "Sign in",
                        style: AppTextStyles.inter(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          gradientColors: const [
                            AppColors.primarygredent2,
                            AppColors.primarygredent1,
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
