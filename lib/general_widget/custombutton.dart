import 'package:flutter/material.dart';
import 'package:rosannalie/utils/appString.dart';
import '../utils/appcolors.dart';

class CustomButton extends StatefulWidget {
  final String text;
  final VoidCallback? onTap;
  final bool showIcon;
  final Widget? icon;
  final bool isIconLeft;
  final double? width;
  final double height;
  final double borderRadius;
  final List<Color>? gradientColors;
  final TextStyle? textStyle;
  final bool isDisabled;

  const CustomButton({
    super.key,
    required this.text,
    this.onTap,
    this.showIcon = false,
    this.icon,
    this.isIconLeft = false,
    this.width = double.infinity,
    this.height = 48.0,
    this.borderRadius = 14.0,
    this.gradientColors,
    this.textStyle,
    this.isDisabled = false,
  });

  @override
  State<CustomButton> createState() => _CustomButtonState();
}

class _CustomButtonState extends State<CustomButton>
    with SingleTickerProviderStateMixin {
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
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.96,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTapDown(TapDownDetails details) {
    if (!widget.isDisabled && widget.onTap != null) {
      _controller.forward();
    }
  }

  void _handleTapUp(TapUpDetails details) {
    if (!widget.isDisabled && widget.onTap != null) {
      _controller.reverse();
      widget.onTap!();
    }
  }

  void _handleTapCancel() {
    if (!widget.isDisabled && widget.onTap != null) {
      _controller.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool hasEffectiveIcon = widget.showIcon || widget.icon != null;
    final bool isButtonDisabled = widget.isDisabled || widget.onTap == null;

    final defaultGradient = LinearGradient(
      colors:
          widget.gradientColors ??
          [AppColors.primarygredent2, AppColors.primarygredent1],
      begin: Alignment.centerLeft,
      end: Alignment.centerRight,
    );

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: isButtonDisabled
          ? SystemMouseCursors.forbidden
          : SystemMouseCursors.click,
      child: GestureDetector(
        onTapDown: _handleTapDown,
        onTapUp: _handleTapUp,
        onTapCancel: _handleTapCancel,
        child: AnimatedBuilder(
          animation: _scaleAnimation,
          builder: (context, child) {
            return Transform.scale(scale: _scaleAnimation.value, child: child);
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: widget.width,
            height: widget.height,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(widget.borderRadius),
              gradient: isButtonDisabled
                  ? LinearGradient(
                      colors: [Colors.grey.shade400, Colors.grey.shade500],
                    )
                  : defaultGradient,
              boxShadow: isButtonDisabled
                  ? []
                  : [
                      BoxShadow(
                        color:
                            (widget.gradientColors?.first ??
                                    AppColors.primarygredent2)
                                .withValues(alpha: 0.3),
                        blurRadius: _isHovered ? 12.0 : 8.0,
                        offset: Offset(0, _isHovered ? 4.0 : 2.0),
                      ),
                    ],
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 12.0,
                vertical: 14.0,
              ),
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (hasEffectiveIcon && widget.isIconLeft) ...[
                      widget.icon ??
                          const Icon(
                            Icons.arrow_forward_rounded,
                            color: Colors.white,
                            size: 20,
                          ),
                      const SizedBox(width: 10),
                    ],
                    Text(
                      widget.text,
                      style:
                          widget.textStyle ??
                          AppTextStyles.plusJakartaSans(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                    ),
                    if (hasEffectiveIcon && !widget.isIconLeft) ...[
                      const SizedBox(width: 10),
                      widget.icon ??
                          const Icon(
                            Icons.arrow_forward_rounded,
                            color: Colors.white,
                            size: 20,
                          ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
