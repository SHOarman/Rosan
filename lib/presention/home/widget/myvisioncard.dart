import 'package:flutter/material.dart';
import 'package:rosannalie/utils/appString.dart';

class Myvisioncard extends StatelessWidget {
  const Myvisioncard({super.key});

  @override
  Widget build(BuildContext context) {
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
          // Header: Emoji + Title and Edit Button
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Text(
                    "🌟",
                    style: TextStyle(fontSize: 16.0),
                  ),
                  const SizedBox(width: 8.0),
                  Text(
                    "My Vision",
                    style: AppTextStyles.plusJakartaSans(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF2E2252),
                    ),
                  ),
                ],
              ),
              GestureDetector(
                onTap: () {
                  // Action for edit
                  print("Edit Vision Clicked!");
                },
                child: Text(
                  "Edit",
                  style: AppTextStyles.plusJakartaSans(
                    fontSize: 14.0,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF7B64B0),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16.0),
          // Vision Text (Italicized)
          Text(
            "In 5 years, I'm living with purpose and freedom. I've launched my own business, I'm healthy and energized, and I spend meaningful time with the people I love.",
            style: AppTextStyles.plusJakartaSans(
              fontSize: 15.0,
              fontWeight: FontWeight.w500,
              color: const Color(0xFF7A68A6),
            ).copyWith(
              fontStyle: FontStyle.italic,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}
