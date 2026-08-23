import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rosannalie/core/route/app_pages.dart';
import 'package:rosannalie/general_widget/custom_background.dart';
import 'package:rosannalie/presention/home/widget/daily_msg.dart';
import 'package:rosannalie/presention/home/widget/feelingcard.dart';
import 'package:rosannalie/presention/home/widget/quickaccess.dart';
import 'package:rosannalie/presention/home/widget/todaytaks.dart';
import 'package:rosannalie/presention/home/widget/my_goals_widget.dart';
import 'package:rosannalie/utils/appcolors.dart';
import 'package:rosannalie/general_widget/customnav_button.dart';
import '../../utils/appString.dart';
import 'package:rosannalie/core/services/controller/authcontroller.dart';
import 'package:rosannalie/core/services/controller/todaytaskcontroller.dart';
import 'package:rosannalie/core/services/controller/mygoall_controller.dart';
import 'package:rosannalie/core/services/controller/quote_controller.dart';
import 'package:rosannalie/core/services/controller/future_me_controller.dart';
import 'package:rosannalie/core/services/controller/notification_controller.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  String getGreeting() {
    var hour = DateTime.now().hour;
    if (hour < 12) {
      return 'Good Morning';
    } else if (hour < 17) {
      return 'Good Afternoon';
    } else if (hour < 20) {
      return 'Good Evening';
    } else {
      return 'Good Evening';
    }
  }

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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Obx(() {
                                  final authController = Get.find<Authcontroller>();
                                  final firstName = authController.userName.value.isNotEmpty
                                      ? authController.userName.value.trim().split(" ").first
                                      : "User";
                                  return Text(
                                    '${getGreeting()}, $firstName',
                                    style: AppTextStyles.plusJakartaSans(
                                      fontSize: 20,
                                      color: const Color(0xFF161022),
                                      fontWeight: FontWeight.w900,
                                    ).copyWith(
                                      height: 28 / 20,
                                      letterSpacing: 0,
                                    ),
                                  );
                                }),
                                const SizedBox(height: 6),
                                Text(
                                  "You are amazing!",
                                  style: AppTextStyles.inter(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: Color(0xff575B61),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              Get.toNamed(AppRoutes.notifications);
                            },
                            child: Stack(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    shape: BoxShape.circle,
                                    border: Border.all(color: const Color(0xFFEBE6F6)),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withValues(alpha: 0.03),
                                        blurRadius: 10,
                                        offset: const Offset(0, 2),
                                      )
                                    ],
                                  ),
                                  child: const Icon(
                                    Icons.notifications_none_rounded,
                                    color: Color(0xFF161022),
                                    size: 24,
                                  ),
                                ),
                                Obx(() {
                                  final notifController = Get.put(NotificationController());
                                  final count = notifController.notifications.where((n) => (n as Map)['readAt'] == null).length;
                                  if (count == 0) return const SizedBox.shrink();

                                  return Positioned(
                                    top: 0,
                                    right: 0,
                                    child: Container(
                                      padding: const EdgeInsets.all(4),
                                      decoration: BoxDecoration(
                                        color: Colors.redAccent,
                                        shape: BoxShape.circle,
                                        border: Border.all(color: Colors.white, width: 2),
                                      ),
                                      child: Text(
                                        count > 9 ? '9+' : '$count',
                                        style: AppTextStyles.inter(
                                          fontSize: 10,
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  );
                                }),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 25),

                      //======================Dailymsg=====================================
                      DailyMsg(),

                      SizedBox(height: 30),

                      //==================================== feelingcard===================================================
                      Feelingcard(),

                      SizedBox(height: 24),

                      Text(
                        "Quick Access",
                        style: AppTextStyles.plusJakartaSans(
                          color: Color(0xff161022),
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ).copyWith(letterSpacing: 0.5)
                      ),
                      SizedBox(height: 14),

                      //=====================================quick_card==================================================
                      Row(
                        children: [
                          Expanded(
                            child: Obx(() {
                              final taskController = Get.isRegistered<Todaytaskcontroller>()
                                  ? Get.find<Todaytaskcontroller>()
                                  : Get.put(Todaytaskcontroller());
                              final taskCount = taskController.tasks.length;
                              return Quickaccess(
                                title: "To Do's",
                                subtitle: "— $taskCount tasks",
                                svgIconPath: "assets/icon/ListIcon.svg",
                                iconBackgroundColor: Colors.white,
                                gradientColors: const [
                                  Color(0xFFFFF0E8),
                                  Color(0xFFFFD4B5),
                                ],
                                onTap: () {
                                  Get.toNamed(AppRoutes.todaytaks_seeall);
                                },
                              );
                            }),
                          ),

                          const SizedBox(width: 16),

                          Expanded(
                            child: Obx(() {
                              final goalController = Get.isRegistered<MygoallController>()
                                  ? Get.find<MygoallController>()
                                  : Get.put(MygoallController());
                              final goalCount = goalController.activeGoalsCount;
                              return Quickaccess(
                                title: "Goals",
                                subtitle: "— $goalCount goals",
                                svgIconPath: "assets/icon/TargetIcon.svg",
                                iconBackgroundColor: Colors.white,
                                gradientColors: const [
                                  Color(0xFFF0E8FF),
                                  Color(0xFFDDD0FF),
                                ],
                                onTap: () {
                                  Get.toNamed(AppRoutes.mygoals_seeall);
                                },
                              );
                            }),
                          ),
                        ],
                      ),
                      SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: Obx(() {
                              final quoteController = Get.isRegistered<QuoteController>()
                                  ? Get.find<QuoteController>()
                                  : Get.put(QuoteController());
                              final quoteCount = quoteController.quotes.length;
                              return Quickaccess(
                                title: "Quotes",
                                subtitle: "— $quoteCount quotes",
                                svgIconPath: "assets/icon/QuoteIcon (1).svg",
                                iconBackgroundColor: Colors.white,
                                gradientColors: const [
                                  Color(0xFFFFF0E8),
                                  Color(0xFFFFD4B5),
                                ],
                                onTap: () {
                                  Get.toNamed(AppRoutes.allquotes);
                                },
                              );
                            }),
                          ),

                          const SizedBox(width: 16),

                          Expanded(
                            child: Obx(() {
                              final futureMeController = Get.isRegistered<FutureMeController>()
                                  ? Get.find<FutureMeController>()
                                  : Get.put(FutureMeController());
                              final completedCount = futureMeController.completedJourneyCount;
                              return Quickaccess(
                                title: "Future Me",
                                subtitle: "— $completedCount locked in",
                                svgIconPath: "assets/icon/ImageIcon (1).svg",
                                iconBackgroundColor: Colors.white,
                                gradientColors: const [
                                  Color(0xFFF0E8FF),
                                  Color(0xFFDDD0FF),
                                ],
                                onTap: () {
                                  Get.toNamed(AppRoutes.futureme);
                                },
                              );
                            }),
                          ),
                        ],
                      ),

                      SizedBox(height: 20),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Today's Tasks",
                            style: AppTextStyles.plusJakartaSans(
                              color: const Color(0xff3D2E6B),
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                            ),
                          ),

                          GestureDetector(
                            onTap: () {
                              Get.toNamed(AppRoutes.todaytaks_seeall);



                            },
                            child: Text(
                              "See all →",
                              style: AppTextStyles.inter(
                                color: const Color(0xff7B64B0),
                                fontWeight: FontWeight.w600,
                                fontSize: 13,
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 20),

                      //============================================today_taks=============================================
                      const TodayTasks(),

                      const SizedBox(height: 24.0),

                      //============================================my_goals===============================================
                      const MyGoalsWidget(),

                      const SizedBox(height: 70.0),
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
            child: Center(child: CustomBottomNavBar(selectedIndex: 0)),
          ),
        ],
      ),
    );
  }
}
