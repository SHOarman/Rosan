import 'package:get/get.dart';
import 'package:rosannalie/core/services/controller/authcontroller.dart';
import 'package:rosannalie/core/services/controller/todaytaskcontroller.dart';
import 'package:rosannalie/core/services/controller/mygoall_controller.dart';
import 'package:rosannalie/presention/home/mygoals_seeall.dart';

class DependencyInjection {
  static void bindings() {
    //==============================authcontroller=======================================

    Get.put(Authcontroller(), permanent: true);
    
    //========================todaytakshcontroller======================================
    Get.put(Todaytaskcontroller(), permanent: true);

    //========================mygoalscontroller=========================================
    Get.put(MygoallController(), permanent: true);
  }
}
