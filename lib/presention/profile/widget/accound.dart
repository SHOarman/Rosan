import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:rosannalie/utils/appString.dart';

class Accound extends StatelessWidget {
  final VoidCallback? onTapEditProfile;
  final VoidCallback? onTapNotifications;

  const Accound({
    super.key,
    this.onTapEditProfile,
    this.onTapNotifications,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 350.0,
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
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Edit Profile Item
          _buildMenuItem(
            svgPath: "assets/images/Icon.svg",
            title: "Edit Profile",
            onTap: onTapEditProfile,
            isTopRounded: true,
            isBottomRounded: false,
          ),
          // Divider
          const Divider(
            height: 1.0,
            thickness: 1.0,
            color: Color(0xFFE3E7EB),
            indent: 12.0,
            endIndent: 12.0,
          ),
          // Notifications Item
          _buildMenuItem(
            svgPath: "assets/images/Icon (1).svg",
            title: "Notifications",
            onTap: onTapNotifications,
            isTopRounded: false,
            isBottomRounded: true,
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem({
    required String svgPath,
    required String title,
    required VoidCallback? onTap,
    required bool isTopRounded,
    required bool isBottomRounded,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.only(
        topLeft: isTopRounded ? const Radius.circular(20.0) : Radius.zero,
        topRight: isTopRounded ? const Radius.circular(20.0) : Radius.zero,
        bottomLeft: isBottomRounded ? const Radius.circular(20.0) : Radius.zero,
        bottomRight: isBottomRounded ? const Radius.circular(20.0) : Radius.zero,
      ),
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
                svgPath,
                colorFilter: const ColorFilter.mode(
                  Color(0xFF7B64B0),
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
                title,
                style: AppTextStyles.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF161022),
                ),
              ),
            ),
            // Chevron Right Icon
            const Icon(
              Icons.chevron_right,
              color: Color(0xFF8F7DB5),
              size: 20.0,
            ),
          ],
        ),
      ),
    );
  }
}
