import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:rosannalie/utils/appString.dart';

class CustomCard extends StatefulWidget {
  final String text;
  final String? emoji;
  final Widget? leading;
  final String? imageAsset;
  final VoidCallback? onTap;
  final double? width;
  final double? height;
  final TextStyle? textStyle;
  final Color? backgroundColor;
  final Color? borderColor;
  final double borderRadius;

  const CustomCard({
    super.key,
    required this.text,
    this.emoji,
    this.leading,
    this.imageAsset,
    this.onTap,
    this.width = 350.0, // Default width as per UI spec (350px)
    this.height = 56.0,  // Default height as per UI spec (56px)
    this.textStyle,
    this.backgroundColor,
    this.borderColor,
    this.borderRadius = 14.0, // Default radius as per UI spec (14px)
  });

  @override
  State<CustomCard> createState() => _CustomCardState();
}

class _CustomCardState extends State<CustomCard> with SingleTickerProviderStateMixin {
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
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.98).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTapDown(TapDownDetails details) {
    if (widget.onTap != null) {
      _controller.forward();
    }
  }

  void _handleTapUp(TapUpDetails details) {
    if (widget.onTap != null) {
      _controller.reverse();
      widget.onTap!();
    }
  }

  void _handleTapCancel() {
    if (widget.onTap != null) {
      _controller.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isClickable = widget.onTap != null;

    Widget cardContent = Container(
      width: widget.width,
      height: widget.height,
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      decoration: BoxDecoration(
        color: widget.backgroundColor ?? Colors.white.withValues(alpha: 0.65),
        borderRadius: BorderRadius.circular(widget.borderRadius),
        border: Border.all(
          color: widget.borderColor ?? Colors.white.withValues(alpha: 0.90),
          width: 1.0,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (widget.leading != null) ...[
            widget.leading!,
            const SizedBox(width: 12.0),
          ] else if (widget.imageAsset != null) ...[
            Image.asset(
              widget.imageAsset!,
              width: 24.0,
              height: 24.0,
              fit: BoxFit.contain,
            ),
            const SizedBox(width: 12.0),
          ] else if (widget.emoji != null) ...[
            Text(
              widget.emoji!,
              style: const TextStyle(
                fontSize: 20.0,
                height: 1.2,
              ),
            ),
            const SizedBox(width: 12.0),
          ],
          Expanded(
            child: Text(
              widget.text,
              style: widget.textStyle ?? AppTextStyles.plusJakartaSans(
                fontSize: 16.0,
                fontWeight: FontWeight.w500,
                color: const Color(0xFF2E2252), // Beautiful deep purple color from UI
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );

    // If clickable, wrap with GestureDetector and scale animation
    if (isClickable) {
      cardContent = GestureDetector(
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
          child: cardContent,
        ),
      );
    }

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: isClickable ? SystemMouseCursors.click : SystemMouseCursors.basic,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(widget.borderRadius),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF4A3870).withValues(alpha: _isHovered ? 0.15 : 0.10),
              offset: Offset(0, _isHovered ? 12.0 : 8.0),
              blurRadius: _isHovered ? 40.0 : 32.0,
              spreadRadius: 0,
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(widget.borderRadius),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
            child: cardContent,
          ),
        ),
      ),
    );
  }
}
