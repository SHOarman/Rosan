import 'package:flutter/material.dart';
import 'package:rosannalie/general_widget/custom_background.dart';
import 'package:rosannalie/general_widget/customnav_button.dart';
import 'package:rosannalie/presention/profile/widget/profilecard.dart';
import 'package:rosannalie/presention/profile/widget/stackcard.dart';
import 'package:rosannalie/presention/profile/widget/accound.dart';
import 'package:get/get.dart';
import 'package:rosannalie/core/route/app_pages.dart';
import 'package:rosannalie/presention/profile/widget/myplan.dart';
import 'package:rosannalie/presention/profile/widget/support_card.dart';
import 'package:rosannalie/presention/profile/widget/logout_card.dart';
import 'package:rosannalie/utils/appString.dart';

class Profile extends StatelessWidget {
  const Profile({super.key});

  void _showLogoutDialog(BuildContext context) {
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24.0),
        ),
        backgroundColor: Colors.transparent,
        child: Container(
          padding: const EdgeInsets.all(24.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24.0),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 20.0,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Exit icon in a light red circle
              Container(
                width: 56.0,
                height: 56.0,
                decoration: const BoxDecoration(
                  color: Color(0xFFFEE2E2),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.logout_rounded,
                  color: Color(0xFFEF4444),
                  size: 28.0,
                ),
              ),
              const SizedBox(height: 20.0),
              // Dialog Title
              Text(
                "Are you sure?",
                style: AppTextStyles.plusJakartaSans(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF161022),
                ),
              ),
              const SizedBox(height: 10.0),
              // Dialog Description
              Text(
                "Do you really want to log out of your account?",
                textAlign: TextAlign.center,
                style: AppTextStyles.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFF8F7DB5),
                ),
              ),
              const SizedBox(height: 24.0),
              // Cancel & Confirm Buttons
              Row(
                children: [
                  // Cancel Button
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        Get.back();
                      },
                      borderRadius: BorderRadius.circular(12.0),
                      child: Container(
                        height: 48.0,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: const Color(0xFFF6F5FB),
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        child: Text(
                          "Cancel",
                          style: AppTextStyles.inter(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF575B61),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12.0),
                  // Log Out Button
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        Get.back();
                        Get.offAllNamed(AppRoutes.singin);
                      },
                      borderRadius: BorderRadius.circular(12.0),
                      child: Container(
                        height: 48.0,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: const Color(0xFFEF4444),
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        child: Text(
                          "Yes, Log Out",
                          style: AppTextStyles.inter(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      barrierDismissible: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    return CustomBackground(
      useSafeArea: false,
      backgroundImageAsset: "assets/images/image.png",
      child: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            bottom: 40.0,
            child: SafeArea(
              bottom: false,
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 40),
                      Center(
                        child: Text(
                          'Profile',
                          style: AppTextStyles.plusJakartaSans(
                            fontSize: 20,
                            color: const Color(0xFF161022),
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),

                      //=============================================profilecard=================================================================
                      Profilecard(onTap: () {}),
                      const SizedBox(height: 20),
                      //===============================stackcard======================================================
                      const Stackcard(),

                      const SizedBox(height: 30),

                      //==========================================accound=======================================
                      Text(
                        "Account",
                        style: AppTextStyles.inter(
                          color: const Color(0xff161022),
                          fontSize: 19,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Accound(
                        onTapEditProfile: () {
                          Get.toNamed(AppRoutes.editprofile);
                        },
                        onTapNotifications: () {
                          print("Notifications Clicked from Profile Screen");
                        },
                      ),
                      const SizedBox(height: 30),

                      Text(
                        "Subscription",
                        style: AppTextStyles.inter(
                          color: const Color(0xff161022),
                          fontSize: 19,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      MyPlan(
                        onTap: () {
                          Get.toNamed(AppRoutes.myplan);
                        },
                      ),
                      const SizedBox(height: 20),
                      Text(
                        "Support",
                        style: AppTextStyles.inter(
                          color: const Color(0xff161022),
                          fontSize: 19,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      SupportCard(
                        onTapHelpCenter: () {
                          print("Help Center Clicked from Profile Screen");
                          Get.toNamed(AppRoutes.helpcenter);
                        },
                        onTapPrivacyPolicy: () {
                          Get.toNamed(AppRoutes.privacypolicy);
                        },
                        onTapTermsOfService: () {
                          Get.toNamed(AppRoutes.termsofservice);
                        },
                      ),
                      const SizedBox(height: 30),
                      //============================loguout====================================
                      LogoutCard(
                        onTap: () {
                          _showLogoutDialog(context);
                        },
                      ),
                      const SizedBox(height: 100),
                    ],
                  ),
                ),
              ),
            ),
          ),
          const Positioned(
            bottom: 50.0,
            left: 0,
            right: 0,
            child: Center(child: CustomBottomNavBar(selectedIndex: 4)),
          ),
        ],
      ),
    );
  }
}
