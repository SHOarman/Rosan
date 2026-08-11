import 'package:get/get.dart';

class OnboardingController extends GetxController {
  // Stores all the data collected during the onboarding flow
  final Map<String, dynamic> onboardingData = {};

  void updateData(String key, dynamic value) {
    onboardingData[key] = value;
    update(); // Notify UI if needed
  }

  void appendToList(String key, dynamic value) {
    if (onboardingData[key] == null) {
      onboardingData[key] = [];
    }
    if (!onboardingData[key].contains(value)) {
      onboardingData[key].add(value);
      update();
    }
  }

  void removeFromList(String key, dynamic value) {
    if (onboardingData[key] != null) {
      onboardingData[key].remove(value);
      update();
    }
  }
}
