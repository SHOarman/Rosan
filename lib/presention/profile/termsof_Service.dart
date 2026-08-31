import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rosannalie/utils/appString.dart';
import 'package:rosannalie/core/services/controller/support_controller.dart';

class TermsOfServicePage extends StatefulWidget {
  const TermsOfServicePage({super.key});

  @override
  State<TermsOfServicePage> createState() => _TermsOfServicePageState();
}

class _TermsOfServicePageState extends State<TermsOfServicePage> {
  final SupportController _supportController = Get.isRegistered<SupportController>()
      ? Get.find<SupportController>()
      : Get.put(SupportController());

  @override
  void initState() {
    super.initState();
    _supportController.fetchTerms();
  }

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

              Obx(() {
                if (_supportController.isTermsLoading.value) {
                  return const Center(
                    child: Padding(
                      padding: EdgeInsets.all(40.0),
                      child: CircularProgressIndicator(color: Color(0xFF5E4B8B)),
                    ),
                  );
                }

                if (_supportController.termsPolicies.isEmpty) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(40.0),
                      child: Text(
                        "No terms and conditions found.",
                        style: AppTextStyles.inter(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: const Color(0xFF575B61),
                        ),
                      ),
                    ),
                  );
                }

                return ListView.separated(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: _supportController.termsPolicies.length,
                  separatorBuilder: (context, index) => const SizedBox(height: 16.0),
                  itemBuilder: (context, index) {
                    final policy = _supportController.termsPolicies[index];
                    return _buildSectionCard(
                      title: policy["title"] ?? "",
                      content: policy["content"] ?? "",
                    );
                  },
                );
              }),
              const SizedBox(height: 40.0),
            ],
          ),
        ),
      ),
    );
  }
}
