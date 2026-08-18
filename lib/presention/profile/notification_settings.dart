import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rosannalie/core/services/controller/notification_settings_controller.dart';
import 'package:rosannalie/general_widget/custom_background.dart';
import 'package:rosannalie/utils/appString.dart';

class NotificationSettingsView extends StatelessWidget {
  NotificationSettingsView({super.key});

  final NotificationSettingsController controller = Get.put(NotificationSettingsController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: CustomBackground(
        useSafeArea: false,
        backgroundImageAsset: "assets/images/image.png",
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 50.0),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () => Get.back(),
                        child: Container(
                          padding: const EdgeInsets.all(8.0),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.6),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.arrow_back_ios_new,
                            color: Color(0xFF3D2E6B),
                            size: 20,
                          ),
                        ),
                      ),
                      const SizedBox(width: 16.0),
                      Text(
                        'Notifications Settings',
                        style: AppTextStyles.plusJakartaSans(
                          fontSize: 20,
                          color: const Color(0xFF161022),
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 30),
                Expanded(
                  child: Obx(() {
                    if (controller.isLoading.value) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    return SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Container(
                        padding: const EdgeInsets.all(20.0),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.65),
                          borderRadius: BorderRadius.circular(24.0),
                          border: Border.all(
                            color: Colors.white,
                            width: 1.0,
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildToggleRow(
                              "Push Notifications",
                              "Receive alerts on your device",
                              controller.pushNotificationsEnabled.value,
                              controller.togglePushNotifications,
                            ),
                            _buildDivider(),
                            _buildToggleRow(
                              "Email Notifications",
                              "Receive updates via email",
                              controller.emailNotificationsEnabled.value,
                              controller.toggleEmailNotifications,
                            ),
                            _buildDivider(),
                            _buildToggleRow(
                              "Habit Reminders",
                              "Get reminded about your habits",
                              controller.habitRemindersEnabled.value,
                              controller.toggleHabitReminders,
                            ),
                            _buildDivider(),
                            _buildToggleRow(
                              "Task Reminders",
                              "Alerts for upcoming tasks",
                              controller.taskRemindersEnabled.value,
                              controller.toggleTaskReminders,
                            ),
                            _buildDivider(),
                            _buildToggleRow(
                              "Daily Summary",
                              "Your daily summary overview",
                              controller.dailySummaryEnabled.value,
                              controller.toggleDailySummary,
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Divider(
        color: const Color(0xFFC5B8E8).withValues(alpha: 0.5),
        height: 1,
        thickness: 1,
      ),
    );
  }

  Widget _buildToggleRow(String title, String subtitle, bool value, Function(bool) onChanged) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: AppTextStyles.inter(
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF3D2E6B),
                ),
              ),
              const SizedBox(height: 4.0),
              Text(
                subtitle,
                style: AppTextStyles.inter(
                  fontSize: 12.0,
                  fontWeight: FontWeight.w400,
                  color: const Color(0xFF8B7DB5),
                ),
              ),
            ],
          ),
        ),
        CupertinoSwitch(
          value: value,
          activeColor: const Color(0xFF5E4B8B),
          onChanged: onChanged,
        ),
      ],
    );
  }
}
