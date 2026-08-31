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
                    ).copyWith(letterSpacing: 1)
                  ),

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
                              style: AppTextStyles.plusJakartaSans(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color: const Color(0xFF8B7DB5),
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

              Expanded(
                child: Obx(() {
                  final goals = controller.goals;

                  if (controller.isLoading.value && goals.isEmpty) {
                    return const Center(
                      child: CircularProgressIndicator(
                        color: Color(0xFF7B64B0),
                      ),
                    );
                  }
                  
                  if (goals.isEmpty) {
                    return RefreshIndicator(
                      color: const Color(0xFF7B64B0),
                      onRefresh: () => controller.fetchGoals(),
                      child: ListView(
                        physics: const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
                        children: [
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.4,
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "No goals set yet!",
                                    style: AppTextStyles.inter(
                                      color: const Color(0xFF8F7DB5),
                                      fontSize: 14,
                                    ),
                                  ),
                                  const SizedBox(height: 24),
                                  GestureDetector(
                                    onTap: () => _showAddGoalBottomSheet(context, controller),
                                    child: Container(
                                      width: 200,
                                      padding: const EdgeInsets.symmetric(vertical: 12.0),
                                      decoration: BoxDecoration(
                                        color: Colors.white.withValues(alpha: 0.6),
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
                                            "Add Goal",
                                            style: AppTextStyles.plusJakartaSans(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w600,
                                              color: const Color(0xFF7B64B0),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  return RefreshIndicator(
                    color: const Color(0xFF7B64B0),
                    onRefresh: () => controller.fetchGoals(),
                    child: NotificationListener<ScrollNotification>(
                    onNotification: (ScrollNotification scrollInfo) {
                      if (!controller.isLoadingMore.value && 
                          controller.hasMoreData && 
                          scrollInfo.metrics.pixels >= scrollInfo.metrics.maxScrollExtent - 50) {
                        controller.loadMoreGoals();
                        return true;
                      }
                      return false;
                    },
                    child: ListView.builder(
                      physics: const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
                      itemCount: goals.length + 1 + (controller.hasMoreData ? 1 : 0),
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
                        if (index == goals.length + 1) {
                          return const Padding(
                            padding: EdgeInsets.all(16.0),
                            child: Center(
                              child: CircularProgressIndicator(
                                color: Color(0xFF7B64B0),
                              ),
                            ),
                          );
                        }

                        final goal = goals[index];
                        return _buildGoalCard(context, goal, controller);
                      },
                    ),
                  ),
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
            style: AppTextStyles.plusJakartaSans(
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
        mainColor = const Color(0xFF7B64B0);
        break;
      case 'run':
        mainColor = const Color(0xFFFFB300); 
        break;
      case 'book':
        mainColor = const Color(0xFF2ECC71); 
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


            Container(
              height: 7.0,
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
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: EdgeInsets.symmetric(
                  horizontal: goal.isLoading.value ? 16.0 : 12.0, 
                  vertical: 6.0
                ),
                decoration: BoxDecoration(
                  color: mainColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(16.0),
                ),
                child: goal.isLoading.value
                    ? SizedBox(
                        width: 14.0,
                        height: 14.0,
                        child: CircularProgressIndicator(
                          strokeWidth: 2.0,
                          color: mainColor,
                        ),
                      )
                    : Text(
                        "+10% Progress",
                        style: AppTextStyles.plusJakartaSans(
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
    String emojiString;
    switch (goal.iconType) {
      case 'rocket':
        emojiString = "🚀";
        break;
      case 'run':
        emojiString = "🏃";
        break;
      case 'book':
        emojiString = "📚";
        break;
      case 'money':
        emojiString = "💰";
        break;
      default:
        emojiString = "🎯";
    }
    return SizedBox(
      width: 58,
      height: 58,
      child: Stack(
        alignment: Alignment.center,
        children: [
          SizedBox(
            width: 58,
            height: 58,
            child: CustomPaint(
              painter: DashedCirclePainter(
                color: color,
                bgColor: color.withOpacity(0.15),
              ),
            ),
          ),
          Text(
            emojiString,
            style: const TextStyle(fontSize: 24),
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
            bottom: MediaQuery.of(context).viewInsets.bottom + MediaQuery.of(context).padding.bottom + 24,
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
                readOnly: true,
                onTap: () async {
                  final DateTime? picked = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime.now(),
                    lastDate: DateTime(2101),
                    builder: (context, child) {
                      return Theme(
                        data: Theme.of(context).copyWith(
                          colorScheme: const ColorScheme.light(
                            primary: Color(0xFF7B64B0),
                            onPrimary: Colors.white,
                            onSurface: Color(0xFF2E2252),
                          ),
                          textButtonTheme: TextButtonThemeData(
                            style: TextButton.styleFrom(
                              foregroundColor: const Color(0xFF7B64B0),
                            ),
                          ),
                        ),
                        child: child!,
                      );
                    },
                  );
                  if (picked != null) {
                    const List<String> months = [
                      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
                      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
                    ];
                    deadlineController.text = "${picked.day} ${months[picked.month - 1]} ${picked.year}";
                  }
                },
                decoration: InputDecoration(
                  hintText: "Deadline (e.g. 15 Dec 2026)",
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
                    child: Obx(() => GestureDetector(
                      onTap: controller.isCreatingGoal.value 
                        ? null 
                        : () async {
                            if (titleController.text.trim().isEmpty) {
                              Get.snackbar(
                                "Error",
                                "Title cannot be empty",
                                backgroundColor: Colors.redAccent,
                                colorText: Colors.white,
                              );
                              return;
                            }
                            final success = await controller.addGoal(
                              titleController.text.trim(),
                              deadlineController.text.trim(),
                            );
                            if (success) {
                              Get.back();
                            } else {
                              Get.snackbar(
                                "Error",
                                "Failed to create goal",
                                backgroundColor: Colors.redAccent,
                                colorText: Colors.white,
                              );
                            }
                          },
                      child: Container(
                        height: 48,
                        decoration: BoxDecoration(
                          color: const Color(0xFF7B64B0),
                          borderRadius: BorderRadius.circular(24.0),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFF7B64B0).withValues(alpha: 0.3),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Center(
                          child: controller.isCreatingGoal.value
                              ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2,
                                  ),
                                )
                              : Text(
                                  "Set Goal",
                                  style: AppTextStyles.inter(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                        ),
                      ),
                    )),
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

class DashedCirclePainter extends CustomPainter {
  final Color color;
  final Color bgColor;

  DashedCirclePainter({required this.color, required this.bgColor});

  @override
  void paint(Canvas canvas, Size size) {
    final double strokeWidth = 4.5;
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - strokeWidth) / 2;

    // Draw background circle (light opacity)
    final bgPaint = Paint()
      ..color = bgColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;
    canvas.drawCircle(center, radius, bgPaint);

    // Draw 4 dashes
    final dashPaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = strokeWidth;
      
    final int dashCount = 4;
    final double sweepAngle = 3.14159 / 4; // 45 degrees
    
    // Position the gaps perfectly at top, right, bottom, left directions
    for (int i = 0; i < dashCount; i++) {
      final startAngle = (3.14159 / 8) + i * (3.14159 / 2);
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle,
        sweepAngle,
        false,
        dashPaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant DashedCirclePainter oldDelegate) {
    return oldDelegate.color != color || oldDelegate.bgColor != bgColor;
  }
}
