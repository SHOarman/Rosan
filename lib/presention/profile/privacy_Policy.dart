import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rosannalie/utils/appString.dart';

class PrivacyPolicyPage extends StatelessWidget {
  const PrivacyPolicyPage({super.key});

  Widget _buildSectionCard({
    required String title,
    required String content,
    List<String>? bulletPoints,
    String? footerText,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.0),
        border: Border.all(
          color: const Color(0xFFF1EFFF),
          width: 1.0,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF6C586D).withOpacity(0.04),
            blurRadius: 20.0,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: AppTextStyles.plusJakartaSans(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF161022),
            ),
          ),
          const SizedBox(height: 12.0),
          if (content.isNotEmpty)
            Text(
              content,
              style: AppTextStyles.inter(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: const Color(0xFF575B61),
              ).copyWith(height: 1.5),
            ),
          if (bulletPoints != null && bulletPoints.isNotEmpty) ...[
            if (content.isNotEmpty) const SizedBox(height: 8.0),
            ...bulletPoints.map((point) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "• ",
                        style: AppTextStyles.inter(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF7B64B0),
                        ),
                      ),
                      Expanded(
                        child: Text(
                          point,
                          style: AppTextStyles.inter(
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            color: const Color(0xFF575B61),
                          ).copyWith(height: 1.5),
                        ),
                      ),
                    ],
                  ),
                )),
          ],
          if (footerText != null && footerText.isNotEmpty) ...[
            const SizedBox(height: 10.0),
            Text(
              footerText,
              style: AppTextStyles.inter(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: const Color(0xFF575B61),
              ).copyWith(height: 1.5),
            ),
          ],
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFBFBFF),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Row
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
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
                  const SizedBox(width: 16.0),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Privacy Policy",
                          style: AppTextStyles.plusJakartaSans(
                            fontSize: 18,
                            color: const Color(0xFF161022),
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(height: 2.0),
                        Text(
                          "Last updated: 1 January 2026",
                          style: AppTextStyles.inter(
                            fontSize: 12,
                            color: const Color(0xFF8F7DB5),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24.0),

              // Section 1
              _buildSectionCard(
                title: "1. Introduction",
                content: "At Rise, your privacy matters. This Privacy Policy explains how we collect, use, store, and protect your information while helping you achieve your goals, build positive habits, and stay motivated through personalized AI coaching.",
              ),
              const SizedBox(height: 16.0),

              // Section 2
              _buildSectionCard(
                title: "2. Information We Collect",
                content: "We may collect:",
                bulletPoints: [
                  "Account information (name, email address, profile details)",
                  "Goals, tasks, habits, and progress data",
                  "Gratitude journal entries and reflections",
                  "AI Coach conversations and interactions",
                  "App usage analytics and engagement data",
                  "Device information for app performance and security",
                  "Subscription and billing information (processed securely through trusted payment providers)"
                ],
              ),
              const SizedBox(height: 16.0),

              // Section 3
              _buildSectionCard(
                title: "3. How We Use Your Data",
                content: "We use your information to:",
                bulletPoints: [
                  "Personalize your Rise experience",
                  "Deliver AI-powered coaching and recommendations",
                  "Track goals, habits, and achievements",
                  "Send motivational reminders and notifications",
                  "Improve app performance and user experience",
                  "Provide customer support",
                  "Process subscriptions and payments"
                ],
              ),
              const SizedBox(height: 16.0),

              // Section 4
              _buildSectionCard(
                title: "4. Personalized AI Experience",
                content: "Rise uses AI to provide personalized guidance based on your goals, habits, preferences, and interactions. Your AI Coach learns from your activity to deliver more relevant motivation, encouragement, and productivity support over time.",
              ),
              const SizedBox(height: 16.0),

              // Section 5
              _buildSectionCard(
                title: "5. Data Security",
                content: "We protect your data using industry-standard security measures, including encryption, secure cloud storage, and access controls. Your personal information is never sold to third parties.",
              ),
              const SizedBox(height: 16.0),

              // Section 6
              _buildSectionCard(
                title: "6. Data Retention",
                content: "Your data remains available as long as your account is active. If you delete your account, personal information, goals, journal entries, and AI conversations will be permanently removed within a reasonable period unless legally required otherwise.",
              ),
              const SizedBox(height: 16.0),

              // Section 7
              _buildSectionCard(
                title: "7. Your Rights",
                content: "You have the right to:",
                bulletPoints: [
                  "Access your personal data",
                  "Update or correct information",
                  "Export your data",
                  "Delete your account and associated information",
                  "Control notification preferences",
                  "Manage AI personalization settings"
                ],
              ),
              const SizedBox(height: 16.0),

              // Section 8
              _buildSectionCard(
                title: "8. Notifications & Reminders",
                content: "Rise may send:",
                bulletPoints: [
                  "Goal reminders",
                  "Daily motivation messages",
                  "Habit tracking notifications",
                  "Achievement celebrations",
                  "Personalized AI Coach recommendations"
                ],
                footerText: "You can manage these preferences anytime from Settings.",
              ),
              const SizedBox(height: 16.0),

              // Section 9
              _buildSectionCard(
                title: "9. Third-Party Services",
                content: "Rise may use trusted service providers for:",
                bulletPoints: [
                  "Cloud hosting",
                  "Analytics",
                  "Authentication",
                  "Subscription payments"
                ],
                footerText: "These providers are required to maintain appropriate security standards.",
              ),
              const SizedBox(height: 16.0),

              // Section 10
              _buildSectionCard(
                title: "10. Changes to This Policy",
                content: "We may occasionally update this Privacy Policy. If significant changes occur, we will notify you through the app or via email.",
              ),
              const SizedBox(height: 16.0),

              // Contact Us Card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20.0),
                  border: Border.all(
                    color: const Color(0xFFF1EFFF),
                    width: 1.0,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF6C586D).withOpacity(0.04),
                      blurRadius: 20.0,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Contact Us",
                      style: AppTextStyles.plusJakartaSans(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF161022),
                      ),
                    ),
                    const SizedBox(height: 8.0),
                    Text(
                      "support@riseapp.com",
                      style: AppTextStyles.inter(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF7B64B0),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40.0),
            ],
          ),
        ),
      ),
    );
  }
}
