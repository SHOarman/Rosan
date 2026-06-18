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

class Home extends StatelessWidget {
  const Home({super.key});

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
                      Text(
                        'Good Evening, Alex',
                        style: AppTextStyles.plusJakartaSans(
                          fontSize: 20,
                          color: const Color(0xFF161022),
                          fontWeight: FontWeight.w800,
                        ),
                      ),
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
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Quickaccess(
                            title: "To Do's",
                            subtitle: "— 6 tasks",
                            svgIconPath: "assets/icon/ListIcon.svg",
                            iconBackgroundColor: Colors.white,
                            gradientColors: const [
                              Color(0xFFFFF0E8),
                              Color(0xFFFFD4B5),
                            ],
                            onTap: () {
                              print("To Do's Clicked!");
                            },
                          ),

                          const SizedBox(width: 16),

                          Quickaccess(
                            title: "Goals",
                            subtitle: "— 6 goals",
                            svgIconPath: "assets/icon/TargetIcon.svg",
                            iconBackgroundColor: Colors.white,
                            gradientColors: const [
                              Color(0xFFF0E8FF),
                              Color(0xFFDDD0FF),
                            ],
                            onTap: () {
                              print("Goals Clicked!");
                            },
                          ),
                        ],
                      ),
                      SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Quickaccess(
                            title: "Quotes",
                            subtitle: "— 6 quotes",
                            svgIconPath: "assets/icon/QuoteIcon (1).svg",
                            iconBackgroundColor: Colors.white,
                            gradientColors: const [
                              Color(0xFFFFF0E8),
                              Color(0xFFFFD4B5),
                            ],
                            onTap: () {
                              print("To Do's Clicked!");
                            },
                          ),

                          const SizedBox(width: 16),

                          Quickaccess(
                            title: "Future Me",
                            subtitle: "— 6 future’s",
                            svgIconPath: "assets/icon/ImageIcon (1).svg",
                            iconBackgroundColor: Colors.white,
                            gradientColors: const [
                              Color(0xFFF0E8FF),
                              Color(0xFFDDD0FF),
                            ],

                            onTap: () {
                              print("Goals Clicked!");
                            },
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

                      const SizedBox(height: 80.0),
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
            child: Center(child: CustomBottomNavBar(selectedIndex: 0)),
          ),
        ],
      ),
    );
  }
}
