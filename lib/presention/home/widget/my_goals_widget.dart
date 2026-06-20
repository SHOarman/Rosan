import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rosannalie/core/services/controller/mygoall_controller.dart';
import 'package:rosannalie/core/route/app_pages.dart';
import 'package:rosannalie/utils/appString.dart';

class MyGoalsWidget extends StatelessWidget {
  const MyGoalsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final MygoallController controller = Get.find<MygoallController>();

    return Obx(() {
      final goals = controller.goals;

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "My Goals",
                style: AppTextStyles.plusJakartaSans(
                  color: const Color(0xff3D2E6B),
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              GestureDetector(
                onTap: () {
                  Get.toNamed(AppRoutes.mygoals_seeall);
                },
                child: Text(
                  "See all →",
                  style: AppTextStyles.inter(
                    color: const Color(0xff7B64B0),
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                  ),
                ),
              )
            ],
          ),
          const SizedBox(height: 16.0),
          if (goals.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20.0),
              child: Center(
                child: Text(
                  "No active goals",
                  style: AppTextStyles.inter(
                    color: const Color(0xFF8F7DB5),
                    fontSize: 14,
                  ),
                ),
              ),
            )
          else
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: goals.length > 2 ? 2 : goals.length, // Show top 2 as preview
              itemBuilder: (context, index) {
                final goal = goals[index];
                return _buildHomeGoalCard(goal);
              },
            ),
        ],
      );
    });
  }

  Widget _buildHomeGoalCard(GoalItem goal) {
    Color mainColor;
    String emoji;
    switch (goal.iconType) {
      case 'rocket':
        mainColor = const Color(0xFF7B64B0); // purple
        emoji = "🚀";
        break;
      case 'run':
        mainColor = const Color(0xFFFFB300); // orange
        emoji = "🏃";
        break;
      case 'book':
        mainColor = const Color(0xFF2ECC71); // green
        emoji = "📚";
        break;
      case 'money':
        mainColor = const Color(0xFFFF5A79); // pink/magenta
        emoji = "💰";
        break;
      default:
        mainColor = const Color(0xFF7B64B0);
        emoji = "🎯";
    }

    return Obx(() {
      final percentageText = '${(goal.progress.value * 100).round()}%';

      return Container(
        width: double.infinity,
        margin: const EdgeInsets.only(bottom: 12.0),
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.8),
          borderRadius: BorderRadius.circular(20.0),
          border: Border(
            top: BorderSide(color: Colors.white.withOpacity(0.9), width: 1.0),
          ),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF4A3870).withOpacity(0.1),
              blurRadius: 32.0,
              spreadRadius: 0,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  emoji,
                  style: const TextStyle(fontSize: 22),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    goal.title,
                    style: AppTextStyles.plusJakartaSans(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF2E2252),
                    ),
                  ),
                ),
                Text(
                  percentageText,
                  style: AppTextStyles.inter(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: mainColor,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            // Progress Bar
            Container(
              height: 6.0,
              width: double.infinity,
              decoration: BoxDecoration(
                color: mainColor.withOpacity(0.15),
                borderRadius: BorderRadius.circular(3.0),
              ),
              alignment: Alignment.centerLeft,
              child: FractionallySizedBox(
                widthFactor: goal.progress.value,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  decoration: BoxDecoration(
                    color: mainColor,
                    borderRadius: BorderRadius.circular(3.0),
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    });
  }
}
