import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:rosannalie/core/route/app_pages.dart';
import 'package:rosannalie/core/services/controller/onboarding_controller.dart';
import 'package:rosannalie/core/services/api_services/apiservices.dart';

class Authcontroller extends GetxController {
  final TextEditingController nameController = TextEditingController();
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

  Future<void> registerUser() async {
    if (nameController.text.isEmpty || emailController.text.isEmpty || passwordController.text.isEmpty) {
      Get.snackbar("Error", "Please fill all fields", backgroundColor: Colors.red, colorText: Colors.white);
      return;
    }
    if (!agreeToTerms.value) {
      Get.snackbar("Error", "Please agree to terms and privacy", backgroundColor: Colors.red, colorText: Colors.white);
      return;
    }

    isLoading.value = true;
    final onboardingController = Get.isRegistered<OnboardingController>() 
        ? Get.find<OnboardingController>() 
        : Get.put(OnboardingController());

    try {
      final Map<String, dynamic> requestBody = {
        "name": nameController.text,
        "email": emailController.text,
        "password": passwordController.text,
        "onboarding": onboardingController.onboardingData,
      };
      
      print("===== REGISTER PAYLOAD =====");
      print(jsonEncode(requestBody));
      print("============================");

      final response = await http.post(
        Uri.parse(Apiservices.register),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(requestBody),
      );

      isLoading.value = false;
      if (response.statusCode == 201 || response.statusCode == 200) {
        Get.snackbar("Success", "Account created! Please verify your email.", backgroundColor: const Color(0xff5E4B8B), colorText: Colors.white);
        Get.toNamed(AppRoutes.verificationcode); // Assuming this is where OTP input is
      } else {
        String errorMsg = response.body;
        if (errorMsg.length > 100) errorMsg = "${errorMsg.substring(0, 100)}...";
        Get.snackbar("Error", "Failed to register. $errorMsg", backgroundColor: Colors.red, colorText: Colors.white);
      }
    } catch (e) {
      isLoading.value = false;
      Get.snackbar("Error", "An error occurred: $e", backgroundColor: Colors.red, colorText: Colors.white);
    }
  }

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
  Future<void> verifyOtp() async {
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
    
    try {
      final Map<String, dynamic> requestBody = {
        "email": emailController.text,
        "code": otp,
      };

      print("===== VERIFY OTP PAYLOAD =====");
      print(jsonEncode(requestBody));
      print("==============================");

      final response = await http.post(
        Uri.parse(Apiservices.verify_otp),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(requestBody),
      );

      isLoading.value = false;
      if (response.statusCode == 200 || response.statusCode == 201) {
        for (var controller in otpControllers) {
          controller.clear();
        }
        Get.toNamed(AppRoutes.resetpassword); // Change route if needed after verification
        Get.snackbar("Success", "Email verified successfully!", snackPosition: SnackPosition.BOTTOM, backgroundColor: const Color(0xff5E4B8B), colorText: Colors.white);
      } else {
        String errorMsg = response.body;
        if (errorMsg.length > 100) errorMsg = "${errorMsg.substring(0, 100)}...";
        Get.snackbar("Error", "Verification failed. $errorMsg", snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.red, colorText: Colors.white);
      }
    } catch (e) {
      isLoading.value = false;
      Get.snackbar("Error", "An error occurred: $e", snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.red, colorText: Colors.white);
    }
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