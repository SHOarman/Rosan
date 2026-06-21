import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rosannalie/core/services/controller/gratitude_controller.dart';
import 'package:rosannalie/general_widget/custom_background.dart';
import 'package:rosannalie/general_widget/customnav_button.dart';
import 'package:rosannalie/presention/Gratitude/widget/gratitudecard.dart';
import 'package:rosannalie/utils/appString.dart';

class Gratitude extends StatelessWidget {
  const Gratitude({super.key});

  @override
  Widget build(BuildContext context) {
    final GratitudeController controller = Get.isRegistered<GratitudeController>()
        ? Get.find<GratitudeController>()
        : Get.put(GratitudeController());

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
                physics: const BouncingScrollPhysics(),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 40),

                      // Title
                      Center(
                        child: Text(
                          'Gratitude',
                          style: AppTextStyles.plusJakartaSans(
                            fontSize: 20,
                            color: const Color(0xFF161022),
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),

                      const SizedBox(height: 24),

                      // Gratitude prompt card
                      Gratitudecard(
                        onAddTap: () => _showAddEntrySheet(context, controller),
                      ),

                      const SizedBox(height: 24),

                      // Stats row
                      Obx(() => _buildStatsRow(controller)),

                      const SizedBox(height: 28),

                      // Recent Entries header
                      Text(
                        'Recent entries',
                        style: AppTextStyles.plusJakartaSans(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF161022),
                        ),
                      ),

                      const SizedBox(height: 16),

                      // Entries list
                      Obx(() {
                        if (controller.entries.isEmpty) {
                          return Center(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 30),
                              child: Text(
                                'No entries yet. Add your first!',
                                style: AppTextStyles.inter(
                                  color: const Color(0xFF8F7DB5),
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          );
                        }
                        return ListView.separated(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: controller.entries.length,
                          separatorBuilder: (_, __) =>
                              const SizedBox(height: 12),
                          itemBuilder: (context, index) {
                            final entry = controller.entries[index];
                            return _buildEntryCard(entry, controller);
                          },
                        );
                      }),

                      const SizedBox(height: 10),

                      // A note from Rise
                      _buildRiseNoteCard(),

                      const SizedBox(height: 80),
                    ],
                  ),
                ),
              ),
            ),
          ),
          const Positioned(
            bottom: 40.0,
            left: 0,
            right: 0,
            child: Center(
              child: CustomBottomNavBar(selectedIndex: 1),
            ),
          ),
        ],
      ),
    );
  }

  // ── Stats Row ──────────────────────────────────────────────────
  Widget _buildStatsRow(GratitudeController c) {
    return Row(
      children: [
        Expanded(
          child: _buildStatCard(
            value: '${c.totalEntries}',
            label: 'Total',
            emoji: '🗒️',
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildStatCard(
            value: '${c.dayStreak}',
            label: 'Day streak',
            emoji: '🔥',
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildStatCard(
            value: '${c.daysThisMonth}',
            label: 'Days this month',
            emoji: '📅',
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard({
    required String value,
    required String label,
    required String emoji,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 10),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.8),
        borderRadius: BorderRadius.circular(18),
        border: const Border(
          top: BorderSide(color: Color(0xFFFFFFFF), width: 1),
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF4A3870).withValues(alpha: 0.08),
            blurRadius: 20,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(emoji, style: const TextStyle(fontSize: 20)),
          const SizedBox(height: 6),
          Text(
            value,
            style: AppTextStyles.plusJakartaSans(
              fontSize: 22,
              fontWeight: FontWeight.w800,
              color: const Color(0xFF2E2252),
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: AppTextStyles.inter(
              fontSize: 11,
              fontWeight: FontWeight.w500,
              color: const Color(0xFF8F7DB5),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  // ── Entry Card ─────────────────────────────────────────────────
  Widget _buildEntryCard(GratitudeEntry entry, GratitudeController controller) {
    return Dismissible(
      key: ValueKey(entry.text + entry.dateLabel),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        decoration: BoxDecoration(
          color: Colors.redAccent.withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(18),
        ),
        child: const Icon(Icons.delete_outline, color: Colors.redAccent),
      ),
      onDismissed: (_) => controller.deleteEntry(entry),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.8),
          borderRadius: BorderRadius.circular(18),
          border: const Border(
            top: BorderSide(color: Color(0xFFFFFFFF), width: 1),
          ),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF4A3870).withValues(alpha: 0.08),
              blurRadius: 20,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: const Color(0xFFF4F0FF),
                borderRadius: BorderRadius.circular(12),
              ),
              alignment: Alignment.center,
              child: Text(entry.emoji,
                  style: const TextStyle(fontSize: 20)),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    entry.text,
                    style: AppTextStyles.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: const Color(0xFF2E2252),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    entry.dateLabel,
                    style: AppTextStyles.inter(
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      color: const Color(0xFF8F7DB5),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── A note from Rise ───────────────────────────────────────────
  Widget _buildRiseNoteCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFFEDE8FB).withValues(alpha: 0.85),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: const Color(0xFFC5B8E8).withValues(alpha: 0.5),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text('❤️', style: TextStyle(fontSize: 14)),
              const SizedBox(width: 6),
              Text(
                'A note from Rise',
                style: AppTextStyles.plusJakartaSans(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF3D2E6B),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            '"Gratitude doesn\'t change the scenery — it washes clean the glass you look through so you can see the colors in the same world. Keep noticing, fvbb."',
            style: AppTextStyles.playfairDisplay(
              fontSize: 13,
              fontWeight: FontWeight.w400,
              color: const Color(0xFF8F7DB5),
            ),
          ),
        ],
      ),
    );
  }

  // ── Add Entry Dialog ───────────────────────────────────────────
  void _showAddEntrySheet(
      BuildContext context, GratitudeController controller) {
    final textController = TextEditingController();

    showDialog(
      context: context,
      barrierColor: Colors.black.withValues(alpha: 0.35),
      builder: (ctx) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: const EdgeInsets.symmetric(horizontal: 24),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(26, 20, 26, 20),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFFC5B8E8), // 85% opacity feel
                  Color(0xFFFFD7C3), // 75% opacity feel
                ],
              ),
              borderRadius: BorderRadius.circular(20),
              border: const Border(
                top: BorderSide(
                  color: Color(0xFFFFFFFF),
                  width: 1,
                ),
              ),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF4A3870).withValues(alpha: 0.1),
                  offset: const Offset(0, 8),
                  blurRadius: 32,
                  spreadRadius: 0,
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Icon + Title row
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            Color(0xFF79479C),
                            Color(0xFFAC6262),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      alignment: Alignment.center,
                      child: const Text(
                        '✨',
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'What made you smile today?',
                        style: AppTextStyles.plusJakartaSans(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF2E2252),
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                // Text field
                TextField(
                  controller: textController,
                  maxLines: 4,
                  decoration: InputDecoration(
                    hintText: 'Write freely, no judgment...',
                    hintStyle: AppTextStyles.inter(
                      color: const Color(0xFF8F7DB5).withValues(alpha: 0.6),
                      fontSize: 14,
                    ),
                    filled: true,
                    fillColor: Colors.white.withValues(alpha: 0.85),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide(
                        color: Colors.white.withValues(alpha: 0.6),
                        width: 1,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: const BorderSide(
                        color: Color(0xFF7B64B0),
                        width: 1.5,
                      ),
                    ),
                    contentPadding: const EdgeInsets.all(14),
                  ),
                  style: AppTextStyles.inter(
                    color: const Color(0xFF2E2252),
                    fontSize: 14,
                  ),
                ),

                const SizedBox(height: 20),

                // Buttons row
                Row(
                  children: [
                    // Cancel
                    Expanded(
                      child: GestureDetector(
                        onTap: () => Navigator.of(ctx).pop(),
                        child: Container(
                          height: 48,
                          alignment: Alignment.center,
                          child: Text(
                            'Cancel',
                            style: AppTextStyles.inter(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xFF8F7DB5),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    // Save
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          final text = textController.text.trim();
                          if (text.isEmpty) return;
                          controller.addEntry(text, '✨');
                          Navigator.of(ctx).pop();
                        },
                        child: Container(
                          height: 48,
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                Color(0xFF8F7DB5),
                                Color(0xFF7B64B0),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(24),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFF7B64B0)
                                    .withValues(alpha: 0.35),
                                blurRadius: 12,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          alignment: Alignment.center,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Save ',
                                style: AppTextStyles.inter(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              const Text('💛',
                                  style: TextStyle(fontSize: 14)),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
