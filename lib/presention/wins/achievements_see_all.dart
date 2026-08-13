import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rosannalie/core/services/controller/wins_controller.dart';
import 'package:rosannalie/general_widget/custom_background.dart';
import 'package:rosannalie/presention/wins/widget/achievements.dart';
import 'package:rosannalie/utils/appString.dart';

class WinsSeeAll extends StatelessWidget {
  const WinsSeeAll({super.key});

  @override
  Widget build(BuildContext context) {
    final WinsController controller = Get.isRegistered<WinsController>()
        ? Get.find<WinsController>()
        : Get.put(WinsController());

    return CustomBackground(
      useSafeArea: false,
      backgroundImageAsset: "assets/images/image.png",
      child: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 20),

            // Top Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () => Get.back(),
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF4A3870).withValues(alpha: 0.1),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.arrow_back,
                        color: Color(0xFF161022),
                        size: 20,
                      ),
                    ),
                  ),
                  Text(
                    "Today's Achievements",
                    style: AppTextStyles.plusJakartaSans(
                      fontSize: 18,
                      color: const Color(0xFF161022),
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(width: 40),
                ],
              ),
            ),

            const SizedBox(height: 20),

            Expanded(
              child: RefreshIndicator(
                color: const Color(0xFF7B64B0),
                onRefresh: () => controller.fetchWinsDashboard(),
                child: const SingleChildScrollView(
                  physics: AlwaysScrollableScrollPhysics(
                    parent: BouncingScrollPhysics(),
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.0),
                    child: Achievements(),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
