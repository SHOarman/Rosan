import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rosannalie/core/services/controller/future_me_controller.dart';
import 'package:rosannalie/general_widget/custom_background.dart';
import 'package:rosannalie/presention/home/widget/futuredcard.dart';
import 'package:rosannalie/presention/home/widget/myvisioncard.dart';
import 'package:rosannalie/presention/home/widget/myjourneycard.dart';
import 'package:rosannalie/presention/home/widget/futurelettercard.dart';
import 'package:rosannalie/presention/home/widget/growthsnapshotcard.dart';
import 'package:rosannalie/utils/appString.dart';

class Futureme extends StatelessWidget {
  const Futureme({super.key});

  @override
  Widget build(BuildContext context) {
    final FutureMeController controller = Get.isRegistered<FutureMeController>()
        ? Get.find<FutureMeController>()
        : Get.put(FutureMeController());

    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.fetchDashboard();
    });

    return CustomBackground(
      useSafeArea: false,
      backgroundImageAsset: "assets/images/image.png",
      child: SafeArea(
        child: RefreshIndicator(
          color: const Color(0xFF7B64B0),
          onRefresh: () => controller.fetchDashboard(),
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(
              parent: BouncingScrollPhysics(),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                children: [
                  const SizedBox(height: 20),

                  Row(
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
                        "Future Me",
                        style: AppTextStyles.plusJakartaSans(
                          fontSize: 20,
                          color: const Color(0xFF161022),
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(width: 40),
                    ],
                  ),

                  const SizedBox(height: 24.0),

                  //====================futuredred===============================================
                  const Futuredcard(),
                  const SizedBox(height: 24.0),

                  //=========================================myvisioncard===========================================
                  const Myvisioncard(),
                  const SizedBox(height: 24.0),

                  //==================================================== My Journey===========================================
                  const Myjourneycard(),
                  const SizedBox(height: 24.0),

                  //=========================================futurelettercard===========================================
                  const Futurelettercard(),
                  const SizedBox(height: 24.0),

                  //=========================================growthsnapshotcard===========================================
                  const Growthsnapshotcard(),
                  const SizedBox(height: 24.0),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
