import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rosannalie/core/route/app_pages.dart';
import 'package:rosannalie/general_widget/custom_background.dart';
import 'package:rosannalie/general_widget/custombutton.dart';
import 'package:rosannalie/presention/onloading/widget/onboarding_header.dart';
import 'package:rosannalie/utils/appString.dart';
import 'package:rosannalie/utils/appcolors.dart';

class Onlading4 extends StatefulWidget {
  const Onlading4({super.key});

  @override
  State<Onlading4> createState() => _Onlading4State();
}

class _Onlading4State extends State<Onlading4> {
  int? selectedIndex;

  void _toggleSelection(int index) {
    setState(() {
      if (selectedIndex == index) {
        selectedIndex = null;
      } else {
        selectedIndex = index;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> goals = [
      {"text": "Build better habits", "emoji": "🌿"},
      {"text": "Hit my goals", "emoji": "🎯"},
      {"text": "Reduce procrastination", "emoji": "⏰"},
      {"text": "Feel more motivated", "emoji": "✨"},
      {"text": "Create daily structure", "emoji": "📅"},
      {"text": "Track progress", "emoji": "📊"},
    ];

    return CustomBackground.onboarding(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            const OnboardingHeader(currentPage: 3),
            const SizedBox(height: 50),
            Text(
              "What do you mainly want to\nuse Rise for?",
              textAlign: TextAlign.start,
              style: AppTextStyles.plusJakartaSans(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF3D2E6B),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              "Pick everything that resonates.",
              textAlign: TextAlign.start,
              style: AppTextStyles.plusJakartaSans(
                color: const Color(0xFF8B7DB5),
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 30),
            
            // First row: side-by-side
            Row(
              children: [
                Expanded(
                  child: GoalPillCard(
                    isExpanded: true,
                    text: goals[0]["text"]!,
                    emoji: goals[0]["emoji"]!,
                    isSelected: selectedIndex == 0,
                    onTap: () => _toggleSelection(0),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: GoalPillCard(
                    isExpanded: true,
                    text: goals[1]["text"]!,
                    emoji: goals[1]["emoji"]!,
                    isSelected: selectedIndex == 1,
                    onTap: () => _toggleSelection(1),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            
            // Remaining rows stacked vertically
            GoalPillCard(
              text: goals[2]["text"]!,
              emoji: goals[2]["emoji"]!,
              isSelected: selectedIndex == 2,
              onTap: () => _toggleSelection(2),
            ),
            const SizedBox(height: 12),
            GoalPillCard(
              text: goals[3]["text"]!,
              emoji: goals[3]["emoji"]!,
              isSelected: selectedIndex == 3,
              onTap: () => _toggleSelection(3),
            ),
            const SizedBox(height: 12),
            GoalPillCard(
              text: goals[4]["text"]!,
              emoji: goals[4]["emoji"]!,
              isSelected: selectedIndex == 4,
              onTap: () => _toggleSelection(4),
            ),
            const SizedBox(height: 12),
            GoalPillCard(
              text: goals[5]["text"]!,
              emoji: goals[5]["emoji"]!,
              isSelected: selectedIndex == 5,
              onTap: () => _toggleSelection(5),
            ),
            
            const SizedBox(height: 120),
            Center(
              child: CustomButton(
                text: "Continue",
                showIcon: true,
                gradientColors: const [
                  AppColors.primarygredent2,
                  AppColors.primarygredent1,
                ],
                isDisabled: selectedIndex == null,
                onTap: () {
                  Get.toNamed(AppRoutes.onborading5);
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

class GoalPillCard extends StatefulWidget {
  final String text;
  final String emoji;
  final bool isSelected;
  final VoidCallback onTap;
  final bool isExpanded;

  const GoalPillCard({
    super.key,
    required this.text,
    required this.emoji,
    required this.isSelected,
    required this.onTap,
    this.isExpanded = false,
  });

  @override
  State<GoalPillCard> createState() => _GoalPillCardState();
}

class _GoalPillCardState extends State<GoalPillCard> with SingleTickerProviderStateMixin {
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
                if (widget.isExpanded)
                  Expanded(
                    child: Text(
                      widget.text,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      style: AppTextStyles.inter(
                        fontSize: 14.0,
                        fontWeight: widget.isSelected ? FontWeight.bold : FontWeight.w500,
                        color: widget.isSelected 
                            ? const Color(0xFF3D2E6B) // Dark purple for active state
                            : const Color(0xFF8F7DB5), // Softer purple for inactive state
                      ),
                    ),
                  )
                else
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
