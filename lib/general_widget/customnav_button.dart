import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:rosannalie/core/route/app_pages.dart';
import 'package:rosannalie/utils/appString.dart';

class CustomBottomNavBar extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int>? onTap;

  const CustomBottomNavBar({
    super.key,
    required this.selectedIndex,
    this.onTap,
  });

  static const _navItems = [
    _NavItem(
      activeIcon: 'assets/icon/activehome.svg',
      inactiveIcon: 'assets/icon/inactivehome.svg',
      label: 'Home',
      route: AppRoutes.home,
    ),
    _NavItem(
      activeIcon: 'assets/icon/activegratitde.svg',
      inactiveIcon: 'assets/icon/inactivegratitde.svg',
      label: 'Gratitude',
      route: AppRoutes.gratitude,
    ),
    _NavItem(
      activeIcon: 'assets/icon/activeinbox.svg',
      inactiveIcon: 'assets/icon/inactiveinbox.svg',
      label: 'AI Coach',
      route: AppRoutes.inbox,
    ),
    _NavItem(
      activeIcon: 'assets/icon/activewins.svg',
      inactiveIcon: 'assets/icon/inactivewins.svg',
      label: 'Wins',
      route: AppRoutes.wins,
    ),
    _NavItem(
      activeIcon: 'assets/icon/activeprofile.svg',
      inactiveIcon: 'assets/icon/inactiveprofile.svg',
      label: 'Profile',
      route: AppRoutes.profile,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 350.0,
      height: 70.0,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(32.0),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.30),
          width: 1.0,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0x0D000000),
            blurRadius: 6.0,
            spreadRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(32.0),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 15.0, sigmaY: 15.0),
          child: Container(
            color: Colors.white.withValues(alpha: 0.10),
            padding: const EdgeInsets.symmetric(horizontal: 6.0, vertical: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(_navItems.length, (index) {
                return _buildNavItem(index, context);
              }),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(int index, BuildContext context) {
    final item = _navItems[index];
    final bool isSelected = selectedIndex == index;

    return GestureDetector(
      onTap: () {
        if (onTap != null) {
          onTap!(index);
        } else {
          if (!isSelected) {
            Get.offAllNamed(item.route);
          }
        }
      },
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        width: isSelected ? 76.0 : 54.0,
        height: 44.0,
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFEFE8FF) : Colors.transparent,
          borderRadius: BorderRadius.circular(32.0),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.06),
                    blurRadius: 10.0,
                    spreadRadius: 0,
                    offset: Offset.zero,
                  ),
                ]
              : [],
        ),
        alignment: Alignment.center,
        padding: isSelected
            ? const EdgeInsets.symmetric(horizontal: 16.0, vertical: 0.0)
            : EdgeInsets.zero,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            SvgPicture.asset(
              isSelected ? item.activeIcon : item.inactiveIcon,
              width: isSelected ? 18.0 : 20.0,
              height: isSelected ? 18.0 : 20.0,
              colorFilter: ColorFilter.mode(
                isSelected ? const Color(0xFF5E4B8B) : const Color(0xFF575B61),
                BlendMode.srcIn,
              ),
            ),
            const SizedBox(height: 2),
            FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                item.label,
                style: AppTextStyles.inter(
                  fontSize: 10.0,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                  color: isSelected
                      ? const Color(0xFF5E4B8B)
                      : const Color(0xFF575B61),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _NavItem {
  final String activeIcon;
  final String inactiveIcon;
  final String label;
  final String route;

  const _NavItem({
    required this.activeIcon,
    required this.inactiveIcon,
    required this.label,
    required this.route,
  });
}
