import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:rosannalie/general_widget/custombutton.dart';
import 'package:rosannalie/utils/appString.dart';
import 'package:rosannalie/core/route/app_pages.dart';

class HelpCenter extends StatefulWidget {
  const HelpCenter({super.key});

  @override
  State<HelpCenter> createState() => _HelpCenterState();
}

class _HelpCenterState extends State<HelpCenter> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = "";

  // Index of the expanded FAQ item (-1 means none)
  int _expandedIndex = 0;

  final List<Map<String, String>> _allFaqs = [
    {
      "question": "How does Rise help me stay motivated?",
      "answer": "Rise uses personalized AI coaching, goal tracking, daily encouragement, and progress insights to help you stay focused and motivated."
    },
    {
      "question": "What is the Rise AI Coach?",
      "answer": "Rise AI Coach is your personal guide that analyzes your habits, streaks, and wins to provide actionable tips and mental models for success."
    },
    {
      "question": "How do I create and track goals?",
      "answer": "Navigate to the Goals tab or tap 'See All' under My Goals on the home screen to create new goals and follow your progress."
    },
    {
      "question": "What are Daily Wins?",
      "answer": "Daily Wins represent major or minor milestones you achieve each day. Tracking wins reinforces positive habit loops."
    },
    {
      "question": "How does the Gratitude Journal work?",
      "answer": "Write down three things you are grateful for each day. This simple practice helps rewire your brain for positivity."
    },
    {
      "question": "Can I customize my daily reminders?",
      "answer": "Yes, you can customize notifications frequency and times in settings to match your daily routine."
    },
    {
      "question": "How are streaks and achievements earned?",
      "answer": "Complete your daily tasks consistently to maintain your streak. Reaching milestones unlocks achievements."
    },
    {
      "question": "Is my personal data private and secure?",
      "answer": "Your personal data is fully encrypted and stored securely. We do not sell your personal data to third parties."
    },
    {
      "question": "What features are included in Rise Premium?",
      "answer": "Rise Premium unlocks unlimited goals, advanced AI coach personalization, detailed analytics, and custom themes."
    },
    {
      "question": "How can I contact the Rise support team?",
      "answer": "You can reach our support team by tapping the 'Contact Support' button below or emailing support@riseapp.com."
    },
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }



  @override
  Widget build(BuildContext context) {
    // Filter FAQs based on query
    final filteredFaqs = _allFaqs.where((faq) {
      final question = faq["question"]!.toLowerCase();
      final answer = faq["answer"]!.toLowerCase();
      final query = _searchQuery.toLowerCase();
      return question.contains(query) || answer.contains(query);
    }).toList();

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Custom Header Row with Subtitle in Column
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
                          "Help Center",
                          style: AppTextStyles.plusJakartaSans(
                            fontSize: 18,
                            color: const Color(0xFF161022),
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(height: 2.0),
                        Text(
                          "Answers & support",
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
              const SizedBox(height: 24),

              // Banner Block
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20.0),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF8F7DB5), Color(0xFF7B64B0)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(20.0),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "How can we help you?",
                      style: AppTextStyles.plusJakartaSans(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 6.0),
                    Text(
                      "Find answers to common questions below.",
                      style: AppTextStyles.inter(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: Colors.white.withOpacity(0.9),
                      ),
                    ),
                    const SizedBox(height: 16.0),
                    // Search bar
                    Container(
                      height: 48.0,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(24.0),
                      ),
                      child: TextField(
                        controller: _searchController,
                        onChanged: (val) {
                          setState(() {
                            _searchQuery = val;
                          });
                        },
                        style: AppTextStyles.inter(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: const Color(0xFF161022),
                        ),
                        decoration: InputDecoration(
                          hintText: "Search for a topic...",
                          hintStyle: AppTextStyles.inter(
                            fontSize: 14,
                            color: const Color(0xFF8F7DB5),
                          ),
                          prefixIcon: const Icon(
                            Icons.search_rounded,
                            color: Color(0xFF8F7DB5),
                          ),
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(vertical: 14.0),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 28),

              // FREQUENTLY ASKED QUESTIONS header
              Text(
                "FREQUENTLY ASKED QUESTIONS",
                style: AppTextStyles.inter(
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                  color: const Color(0xFF161022),
                ).copyWith(letterSpacing: 0.5),
              ),
              const SizedBox(height: 16),

              // FAQs List
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: filteredFaqs.length,
                separatorBuilder: (context, index) => const SizedBox(height: 12.0),
                itemBuilder: (context, index) {
                  final faq = filteredFaqs[index];
                  // Find exact index in _allFaqs to match expansion state correctly
                  final originalIndex = _allFaqs.indexOf(faq);
                  final isExpanded = _expandedIndex == originalIndex;

                  return Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16.0),
                      border: Border.all(
                        color: const Color(0xFFF1EFFF),
                        width: 1.0,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF6C586D).withOpacity(0.03),
                          blurRadius: 16.0,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Material(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.circular(16.0),
                      clipBehavior: Clip.antiAlias,
                      child: Theme(
                        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
                        child: ExpansionTile(
                          key: ValueKey(faq["question"]),
                          initiallyExpanded: isExpanded,
                          onExpansionChanged: (expanded) {
                            setState(() {
                              _expandedIndex = expanded ? originalIndex : -1;
                            });
                          },
                          title: Text(
                            faq["question"]!,
                            style: AppTextStyles.inter(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFF161022),
                            ),
                          ),
                          trailing: Container(
                            width: 28.0,
                            height: 28.0,
                            decoration: BoxDecoration(
                              color: isExpanded ? const Color(0xFFF1EFFF) : const Color(0xFFF6F5FB),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              isExpanded ? Icons.close : Icons.add,
                              color: const Color(0xFF7B64B0),
                              size: 16.0,
                            ),
                          ),
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 16.0),
                              child: Text(
                                faq["answer"]!,
                                style: AppTextStyles.inter(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                  color: const Color(0xFF575B61),
                                ).copyWith(height: 1.4),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 28),

              // Still Need Help Card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24.0),
                  border: Border.all(
                    color: const Color(0xFFF1EFFF),
                    width: 1.0,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF6C586D).withOpacity(0.04),
                      blurRadius: 24.0,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    // Help Icon circle
                    Container(
                      width: 44.0,
                      height: 44.0,
                      decoration: const BoxDecoration(
                        color: Color(0xFFF1EFFF),
                        shape: BoxShape.circle,
                      ),
                      alignment: Alignment.center,
                      child: SvgPicture.asset(
                        "assets/images/Icon (4).svg",
                        colorFilter: const ColorFilter.mode(
                          Color(0xFF7B64B0),
                          BlendMode.srcIn,
                        ),
                        width: 20.0,
                        height: 20.0,
                      ),
                    ),
                    const SizedBox(height: 16.0),
                    Text(
                      "Still need help?",
                      style: AppTextStyles.plusJakartaSans(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF161022),
                      ),
                    ),
                    const SizedBox(height: 6.0),
                    Text(
                      "Our support team is available Monday–Friday, 9:00–17:00 CET.",
                      textAlign: TextAlign.center,
                      style: AppTextStyles.inter(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xFF8F7DB5),
                      ).copyWith(height: 1.4),
                    ),
                    const SizedBox(height: 20.0),
                    CustomButton(
                      text: "Contact Support",
                      height: 48.0,
                      onTap: () {
                        print("Contact Support Clicked, navigating to SendMail");
                        Get.toNamed(AppRoutes.sendmail);
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Delete Account Button card
              Container(
                width: double.infinity,
                height: 60.0,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16.0),
                  border: Border.all(
                    color: const Color(0xFFFEE2E2),
                    width: 1.0,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFFEF4444).withOpacity(0.02),
                      blurRadius: 16.0,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () => Get.toNamed(AppRoutes.deleteaccount),
                    borderRadius: BorderRadius.circular(16.0),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Delete Account",
                            style: AppTextStyles.inter(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFFEF4444),
                            ),
                          ),
                          const Icon(
                            Icons.delete_outline_rounded,
                            color: Color(0xFFEF4444),
                            size: 20.0,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}
