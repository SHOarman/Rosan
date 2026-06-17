
import 'package:get/get.dart';
import 'package:rosannalie/core/services/controller/authcontroller.dart';

class DependencyInjection {
  static void bindings() {
    //==============================authcontroller=======================================

    Get.lazyPut(()=>Authcontroller());
  }
}
