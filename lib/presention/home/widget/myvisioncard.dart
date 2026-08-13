import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rosannalie/core/services/controller/future_me_controller.dart';
import 'package:rosannalie/utils/appString.dart';

class Myvisioncard extends StatelessWidget {
  const Myvisioncard({super.key});

  @override
  Widget build(BuildContext context) {
    final FutureMeController controller = Get.isRegistered<FutureMeController>()
        ? Get.find<FutureMeController>()
        : Get.put(FutureMeController());

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18.0),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.65),
        borderRadius: BorderRadius.circular(20.0),
        border: Border(
          top: BorderSide(
            color: Colors.white.withValues(alpha: 0.9),
            width: 1.0,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF4A3870).withValues(alpha: 0.1),
            blurRadius: 32.0,
            spreadRadius: 0,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header: Emoji + Title
          Row(
            children: [
              const Text(
                "🌟",
                style: TextStyle(fontSize: 16.0),
              ),
              const SizedBox(width: 8.0),
              Text(
                "My Vision",
                style: AppTextStyles.plusJakartaSans(
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF2E2252),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16.0),
          // Vision Text (Italicized)
          Obx(() => Text(
            controller.vision.value.isEmpty
                ? "In 5 years, I am living with freedom, health, and purpose."
                : controller.vision.value,
            style: AppTextStyles.plusJakartaSans(
              fontSize: 15.0,
              fontWeight: FontWeight.w500,
              color: const Color(0xFF7A68A6),
            ).copyWith(
              fontStyle: FontStyle.italic,
              height: 1.5,
            ),
          )),
        ],
      ),
    );
  }
}
