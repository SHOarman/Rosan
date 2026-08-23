import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:rosannalie/core/route/app_pages.dart';
import 'package:rosannalie/general_widget/custombutton.dart';
import 'package:rosannalie/utils/appString.dart';
import 'package:rosannalie/core/services/controller/subscriptionController.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

class SubscriptionPromotionProfile extends StatefulWidget {
  const SubscriptionPromotionProfile({super.key});

  @override
  State<SubscriptionPromotionProfile> createState() =>
      _SubscriptionPromotionProfileState();
}

class _SubscriptionPromotionProfileState
    extends State<SubscriptionPromotionProfile> {
  final pubController = Get.put(SubscriptionController());

  String _selectedPlanId = "";

  Widget _buildFeatureItem(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(4.0),
            decoration: BoxDecoration(
              color: const Color(0xFFEEEAFF),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.check_rounded,
              color: Color(0xFF7A64AE),
              size: 14.0,
            ),
          ),
          const SizedBox(width: 12.0),
          Expanded(
            child: Text(
              text,
              style: AppTextStyles.inter(
                fontSize: 14.0,
                fontWeight: FontWeight.w500,
                color: const Color(0xFF4A3B4D),
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
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 12.0,
              ),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Get.back(),
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: const BoxDecoration(
                        color: Color(0xFFF6F5FB),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.arrow_back,
                        color: Color(0xFF382A6E),
                        size: 20,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Text(
                    "Premium Plan",
                    style: AppTextStyles.plusJakartaSans(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF161022),
                    ),
                  ),
                ],
              ),
            ),

            // Scrollable body
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24.0,
                  vertical: 16.0,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Center(
                      child: Image.asset(
                        "assets/images/LOGO (2) 2 (3).png",
                        width: 90,
                        height: 90,
                      ),
                    ),
                    //),
                    const SizedBox(height: 24.0),

                    // Title
                    Obx(
                      () => Text(
                        pubController.paywallTitle.value.isEmpty
                            ? "Rise Premium ✨"
                            : pubController.paywallTitle.value,
                        textAlign: TextAlign.center,
                        style: AppTextStyles.poppins(
                          fontSize: 24,
                          fontWeight: FontWeight.w800,
                          color: const Color(0xFF433475),
                        ),
                      ),
                    ),

                    const SizedBox(height: 8.0),

                    // Subtitle
                    Obx(
                      () => Text(
                        pubController.paywallSubtitle.value.isEmpty
                            ? "Unlock your full potential with everything Rise has to offer."
                            : pubController.paywallSubtitle.value,
                        textAlign: TextAlign.center,
                        style: AppTextStyles.inter(
                          fontSize: 14,
                          color: const Color(0xFF7E70AD),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),

                    const SizedBox(height: 24.0),

                    // Trial Banner (Green Box)
                    Container(
                      padding: const EdgeInsets.all(16.0),
                      decoration: BoxDecoration(
                        color: const Color(0xFFEAF9F1), // Soft green
                        borderRadius: BorderRadius.circular(16.0),
                        border: Border.all(
                          color: const Color(0xFFD3EFE0),
                          width: 2,
                        ),
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8.0),
                            decoration: BoxDecoration(
                              color: const Color(0xFFFFF0DD),
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                            child: const Icon(
                              Icons.card_giftcard,
                              color: Color(0xFFE94D2B),
                              size: 20,
                            ),
                          ),
                          const SizedBox(width: 16.0),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Obx(
                                  () => Text(
                                    pubController.paywallBanner.value.isEmpty
                                        ? "7-day free trial"
                                        : pubController.paywallBanner.value,
                                    style: AppTextStyles.plusJakartaSans(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: const Color(0xFF147A46),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 4.0),
                                Obx(
                                  () => Text(
                                    pubController.paywallSubtext.value.isEmpty
                                        ? "No charge until your trial ends. Cancel anytime."
                                        : pubController.paywallSubtext.value,
                                    style: AppTextStyles.inter(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                      color: const Color(0xFF339864),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24.0),


                    Obx(() {
                      if (pubController.backendPlans.isEmpty) {
                        return const Padding(
                          padding: EdgeInsets.all(32.0),
                          child: Center(child: CircularProgressIndicator()),
                        );
                      }

                      // Default Selections
                      if (_selectedPlanId.isEmpty &&
                          pubController.backendPlans.isNotEmpty) {
                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          setState(
                            () => _selectedPlanId = pubController
                                .backendPlans
                                .first['planCode']
                                .toString(),
                          );
                        });
                      }

                      // Tab Switcher Container
                      return Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(4.0),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(
                                color: const Color(0xFFEBE6F6),
                                width: 1.5,
                              ),
                              borderRadius: BorderRadius.circular(30.0),
                            ),
                            child: Row(
                              children: pubController.backendPlans.map((planData) {
                                        final String planCode =
                                            planData['planCode'].toString();
                                        final bool isSelected =
                                            _selectedPlanId == planCode;
                                        final bool isPopular =
                                            planData['isPopular'] == true;

                                        return Expanded(
                                          child: GestureDetector(
                                            onTap: () => setState(
                                              () => _selectedPlanId = planCode,
                                            ),
                                            child: AnimatedContainer(
                                              duration: const Duration(
                                                milliseconds: 200,
                                              ),
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                    vertical: 14.0,
                                                  ),
                                              decoration: BoxDecoration(
                                                gradient: isSelected
                                                    ? const LinearGradient(
                                                        colors: [
                                                          Color(0xFF9B85CF),
                                                          Color(0xFF5E4B8B),
                                                        ],
                                                        begin: Alignment.centerLeft,
                                                        end: Alignment.centerRight,
                                                      )
                                                    : null,
                                                color: isSelected ? null : Colors.transparent,
                                                borderRadius: BorderRadius.circular(30.0),
                                              ),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Text(
                                                    planData['title'] ??
                                                        planCode,
                                                    style:
                                                        AppTextStyles.plusJakartaSans(
                                                          fontSize: 14,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: isSelected
                                                              ? Colors.white
                                                              : const Color(
                                                                  0xFF7A64AE,
                                                                ),
                                                        ),
                                                  ),
                                                  if (isPopular) ...[
                                                    const SizedBox(width: 6.0),
                                                    Container(
                                                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                                      decoration: BoxDecoration(
                                                        color: isSelected
                                                            ? Colors.white.withValues(alpha: 0.25)
                                                            : const Color(0xFFF25C54).withValues(alpha: 0.1),
                                                        borderRadius: BorderRadius.circular(20),
                                                      ),
                                                      child: Text(
                                                        "Save 20%",
                                                        style: AppTextStyles.inter(
                                                          fontSize: 10,
                                                          fontWeight: FontWeight.bold,
                                                          color: isSelected
                                                              ? Colors.white
                                                              : const Color(0xFFF25C54),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ],
                                              ),
                                            ),
                                          ),
                                        );
                                      })
                                      .toList(),
                            ),
                          ),

                          const SizedBox(height: 24.0),

                          // Render Selected Plan Details Box
                          Builder(
                            builder: (context) {
                              final selectedPlanData = pubController
                                  .backendPlans
                                  .firstWhere(
                                    (p) =>
                                        p['planCode'].toString() ==
                                        _selectedPlanId,
                                    orElse: () => null,
                                  );
                              if (selectedPlanData == null)
                                return const SizedBox.shrink();

                              final formattedPrice =
                                  selectedPlanData['formattedPrice'] ??
                                  "\$${selectedPlanData['price']}";
                              final priceParts = formattedPrice
                                  .toString()
                                  .split("/");
                              final priceAmount = priceParts.isNotEmpty
                                  ? priceParts[0]
                                  : formattedPrice;
                              final priceCycle = priceParts.length > 1
                                  ? "/${priceParts[1]}"
                                  : "";

                              var featuresList =
                                  selectedPlanData['features'] != null &&
                                      (selectedPlanData['features'] as List)
                                          .isNotEmpty
                                  ? List<String>.from(
                                      selectedPlanData['features'],
                                    )
                                  : pubController.paywallFeatures;

                              return Container(
                                width: double.infinity,
                                padding: const EdgeInsets.all(24.0),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFFAF9FF),
                                  borderRadius: BorderRadius.circular(24.0),
                                  border: Border.all(
                                    color: const Color(0xFFEFECFB),
                                    width: 1.5,
                                  ),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    RichText(
                                      text: TextSpan(
                                        children: [
                                          TextSpan(
                                            text: priceAmount,
                                            style: AppTextStyles.poppins(
                                              fontSize: 40,
                                              fontWeight: FontWeight.w800,
                                              color: const Color(0xFF4C3B78),
                                            ),
                                          ),
                                          TextSpan(
                                            text: " $priceCycle",
                                            style: AppTextStyles.inter(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w600,
                                              color: const Color(0xFF8A79B3),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(height: 8.0),
                                    Text(
                                      selectedPlanData['subtext'] ??
                                          "Billed ${selectedPlanData['title']?.toString().toLowerCase()}. Cancel anytime.",
                                      style: AppTextStyles.inter(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                        color: const Color(0xFF9080B9),
                                      ),
                                    ),
                                    const SizedBox(height: 24.0),
                                    const Divider(
                                      color: Color(0xFFEBE6F6),
                                      thickness: 1,
                                    ),
                                    const SizedBox(height: 24.0),

                                    // Plan specific features
                                    ...featuresList.map(
                                      (f) => _buildFeatureItem(f),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ],
                      );
                    }),

                    const SizedBox(height: 32.0),
                  ],
                ),
              ),
            ),
            // Sticky Bottom Checkout Button
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 24.0,
                vertical: 16.0,
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border(
                  top: BorderSide(
                    color: Colors.black.withValues(alpha: 0.05),
                    width: 1,
                  ),
                ),
              ),
              child: Obx(
                () => CustomButton(
                  text: pubController.isLoading.value
                      ? "Processing..."
                      : (pubController.paywallBanner.value.isEmpty
                            ? "Start 7-Day Free Trial"
                            : pubController.paywallBanner.value),
                  gradientColors: const [
                    Color(0xFF7961B2), // Solid Purple for the new UI
                    Color(0xFF67519E),
                  ],
                  onTap: () async {
                    if (pubController.isLoading.value) return;

                    if (_selectedPlanId.isEmpty) {
                      Get.snackbar("Notice", "Please select a plan first");
                      return;
                    }

                    await pubController.makePurchase(_selectedPlanId);
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
