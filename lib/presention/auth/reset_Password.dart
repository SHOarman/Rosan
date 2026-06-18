import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rosannalie/core/services/controller/authcontroller.dart';
import 'package:rosannalie/general_widget/custombutton.dart';
import 'package:rosannalie/presention/auth/widget/customtextfeild.dart';
import 'package:rosannalie/utils/appString.dart';
import 'package:rosannalie/utils/appcolors.dart';

class ResetPassword extends StatefulWidget {
  const ResetPassword({super.key});

  @override
  State<ResetPassword> createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  final _formKey = GlobalKey<FormState>();

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
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  Text(
                    "Create New Password",
                    style: AppTextStyles.poppins(
                      color: AppColors.primarygredent1,
                      fontSize: 25,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Please enter a new password to change",
                    style: AppTextStyles.inter(
                      color: const Color(0xff647276),
                      fontSize: 13,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  const SizedBox(height: 32),
                  CustomTextField(
                    controller: authController.newPasswordController,
                    labelText: "New Password",
                    hintText: "••••••••",
                    isPassword: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please enter your password";
                      }
                      if (value.length < 8) {
                        return "Password must be at least 8 characters long";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  CustomTextField(
                    controller: authController.confirmPasswordController,
                    labelText: "Confirm Password",
                    hintText: "••••••••",
                    isPassword: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please confirm your password";
                      }
                      if (value != authController.newPasswordController.text) {
                        return "Passwords do not match";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 48),
                  Obx(
                    () => Center(
                      child: CustomButton(
                        text: authController.isLoading.value
                            ? "Changing Password..."
                            : "Create new Password",
                        gradientColors: const [
                          AppColors.primarygredent2,
                          AppColors.primarygredent1,
                        ],
                        showIcon: !authController.isLoading.value,
                        isDisabled: authController.isLoading.value,
                        onTap: () {
                          authController.createNewPassword(_formKey);
                        },
                      ),
                    ),
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
