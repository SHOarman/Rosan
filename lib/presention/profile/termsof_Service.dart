import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rosannalie/utils/appString.dart';

class TermsOfServicePage extends StatelessWidget {
  const TermsOfServicePage({super.key});

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
                          "Terms of Service",
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
                title: "1. Acceptance of Terms",
                content: "By downloading, accessing, or using Rise (\"the App\"), you agree to these Terms of Service. If you do not agree with these terms, please discontinue use of the App.",
              ),
              const SizedBox(height: 16.0),

              // Section 2
              _buildSectionCard(
                title: "2. About Rise",
                content: "Rise is a personal growth and productivity platform designed to help users:",
                bulletPoints: [
                  "Set meaningful goals",
                  "Build positive habits",
                  "Track daily progress",
                  "Practice gratitude",
                  "Stay motivated through AI-powered coaching",
                  "Celebrate personal achievements"
                ],
                footerText: "Rise is intended for personal development and self-improvement purposes only.",
              ),
              const SizedBox(height: 16.0),

              // Section 3
              _buildSectionCard(
                title: "3. Eligibility",
                content: "You must be at least 13 years old to use Rise. If you are under the age required by your local laws, parental or guardian consent may be necessary.",
              ),
              const SizedBox(height: 16.0),

              // Section 4
              _buildSectionCard(
                title: "4. User Accounts",
                content: "To access certain features, you may need to create an account. You are responsible for:",
                bulletPoints: [
                  "Keeping your login credentials secure",
                  "Maintaining accurate account information",
                  "All activity that occurs under your account"
                ],
                footerText: "Please notify us immediately if you believe your account has been compromised.",
              ),
              const SizedBox(height: 16.0),

              // Section 5
              _buildSectionCard(
                title: "5. AI Coach Disclaimer",
                content: "Rise includes AI-powered coaching and motivational guidance. The AI Coach is intended to provide encouragement, productivity support, habit-building suggestions, and personal development insights. AI responses should not be considered professional medical, psychological, legal, or financial advice. Users remain responsible for their own decisions and actions.",
              ),
              const SizedBox(height: 16.0),

              // Section 6
              _buildSectionCard(
                title: "6. Subscription & Premium Features",
                content: "Rise may offer free and premium subscription plans. Premium features may include:",
                bulletPoints: [
                  "Unlimited AI Coach conversations",
                  "Advanced goal tracking",
                  "Enhanced productivity insights",
                  "Personalized coaching experiences",
                  "Additional motivational content"
                ],
                footerText: "Subscription fees are billed according to the selected plan.",
              ),
              const SizedBox(height: 16.0),

              // Section 7
              _buildSectionCard(
                title: "7. Cancellation & Billing",
                content: "You may cancel your subscription at any time through your device's app store or account settings. Premium access remains available until the end of the active billing period. Refunds are subject to the policies of the platform through which the purchase was made.",
              ),
              const SizedBox(height: 16.0),

              // Section 8
              _buildSectionCard(
                title: "8. User Responsibilities",
                content: "You agree to use Rise responsibly and respectfully. You may not:",
                bulletPoints: [
                  "Attempt to disrupt the service",
                  "Abuse AI features",
                  "Access accounts belonging to others",
                  "Upload harmful or malicious content",
                  "Use the platform for unlawful activities"
                ],
                footerText: "Violation of these rules may result in account suspension or termination.",
              ),
              const SizedBox(height: 16.0),

              // Section 9
              _buildSectionCard(
                title: "9. Intellectual Property",
                content: "All content, branding, designs, graphics, AI experiences, and software within Rise are protected by intellectual property laws. You may not copy, modify, distribute, or reproduce any part of the App without written permission.",
              ),
              const SizedBox(height: 16.0),

              // Section 10
              _buildSectionCard(
                title: "10. Limitation of Liability",
                content: "Rise is provided \"as is.\" While we strive to offer reliable services, we cannot guarantee uninterrupted availability or specific personal outcomes. We are not responsible for losses resulting from the use or inability to use the App.",
              ),
              const SizedBox(height: 16.0),

              // Section 11
              _buildSectionCard(
                title: "11. Changes to These Terms",
                content: "We may update these Terms of Service periodically. When significant changes occur, we will notify users through the App or via email. Continued use of Rise after updates indicates acceptance of the revised terms.",
              ),
              const SizedBox(height: 16.0),

              // Section 12 / Contact Card
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
                      "12. Contact",
                      style: AppTextStyles.plusJakartaSans(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF161022),
                      ),
                    ),
                    const SizedBox(height: 12.0),
                    Text(
                      "If you have questions regarding these Terms, please contact us: support@riseapp.com or www.riseapp.com",
                      style: AppTextStyles.inter(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xFF575B61),
                      ).copyWith(height: 1.5),
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
