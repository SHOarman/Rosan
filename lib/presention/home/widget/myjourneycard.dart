import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rosannalie/core/services/controller/future_me_controller.dart';
import 'package:rosannalie/utils/appString.dart';

class Myjourneycard extends StatelessWidget {
  const Myjourneycard({super.key});

  Widget _getIconWidget(String iconType) {
    switch (iconType.toUpperCase()) {
      case 'CHECK':
        return const Icon(Icons.check, color: Colors.white, size: 16);
      case 'FLAME':
        return const Text("🔥", style: TextStyle(fontSize: 14));
      case 'STAR':
        return const Text("⭐", style: TextStyle(fontSize: 14));
      case 'TROPHY':
        return const Text("🏆", style: TextStyle(fontSize: 14));
      default:
        return const Icon(Icons.check, color: Colors.white, size: 16);
    }
  }

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
          // Header Row
          Row(
            children: [
              const Text(
                "🗺️",
                style: TextStyle(fontSize: 18.0),
              ),
              const SizedBox(width: 8.0),
              Text(
                "My Journey",
                style: AppTextStyles.plusJakartaSans(
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF2E2252),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24.0),
          // Timeline List
          Obx(() {
            if (controller.isLoading.value && controller.journeyList.isEmpty) {
              return const Padding(
                padding: EdgeInsets.all(16.0),
                child: Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF7B64B0)),
                  ),
                ),
              );
            }

            final items = controller.journeyList;

            if (items.isEmpty) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 12.0),
                child: Text(
                  "No journey milestones found",
                  style: AppTextStyles.inter(
                    fontSize: 13.0,
                    fontWeight: FontWeight.w400,
                    color: const Color(0xFF8F7DB5),
                  ),
                ),
              );
            }

            return Column(
              children: List.generate(items.length, (index) {
                final item = items[index];
                final isLast = index == items.length - 1;
                final bool isCompleted = item.status.toUpperCase() == 'COMPLETED';

                return IntrinsicHeight(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Timeline indicator column (Circle + vertical line)
                      Column(
                        children: [
                          // Circle
                          isCompleted
                              ? Container(
                                  width: 34.0,
                                  height: 34.0,
                                  decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    gradient: LinearGradient(
                                      colors: [Color(0xFF9B85CF), Color(0xFF5E4B8B)],
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                    ),
                                  ),
                                  alignment: Alignment.center,
                                  child: _getIconWidget(item.icon),
                                )
                              : CustomPaint(
                                  painter: DashedBorderPainter(color: const Color(0xFFC5B8E8)),
                                  child: Container(
                                    width: 34.0,
                                    height: 34.0,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: const Color(0xFFC5B8E8).withValues(alpha: 0.3),
                                    ),
                                    alignment: Alignment.center,
                                    child: _getIconWidget(item.icon),
                                  ),
                                ),
                          // Connector line (drawn if not last item)
                          if (!isLast)
                            Expanded(
                              child: Container(
                                width: 2.0,
                                color: isCompleted
                                    ? const Color(0xFF9B85CF)
                                    : const Color(0xFFC5B8E8).withValues(alpha: 0.4),
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(width: 16.0),

                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 4.0),
                            Text(
                              item.title,
                              style: AppTextStyles.plusJakartaSans(
                                fontSize: 16.0,
                                fontWeight: FontWeight.bold,
                                color: isCompleted
                                    ? const Color(0xFF2E2252)
                                    : const Color(0xFF8F7DB5),
                              ),
                            ),
                            const SizedBox(height: 2.0),
                            Text(
                              item.date,
                              style: AppTextStyles.plusJakartaSans(
                                fontSize: 12.0,
                                fontWeight: FontWeight.w500,
                                color: const Color(0xFF8F7DB5)
                              ),
                            ),
                            if (!isLast) const SizedBox(height: 20.0),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              }),
            );
          }),
        ],
      ),
    );
  }
}

class DashedBorderPainter extends CustomPainter {
  final Color color;
  final double strokeWidth;

  DashedBorderPainter({required this.color, this.strokeWidth = 1.0});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;

    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - strokeWidth) / 2;

    final double dashLength = 4.0;
    final double gapLength = 2.5;
    final double circumference = 2 * 3.14159 * radius;
    final int count = circumference ~/ (dashLength + gapLength);
    final double step = (3.14159 * 2) / count;

    for (int i = 0; i < count; i++) {
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        i * step,
        (dashLength / (dashLength + gapLength)) * step,
        false,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant DashedBorderPainter oldDelegate) {
    return oldDelegate.color != color || oldDelegate.strokeWidth != strokeWidth;
  }
}
