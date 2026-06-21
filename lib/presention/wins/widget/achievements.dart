import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:rosannalie/utils/appString.dart';
import 'package:rosannalie/presention/wins/widget/stackcard.dart';

class AchievementItem {
  final String emoji;
  final String title;
  final String time;
  final String points;

  const AchievementItem({
    required this.emoji,
    required this.title,
    required this.time,
    required this.points,
  });
}

class Achievements extends StatelessWidget {
  const Achievements({super.key});

  static const List<AchievementItem> _defaultAchievements = [
    AchievementItem(
      emoji: '💪',
      title: 'Completed morning workout',
      time: '7:30 AM',
      points: '+50',
    ),
    AchievementItem(
      emoji: '💧',
      title: 'Drank 8 glasses of water',
      time: '4:00 PM',
      points: '+30',
    ),
    AchievementItem(
      emoji: '📚',
      title: 'Read for 20 minutes',
      time: '9:00 PM',
      points: '+40',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: _defaultAchievements.map((achievement) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 12.0),
          child: Container(
            width: double.infinity,
            height: 70.0,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.06),
                  blurRadius: 10,
                  spreadRadius: 0,
                  offset: Offset.zero,
                ),
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.10),
                  blurRadius: 4,
                  spreadRadius: 0,
                  offset: Offset.zero,
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 14.0),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.65),
                    borderRadius: BorderRadius.circular(20),
                    border: Border(
                      top: BorderSide(
                        color: const Color(0xFFF3F3F3).withValues(alpha: 0.40),
                        width: 1.0,
                      ),
                    ),
                  ),
                  child: Row(
                    children: [
                      // Emoji leading container
                      Container(
                        width: 42,
                        height: 42,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                            color: const Color(0xFFF3F3F3),
                            width: 1.0,
                          ),
                        ),
                        child: Center(
                          child: Text(
                            achievement.emoji,
                            style: const TextStyle(
                              fontSize: 20.0,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12.0),
                      // Text Title & Subtitle column
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              achievement.title,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: AppTextStyles.plusJakartaSans(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                                color: const Color(0xFF161022),
                              ),
                            ),
                            const SizedBox(height: 2.0),
                            Text(
                              achievement.time,
                              style: AppTextStyles.plusJakartaSans(
                                fontSize: 11,
                                fontWeight: FontWeight.w500,
                                color: const Color(0xFFB5AEC4),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8.0),
                      // Trailing points chip
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 6.0),
                        decoration: BoxDecoration(
                          color: const Color(0xFFE8E3F5),
                          borderRadius: BorderRadius.circular(100),
                          border: Border.all(
                            color: Color(0xFFC5B8E8),
                            width: 1.2
                          )
                        ),
                        child: Text(
                          achievement.points,
                          style: AppTextStyles.plusJakartaSans(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            gradientColors: [
                              Color(0xff9B85CF),
                              Color(0xff5E4B8B)
                              
                            ]
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}

class AchievementGridItem {
  final Widget icon;
  final String title;
  final String subtitle;
  final List<Color> gradientColors;
  final Color? badgeColor;

  const AchievementGridItem({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.gradientColors,
    this.badgeColor,
  });
}

class AchievementsGrid extends StatelessWidget {
  const AchievementsGrid({super.key});

  static final List<AchievementGridItem> _gridItems = [
    AchievementGridItem(
      icon: const Text('🌱', style: TextStyle(fontSize: 24)),
      title: 'First Step',
      subtitle: 'Completed your first task',
      gradientColors: const [
        Color(0xFFA1E7B9),
        Color(0xFFB5F2CC),
      ],
      badgeColor: const Color(0xFF5DBB80),
    ),
    AchievementGridItem(
      icon: SvgPicture.asset(
        'assets/icon/Icon (10).svg',
        width: 24,
        height: 24,
        colorFilter: const ColorFilter.mode(Color(0xFFE67E22), BlendMode.srcIn),
      ),
      title: 'On a Roll',
      subtitle: '3-day streak',
      gradientColors: const [
        Color(0xFFFFDF9F),
        Color(0xFFFFC374),
      ],
      badgeColor: const Color(0xFFFFB33A),
    ),
    AchievementGridItem(
      icon: SvgPicture.asset(
        'assets/icon/TargetIcon.svg',
        width: 24,
        height: 24,
      ),
      title: 'Goal Setter',
      subtitle: 'Created your first goal',
      gradientColors: const [
        Color(0xFFC4C1E0),
        Color(0xFFAB9FD5),
      ],
      badgeColor: const Color(0xFF7E57C2),
    ),
    AchievementGridItem(
      icon: const Text('🙏', style: TextStyle(fontSize: 24)),
      title: 'Gratitude Pro',
      subtitle: '7 gratitude entries',
      gradientColors: const [
        Color(0xFFCBD6E2),
        Color(0xFFA9BCCF),
      ],
    ),
    AchievementGridItem(
      icon: const Text('⭐', style: TextStyle(fontSize: 24)),
      title: 'Habit Builder',
      subtitle: '14-day streak',
      gradientColors: const [
        Color(0xFFECC1DD),
        Color(0xFFDB95C7),
      ],
    ),
    AchievementGridItem(
      icon: SvgPicture.asset(
        'assets/icon/Icon (11).svg',
        width: 24,
        height: 24,
        colorFilter: const ColorFilter.mode(Color(0xFFD35400), BlendMode.srcIn),
      ),
      title: 'Champion',
      subtitle: 'Complete a big goal',
      gradientColors: const [
        Color(0xFFECA3A3),
        Color(0xFFD57474),
      ],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(child: _buildCard(_gridItems[0])),
            const SizedBox(width: 10),
            Expanded(child: _buildCard(_gridItems[1])),
            const SizedBox(width: 10),
            Expanded(child: _buildCard(_gridItems[2])),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(child: _buildCard(_gridItems[3])),
            const SizedBox(width: 10),
            Expanded(child: _buildCard(_gridItems[4])),
            const SizedBox(width: 10),
            Expanded(child: _buildCard(_gridItems[5])),
          ],
        ),
      ],
    );
  }

  Widget _buildCard(AchievementGridItem item) {
    return StackCard(
      gradientColors: item.gradientColors,
      icon: item.icon,
      title: item.title,
      subtitle: item.subtitle,
      titleColor: const Color(0xFF161022),
      subtitleColor: Colors.white.withValues(alpha: 0.9),
      titleFontSize: 13.0,
      subtitleFontSize: 10.0,
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 8),
      trailing: item.badgeColor != null ? _buildCheckBadge(item.badgeColor!) : null,
    );
  }

  Widget _buildCheckBadge(Color badgeColor) {
    return Container(
      width: 18,
      height: 18,
      decoration: BoxDecoration(
        color: badgeColor,
        shape: BoxShape.circle,
        border: Border.all(
          color: Colors.white,
          width: 1.2,
        ),
      ),
      child: const Center(
        child: Icon(
          Icons.check,
          size: 11,
          color: Colors.white,
        ),
      ),
    );
  }
}
