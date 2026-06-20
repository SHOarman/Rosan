import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rosannalie/core/services/controller/quote_controller.dart';
import 'package:rosannalie/general_widget/custom_background.dart';
import 'package:rosannalie/presention/home/hometab_var/AllQuotes.dart';
import 'package:rosannalie/presention/home/hometab_var/Saved.dart';
import 'package:rosannalie/utils/appString.dart';

class Allquotes extends StatelessWidget {
  const Allquotes({super.key});

  @override
  Widget build(BuildContext context) {
    final QuoteController controller = Get.find<QuoteController>();

    return CustomBackground(
      useSafeArea: false,
      backgroundImageAsset: "assets/images/image.png",
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              // Header Row with centered title and left back button
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
                    "All Quotes",
                    style: AppTextStyles.plusJakartaSans(
                      fontSize: 20,
                      color: const Color(0xFF161022),
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  // Empty placeholder to balance the back button alignment
                  const SizedBox(width: 40),
                ],
              ),
              const SizedBox(height: 24),

              // Horizontal Tab Switcher with custom pills
              Obx(() => Row(
                    children: [
                      _buildTabButton(
                        label: "All Quotes",
                        isSelected: controller.selectedTabIndex.value == 0,
                        onTap: () => controller.changeTab(0),
                      ),
                      const SizedBox(width: 12),
                      _buildTabButton(
                        label: "❤️ Saved (${controller.savedQuotes.length})",
                        isSelected: controller.selectedTabIndex.value == 1,
                        onTap: () => controller.changeTab(1),
                      ),
                    ],
                  )),
              const SizedBox(height: 24),

              // Tab View Content
              Expanded(
                child: Obx(() {
                  if (controller.selectedTabIndex.value == 0) {
                    return const AllQuotesTab();
                  } else {
                    return const SavedQuotesTab();
                  }
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTabButton({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected
              ? const Color(0xFFC7BCE6)
              : Colors.white.withValues(alpha: 0.7),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: isSelected
                ? const Color(0xFFB0A2DC)
                : const Color(0xFFE2DCF7),
            width: 1,
          ),
        ),
        child: Text(
          label,
          style: AppTextStyles.plusJakartaSans(
            fontSize: 14,
            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
            color: isSelected ? const Color(0xFF3D2E6B) : const Color(0xFF8F7DB5),
          ),
        ),
      ),
    );
  }
}
