import 'package:get/get.dart';
import 'package:rosannalie/presention/Gratitude/gratitude.dart';
import 'package:rosannalie/presention/ai_chart/aichart.dart';
import 'package:rosannalie/presention/auth/create_accound.dart';
import 'package:rosannalie/presention/auth/email_verfication.dart';
import 'package:rosannalie/presention/auth/forgot_password.dart';
import 'package:rosannalie/presention/auth/reset_Password.dart';
import 'package:rosannalie/presention/auth/reset_success_screen.dart';
import 'package:rosannalie/presention/home/home.dart';
import 'package:rosannalie/presention/home/mygoals_seeall.dart';
import 'package:rosannalie/presention/home/todaystaks_seeall.dart';
import 'package:rosannalie/presention/onloading/onlading.dart';
import 'package:rosannalie/presention/onloading/onlading1.dart';
import 'package:rosannalie/presention/profile/profile.dart';
import 'package:rosannalie/presention/profile/editprofile.dart';
import 'package:rosannalie/presention/profile/helpcenter.dart';
import 'package:rosannalie/presention/profile/sendmail.dart';
import 'package:rosannalie/presention/profile/delete_account.dart';
import 'package:rosannalie/presention/profile/privacy_Policy.dart';
import 'package:rosannalie/presention/profile/termsof_Service.dart';
import 'package:rosannalie/presention/profile/myplan.dart';
import 'package:rosannalie/presention/wins/wins.dart';

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
  static const initial = AppRoutes.home;
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
    GetPage(name: AppRoutes.createaccount, page: ()=>CreateAccound()),
    GetPage(name: AppRoutes.forgotpassword, page: ()=>ForgotPassword()),

    GetPage(name: AppRoutes.verificationcode, page: ()=>EmailVerfication()),
    GetPage(name: AppRoutes.resetpassword, page: ()=>ResetPassword()),
    GetPage(name: AppRoutes.resetsuccess, page: ()=>ResetSuccessScreen()),

    //===========================================homesecation================================================
    GetPage(name: AppRoutes.home, page: ()=>Home(),  transitionDuration: Duration.zero,),
    GetPage(name: AppRoutes.mygoals_seeall, page: ()=>MygoalsSeeall()),
    GetPage(name: AppRoutes.todaytaks_seeall, page: ()=>TodaystaksSeeall()),

    //===========================================Grarirude================================================

    GetPage(name: AppRoutes.gratitude, page: ()=>Gratitude(),  transitionDuration: Duration.zero,),
    //===========================================aichart================================================

    GetPage(name: AppRoutes.inbox, page: ()=>Aichart(),  transitionDuration: Duration.zero,),
    //===========================================wins================================================

    GetPage(name: AppRoutes.wins, page: ()=>Wins(),  transitionDuration: Duration.zero,),
    //===========================================profile================================================

    GetPage(name: AppRoutes.profile, page: ()=>Profile(),  transitionDuration: Duration.zero,),
    GetPage(name: AppRoutes.editprofile, page: ()=>EditProfile()),
    GetPage(name: AppRoutes.helpcenter, page: ()=>HelpCenter()),
    GetPage(name: AppRoutes.sendmail, page: ()=>SendMail()),
    GetPage(name: AppRoutes.deleteaccount, page: ()=>DeleteAccountPage()),
    GetPage(name: AppRoutes.privacypolicy, page: ()=>const PrivacyPolicyPage()),
    GetPage(name: AppRoutes.termsofservice, page: ()=>const TermsOfServicePage()),
    GetPage(name: AppRoutes.myplan, page: ()=>const MyPlanPage()),




  ];
}
