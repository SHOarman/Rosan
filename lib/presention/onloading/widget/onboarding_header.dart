import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rosannalie/utils/appString.dart';

class OnboardingHeader extends StatelessWidget {
  final int currentPage; // 1 to 12
  final int totalPages;   // Default is 12

  const OnboardingHeader({
    super.key,
    required this.currentPage,
    this.totalPages = 12,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        if (currentPage > 1) ...[
          GestureDetector(
            onTap: () {
              Get.back();
            },
            child: Container(
              width: 36.0,
              height: 36.0,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.08),
                    blurRadius: 8.0,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: const Center(
                child: Icon(
                  Icons.chevron_left_rounded,
                  color: Color(0xFF2E2252),
                  size: 22,
                ),
              ),
            ),
          ),
          const SizedBox(width: 16.0),
        ],
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(100.0),
            child: Container(
              height: 6.0,
              color: const Color(0xFFEADBFC).withValues(alpha: 0.6), // Light lavender track
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final fillWidth = constraints.maxWidth * (currentPage / totalPages);
                  return Align(
                    alignment: Alignment.centerLeft,
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      width: fillWidth,
                      height: 6.0,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100.0),
                        gradient: const LinearGradient(
                          colors: [
                            Color(0xFF9B85CF),
                            Color(0xFF5E4B8B),
                          ],
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ),
        const SizedBox(width: 16.0),
        Text(
          "$currentPage/$totalPages",
          style: AppTextStyles.plusJakartaSans(
            fontSize: 13.0,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF8B7DB5),
          ),
        ),
      ],
    );
  }
}
