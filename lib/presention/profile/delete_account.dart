import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:rosannalie/utils/appString.dart';
import 'package:rosannalie/core/route/app_pages.dart';

class DeleteAccountPage extends StatefulWidget {
  const DeleteAccountPage({super.key});

  @override
  State<DeleteAccountPage> createState() => _DeleteAccountPageState();
}

class _DeleteAccountPageState extends State<DeleteAccountPage> {
  final TextEditingController _confirmController = TextEditingController();
  bool _canDelete = false;

  @override
  void dispose() {
    _confirmController.dispose();
    super.dispose();
  }

  Widget _buildLostItem(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 2.0),
            padding: const EdgeInsets.all(2.0),
            decoration: const BoxDecoration(
              color: Color(0xFFFFF1F1),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.close_rounded,
              color: Color(0xFFEF4444),
              size: 12.0,
            ),
          ),
          const SizedBox(width: 8.0),
          Expanded(
            child: Text(
              text,
              style: AppTextStyles.inter(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: const Color(0xFFEF4444),
              ),
            ),
          ),
        ],
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
                    "Delete Account",
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

              // Circular warning exclamation mark icon in center
              Center(
                child: Container(
                  width: 80.0,
                  height: 80.0,
                  decoration: const BoxDecoration(
                    color: Color(0xFFFFF1F1),
                    shape: BoxShape.circle,
                  ),
                  alignment: Alignment.center,
                  child: SvgPicture.asset(
                    "assets/images/underscero.svg",
                    width: 8.0,
                    height: 27.0,
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Title "This action cannot be undone"
              Center(
                child: Text(
                  "This action cannot be undone",
                  textAlign: TextAlign.center,
                  style: AppTextStyles.plusJakartaSans(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF161022),
                  ),
                ),
              ),
              const SizedBox(height: 8.0),

              // Subtext warning
              Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: Text(
                    "Deleting your Rise account will permanently remove your personal data, goals, progress history, gratitude journal entries, achievements, and AI coaching history.",
                    textAlign: TextAlign.center,
                    style: AppTextStyles.inter(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: const Color(0xFF8F7DB5),
                    ).copyWith(height: 1.4),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Warning "You will lose" list box card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF5F5),
                  borderRadius: BorderRadius.circular(16.0),
                  border: Border.all(
                    color: const Color(0xFFFEE2E2),
                    width: 1.0,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "You will lose:",
                      style: AppTextStyles.inter(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFFEF4444),
                      ),
                    ),
                    const SizedBox(height: 10.0),
                    _buildLostItem("All goals and progress tracking"),
                    _buildLostItem("Task history and completed achievements"),
                    _buildLostItem("Gratitude journal entries"),
                    _buildLostItem("AI Coach personalized insights"),
                    _buildLostItem("Streaks, badges, and milestone records"),
                    _buildLostItem("Premium subscription preferences"),
                    _buildLostItem("Personal growth statistics"),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Type DELETE to confirm label
              Text.rich(
                TextSpan(
                  text: "Type ",
                  style: AppTextStyles.inter(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF64748B),
                  ),
                  children: [
                    const TextSpan(
                      text: "DELETE",
                      style: TextStyle(
                        color: Color(0xFFEF4444),
                      ),
                    ),
                    const TextSpan(
                      text: " to confirm",
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8.0),

              TextFormField(
                controller: _confirmController,
                onChanged: (value) {
                  setState(() {
                    _canDelete = value == "DELETE";
                  });
                },
                style: AppTextStyles.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF161022),
                ).copyWith(letterSpacing: 1.5),
                decoration: InputDecoration(
                  hintText: "DELETE",
                  hintStyle: AppTextStyles.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF8F7DB5).withOpacity(0.5),
                  ).copyWith(letterSpacing: 1.5),
                  fillColor: Colors.white,
                  filled: true,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 14.0,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                    borderSide: const BorderSide(
                      color: Color(0xFFE2E8F0),
                      width: 1.0,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                    borderSide: const BorderSide(
                      color: Color(0xFFEF4444),
                      width: 1.5,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 32),

              // Delete Button (permanently delete account)
              SizedBox(
                width: double.infinity,
                height: 52.0,
                child: ElevatedButton(
                  onPressed: _canDelete
                      ? () {
                          print("Account Permanently Deleted");
                          Get.snackbar(
                            "Account Deleted",
                            "Your account has been deleted successfully",
                            snackPosition: SnackPosition.BOTTOM,
                            backgroundColor: const Color(0xFFFEE2E2),
                            colorText: const Color(0xFFEF4444),
                            margin: const EdgeInsets.all(20),
                            borderRadius: 12,
                          );
                          Future.delayed(const Duration(seconds: 2), () {
                            Get.offAllNamed(AppRoutes.singin);
                          });
                        }
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFEF4444),
                    disabledBackgroundColor: const Color(
                      0xFFEF4444,
                    ).withOpacity(0.5),
                    foregroundColor: Colors.white,
                    disabledForegroundColor: Colors.white.withOpacity(0.8),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16.0),
                    ),
                  ),
                  child: Text(
                    "Permanently Delete Account",
                    style: AppTextStyles.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),

              // Keep My Account Button (Cancel action)
              SizedBox(
                width: double.infinity,
                height: 52.0,
                child: OutlinedButton(
                  onPressed: () => Get.back(),
                  style: OutlinedButton.styleFrom(
                    backgroundColor: Colors.white,
                    side: const BorderSide(
                      color: Color(0xFFC5B8E8),
                      width: 1.0,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16.0),
                    ),
                  ),
                  child: Text(
                    "Keep My Account",
                    style: AppTextStyles.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF5E4B8B),
                    ),
                  ),
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
