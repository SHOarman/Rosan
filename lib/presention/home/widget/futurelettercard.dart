import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rosannalie/core/services/controller/future_me_controller.dart';
import 'package:rosannalie/utils/appString.dart';

class Futurelettercard extends StatelessWidget {
  const Futurelettercard({super.key});

  void _showWriteLetterBottomSheet(BuildContext context, FutureMeController controller) {
    final textController = TextEditingController();
    DateTime selectedDate = DateTime(DateTime.now().year, 12, 31);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setModalState) {
          return Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom + MediaQuery.of(context).padding.bottom,
            ),
            child: Container(
              padding: const EdgeInsets.all(24.0),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(28.0)),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Letter to Future Self ✉️",
                        style: AppTextStyles.plusJakartaSans(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF3D2E6B),
                        ),
                      ),
                      IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(Icons.close, color: Color(0xFF8F7DB5)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16.0),
                  Text(
                    "Write your message:",
                    style: AppTextStyles.plusJakartaSans(
                      fontSize: 14.0,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF575B61),
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  TextField(
                    controller: textController,
                    maxLines: 4,
                    decoration: InputDecoration(
                      hintText: "Remember why you started Rise: consistency leads to mastery!",
                      hintStyle: AppTextStyles.inter(
                        fontSize: 14.0,
                        color: const Color(0xFFB0A5C8),
                      ),
                      filled: true,
                      fillColor: const Color(0xFFF9F7FC),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16.0),
                        borderSide: const BorderSide(color: Color(0xFFE2DCF7)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16.0),
                        borderSide: const BorderSide(color: Color(0xFF7B64B0), width: 1.5),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Unlock Date:",
                        style: AppTextStyles.plusJakartaSans(
                          fontSize: 14.0,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF575B61),
                        ),
                      ),
                      TextButton.icon(
                        onPressed: () async {
                          final picked = await showDatePicker(
                            context: context,
                            initialDate: selectedDate,
                            firstDate: DateTime.now(),
                            lastDate: DateTime(2035),
                          );
                          if (picked != null) {
                            setModalState(() {
                              selectedDate = picked;
                            });
                          }
                        },
                        icon: const Icon(Icons.calendar_today, size: 16, color: Color(0xFF7B64B0)),
                        label: Text(
                          "${selectedDate.day}/${selectedDate.month}/${selectedDate.year}",
                          style: AppTextStyles.inter(
                            fontSize: 14.0,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF7B64B0),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20.0),
                  Obx(() => SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: controller.isSavingLetter.value
                          ? null
                          : () async {
                              final success = await controller.createLetter(
                                content: textController.text,
                                unlockAt: selectedDate,
                              );
                              if (success && context.mounted) {
                                Navigator.pop(context);
                              }
                            },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF7B64B0),
                        padding: const EdgeInsets.symmetric(vertical: 16.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16.0),
                        ),
                      ),
                      child: controller.isSavingLetter.value
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            )
                          : Text(
                              "Send to Future Self ✨",
                              style: AppTextStyles.plusJakartaSans(
                                fontSize: 16.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                    ),
                  )),
                ],
              ),
            ),
          );
        },
      ),
    );
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
        gradient: LinearGradient(
          colors: [
            const Color(0xFFFFD4B5).withValues(alpha: 0.40),
            const Color(0xFFFFC0C0).withValues(alpha: 0.35),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
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
          // Header: Emoji + Title
          Row(
            children: [
              const Text(
                "✉️",
                style: TextStyle(fontSize: 16.0),
              ),
              const SizedBox(width: 8.0),
              Text(
                "Letter to future me",
                style: AppTextStyles.plusJakartaSans(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF3D2E6B),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16.0),



          // Action Button: Write a letter
          GestureDetector(
            onTap: () => _showWriteLetterBottomSheet(context, controller),
            child: CustomPaint(
              painter: DashedRectPainter(
                color: const Color(0xFFC5B8E8),
                strokeWidth: 1.0,
                radius: 14.0,
              ),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(14.0),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.4),
                  borderRadius: BorderRadius.circular(14.0),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "✍️",
                      style: TextStyle(fontSize: 16.0),
                    ),
                    const SizedBox(width: 8.0),
                    Text(
                      "Write a letter to your future self",
                      style: AppTextStyles.plusJakartaSans(
                        fontSize: 14.0,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF7B64B0),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class DashedRectPainter extends CustomPainter {
  final Color color;
  final double strokeWidth;
  final double radius;

  DashedRectPainter({
    required this.color,
    required this.strokeWidth,
    required this.radius,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    final rect = Rect.fromLTWH(0, 0, size.width, size.height);
    final rrect = RRect.fromRectAndRadius(rect, Radius.circular(radius));

    final path = Path()..addRRect(rrect);

    final dashPath = Path();
    final dashArray = <double>[4.0, 4.0];
    for (final metric in path.computeMetrics()) {
      double distance = 0.0;
      int index = 0;
      while (distance < metric.length) {
        final len = dashArray[index % dashArray.length];
        if (index % 2 == 0) {
          dashPath.addPath(
            metric.extractPath(distance, distance + len),
            Offset.zero,
          );
        }
        distance += len;
        index++;
      }
    }

    canvas.drawPath(dashPath, paint);
  }

  @override
  bool shouldRepaint(covariant DashedRectPainter oldDelegate) {
    return oldDelegate.color != color ||
        oldDelegate.strokeWidth != strokeWidth ||
        oldDelegate.radius != radius;
  }
}
