import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Authcontroller extends GetxController {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  final RxBool isLoading = false.obs;

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }

  void signIn(GlobalKey<FormState> formKey) {
    if (!formKey.currentState!.validate()) return;

    isLoading.value = true;
    
    // Simulate API call for login
    Future.delayed(const Duration(seconds: 1500), () {
      isLoading.value = false;
      Get.snackbar(
        "Success",
        "Logged in successfully!",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xff5E4B8B),
        colorText: Colors.white,
      );
    });
  }
}