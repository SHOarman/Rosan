import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:rosannalie/utils/appString.dart';

class LogoutCard extends StatelessWidget {
  final VoidCallback? onTap;

  const LogoutCard({
    super.key,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 350.0,
      height: 52.0,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.8),
        borderRadius: BorderRadius.circular(16.0),
        border: Border(
          top: BorderSide(color: Colors.white.withOpacity(0.9), width: 1.0),
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF6C586D).withOpacity(0.05),
            blurRadius: 32.0,
            spreadRadius: 0,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SvgPicture.asset(
                "assets/images/Icon (8).svg",
                colorFilter: const ColorFilter.mode(
                  Color(0xFFEF4444),
                  BlendMode.srcIn,
                ),
                width: 20.0,
                height: 20.0,
              ),
              const SizedBox(width: 8.0),
              Text(
                "Log Out",
                style: AppTextStyles.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFFEF4444),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
