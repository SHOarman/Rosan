import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:rosannalie/core/route/app_pages.dart';
import 'package:rosannalie/general_widget/custombutton.dart';
import 'package:rosannalie/utils/appString.dart';
class SubscriptionPromotion extends StatefulWidget {
  const SubscriptionPromotion({super.key});

  @override
  State<SubscriptionPromotion> createState() => _SubscriptionPromotionState();
}

class _SubscriptionPromotionState extends State<SubscriptionPromotion> {
  bool _isYearlySelected = true;

  Widget _buildFeatureItem(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Row(
        children: [
          Container(
            width: 24,
            height: 24,
            decoration: const BoxDecoration(
              color: Color(0xFFE3F5EC), // Soft green circle background
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.check_rounded,
              color: Color(0xFF2FA870), // Beautiful deep green checkmark
              size: 14.0,
            ),
          ),
          const SizedBox(width: 12.0),
          Expanded(
            child: Text(
              text,
              style: AppTextStyles.inter(
                fontSize: 15.0,
                fontWeight: FontWeight.w500,
                color: const Color(0xFF5E4B8B), // Cohesive theme color
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Unselected shadows from design specs
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
            // 1. Large background outline star and sparkle decorations on the right
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
                      onPressed: () => Get.offAllNamed(AppRoutes.home),
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
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4.0),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFAD4C0).withValues(alpha: 0.3), // 30% Opacity orange base
                            borderRadius: BorderRadius.circular(100.0), // Rounded pill radius
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
                                  color: const Color(0xFF7D3E25), // Cohesive dark orange text
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16.0),

                        // Title
                        Text(
                          "Unlock your full potential",
                          style: AppTextStyles.poppins(
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF161022),
                          ),
                        ),
                        const SizedBox(height: 8.0),

                        // Subtitle
                        Text(
                          "Commit to your future self today.",
                          style: AppTextStyles.inter(
                            fontSize: 15,
                            color: const Color(0xFF8F7DB5),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 32.0),

                        // Features Checks list
                        _buildFeatureItem("AI Motivational Coach"),
                        _buildFeatureItem("Smart Planning & Calendar"),
                        _buildFeatureItem("Unlimited Habit Tracking"),
                        _buildFeatureItem("Future Self Goal Coaching"),
                        const SizedBox(height: 24.0),

                        // Yearly Subscription Card (Stack to support absolute badge)
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              _isYearlySelected = true;
                            });
                          },
                          child: Stack(
                            clipBehavior: Clip.none,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 14.0),
                                decoration: BoxDecoration(
                                  color: _isYearlySelected
                                      ? const Color(0xFF9A7C9D).withValues(alpha: 0.05) // Selected: 5% opacity
                                      : Colors.white,
                                  borderRadius: BorderRadius.circular(16.0),
                                  border: Border.all(
                                    color: _isYearlySelected ? const Color(0xFF9A7C9D) : const Color(0xFFE6DCFA),
                                    width: _isYearlySelected ? 2.0 : 1.0,
                                  ),
                                  boxShadow: _isYearlySelected ? [] : unselectedShadow,
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          "Yearly",
                                          style: AppTextStyles.plusJakartaSans(
                                            fontSize: 18.0,
                                            fontWeight: FontWeight.bold,
                                            color: const Color(0xFF161022),
                                          ),
                                        ),
                                        const SizedBox(height: 4.0),
                                        Text(
                                          "Just \$4.99 per month",
                                          style: AppTextStyles.inter(
                                            fontSize: 13.0,
                                            fontWeight: FontWeight.w500,
                                            color: const Color(0xFF8F7DB5),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Text(
                                      "\$59.99/yr",
                                      style: AppTextStyles.plusJakartaSans(
                                        fontSize: 18.0,
                                        fontWeight: FontWeight.bold,
                                        color: const Color(0xFF161022),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              // MOST POPULAR badge pill on top border
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
                        const SizedBox(height: 16.0),

                        // Monthly Subscription Card
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              _isYearlySelected = false;
                            });
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 18.0),
                            decoration: BoxDecoration(
                              color: !_isYearlySelected
                                      ? const Color(0xFF9A7C9D).withValues(alpha: 0.05)
                                      : Colors.white,
                              borderRadius: BorderRadius.circular(16.0),
                              border: Border.all(
                                color: !_isYearlySelected ? const Color(0xFF9A7C9D) : const Color(0xFFE6DCFA),
                                width: !_isYearlySelected ? 2.0 : 1.0,
                              ),
                              boxShadow: !_isYearlySelected ? [] : unselectedShadow,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Monthly",
                                  style: AppTextStyles.plusJakartaSans(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.bold,
                                    color: const Color(0xFF161022),
                                  ),
                                ),
                                Text(
                                  "\$6.99/mo",
                                  style: AppTextStyles.plusJakartaSans(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.bold,
                                    color: const Color(0xFF161022),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 40.0),

                        // Trial call to action button
                        Center(
                          child: CustomButton(
                            text: "Start 7-Day Free Trial",
                            gradientColors: const [
                              Color(0xFF8B77C2), // Premium custom purple gradients
                              Color(0xFF6B58A3),
                            ],
                            onTap: () {
                              Get.snackbar(
                                "Subscription",
                                "Trial plan initiated successfully!",
                                backgroundColor: const Color(0xFFF6F5FB),
                                colorText: const Color(0xFF5E4B8B),
                                snackPosition: SnackPosition.BOTTOM,
                              );
                            },
                          ),
                        ),
                        const SizedBox(height: 16.0),

                        // Cancel info label
                        Center(
                          child: Text(
                            "Cancel anytime. Auto-renews after 7 days.",
                            style: AppTextStyles.inter(
                              fontSize: 12.0,
                              fontWeight: FontWeight.w500,
                              color: const Color(0xFF8F7DB5),
                            ),
                          ),
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
