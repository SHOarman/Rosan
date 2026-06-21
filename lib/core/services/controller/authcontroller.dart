import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rosannalie/core/route/app_pages.dart';

class Authcontroller extends GetxController {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController forgotPasswordEmailController = TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();
  
  //========================emailverifcarion ===========
  final List<TextEditingController> otpControllers = List.generate(6, (_) => TextEditingController());

  final RxBool isLoading = false.obs;
  final RxBool rememberMe = false.obs;
  final RxBool agreeToTerms = false.obs;

  void signIn(GlobalKey<FormState> formKey) {
    if (!formKey.currentState!.validate()) return;

    isLoading.value = true;
    
    // Simulate API call for login
    Future.delayed(const Duration(milliseconds: 1500), () {
      isLoading.value = false;
      Get.offAllNamed(AppRoutes.subscriptionPromotion);
    });
  }

  void sendForgotPasswordCode(GlobalKey<FormState> formKey) {
    if (!formKey.currentState!.validate()) return;

    isLoading.value = true;

    // Simulate API call to send reset code
    Future.delayed(const Duration(milliseconds: 1500), () {
      isLoading.value = false;
      Get.toNamed(AppRoutes.verificationcode);
      Get.snackbar(
        "Success",
        "Verification code sent to ${forgotPasswordEmailController.text} successfully!",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xff5E4B8B),
        colorText: Colors.white,
      );
    });
  }

  //========================emailverifcarion ===========
  void verifyOtp() {
    String otp = otpControllers.map((controller) => controller.text).join();
    if (otp.length < 6) {
      Get.snackbar(
        "Error",
        "Please enter the complete 6-digit code.",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    isLoading.value = true;
    Future.delayed(const Duration(milliseconds: 1500), () {
      isLoading.value = false;
      
      // Clear OTP controllers
      for (var controller in otpControllers) {
        controller.clear();
      }

      Get.toNamed(AppRoutes.resetpassword);
      Get.snackbar(
        "Success",
        "Email verified successfully!",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xff5E4B8B),
        colorText: Colors.white,
      );
    });
  }
//===========================resendotp_code====================================================

  void resendOtpCode() {
    isLoading.value = true;
    Future.delayed(const Duration(milliseconds: 1500), () {
      isLoading.value = false;
      Get.snackbar(
        "Code Resent",
        "A new verification code has been sent to your email.",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xff5E4B8B),
        colorText: Colors.white,
      );
    });
  }

  void createNewPassword(GlobalKey<FormState> formKey) {
    if (!formKey.currentState!.validate()) return;

    if (newPasswordController.text != confirmPasswordController.text) {
      Get.snackbar(
        "Error",
        "Passwords do not match",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    isLoading.value = true;
    Future.delayed(const Duration(milliseconds: 1500), () {
      isLoading.value = false;
      newPasswordController.clear();
      confirmPasswordController.clear();
      Get.offAllNamed(AppRoutes.resetsuccess);
      Get.snackbar(
        "Success",
        "Password changed successfully!",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xff5E4B8B),
        colorText: Colors.white,
      );
    });
  }
}