import 'package:get/get.dart';
import 'package:rosannalie/core/services/controller/authcontroller.dart';
import 'package:rosannalie/core/services/controller/todaytaskcontroller.dart';
import 'package:rosannalie/core/services/controller/mygoall_controller.dart';
import 'package:rosannalie/core/services/controller/quote_controller.dart';
import 'package:rosannalie/core/services/controller/gratitude_controller.dart';

class DependencyInjection {
  static void bindings() {
    //==============================authcontroller=======================================

    Get.put(Authcontroller(), permanent: true);
    
    //========================todaytakshcontroller======================================
    Get.put(Todaytaskcontroller(), permanent: true);

    //========================mygoalscontroller=========================================
    Get.put(MygoallController(), permanent: true);

    //========================quotecontroller===========================================
    Get.put(QuoteController(), permanent: true);

    //========================gratitudecontroller=======================================
    Get.put(GratitudeController(), permanent: true);
  }
}
