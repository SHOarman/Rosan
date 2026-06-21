import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rosannalie/core/services/controller/todaytaskcontroller.dart';
import 'package:rosannalie/general_widget/custom_background.dart';
import 'package:rosannalie/utils/appString.dart';

class TodaystaksSeeall extends StatelessWidget {
  const TodaystaksSeeall({super.key});

  @override
  Widget build(BuildContext context) {
    final Todaytaskcontroller controller = Get.find<Todaytaskcontroller>();

    return CustomBackground(
      useSafeArea: false,
      backgroundImageAsset: "assets/images/image.png",
      child: Stack(
        children: [
          SafeArea(
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
                        "Today's Tasks",
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

                  // Progress Section
                  Obx(() {
                    final tasks = controller.tasks;
                    final int doneCount = controller.doneCount;
                    final double progressPercentage = controller.progressPercentage;

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '$doneCount of ${tasks.length} done',
                              style: AppTextStyles.inter(
                                fontSize: 12.0,
                                fontWeight: FontWeight.w500,
                                color: const Color(0xFF8F7DB5),
                              ),
                            ),
                            Text(
                              '${(progressPercentage * 100).round()}%',
                              style: AppTextStyles.inter(
                                fontSize: 12.0,
                                fontWeight: FontWeight.w600,
                                color: const Color(0xFF8F7DB5),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8.0),
                        // Progress Bar
                        Container(
                          height: 6.0,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: const Color(0xFF8F7DB5).withOpacity(0.15),
                            borderRadius: BorderRadius.circular(3.0),
                          ),
                          alignment: Alignment.centerLeft,
                          child: FractionallySizedBox(
                            widthFactor: progressPercentage,
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 350),
                              decoration: BoxDecoration(
                                color: const Color(0xFF7B64B0),
                                borderRadius: BorderRadius.circular(3.0),
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  }),
                  const SizedBox(height: 24),

                  // Tasks List
                  Expanded(
                    child: Obx(() {
                      final tasks = controller.tasks;
                      if (tasks.isEmpty) {
                        return Center(
                          child: Text(
                            "No tasks for today!",
                            style: AppTextStyles.inter(
                              color: const Color(0xFF8F7DB5),
                              fontSize: 14,
                            ),
                          ),
                        );
                      }
                      return ListView.builder(
                        physics: const BouncingScrollPhysics(),
                        padding: const EdgeInsets.only(bottom: 80.0),
                        itemCount: tasks.length,
                        itemBuilder: (context, index) {
                          final task = tasks[index];
                          return _buildTaskCard(context, task, controller);
                        },
                      );
                    }),
                  ),
                ],
              ),
            ),
          ),

          // Floating Action Button to Add Task
          Positioned(
            bottom: 30,
            right: 20,
            child: GestureDetector(
              onTap: () => _showAddTaskBottomSheet(context, controller),
              child: Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF8F7DB5), Color(0xFF7B64B0)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF7B64B0).withOpacity(0.4),
                      blurRadius: 16,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.add,
                  color: Colors.white,
                  size: 28,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTaskCard(BuildContext context, TaskItem task, Todaytaskcontroller controller) {
    return Obx(() {
      return Container(
        width: double.infinity,
        margin: const EdgeInsets.only(bottom: 12.0),
        padding: const EdgeInsets.only(top: 14, bottom: 14, left: 16, right: 16),
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
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Checkbox
                GestureDetector(
                  onTap: () => controller.toggleTask(task),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    width: 22.0,
                    height: 22.0,
                    decoration: BoxDecoration(
                      color: task.isCompleted.value
                          ? const Color(0xFF7B64B0)
                          : Colors.transparent,
                      border: Border.all(
                        color: task.isCompleted.value
                            ? const Color(0xFF7B64B0)
                            : const Color(0xFF8F7DB5).withOpacity(0.4),
                        width: 1.5,
                      ),
                      borderRadius: BorderRadius.circular(6.0),
                    ),
                    alignment: Alignment.center,
                    child: task.isCompleted.value
                        ? const Icon(
                            Icons.check,
                            color: Colors.white,
                            size: 14.0,
                          )
                        : null,
                  ),
                ),
                const SizedBox(width: 12.0),
                // Title and badges
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        task.title,
                        style: AppTextStyles.inter(
                          fontSize: 14.0,
                          fontWeight: task.isCompleted.value
                              ? FontWeight.w500
                              : FontWeight.w600,
                          color: task.isCompleted.value
                              ? const Color(0xFF8F7DB5)
                              : const Color(0xFF161022),
                        ).copyWith(
                          decoration: task.isCompleted.value
                              ? TextDecoration.lineThrough
                              : TextDecoration.none,
                        ),
                      ),
                      const SizedBox(height: 6.0),
                      Row(
                        children: [
                          _buildPriorityBadge(task.priority),
                          const SizedBox(width: 8.0),
                          _buildCategoryBadge(task.category),
                        ],
                      ),
                    ],
                  ),
                ),
                // Delete button
                IconButton(
                  onPressed: () => controller.deleteTask(task),
                  icon: const Icon(
                    CupertinoIcons.trash,
                    size: 18,
                    color: Colors.redAccent,
                  ),
                ),
              ],
            ),
            if (task.showDailyToggle) ...[
              const SizedBox(height: 10.0),
              Divider(
                color: const Color(0xFF8F7DB5).withOpacity(0.1),
                height: 1.0,
              ),
              const SizedBox(height: 10.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Set for daily',
                    style: AppTextStyles.inter(
                      fontSize: 12.0,
                      fontWeight: FontWeight.w500,
                      color: const Color(0xFF8F7DB5).withOpacity(0.8),
                    ),
                  ),
                  Transform.scale(
                    scale: 0.8,
                    alignment: Alignment.centerRight,
                    child: CupertinoSwitch(
                      value: task.isDaily.value,
                      activeColor: const Color(0xFF7B64B0),
                      onChanged: (value) {
                        controller.toggleDaily(task);
                      },
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      );
    });
  }

  Widget _buildPriorityBadge(String priority) {
    Color bgColor;
    Color textColor;

    switch (priority.toLowerCase()) {
      case 'high':
        bgColor = const Color(0xFFFFF0F0);
        textColor = const Color(0xFFFF6B6B);
        break;
      case 'medium':
        bgColor = const Color(0xFFFFF9E6);
        textColor = const Color(0xFFFFB300);
        break;
      default:
        bgColor = const Color(0xFFF0FFF4);
        textColor = const Color(0xFF2ECC71);
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 4.0),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Text(
        priority,
        style: AppTextStyles.inter(
          fontSize: 11.0,
          fontWeight: FontWeight.w600,
          color: textColor,
        ),
      ),
    );
  }

  Widget _buildCategoryBadge(String category) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 4.0),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F4F8),
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Text(
        category,
        style: AppTextStyles.inter(
          fontSize: 11.0,
          fontWeight: FontWeight.w500,
          color: const Color(0xFF8F7DB5),
        ),
      ),
    );
  }



  Widget _buildPriorityButton(String priority, RxString selectedPriority) {
    return Obx(() {
      final isSelected = selectedPriority.value == priority;
      Color bgColor;
      Color textColor;
      Border? border;

      if (isSelected) {
        border = null;
        switch (priority.toLowerCase()) {
          case 'high':
            bgColor = const Color(0xFFFFF0F0);
            textColor = const Color(0xFFFF6B6B);
            break;
          case 'medium':
            bgColor = const Color(0xFFFFF9E6);
            textColor = const Color(0xFFFFB300);
            break;
          default:
            bgColor = const Color(0xFFF0FFF4);
            textColor = const Color(0xFF2ECC71);
        }
      } else {
        bgColor = Colors.white;
        border = Border.all(color: const Color(0xFFE2DCF7), width: 1.0);
        switch (priority.toLowerCase()) {
          case 'high':
            textColor = const Color(0xFFFF6B6B);
            break;
          case 'medium':
            textColor = const Color(0xFFFFB300);
            break;
          default:
            textColor = const Color(0xFF2ECC71);
        }
      }

      return GestureDetector(
        onTap: () => selectedPriority.value = priority,
        child: Container(
          height: 48,
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(24.0),
            border: border,
          ),
          child: Center(
            child: Text(
              priority,
              style: AppTextStyles.inter(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: textColor,
              ),
            ),
          ),
        ),
      );
    });
  }

  void _showAddTaskBottomSheet(BuildContext context, Todaytaskcontroller controller) {
    final titleController = TextEditingController();
    var selectedPriority = 'High'.obs;

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
              // Header title
              Text(
                "New Task",
                style: AppTextStyles.plusJakartaSans(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  color: const Color(0xFF2E2252),
                ),
              ),
              const SizedBox(height: 20),

              // Text Field: "What needs to be done?"
              TextField(
                controller: titleController,
                decoration: InputDecoration(
                  hintText: "What needs to be done?",
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
              const SizedBox(height: 20),

              // Priority Selection Row: High, Medium, Low
              Row(
                children: [
                  Expanded(child: _buildPriorityButton('High', selectedPriority)),
                  const SizedBox(width: 10),
                  Expanded(child: _buildPriorityButton('Medium', selectedPriority)),
                  const SizedBox(width: 10),
                  Expanded(child: _buildPriorityButton('Low', selectedPriority)),
                ],
              ),
              const SizedBox(height: 24),

              // Action Buttons Row: Cancel and Add Task
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
                            "Please enter what needs to be done.",
                            snackPosition: SnackPosition.BOTTOM,
                            backgroundColor: Colors.redAccent,
                            colorText: Colors.white,
                          );
                          return;
                        }
                        // Add task with smart category and daily options
                        final priority = selectedPriority.value;
                        final isHigh = priority == 'High';
                        controller.addTask(
                          titleController.text.trim(),
                          priority,
                          isHigh ? 'Health' : (priority == 'Medium' ? 'Learning' : 'Mindfulness'),
                          isHigh, // show daily switch if priority is High
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
                            "Add Task",
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
