import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:rosannalie/core/route/app_pages.dart';
import 'package:rosannalie/core/services/controller/authcontroller.dart';
import 'package:rosannalie/general_widget/custombutton.dart';
import 'package:rosannalie/presention/auth/widget/customtextfeild.dart';
import 'package:rosannalie/utils/appString.dart';
import 'package:rosannalie/utils/appcolors.dart';

class SigninScreen extends StatefulWidget {
  const SigninScreen({super.key});

  @override
  State<SigninScreen> createState() => _SigninScreenState();
}

class _SigninScreenState extends State<SigninScreen> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final authController = Get.find<Authcontroller>();
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 60),
                  Text(
                    "Welcome Back !",
                    style: AppTextStyles.poppins(
                      fontSize: 28,
                      color: const Color(0xff5E4B8B),
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Sign in with your email and password\nto continue",
                    style: AppTextStyles.inter(
                      color: const Color(0xff647276),
                      fontWeight: FontWeight.w400,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 40),
                  CustomTextField(
                    controller: authController.emailController,
                    labelText: "Email",
                    hintText: "Enter your email",
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please enter your email";
                      }
                      if (!RegExp("").hasMatch(value)) {
                        return "Please enter a valid email address";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 24),
                  CustomTextField(
                    controller: authController.passwordController,
                    labelText: "Password",
                    hintText: "Enter your password",
                    isPassword: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please enter your password";
                      }
                      if (value.length < 6) {
                        return "Password must be at least 6 characters";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Obx(
                        () => GestureDetector(
                          onTap: () {
                            authController.rememberMe.value =
                                !authController.rememberMe.value;
                          },
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                width: 18,
                                height: 18,
                                decoration: BoxDecoration(
                                  color: authController.rememberMe.value
                                      ? const Color(0xFF5E4B8B)
                                      : Colors.transparent,
                                  borderRadius: BorderRadius.circular(4),
                                  border: Border.all(
                                    color: authController.rememberMe.value
                                        ? const Color(0xFF5E4B8B)
                                        : const Color(0xFFC5B8E8),
                                    width: 1.5,
                                  ),
                                ),
                                child: authController.rememberMe.value
                                    ? const Icon(
                                        Icons.check,
                                        color: Colors.white,
                                        size: 12,
                                      )
                                    : null,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                "Remember me",
                                style: AppTextStyles.inter(
                                  fontSize: 14,
                                  color: const Color(0xFF2E2252),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Get.toNamed(AppRoutes.forgotpassword);
                        },
                        child: Text(
                          "Forgot password ?",
                          style: AppTextStyles.inter(
                            fontSize: 14,
                            color: const Color(0xFF2E2252),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 35),

                  Obx(
                    () => Center(
                      child: CustomButton(
                        text: authController.isLoading.value
                            ? "Signing In..."
                            : "Continue",
                        showIcon: !authController.isLoading.value,
                        isDisabled: authController.isLoading.value,
                        gradientColors: const [
                          AppColors.primarygredent2,
                          AppColors.primarygredent1,
                        ],
                        onTap: () {
                          authController.signIn(_formKey);
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  Center(
                    child: Text(
                      "Or ",
                      style: AppTextStyles.inter(
                        gradientColors: const [
                          AppColors.primarygredent2,
                          AppColors.primarygredent1,
                        ],
                        fontSize: 14,
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

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

                  SizedBox(height: 30),

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
                          Get.toNamed(AppRoutes.createaccount);
                        },
                        child: Text(
                          "Sign Up",
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
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
