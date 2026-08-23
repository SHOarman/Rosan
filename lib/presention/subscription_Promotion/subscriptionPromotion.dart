import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:rosannalie/core/route/app_pages.dart';
import 'package:rosannalie/general_widget/custombutton.dart';
import 'package:rosannalie/utils/appString.dart';
import 'package:rosannalie/core/services/controller/subscriptionController.dart';
class SubscriptionPromotion extends StatefulWidget {
  const SubscriptionPromotion({super.key});

  @override
  State<SubscriptionPromotion> createState() => _SubscriptionPromotionState();
}

class _SubscriptionPromotionState extends State<SubscriptionPromotion> {
  final pubController = Get.put(SubscriptionController());
  
  String _selectedPlanId = "";

  Widget _buildFeatureItem(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Row(
        children: [
          Container(
            width: 24,
            height: 24,
            decoration: const BoxDecoration(
              color: Color(0xFFE3F5EC),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.check_rounded,
              color: Color(0xFF2FA870),
              size: 14.0,
            ),
          ),
          const SizedBox(width: 12.0),
          Expanded(
            child: Text(
              text,
              style: AppTextStyles.manrope(
                fontSize: 16.0,
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
    final List<BoxShadow> unselectedShadow = [
      BoxShadow(
        color: Colors.black.withValues(alpha: 0.1),
        offset: const Offset(0, 1),
        blurRadius: 2.0,
        spreadRadius: -1.0,
      ),
      BoxShadow(
        color: Colors.black.withValues(alpha: 0.1),
        offset: const Offset(0, 1),
        blurRadius: 3.0,
        spreadRadius: 0.0,
      ),
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: [
            // 1. Large background outline star and sparkle decorations
            Positioned(
              right: -30,
              top: 130,
              child: IgnorePointer(
                child: Opacity(
                  opacity: 0.08,
                  child: SvgPicture.asset(
                    "assets/icon/star.svg",
                    width: 150,
                    height: 150,
                    colorFilter: const ColorFilter.mode(
                      Color(0xFF7B64B0),
                      BlendMode.srcIn,
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              right: 40,
              top: 110,
              child: IgnorePointer(
                child: Opacity(
                  opacity: 0.10,
                  child: SvgPicture.asset(
                    "assets/icon/star.svg",
                    width: 18,
                    height: 18,
                    colorFilter: const ColorFilter.mode(
                      Color(0xFF7B64B0),
                      BlendMode.srcIn,
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              right: 70,
              top: 240,
              child: IgnorePointer(
                child: Opacity(
                  opacity: 0.10,
                  child: SvgPicture.asset(
                    "assets/icon/star.svg",
                    width: 14,
                    height: 14,
                    colorFilter: const ColorFilter.mode(
                      Color(0xFF7B64B0),
                      BlendMode.srcIn,
                    ),
                  ),
                ),
              ),
            ),

            // 2. Main Content
            Column(
              children: [
                // Top header action: Close Button
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  child: Align(
                    alignment: Alignment.topRight,
                    child: IconButton(
                      icon: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: const BoxDecoration(
                          color: Color(0xFFF6F5FB),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.close_rounded,
                          color: Color(0xFF161022),
                          size: 20,
                        ),
                      ),
                      onPressed: () => Get.toNamed(AppRoutes.home),
                    ),
                  ),
                ),

                // Scrollable content body
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Premium Plan Tag Badge
                        Obx(() => Text(
                          pubController.paywallTitle.value,
                          style: AppTextStyles.poppins(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF161022),
                          ),
                        )),
                        const SizedBox(height: 8.0),

                        Obx(() => Text(
                          pubController.paywallSubtitle.value,
                          style: AppTextStyles.inter(
                            fontSize: 15,
                            color: const Color(0xFF4A3B4D),
                            fontWeight: FontWeight.w500,
                          ),
                        )),

                        const SizedBox(height: 26.0),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4.0),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFAD4C0).withValues(alpha: 0.3), // 30% Opacity orange base
                            borderRadius: BorderRadius.circular(100.0),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              SvgPicture.asset(
                                "assets/icon/star.svg",
                                width: 12,
                                height: 12,
                                colorFilter: const ColorFilter.mode(
                                  Color(0xFF7D3E25),
                                  BlendMode.srcIn,
                                ),
                              ),
                              const SizedBox(width: 8.0),
                              Text(
                                "Premium Plan",
                                style: AppTextStyles.plusJakartaSans(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: const Color(0xFF7D3E25),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16.0),


                        Obx(() {
                          if (pubController.paywallFeatures.isEmpty) {
                            return const Center(child: CircularProgressIndicator());
                          }
                          return Column(
                            children: pubController.paywallFeatures
                                .map((feature) => _buildFeatureItem(feature))
                                .toList(),
                          );
                        }),
                        const SizedBox(height: 24.0),

                        // Dynamic Plans List
                        Obx(() {
                          if (pubController.backendPlans.isEmpty) {
                            return const SizedBox.shrink();
                          }

                          if (_selectedPlanId.isEmpty && pubController.backendPlans.isNotEmpty) {
                             WidgetsBinding.instance.addPostFrameCallback((_) {
                               setState(() => _selectedPlanId = pubController.backendPlans.first['planCode'].toString());
                             });
                          }

                          return Column(
                            children: pubController.backendPlans.map((planData) {
                              final String planCode = planData['planCode'].toString();
                              final bool isSelected = _selectedPlanId == planCode;
                              final bool isPopular = planData['isPopular'] == true;

                              return Padding(
                                padding: const EdgeInsets.only(bottom: 16.0),
                                child: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      _selectedPlanId = planCode;
                                    });
                                  },
                                  child: Stack(
                                    clipBehavior: Clip.none,
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 14.0),
                                        decoration: BoxDecoration(
                                          color: isSelected
                                              ? const Color(0xFF9A7C9D).withValues(alpha: 0.05)
                                              : Colors.white,
                                          borderRadius: BorderRadius.circular(16.0),
                                          border: Border.all(
                                            color: isSelected ? const Color(0xFF9A7C9D) : const Color(0xFFE6DCFA),
                                            width: isSelected ? 2.0 : 1.0,
                                          ),
                                          boxShadow: isSelected ? [] : unselectedShadow,
                                        ),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                  planData['title'] ?? planCode,
                                                  style: AppTextStyles.manrope(
                                                    fontSize: 18.0,
                                                    fontWeight: FontWeight.bold,
                                                    color: const Color(0xFF2E2530),
                                                  ),
                                                ),
                                                if (planData['subtext'] != null) ...[
                                                  const SizedBox(height: 4.0),
                                                  Text(
                                                    planData['subtext'],
                                                    style: AppTextStyles.manrope(
                                                      fontSize: 14.0,
                                                      fontWeight: FontWeight.w500,
                                                      color: const Color(0xFF4A3B4D),
                                                    ),
                                                  ),
                                                ]
                                              ],
                                            ),
                                            Text(
                                              planData['formattedPrice'] ?? "\$${planData['price']}",
                                              style: AppTextStyles.manrope(
                                                fontSize: 18.0,
                                                fontWeight: FontWeight.bold,
                                                color: const Color(0xFF2E2530),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      if (isPopular)
                                        Positioned(
                                          top: -10,
                                          left: 16,
                                          child: Container(
                                            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 3.0),
                                            decoration: BoxDecoration(
                                              color: const Color(0xFF9A7C9D), // Purple base badge color
                                              borderRadius: BorderRadius.circular(6.0),
                                            ),
                                            child: Text(
                                              "MOST POPULAR",
                                              style: AppTextStyles.inter(
                                                fontSize: 9,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                              );
                            }).toList(),
                          );
                        }),
                        
                        const SizedBox(height: 24.0),

                        // Trial call to action button
                        Center(
                          child: Obx(() => CustomButton(
                            text: pubController.isLoading.value ? "Processing..." : pubController.paywallBanner.value,
                            gradientColors: const [
                              Color(0xFF8B77C2), // Premium custom purple gradients
                              Color(0xFF6B58A3),
                            ],
                            onTap: () async {
                               if (pubController.isLoading.value) return;
                               
                               if (_selectedPlanId.isEmpty) {
                                  Get.snackbar("Notice", "Please select a plan first");
                                  return;
                               }
                               
                               await pubController.makePurchase(_selectedPlanId);
                            },
                          )),
                        ),
                        const SizedBox(height: 16.0),

                        // Cancel info label
                        Center(
                          child: Obx(() => Text(
                            pubController.paywallSubtext.value,
                            style: AppTextStyles.inter(
                              fontSize: 12.0,
                              fontWeight: FontWeight.w500,
                              color: const Color(0xFF8F7DB5),
                            ),
                          )),
                        ),
                        const SizedBox(height: 40.0),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
