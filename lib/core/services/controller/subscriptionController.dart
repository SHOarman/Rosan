import 'package:get/get.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:rosannalie/core/services/api_services/apiservices.dart';

class SubscriptionController extends GetxController {
  var isLoading = false.obs;
  var isProMember = false.obs;
  var availablePackages = <Package>[].obs;

  // Backend UI Plans Data
  var paywallTitle = "".obs;
  var paywallSubtitle = "".obs;
  var paywallBanner = "".obs;
  var paywallSubtext = "".obs;
  var paywallFeatures = <String>[].obs;
  var backendPlans = [].obs;

  @override
  void onInit() {
    super.onInit();
    fetchBackendPlans();
    fetchOfferings();
    checkCustomerStatus();
  }

  // Fetch UI configuration and plans from the backend
  Future<void> fetchBackendPlans() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('accessToken') ?? '';

      final response = await http.get(
        Uri.parse(Apiservices.getavabile_plans),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
          'ngrok-skip-browser-warning': 'true',
          'bypass-tunnel-reminder': 'true',
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final decoded = jsonDecode(response.body);
        if (decoded['success'] == true && decoded['data'] != null) {
          final data = decoded['data'];
          if (data['title'] != null) paywallTitle.value = data['title'];
          if (data['subtitle'] != null) paywallSubtitle.value = data['subtitle'];
          if (data['trialBanner'] != null) paywallBanner.value = data['trialBanner'];
          if (data['trialSubtext'] != null) paywallSubtext.value = data['trialSubtext'];
          
          if (data['features'] != null) {
            paywallFeatures.value = List<String>.from(data['features']);
          }
          if (data['plans'] != null) {
            backendPlans.value = data['plans'];
          }
        }
      }
    } catch (e) {
      print("Error fetching backend plans: $e");
    }
  }

  Future<void> fetchOfferings() async {
    try {
      isLoading(true);
      Offerings offerings = await Purchases.getOfferings();
      if (offerings.current != null && offerings.current!.availablePackages.isNotEmpty) {
        availablePackages.value = offerings.current!.availablePackages;
      }
    } catch (e) {
      Get.snackbar("Error", e.toString());
    } finally {
      isLoading(false);
    }
  }

  Future<void> makePurchase(String planCode) async {
    try {
      isLoading(true);
      
      // Find matching RevenueCat Package
      Package? selectedPackage;
      for (var pkg in availablePackages) {
         if (planCode.toUpperCase() == "YEARLY" && pkg.packageType == PackageType.annual) {
            selectedPackage = pkg;
            break;
         } else if (planCode.toUpperCase() == "MONTHLY" && pkg.packageType == PackageType.monthly) {
            selectedPackage = pkg;
            break;
         }
         else if (pkg.identifier.toUpperCase().contains(planCode.toUpperCase())) {
            selectedPackage = pkg;
            break;
         }
      }
      
      if (selectedPackage == null) {
         Get.snackbar("Notice", "Plan not found in store.");
         isLoading(false);
         return;
      }
      
      PurchaseResult result = await Purchases.purchase(PurchaseParams.package(selectedPackage));
      CustomerInfo customerInfo = result.customerInfo;
      
      var entitlement = customerInfo.entitlements.all["Rise Pro"];
      
      if (entitlement != null && entitlement.isActive) {
        isProMember.value = true;
        Get.snackbar("Success", "Subscription activated successfully via RevenueCat!");
      }
    } catch (e) {
      Get.snackbar("Purchase Cancelled/Failed", e.toString());
    } finally {
      isLoading(false);
    }
  }

  Future<void> checkCustomerStatus() async {
    try {
      CustomerInfo customerInfo = await Purchases.getCustomerInfo();
      var entitlement = customerInfo.entitlements.all["Rise Pro"];
      if (entitlement != null && entitlement.isActive) {
        isProMember.value = true;
      }
    } catch (e) {
    }
  }

  Future<void> restorePurchases() async {
    try {
      isLoading(true);
      CustomerInfo customerInfo = await Purchases.restorePurchases();
      var entitlement = customerInfo.entitlements.all["Rise Pro"];
      if (entitlement != null && entitlement.isActive) {
        isProMember.value = true;
        Get.snackbar("Success", "Purchases restored successfully!");
      } else {
        Get.snackbar("Notice", "No active subscription found to restore.");
      }
    } catch (e) {
      Get.snackbar("Error", e.toString());
    } finally {
      isLoading(false);
    }
  }
}