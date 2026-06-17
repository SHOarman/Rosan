import 'package:get/get.dart';
import 'package:rosannalie/presention/onloading/onlading.dart';
import 'package:rosannalie/presention/onloading/onlading1.dart';

import '../../presention/onloading/onlading10.dart';
import '../../presention/onloading/onlading11.dart';
import '../../presention/onloading/onlading12.dart';
import '../../presention/onloading/onlading13.dart';
import '../../presention/onloading/onlading2.dart';
import '../../presention/onloading/onlading3.dart';
import '../../presention/onloading/onlading4.dart';
import '../../presention/onloading/onlading5.dart';
import '../../presention/onloading/onlading6.dart';
import '../../presention/onloading/onlading7.dart';
import '../../presention/onloading/onlading8.dart';
import '../../presention/onloading/onlading9.dart';
import '../../presention/auth/signin_screen.dart';
import 'app_pages.dart';

class AppPages {
  static const initial = AppRoutes.onborading;
  static final routes = [

    //================================onloding==========================
    GetPage(name: AppRoutes.onborading, page: ()=>Onlading()),
    GetPage(name: AppRoutes.onborading1, page: ()=>Onlading1()),
    GetPage(name: AppRoutes.onborading2, page: ()=>Onlading2()),
    GetPage(name: AppRoutes.onborading3, page: ()=>Onlading3()),
    GetPage(name: AppRoutes.onborading4, page: ()=>Onlading4()),
    GetPage(name: AppRoutes.onborading5, page: ()=>Onlading5()),
    GetPage(name: AppRoutes.onborading6, page: ()=>Onlading6()),
    GetPage(name: AppRoutes.onborading7, page: ()=>Onlading7()),
    GetPage(name: AppRoutes.onborading8, page: ()=>Onlading8()),
    GetPage(name: AppRoutes.onborading9, page: ()=>Onlading9()),
    GetPage(name: AppRoutes.onborading10, page: ()=>Onlading10()),
    GetPage(name: AppRoutes.onborading11, page: ()=>Onlading11()),
    GetPage(name: AppRoutes.onborading12, page: ()=>Onlading12()),
    GetPage(name: AppRoutes.onborading13, page: ()=>Onlading13()),




    //========================================authscrean====================================================
    GetPage(name: AppRoutes.singin, page: ()=>SigninScreen()),


  ];
}

