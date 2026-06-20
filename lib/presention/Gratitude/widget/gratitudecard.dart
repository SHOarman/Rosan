import 'package:flutter/material.dart';
import 'package:rosannalie/utils/appString.dart';

class Gratitudecard extends StatelessWidget {
  final VoidCallback? onAddTap;
  const Gratitudecard({super.key, this.onAddTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFFC5B8E8),
            Color(0xFFFFD7C3),
          ],
        ),
        borderRadius: BorderRadius.circular(20.0),
        border:  Border.all(
          color: Color(0xFFFFFFFF),
          width: 1.0,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF4A3870).withValues(alpha: 0.1),
            offset: const Offset(0, 8),
            blurRadius: 32.0,
            spreadRadius: 0,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header row: icon + label
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color(0xFF79479C),
                      Color(0xFFAC6262),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
                alignment: Alignment.center,
                child: const Text(
                  '✨',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Text(
                'MOMENT OF GRATITUDE',
                style: AppTextStyles.plusJakartaSans(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF575B61),
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Question text
          Text(
            'What are you grateful for right now?',
            style: AppTextStyles.plusJakartaSans(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF3D2E6B),
            ),
          ),

          const SizedBox(height: 20),

          // Add gratitude note button
          GestureDetector(
            onTap: onAddTap,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 14),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.75),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.add,
                    color: Color(0xFF7B64B0),
                    size: 18,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    'Add a gratitude note',
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
        ],
      ),
    );
  }
}
