import 'package:flutter/material.dart';
import 'package:rosannalie/utils/appString.dart';

class Profilecard extends StatelessWidget {
  final String name;
  final String email;
  final String initials;
  final VoidCallback? onTap;

  const Profilecard({
    super.key,
    this.name = "Alex Johnson",
    this.email = "alex@example.com",
    this.initials = "AX",
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        height: 85.0,
        padding: const EdgeInsets.all(12.0),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.8),
          borderRadius: BorderRadius.circular(12.0),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 10.0,
              spreadRadius: 0.0,
              offset: const Offset(0, 0),
            ),
          ],
        ),
        child: Row(
          children: [
            // Initials Avatar with Gradient
            Container(
              width: 56.0,
              height: 56.0,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [Color(0xFF8F7DB5), Color(0xFF7B64B0)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              alignment: Alignment.center,
              child: Text(
                initials,
                style: AppTextStyles.inter(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(width: 12.0),
            // User Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    name,
                    style: AppTextStyles.plusJakartaSans(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF161022),
                    ),
                  ),
                  const SizedBox(height: 2.0),
                  Text(
                    email,
                    style: AppTextStyles.inter(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: const Color(0xFF8F7DB5),
                    ),
                  ),
                ],
              ),
            ),
            // Chevron icon
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
