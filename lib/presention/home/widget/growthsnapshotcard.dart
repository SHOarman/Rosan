import 'package:flutter/material.dart';
import 'package:rosannalie/utils/appString.dart';

class Growthsnapshotcard extends StatelessWidget {
  const Growthsnapshotcard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18.0),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.65),
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
          // Header Row
          Row(
            children: [
              const Text(
                "📊",
                style: TextStyle(fontSize: 16.0),
              ),
              const SizedBox(width: 8.0),
              Text(
                "Growth Snapshot",
                style: AppTextStyles.plusJakartaSans(
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF2E2252),
                ),
              ),
            ],
          ),
          const SizedBox(height: 18.0),
          // Metrics Row
          Row(
            children: [
              Expanded(
                child: _buildMetricItem(
                  emoji: "📅",
                  value: "2",
                  label: "Days active",
                ),
              ),
              const SizedBox(width: 12.0),
              Expanded(
                child: _buildMetricItem(
                  emoji: "✅",
                  value: "4",
                  label: "Tasks done",
                ),
              ),
              const SizedBox(width: 12.0),
              Expanded(
                child: _buildMetricItem(
                  emoji: "🎯",
                  value: "1",
                  label: "Goals set",
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMetricItem({
    required String emoji,
    required String value,
    required String label,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 8.0),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.8),
        borderRadius: BorderRadius.circular(16.0),
        border: Border.all(
          color: const Color(0xFFE2DCF7).withValues(alpha: 0.5),
          width: 1.0,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            emoji,
            style: const TextStyle(fontSize: 22.0),
          ),
          const SizedBox(height: 8.0),
          Text(
            value,
            style: AppTextStyles.plusJakartaSans(
              fontSize: 22.0,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF2E2252),
            ),
          ),
          const SizedBox(height: 4.0),
          Text(
            label,
            style: AppTextStyles.inter(
              fontSize: 11.0,
              fontWeight: FontWeight.w500,
              color: const Color(0xFF8F7DB5),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
