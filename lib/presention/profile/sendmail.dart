import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rosannalie/general_widget/custombutton.dart';
import 'package:rosannalie/utils/appString.dart';
import 'package:rosannalie/core/services/controller/support_controller.dart';
import 'package:rosannalie/core/route/app_pages.dart';

class SendMail extends StatelessWidget {
  SendMail({super.key});

  final TextEditingController _subjectController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _messageController = TextEditingController();
  final TextEditingController _categoryController = TextEditingController();
  final RxBool _isSubmitting = false.obs;

  InputDecoration _buildInputDecoration(String hintText) {
    return InputDecoration(
      hintText: hintText,
      hintStyle: AppTextStyles.inter(
        fontSize: 14,
        color: const Color(0xFF8F7DB5),
      ),
      fillColor: const Color(0xFFE6DCFA),
      filled: true,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 14.0),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.0),
        borderSide: const BorderSide(
          color: Color(0xFFC9B7EB),
          width: 1.0,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.0),
        borderSide: const BorderSide(
          color: Color(0xFF9B85CF),
          width: 1.5,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Custom Header Row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () => Get.back(),
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: const BoxDecoration(
                        color: Color(0xFFF1EFFF),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.arrow_back,
                        color: Color(0xFF5E4B8B),
                        size: 20,
                      ),
                    ),
                  ),
                  Text(
                    "Send Email",
                    style: AppTextStyles.plusJakartaSans(
                      fontSize: 18,
                      color: const Color(0xFF161022),
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(width: 40), // spacer to center the title
                ],
              ),
              const SizedBox(height: 24),

              // Category Input Section Card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: const Color(0xFFF9F7FD),
                  borderRadius: BorderRadius.circular(16.0),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Category",
                      style: AppTextStyles.inter(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF161022),
                      ),
                    ),
                    const SizedBox(height: 10.0),
                    TextFormField(
                      controller: _categoryController,
                      style: AppTextStyles.inter(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xFF161022),
                      ),
                      decoration: _buildInputDecoration("e.g. Bug Report, Feature Request"),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Subject Input Section Card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: const Color(0xFFF9F7FD),
                  borderRadius: BorderRadius.circular(16.0),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Subject",
                      style: AppTextStyles.inter(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF161022),
                      ),
                    ),
                    const SizedBox(height: 10.0),
                    TextFormField(
                      controller: _subjectController,
                      style: AppTextStyles.inter(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xFF161022),
                      ),
                      decoration: _buildInputDecoration("Short title of your issue or suggestion"),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Email Address Input Section Card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: const Color(0xFFF9F7FD),
                  borderRadius: BorderRadius.circular(16.0),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Email Address",
                      style: AppTextStyles.inter(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF161022),
                      ),
                    ),
                    const SizedBox(height: 10.0),
                    TextFormField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      style: AppTextStyles.inter(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xFF161022),
                      ),
                      decoration: _buildInputDecoration("Write your email"),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Message (Massage) Input Section Card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: const Color(0xFFF9F7FD),
                  borderRadius: BorderRadius.circular(16.0),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Message",
                      style: AppTextStyles.inter(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF161022),
                      ),
                    ),
                    const SizedBox(height: 10.0),
                        TextFormField(
                          controller: _messageController,
                          maxLines: 8,
                          style: AppTextStyles.inter(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: const Color(0xFF161022),
                          ),
                          decoration: _buildInputDecoration("Please explain what happened...").copyWith(
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16.0,
                              vertical: 14.0,
                            ),
                          ),
                        ),
                  ],
                ),
              ),
              const SizedBox(height: 60),

              // Submit Button
              Center(
                child: Obx(() => CustomButton(
                  text: _isSubmitting.value ? "Submitting..." : "Submit",
                  height: 52.0,
                  showIcon: !_isSubmitting.value,
                  onTap: () async {
                    if (_isSubmitting.value) return;

                    final subject = _subjectController.text.trim();
                    final email = _emailController.text.trim();
                    final message = _messageController.text.trim();

                    final category = _categoryController.text.trim();

                    if (subject.isEmpty || email.isEmpty || message.isEmpty || category.isEmpty) {
                      Get.snackbar(
                        "Error",
                        "Please fill in all fields",
                        snackPosition: SnackPosition.BOTTOM,
                        backgroundColor: const Color(0xFFFEE2E2),
                        colorText: const Color(0xFFEF4444),
                        margin: const EdgeInsets.all(20),
                        borderRadius: 12,
                      );
                      return;
                    }

                    _isSubmitting.value = true;

                    final supportController = Get.isRegistered<SupportController>() ? Get.find<SupportController>() : Get.put(SupportController());
                    final success = await supportController.createSupportTicket(
                      email: email,
                      subject: subject,
                      message: message,
                      category: category,
                    );

                    _isSubmitting.value = false;

                    if (success) {
                      Get.snackbar(
                        "Success",
                        "Support request sent successfully",
                        snackPosition: SnackPosition.BOTTOM,
                        backgroundColor: const Color(0xFFEFE8FF),
                        colorText: const Color(0xFF7B64B0),
                        margin: const EdgeInsets.all(20),
                        borderRadius: 12,
                        duration: const Duration(seconds: 2),
                      );
                      Future.delayed(const Duration(seconds: 2), () {
                        Get.offAllNamed(AppRoutes.home);
                      });
                    } else {
                      Get.snackbar(
                        "Error",
                        "Failed to send support request. Please try again.",
                        snackPosition: SnackPosition.BOTTOM,
                        backgroundColor: const Color(0xFFFEE2E2),
                        colorText: const Color(0xFFEF4444),
                        margin: const EdgeInsets.all(20),
                        borderRadius: 12,
                      );
                    }
                  },
                )),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
