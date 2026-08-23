import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rosannalie/core/services/controller/future_me_controller.dart';
import 'package:rosannalie/utils/appString.dart';

class Growthsnapshotcard extends StatelessWidget {
  const Growthsnapshotcard({super.key});

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
        border: Border.all(
          color: const Color(0xFFFFFFFF).withValues(alpha: 0.9),
          width: 1.0,
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
          // Header Row
          Row(
            children: [
              const Text(
                "📊",
                style: TextStyle(fontSize: 16.0),
              ),
              const SizedBox(width: 8.0),
              Text(
                "Growth Snapshot",
                style: AppTextStyles.plusJakartaSans(
                  fontSize: 17.0,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF3D2E6B),
                ),
              ),
            ],
          ),
          const SizedBox(height: 18.0),
          // Metrics Row
          Obx(() => Row(
            children: [
              Expanded(
                child: _buildMetricItem(
                  iconWidget: _buildCalendarIcon(),
                  value: controller.daysActive.value.toString(),
                  label: "Days active",
                ),
              ),
              const SizedBox(width: 12.0),
              Expanded(
                child: _buildMetricItem(
                  iconWidget: const Text("✅", style: TextStyle(fontSize: 22.0)),
                  value: controller.tasksDone.value.toString(),
                  label: "Tasks done",
                ),
              ),
              const SizedBox(width: 12.0),
              Expanded(
                child: _buildMetricItem(
                  iconWidget: const Text("🎯", style: TextStyle(fontSize: 22.0)),
                  value: controller.goalsSet.value.toString(),
                  label: "Goals set",
                ),
              ),
            ],
          )),
        ],
      ),
    );
  }

  Widget _buildCalendarIcon() {
    final now = DateTime.now();
    final months = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"];
    final currentMonth = months[now.month - 1];

    return SizedBox(
      width: 28.0,
      height: 30.0,
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          Container(
            width: 26.0,
            height: 26.0,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(4.0),
              border: Border.all(color: const Color(0xFFD6D1E6), width: 1.0),
            ),
            child: Column(
              children: [
                Container(
                  height: 9.0,
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    color: Color(0xFFF14A4A),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(3.0),
                      topRight: Radius.circular(3.0),
                    ),
                  ),
                  alignment: Alignment.center,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 1.0),
                    child: Text(
                      currentMonth,
                      style: const TextStyle(
                        fontSize: 5.5,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        height: 1.0,
                        letterSpacing: 0.2,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Center(
                    child: Text(
                      now.day.toString(),
                      style: const TextStyle(
                        fontSize: 12.0,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF2E2252),
                        height: 1.0,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Left Binder Ring
          Positioned(
            top: 1.0,
            left: 7.0,
            child: Container(
              width: 2.5,
              height: 5.5,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(1.5),
                border: Border.all(color: const Color(0xFF575B61), width: 0.5),
              ),
            ),
          ),
          // Right Binder Ring
          Positioned(
            top: 1.0,
            right: 7.0,
            child: Container(
              width: 2.5,
              height: 5.5,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(1.5),
                border: Border.all(color: const Color(0xFF575B61), width: 0.5),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMetricItem({
    required Widget iconWidget,
    required String value,
    required String label,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 8.0),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.8),
        borderRadius: BorderRadius.circular(16.0),
        border: Border.all(
          color: const Color(0xFFE2DCF7).withValues(alpha: 0.5),
          width: 1.0,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          iconWidget,
          const SizedBox(height: 8.0),
          Text(
            value,
            style: AppTextStyles.plusJakartaSans(
              fontSize: 22.0,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF2E2252),
            ),
          ),
          const SizedBox(height: 4.0),
          Text(
            label,
            style: AppTextStyles.plusJakartaSans(
              fontSize: 12.0,
              fontWeight: FontWeight.w400,
              color: const Color(0xFFB5A8D5),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
