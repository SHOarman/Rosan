import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rosannalie/core/services/controller/notification_controller.dart';
import 'package:rosannalie/general_widget/custom_background.dart';
import 'package:rosannalie/utils/appString.dart';
import 'package:rosannalie/utils/appcolors.dart';
import 'package:intl/intl.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final NotificationController controller = Get.put(NotificationController());

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          "Notifications",
          style: AppTextStyles.plusJakartaSans(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: const Color(0xFF161022),
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF161022)),
          onPressed: () => Get.back(),
        ),
        actions: [
          Obx(() {
            final unreadCount = controller.notifications.where((n) => (n as Map)['readAt'] == null).length;
            if (unreadCount == 0) return const SizedBox.shrink();

            return GestureDetector(
              onTap: () {
                controller.markAllAsRead();
              },
              child: Container(
                margin: const EdgeInsets.only(right: 20),
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    Text(
                      "$unreadCount new",
                      style: AppTextStyles.inter(
                        fontSize: 12,
                        color: AppColors.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(width: 4),
                    const Icon(Icons.done_all, color: AppColors.primary, size: 16),
                  ],
                ),
              ),
            );
          }),
        ],
      ),
      body: CustomBackground(
        useSafeArea: false,
        backgroundImageAsset: "assets/images/image.png",
        child: Obx(() {
          if (controller.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }

          if (controller.notifications.isEmpty) {
            return Center(
              child: Padding(
                 padding: const EdgeInsets.all(20.0),
                 child: Text(
                   controller.errorMessage.value.isNotEmpty ? "API Error:\n${controller.errorMessage.value}" : "No notifications yet.",
                   textAlign: TextAlign.center,
                   style: AppTextStyles.inter(
                     fontSize: 14,
                     color: const Color(0xFF575B61),
                   ),
                 ),
              )
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            itemCount: controller.notifications.length,
            separatorBuilder: (_, __) => const SizedBox(height: 16),
            itemBuilder: (context, index) {
              final notif = controller.notifications[index];
              final title = notif['title'] ?? 'Notification';
              final message = notif['message'] ?? '';
              final bool isUnread = notif['readAt'] == null;
              final String id = notif['id'] ?? '';

              String dateString = '';
              if (notif['createdAt'] != null) {
                try {
                  final DateTime dt = DateTime.parse(notif['createdAt']);
                  dateString = DateFormat('MMM dd, hh:mm a').format(dt.toLocal());
                } catch (e) {
                  dateString = '';
                }
              }

              return GestureDetector(
                onTap: () {
                  if (isUnread && id.isNotEmpty) {
                    controller.markAsRead(id, index);
                  }
                },
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: isUnread ? const Color(0xFFF9FAFB) : Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      )
                    ],
                    border: Border.all(
                      color: isUnread ? AppColors.primary.withValues(alpha: 0.3) : const Color(0xFFEBE6F6),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Stack(
                        children: [
                          Container(
                            width: 44,
                            height: 44,
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [
                                  AppColors.primarygredent2,
                                  AppColors.primarygredent1,
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.notifications_active_rounded,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                          if (isUnread)
                            Positioned(
                              top: 0,
                              right: 0,
                              child: Container(
                                width: 12,
                                height: 12,
                                decoration: BoxDecoration(
                                  color: Colors.redAccent,
                                  shape: BoxShape.circle,
                                  border: Border.all(color: Colors.white, width: 2),
                                ),
                              ),
                            )
                        ],
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              title,
                              style: AppTextStyles.plusJakartaSans(
                                fontSize: 15,
                                fontWeight: isUnread ? FontWeight.w900 : FontWeight.bold,
                                color: const Color(0xFF161022),
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              message,
                              style: AppTextStyles.inter(
                                fontSize: 13,
                                color: isUnread ? const Color(0xFF374151) : const Color(0xFF575B61),
                                fontWeight: isUnread ? FontWeight.w500 : FontWeight.normal,
                              ),
                            ),
                            if (dateString.isNotEmpty) ...[
                              const SizedBox(height: 10),
                              Text(
                                dateString,
                                style: AppTextStyles.inter(
                                  fontSize: 11,
                                  color: const Color(0xFF9CA3AF),
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        }),
      ),
    );
  }
}