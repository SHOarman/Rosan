import 'package:flutter/material.dart';
import 'package:rosannalie/general_widget/custom_background.dart';
import 'package:rosannalie/general_widget/customnav_button.dart';
import 'package:rosannalie/utils/appString.dart';

class Gratitude extends StatelessWidget {
  const Gratitude({super.key});

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
                      Text(
                        'Gratitude',
                        style: AppTextStyles.plusJakartaSans(
                          fontSize: 20,
                          color: const Color(0xFF161022),
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 80),
                    ],
                  ),
                ),
              ),
            ),
          ),
          const Positioned(
            bottom: 40.0,
            left: 0,
            right: 0,
            child: Center(
              child: CustomBottomNavBar(selectedIndex: 1),
            ),
          ),
        ],
      ),
    );
  }
}
