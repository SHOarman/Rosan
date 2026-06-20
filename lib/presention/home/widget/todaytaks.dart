import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rosannalie/core/services/controller/todaytaskcontroller.dart';
import 'package:rosannalie/utils/appString.dart';

class TodayTasks extends StatelessWidget {
  const TodayTasks({super.key});

  @override
  Widget build(BuildContext context) {
    final Todaytaskcontroller controller = Get.find<Todaytaskcontroller>();

    return Obx(() {
      final tasks = controller.tasks;
      final int doneCount = controller.doneCount;
      final double progressPercentage = controller.progressPercentage;

      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.8),
          borderRadius: BorderRadius.circular(20.0),
          border: Border.all(
            color: Colors.white.withOpacity(0.9),
            width: 1.0,
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
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Progress Section
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
            const SizedBox(height: 16.0),
            // Tasks List
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: tasks.length > 3 ? 3 : tasks.length, // Show top 3 as preview
              separatorBuilder: (context, index) => Divider(
                height: 1.0,
                thickness: 1.0,
                color: const Color(0xFF8F7DB5).withOpacity(0.1),
              ),
              itemBuilder: (context, index) {
                final task = tasks[index];

                return InkWell(
                  onTap: () => controller.toggleTask(task),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12.0),
                    child: Row(
                      children: [
                        // Checkbox
                        Obx(() {
                          return AnimatedContainer(
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
                          );
                        }),
                        const SizedBox(width: 12.0),
                        // Task Title
                        Expanded(
                          child: Obx(() {
                            return Text(
                              task.title,
                              style: AppTextStyles.inter(
                                fontSize: 14.0,
                                fontWeight: task.isCompleted.value
                                    ? FontWeight.w500
                                    : FontWeight.w600,
                                color: task.isCompleted.value
                                    ? const Color(0xFF8F7DB5)
                                    : const Color(0xFF2E2252),
                              ).copyWith(
                                decoration: task.isCompleted.value
                                    ? TextDecoration.lineThrough
                                    : TextDecoration.none,
                              ),
                            );
                          }),
                        ),
                        const SizedBox(width: 8.0),
                        // Priority Badge
                        _buildPriorityBadge(task.priority),
                      ],
                    ),
                  ),
                );
              },
            ),
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
}
