import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rosannalie/core/route/app_pages.dart';
import 'package:rosannalie/general_widget/custom_background.dart';
import 'package:rosannalie/general_widget/custombutton.dart';
import 'package:rosannalie/presention/onloading/widget/onboarding_header.dart';
import 'package:rosannalie/utils/appString.dart';
import 'package:rosannalie/utils/appcolors.dart';

class Onlading9 extends StatefulWidget {
  const Onlading9({super.key});

  @override
  State<Onlading9> createState() => _Onlading9State();
}

class _Onlading9State extends State<Onlading9> {
  final Set<int> selectedIndices = {};

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> styles = [
      {"text": "Gentle nudges", "emoji": "🤗"},
      {"text": "Friendly accountability", "emoji": "🤝"},
      {"text": "Bold challenges", "emoji": "🔥"},
      {"text": "Inspirational quotes", "emoji": "✨"},
      {"text": "Data & progress", "emoji": "📊"},
    ];

    return CustomBackground.onboarding(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            const OnboardingHeader(currentPage: 8),
            const SizedBox(height: 50),
            Text(
              "How do you want to be\nmotivated?",
              textAlign: TextAlign.start,
              style: AppTextStyles.plusJakartaSans(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF3D2E6B),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              "We'll adjust our coaching style for you.",
              textAlign: TextAlign.start,
              style: AppTextStyles.plusJakartaSans(
                color: const Color(0xFF8B7DB5),
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 40),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: List.generate(styles.length, (index) {
                final item = styles[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12.0),
                  child: MotivatedPillCard(
                    text: item["text"]!,
                    emoji: item["emoji"]!,
                    isSelected: selectedIndices.contains(index),
                    onTap: () {
                      setState(() {
                        if (selectedIndices.contains(index)) {
                          selectedIndices.remove(index);
                        } else {
                          selectedIndices.add(index);
                        }
                      });
                    },
                  ),
                );
              }),
            ),
            const SizedBox(height: 100),
            Center(
              child: CustomButton(
                text: "Continue",
                showIcon: true,
                gradientColors: const [
                  AppColors.primarygredent2,
                  AppColors.primarygredent1,
                ],
                isDisabled: selectedIndices.isEmpty,
                onTap: () {
                  Get.toNamed(AppRoutes.onborading10);
                },
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

class MotivatedPillCard extends StatefulWidget {
  final String text;
  final String emoji;
  final bool isSelected;
  final VoidCallback onTap;

  const MotivatedPillCard({
    super.key,
    required this.text,
    required this.emoji,
    required this.isSelected,
    required this.onTap,
  });

  @override
  State<MotivatedPillCard> createState() => _MotivatedPillCardState();
}

class _MotivatedPillCardState extends State<MotivatedPillCard> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  bool _isHovered = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.96).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTapDown(TapDownDetails details) {
    _controller.forward();
  }

  void _handleTapUp(TapUpDetails details) {
    _controller.reverse();
    widget.onTap();
  }

  void _handleTapCancel() {
    _controller.reverse();
  }

  @override
  Widget build(BuildContext context) {
    // Selected states
    final selectedGradient = LinearGradient(
      colors: [
        const Color(0xFF7B64B0).withValues(alpha: 0.19),
        const Color(0xFF7B64B0).withValues(alpha: 0.314),
      ],
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
    );

    final selectedBoxShadow = [
      BoxShadow(
        color: const Color(0xFF7B64B0).withValues(alpha: 0.145),
        offset: const Offset(0, 4),
        blurRadius: _isHovered ? 16 : 12,
        spreadRadius: 0,
      ),
    ];

    // Unselected states
    final unselectedColor = Colors.white.withValues(alpha: 0.55);
    final unselectedBorder = Border.all(
      color: _isHovered ? const Color(0xFF7B64B0) : const Color(0xFFC5B8E8),
      width: 1.0,
    );

    final selectedBorder = Border.all(
      color: const Color(0xFF7B64B0).withValues(alpha: 0.3),
      width: 1.0,
    );

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTapDown: _handleTapDown,
        onTapUp: _handleTapUp,
        onTapCancel: _handleTapCancel,
        child: AnimatedBuilder(
          animation: _scaleAnimation,
          builder: (context, child) {
            return Transform.scale(
              scale: _scaleAnimation.value,
              child: child,
            );
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(100.0), // Rounded pill shape
              color: widget.isSelected ? null : unselectedColor,
              gradient: widget.isSelected ? selectedGradient : null,
              border: widget.isSelected ? selectedBorder : unselectedBorder,
              boxShadow: widget.isSelected ? selectedBoxShadow : [],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  widget.emoji,
                  style: const TextStyle(
                    fontSize: 16.0,
                    height: 1.2,
                  ),
                ),
                const SizedBox(width: 8.0),
                Text(
                  widget.text,
                  style: AppTextStyles.inter(
                    fontSize: 14.0,
                    fontWeight: widget.isSelected ? FontWeight.bold : FontWeight.w500,
                    color: widget.isSelected 
                        ? const Color(0xFF3D2E6B) // Dark purple for active state
                        : const Color(0xFF8F7DB5), // Softer purple for inactive state
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
