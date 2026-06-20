import 'package:flutter/material.dart';
import 'package:rosannalie/utils/appString.dart';

class Myjourneycard extends StatelessWidget {
  const Myjourneycard({super.key});

  @override
  Widget build(BuildContext context) {
    final items = [
      _TimelineItemData(
        icon: const Icon(Icons.check, color: Colors.white, size: 16),
        title: "Started my journey",
        subtitle: "Jun 2026",
        isCompleted: true,
      ),
      _TimelineItemData(
        icon: const Icon(Icons.check, color: Colors.white, size: 16),
        title: "First big goal set",
        subtitle: "Jun 2026",
        isCompleted: true,
      ),
      _TimelineItemData(
        icon: const Text("🔥", style: TextStyle(fontSize: 14)),
        title: "7–day streak",
        subtitle: "Upcoming",
        isCompleted: false,
      ),
      _TimelineItemData(
        icon: const Text("⭐", style: TextStyle(fontSize: 14)),
        title: "30–day milestone",
        subtitle: "Jul 2026",
        isCompleted: false,
      ),
      _TimelineItemData(
        icon: const Text("🏆", style: TextStyle(fontSize: 14)),
        title: "First goal complete",
        subtitle: "Aug 2026",
        isCompleted: false,
      ),
    ];

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
                style: TextStyle(fontSize: 16.0),
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
          Column(
            children: List.generate(items.length, (index) {
              final item = items[index];
              final isLast = index == items.length - 1;

              return IntrinsicHeight(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Timeline indicator column (Circle + vertical line)
                    Column(
                      children: [
                        // Circle
                        Container(
                          width: 32.0,
                          height: 32.0,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: item.isCompleted
                                ? const Color(0xFF7B64B0)
                                : const Color(0xFF7B64B0).withValues(alpha: 0.1),
                          ),
                          alignment: Alignment.center,
                          child: item.icon,
                        ),
                        // Connector line (drawn if not last item)
                        if (!isLast)
                          Expanded(
                            child: Container(
                              width: 2.0,
                              color: const Color(0xFF7B64B0).withValues(alpha: 0.15),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(width: 16.0),
                    // Text details column
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 4.0), // vertical alignment offset
                          Text(
                            item.title,
                            style: AppTextStyles.plusJakartaSans(
                              fontSize: 15.0,
                              fontWeight: FontWeight.bold,
                              color: item.isCompleted
                                  ? const Color(0xFF2E2252)
                                  : const Color(0xFF8F7DB5),
                            ),
                          ),
                          const SizedBox(height: 2.0),
                          Text(
                            item.subtitle,
                            style: AppTextStyles.inter(
                              fontSize: 12.0,
                              fontWeight: FontWeight.w500,
                              color: const Color(0xFF8F7DB5).withValues(alpha: 0.7),
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
          ),
        ],
      ),
    );
  }
}

class _TimelineItemData {
  final Widget icon;
  final String title;
  final String subtitle;
  final bool isCompleted;

  _TimelineItemData({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.isCompleted,
  });
}
