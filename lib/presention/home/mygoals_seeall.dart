import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rosannalie/core/services/controller/mygoall_controller.dart';
import 'package:rosannalie/general_widget/custom_background.dart';
import 'package:rosannalie/utils/appString.dart';

class MygoalsSeeall extends StatelessWidget {
  const MygoalsSeeall({super.key});

  @override
  Widget build(BuildContext context) {
    final MygoallController controller = Get.find<MygoallController>();

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
                            color: const Color(0xFF4A3870).withOpacity(0.1),
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
                    "My Goals",
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
              const SizedBox(height: 30),

              // Overall Progress Card
              Obx(() {
                final progress = controller.overallProgress;
                final activeCount = controller.activeGoalsCount;

                return Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16.0),
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
                  child: Row(
                    children: [
                      _buildOverallProgressRing(progress),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Overall Progress",
                              style: AppTextStyles.plusJakartaSans(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: const Color(0xFF2E2252),
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              "$activeCount active goals - Keep going! 👑",
                              style: AppTextStyles.inter(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color: const Color(0xFF8F7DB5),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              }),
              const SizedBox(height: 24),

              // Goal Cards List
              Expanded(
                child: Obx(() {
                  final goals = controller.goals;

                  if (goals.isEmpty) {
                    return Center(
                      child: Text(
                        "No goals set yet!",
                        style: AppTextStyles.inter(
                          color: const Color(0xFF8F7DB5),
                          fontSize: 14,
                        ),
                      ),
                    );
                  }

                  return ListView.builder(
                    physics: const BouncingScrollPhysics(),
                    itemCount: goals.length + 1, // +1 for the "+ Add a new goal" button
                    itemBuilder: (context, index) {
                      if (index == goals.length) {
                        // Return the Add a new goal button at the end
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 16.0),
                          child: GestureDetector(
                            onTap: () => _showAddGoalBottomSheet(context, controller),
                            child: Container(
                              width: double.infinity,
                              padding: const EdgeInsets.symmetric(vertical: 16.0),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.6),
                                borderRadius: BorderRadius.circular(24.0),
                                border: Border.all(color: const Color(0xFFE2DCF7), width: 1.0),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(
                                    Icons.add,
                                    color: Color(0xFF7B64B0),
                                    size: 18,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    "Add a new goal",
                                    style: AppTextStyles.inter(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: const Color(0xFF7B64B0),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      }

                      final goal = goals[index];
                      return _buildGoalCard(context, goal, controller);
                    },
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOverallProgressRing(double progress) {
    final percentageText = '${(progress * 100).round()}%';
    return SizedBox(
      width: 60,
      height: 60,
      child: Stack(
        alignment: Alignment.center,
        children: [
          SizedBox(
            width: 60,
            height: 60,
            child: CircularProgressIndicator(
              value: progress,
              strokeWidth: 6.0,
              backgroundColor: const Color(0xFF7B64B0).withOpacity(0.15),
              valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF7B64B0)),
            ),
          ),
          Text(
            percentageText,
            style: AppTextStyles.inter(
              fontSize: 14.0,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF2E2252),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGoalCard(BuildContext context, GoalItem goal, MygoallController controller) {
    Color mainColor;
    switch (goal.iconType) {
      case 'rocket':
        mainColor = const Color(0xFF7B64B0); // purple
        break;
      case 'run':
        mainColor = const Color(0xFFFFB300); // orange
        break;
      case 'book':
        mainColor = const Color(0xFF2ECC71); // green
        break;
      case 'money':
        mainColor = const Color(0xFFFF5A79); // pink/magenta
        break;
      default:
        mainColor = const Color(0xFF7B64B0);
    }

    return Obx(() {
      final progressPercentText = '${(goal.progress.value * 100).round()}%';

      return Container(
        width: double.infinity,
        margin: const EdgeInsets.only(bottom: 16.0),
        padding: const EdgeInsets.all(16.0),
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
                _buildGoalProgressRing(goal, mainColor),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        goal.title,
                        style: AppTextStyles.plusJakartaSans(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF2E2252),
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        "Due ${goal.deadline}",
                        style: AppTextStyles.inter(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: const Color(0xFF8F7DB5).withOpacity(0.7),
                        ),
                      ),
                    ],
                  ),
                ),
                Text(
                  progressPercentText,
                  style: AppTextStyles.inter(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: mainColor,
                  ),
                ),
                IconButton(
                  onPressed: () => controller.deleteGoal(goal),
                  icon: const Icon(
                    CupertinoIcons.trash,
                    size: 16,
                    color: Colors.redAccent,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Horizontal Progress Bar
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
            const SizedBox(height: 12),

            // +10% Progress pill button
            GestureDetector(
              onTap: () => controller.incrementProgress(goal),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
                decoration: BoxDecoration(
                  color: mainColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(16.0),
                ),
                child: Text(
                  "+10% Progress",
                  style: AppTextStyles.inter(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: mainColor,
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget _buildGoalProgressRing(GoalItem goal, Color color) {
    IconData iconData;
    switch (goal.iconType) {
      case 'rocket':
        iconData = Icons.rocket_launch;
        break;
      case 'run':
        iconData = Icons.directions_run;
        break;
      case 'book':
        iconData = Icons.menu_book;
        break;
      case 'money':
        iconData = Icons.savings_outlined;
        break;
      default:
        iconData = Icons.flag;
    }
    return SizedBox(
      width: 50,
      height: 50,
      child: Stack(
        alignment: Alignment.center,
        children: [
          SizedBox(
            width: 50,
            height: 50,
            child: CircularProgressIndicator(
              value: goal.progress.value,
              strokeWidth: 4.5,
              backgroundColor: color.withOpacity(0.15),
              valueColor: AlwaysStoppedAnimation<Color>(color),
            ),
          ),
          Icon(
            iconData,
            color: color,
            size: 20,
          ),
        ],
      ),
    );
  }

  void _showAddGoalBottomSheet(BuildContext context, MygoallController controller) {
    final titleController = TextEditingController();
    final deadlineController = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          padding: EdgeInsets.only(
            top: 24,
            left: 24,
            right: 24,
            bottom: MediaQuery.of(context).viewInsets.bottom + 24,
          ),
          decoration: const BoxDecoration(
            color: Color(0xFFF6F5FB),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(32.0),
              topRight: Radius.circular(32.0),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "New Goal 🎯",
                style: AppTextStyles.plusJakartaSans(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  color: const Color(0xFF2E2252),
                ),
              ),
              const SizedBox(height: 20),
              
              // Title Field
              TextField(
                controller: titleController,
                decoration: InputDecoration(
                  hintText: "What do you want to achieve?",
                  hintStyle: AppTextStyles.inter(
                    color: const Color(0xFF8F7DB5).withOpacity(0.6),
                    fontSize: 14,
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16.0),
                    borderSide: const BorderSide(color: Color(0xFFE2DCF7), width: 1.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16.0),
                    borderSide: const BorderSide(color: Color(0xFF7B64B0), width: 1.5),
                  ),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                ),
                style: AppTextStyles.inter(color: const Color(0xFF2E2252), fontSize: 14),
              ),
              const SizedBox(height: 16),

              // Deadline Field
              TextField(
                controller: deadlineController,
                decoration: InputDecoration(
                  hintText: "Deadline (e.g. Dec 2026)",
                  hintStyle: AppTextStyles.inter(
                    color: const Color(0xFF8F7DB5).withOpacity(0.6),
                    fontSize: 14,
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16.0),
                    borderSide: const BorderSide(color: Color(0xFFE2DCF7), width: 1.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16.0),
                    borderSide: const BorderSide(color: Color(0xFF7B64B0), width: 1.5),
                  ),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                ),
                style: AppTextStyles.inter(color: const Color(0xFF2E2252), fontSize: 14),
              ),
              const SizedBox(height: 24),

              // Action Buttons Row: Cancel and Set Goal
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () => Get.back(),
                      child: Container(
                        height: 48,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(24.0),
                          border: Border.all(color: const Color(0xFFE2DCF7), width: 1.0),
                        ),
                        child: Center(
                          child: Text(
                            "Cancel",
                            style: AppTextStyles.inter(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xFF8F7DB5),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        if (titleController.text.trim().isEmpty) {
                          Get.snackbar(
                            "Error",
                            "Please enter what you want to achieve.",
                            snackPosition: SnackPosition.BOTTOM,
                            backgroundColor: Colors.redAccent,
                            colorText: Colors.white,
                          );
                          return;
                        }
                        final deadline = deadlineController.text.trim().isEmpty 
                            ? 'Dec 2026' 
                            : deadlineController.text.trim();
                        controller.addGoal(
                          titleController.text.trim(),
                          deadline,
                        );
                        Get.back();
                      },
                      child: Container(
                        height: 48,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFF8F7DB5), Color(0xFF7B64B0)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(24.0),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFF7B64B0).withOpacity(0.3),
                              blurRadius: 12,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Center(
                          child: Text(
                            "Set Goal",
                            style: AppTextStyles.inter(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
