import 'package:flutter/material.dart';
import 'package:rosannalie/utils/appString.dart';

class CustomTextField extends StatefulWidget {
  final TextEditingController? controller;
  final String labelText;
  final String? hintText;
  final bool isPassword;
  final TextInputType keyboardType;
  final String? Function(String?)? validator;
  final ValueChanged<String>? onChanged;

  const CustomTextField({
    super.key,
    this.controller,
    required this.labelText,
    this.hintText,
    this.isPassword = false,
    this.keyboardType = TextInputType.text,
    this.validator,
    this.onChanged,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  late bool _obscureText;
  final FocusNode _focusNode = FocusNode();
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.isPassword;
    _focusNode.addListener(() {
      setState(() {
        _isFocused = _focusNode.hasFocus;
      });
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final activeGradient = const LinearGradient(
      colors: [
        Color(0xFF9B85CF),
        Color(0xFF5E4B8B),
      ],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    );

    return TextFormField(
      controller: widget.controller,
      focusNode: _focusNode,
      obscureText: _obscureText,
      keyboardType: widget.keyboardType,
      validator: widget.validator,
      onChanged: widget.onChanged,
      style: AppTextStyles.plusJakartaSans(
        color: const Color(0xFF2E2252),
        fontSize: 16,
        fontWeight: FontWeight.w500,
      ),
      decoration: InputDecoration(
        labelText: widget.labelText,
        labelStyle: AppTextStyles.plusJakartaSans(
          color: _isFocused ? const Color(0xFF5E4B8B) : const Color(0xFF8B7DB5),
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
        hintText: widget.hintText,
        hintStyle: AppTextStyles.plusJakartaSans(
          color: const Color(0xFF8B7DB5).withValues(alpha: 0.5),
          fontSize: 15,
        ),
        fillColor: Colors.white.withValues(alpha: 0.55),
        filled: true,
        contentPadding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: BorderSide(
            color: const Color(0xFFC5B8E8).withValues(alpha: 0.5),
            width: 1.0,
          ),
        ),
        focusedBorder: GradientOutlineInputBorder(
          gradient: activeGradient,
          width: 1.5,
          borderRadius: BorderRadius.circular(12.0),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: const BorderSide(
            color: Colors.red,
            width: 1.0,
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: const BorderSide(
            color: Colors.red,
            width: 1.5,
          ),
        ),
        suffixIcon: widget.isPassword
            ? IconButton(
                icon: Icon(
                  _obscureText ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                  color: const Color(0xFF8B7DB5),
                  size: 22,
                ),
                onPressed: () {
                  setState(() {
                    _obscureText = !_obscureText;
                  });
                },
              )
            : null,
      ),
    );
  }
}

class GradientOutlineInputBorder extends OutlineInputBorder {
  final Gradient gradient;
  final double width;

  const GradientOutlineInputBorder({
    required this.gradient,
    this.width = 1.0,
    super.borderRadius = const BorderRadius.all(Radius.circular(12.0)),
    super.borderSide = BorderSide.none,
  });

  @override
  void paint(
    Canvas canvas,
    Rect rect, {
    double? gapStart,
    double gapExtent = 0.0,
    double gapPercentage = 0.0,
    TextDirection? textDirection,
  }) {
    final Paint paint = Paint()
      ..shader = gradient.createShader(rect)
      ..style = PaintingStyle.stroke
      ..strokeWidth = width;

    final double R = borderRadius.topLeft.x;
    final double top = rect.top;
    final double bottom = rect.bottom;
    final double left = rect.left;
    final double right = rect.right;

    final Path path = Path();

    if (gapPercentage <= 0.0 || gapStart == null || gapExtent <= 0.0) {
      path.addRRect(RRect.fromRectAndRadius(rect, Radius.circular(R)));
    } else {
      final double gapLeft = gapStart;
      final double gapRight = gapStart + gapExtent * gapPercentage;

      path.moveTo(gapRight, top);
      path.lineTo(right - R, top);
      path.arcToPoint(Offset(right, top + R), radius: Radius.circular(R));
      path.lineTo(right, bottom - R);
      path.arcToPoint(Offset(right - R, bottom), radius: Radius.circular(R));
      path.lineTo(left + R, bottom);
      path.arcToPoint(Offset(left, bottom - R), radius: Radius.circular(R));
      path.lineTo(left, top + R);
      path.arcToPoint(Offset(left + R, top), radius: Radius.circular(R));
      path.lineTo(gapLeft, top);
    }

    canvas.drawPath(path, paint);
  }
}
