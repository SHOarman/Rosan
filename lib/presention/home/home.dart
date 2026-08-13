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
      return 'Good Night';
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
                            fontWeight: FontWeight.w800,
                          ),
                        );
                      }),
                      const SizedBox(height: 6),
                      Text(
                        "You are amazing!",
                        style: AppTextStyles.inter(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: AppColors.gray,
                        ),
                      ),
                      const SizedBox(height: 20),

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
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
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
                                subtitle: "— $completedCount completed",
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
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
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
                                fontSize: 12,
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
