import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:rosannalie/general_widget/custom_background.dart';
import 'package:rosannalie/general_widget/customnav_button.dart';
import 'package:rosannalie/presention/wins/widget/achievements.dart';
import 'package:rosannalie/presention/wins/widget/streak_progress_card.dart';
import 'package:rosannalie/presention/wins/widget/amazingworkcard.dart';
import 'package:rosannalie/presention/wins/widget/stackcard.dart';
import 'package:rosannalie/utils/appString.dart';

class Wins extends StatelessWidget {
  const Wins({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomBackground(
      useSafeArea: false,
      backgroundImageAsset: "assets/images/image.png",
      child: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            bottom: 40.0,
            child: SafeArea(
              bottom: false,
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 40),

                      // ── Title ─────────────────────────────────────────────
                      Center(
                        child: Text(
                          'Wins',
                          style: AppTextStyles.plusJakartaSans(
                            fontSize: 20,
                            color: const Color(0xFF161022),
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),

                      // ── Stat cards row ────────────────────────────────────
                      Row(
                        children: [
                          // Day streak
                          Expanded(
                            child: StackCard(
                              showBorder: true,
                              gradientColors: const [
                                Color(0xFFFFF8EE),
                                Color(0xFFFFE0B2),
                              ],
                              icon: SvgPicture.asset(
                                'assets/icon/Icon (10).svg',
                                width: 28,
                                height: 28,
                              ),
                              title: '3',
                              subtitle: 'Day streak',
                            ),
                          ),
                          const SizedBox(width: 10),
                          // Points today
                          Expanded(
                            child: StackCard(
                              gradientColors: const [
                                Color(0xFFF3EEFF),
                                Color(0xFFDDD0FF),
                              ],
                              icon: SvgPicture.asset(
                                'assets/icon/Vector (3).svg',
                                width: 28,
                                height: 28,
                              ),
                              title: '120',
                              subtitle: 'Points today',
                            ),
                          ),
                          const SizedBox(width: 10),
                          // Badges
                          Expanded(
                            child: StackCard(
                              gradientColors: const [
                                Color(0xFFF0FFF0),
                                Color(0xFFC8E6C9),
                              ],
                              icon: SvgPicture.asset(
                                'assets/icon/Icon (11).svg',
                                width: 28,
                                height: 28,
                              ),
                              title: '3',
                              subtitle: 'Badges',
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 24),

                      // ── Amazing work card ─────────────────────────────────
                      const Amazingworkcard(),

                      const SizedBox(height: 30),

                      Text(
                        "Today's achievements",
                        style: AppTextStyles.plusJakartaSans(
                          color: const Color(0xff161022),
                          fontWeight: FontWeight.bold,
                          fontSize: 17,
                        ),
                      ),
                      const SizedBox(height: 10),

                      const Achievements(),

                      const SizedBox(height: 30),

                      Text(
                        "Achievements (3/6)",
                        style: AppTextStyles.plusJakartaSans(
                          color: const Color(0xff161022),
                          fontWeight: FontWeight.bold,
                          fontSize: 17,
                        ),
                      ),
                      const SizedBox(height: 10),

                      const AchievementsGrid(),
                      
                      const SizedBox(height: 16),

                      const StreakProgressCard(),

                      const SizedBox(height: 100),

                    ],
                  ),
                ),
              ),
            ),
          ),
          const Positioned(
            bottom: 50.0,
            left: 0,
            right: 0,
            child: Center(child: CustomBottomNavBar(selectedIndex: 3)),
          ),
        ],
      ),
    );
  }
}
