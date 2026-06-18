import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rosannalie/general_widget/custombutton.dart';
import 'package:rosannalie/utils/appString.dart';

class SendMail extends StatefulWidget {
  const SendMail({super.key});

  @override
  State<SendMail> createState() => _SendMailState();
}

class _SendMailState extends State<SendMail> {
  final TextEditingController _subjectController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _messageController = TextEditingController();

  @override
  void dispose() {
    _subjectController.dispose();
    _emailController.dispose();
    _messageController.dispose();
    super.dispose();
  }

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
                    Stack(
                      children: [
                        TextFormField(
                          controller: _messageController,
                          maxLines: 8,
                          style: AppTextStyles.inter(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: const Color(0xFF161022),
                          ),
                          decoration: _buildInputDecoration("Please explain what happened...").copyWith(
                            contentPadding: const EdgeInsets.only(
                              left: 16.0,
                              right: 16.0,
                              top: 14.0,
                              bottom: 70.0, // extra bottom padding for the attach button
                            ),
                          ),
                        ),
                        // Plus/Attachment button on bottom left of field
                        Positioned(
                          left: 12.0,
                          bottom: 12.0,
                          child: InkWell(
                            onTap: () {
                              print("Attach file clicked");
                              Get.snackbar(
                                "Attachment",
                                "File selector opened",
                                snackPosition: SnackPosition.BOTTOM,
                                backgroundColor: const Color(0xFFEFE8FF),
                                colorText: const Color(0xFF7B64B0),
                                margin: const EdgeInsets.all(20),
                                borderRadius: 12,
                              );
                            },
                            borderRadius: BorderRadius.circular(10.0),
                            child: Container(
                              width: 44.0,
                              height: 44.0,
                              decoration: BoxDecoration(
                                color: const Color(0xFFE6DCFA),
                                borderRadius: BorderRadius.circular(10.0),
                                border: Border.all(
                                  color: const Color(0xFFC9B7EB),
                                  width: 1.0,
                                ),
                              ),
                              alignment: Alignment.center,
                              child: const Icon(
                                Icons.add,
                                color: Color(0xFF7B64B0),
                                size: 22.0,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 60),

              // Submit Button
              Center(
                child: CustomButton(
                  text: "Submit",
                  height: 52.0,
                  showIcon: true,
                  onTap: () {
                    print("Submit Support Email. Subject: ${_subjectController.text}, Email: ${_emailController.text}");
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
                      Get.back();
                    });
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
