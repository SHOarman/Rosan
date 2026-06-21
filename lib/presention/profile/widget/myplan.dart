import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:rosannalie/utils/appString.dart';

class MyPlan extends StatelessWidget {
  final VoidCallback? onTap;

  const MyPlan({
    super.key,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.8),
        borderRadius: BorderRadius.circular(20.0),
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
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20.0),
        child: Container(
          height: 65.0,
          padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 14.0),
          child: Row(
            children: [
              // Icon Container with SVG
              Container(
                width: 38.0,
                height: 38.0,
                decoration: BoxDecoration(
                  color: const Color(0xFFF6F5FB),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                alignment: Alignment.center,
                child: SvgPicture.asset(
                  "assets/images/Icon (2).svg",
                  colorFilter: const ColorFilter.mode(
                    Color(0xFF575B61),
                    BlendMode.srcIn,
                  ),
                  width: 20.0,
                  height: 20.0,
                ),
              ),
              const SizedBox(width: 12.0),
              // Text Label
              Expanded(
                child: Text(
                  "My Plan",
                  style: AppTextStyles.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF161022),
                  ),
                ),
              ),
              // Pro Badge
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 6.0),
                decoration: BoxDecoration(
                  color: const Color(0xFFEFE8FF),
                  borderRadius: BorderRadius.circular(20.0),
                ),
                child: Text(
                  "Pro",
                  style: AppTextStyles.inter(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF7B64B0),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
