import 'package:flutter/material.dart';
import 'package:rosannalie/utils/appString.dart';

class MiniCard extends StatefulWidget {
  final String text;
  final String? emoji;
  final String? imageAsset;
  final Widget? leading;
  final bool isSelected;
  final VoidCallback onTap;
  final double? width;
  final double height;

  const MiniCard({
    super.key,
    required this.text,
    required this.onTap,
    this.emoji,
    this.imageAsset,
    this.leading,
    this.isSelected = false,
    this.width = 169.0,
    this.height = 40.0,
  });

  @override
  State<MiniCard> createState() => _MiniCardState();
}

class _MiniCardState extends State<MiniCard> with SingleTickerProviderStateMixin {
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
            width: widget.width,
            height: widget.height,
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(100.0), // Rounded pill shape
              color: widget.isSelected ? null : unselectedColor,
              gradient: widget.isSelected ? selectedGradient : null,
              border: widget.isSelected ? selectedBorder : unselectedBorder,
              boxShadow: widget.isSelected ? selectedBoxShadow : [],
            ),
            child: Center(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: Text(
                      widget.text,
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.inter(
                        fontSize: 14.0,
                        fontWeight: widget.isSelected ? FontWeight.bold : FontWeight.w500,
                        color: widget.isSelected 
                            ? const Color(0xFF3D2E6B) // Dark purple for active state
                            : const Color(0xFF8F7DB5), // Softer purple for inactive state
                      ),
                    ),
                  ),
                  if (widget.leading != null) ...[
                    const SizedBox(width: 8.0),
                    widget.leading!,
                  ] else if (widget.imageAsset != null) ...[
                    const SizedBox(width: 8.0),
                    Image.asset(
                      widget.imageAsset!,
                      width: 16.0,
                      height: 16.0,
                      fit: BoxFit.contain,
                    ),
                  ] else if (widget.emoji != null) ...[
                    const SizedBox(width: 8.0),
                    Text(
                      widget.emoji!,
                      style: const TextStyle(
                        fontSize: 16.0,
                        height: 1.2,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
