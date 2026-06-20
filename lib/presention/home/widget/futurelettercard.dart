import 'package:flutter/material.dart';
import 'package:rosannalie/utils/appString.dart';

class Futurelettercard extends StatelessWidget {
  const Futurelettercard({super.key});

  @override
  Widget build(BuildContext context) {
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
                "Letter to Future Me",
                style: AppTextStyles.plusJakartaSans(
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF2E2252),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16.0),
          // Action Button: Write a letter
          GestureDetector(
            onTap: () {
              print("Write Letter Clicked!");
            },
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.6),
                borderRadius: BorderRadius.circular(16.0),
                border: Border.all(
                  color: const Color(0xFFDDD0FF),
                  width: 1.0,
                ),
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
        ],
      ),
    );
  }
}
