// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:get/get.dart';
// import 'package:http/http.dart' as http;
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:rosannalie/core/route/app_pages.dart';
// import 'package:rosannalie/core/services/controller/onboarding_controller.dart';
// import 'package:rosannalie/core/services/controller/todaytaskcontroller.dart';
// import 'package:rosannalie/core/services/controller/mygoall_controller.dart';
// import 'package:rosannalie/core/services/controller/wins_controller.dart';
// import 'package:rosannalie/core/services/controller/quote_controller.dart';
// import 'dart:async';
// import 'dart:io';
// import 'package:rosannalie/core/services/api_services/apiservices.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:flutter/foundation.dart';
// import 'package:google_sign_in/google_sign_in.dart';
// import 'package:sign_in_with_apple/sign_in_with_apple.dart';
// import 'package:purchases_flutter/purchases_flutter.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
//
// class Authcontroller extends GetxController {
//   final TextEditingController nameController = TextEditingController();
//   final TextEditingController emailController = TextEditingController();
//   final TextEditingController passwordController = TextEditingController();
//   final TextEditingController forgotPasswordEmailController =
//   TextEditingController();
//   final TextEditingController newPasswordController = TextEditingController();
//   final TextEditingController confirmPasswordController =
//   TextEditingController();
//
//   //========================emailverifcarion ===========
//   final List<TextEditingController> otpControllers = List.generate(
//     6,
//         (_) => TextEditingController(),
//   );
//
//   final RxBool isLoading = false.obs;
//   final RxBool rememberMe = false.obs;
//   final RxBool agreeToTerms = false.obs;
//
//   final RxInt resendTimer = 0.obs;
//   Timer? _timer;
//
//   @override
//   void onInit() {
//     super.onInit();
//     _loadSession();
//   }
//
//   Future<void> _loadSession() async {
//     final prefs = await SharedPreferences.getInstance();
//     accessToken = prefs.getString('accessToken') ?? '';
//     userName.value = prefs.getString('userName') ?? 'User';
//     userEmail.value = prefs.getString('userEmail') ?? 'user@example.com';
//     userAvatar.value = prefs.getString('userAvatar') ?? '';
//
//     if (accessToken.isNotEmpty) {
//       await fetchUserProfile();
//       await fetchDashboard();
//       await fetchUserMood();
//       await sendFCMTokenToBackend();
//     }
//   }
//
//   void startResendTimer() {
//     resendTimer.value = 30;
//     _timer?.cancel();
//     _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
//       if (resendTimer.value > 0) {
//         resendTimer.value--;
//       } else {
//         timer.cancel();
//       }
//     });
//   }
//
//   @override
//   void onClose() {
//     _timer?.cancel();
//     super.onClose();
//   }
//
//   Future<void> registerUser() async {
//     if (isLoading.value) return;
//
//     if (nameController.text.isEmpty ||
//         emailController.text.isEmpty ||
//         passwordController.text.isEmpty) {
//       Get.snackbar(
//         "Error",
//         "Please fill all fields",
//         backgroundColor: Colors.red,
//         colorText: Colors.white,
//       );
//       return;
//     }
//
//     if (passwordController.text != confirmPasswordController.text) {
//       Get.snackbar(
//         "Error",
//         "Passwords do not match",
//         backgroundColor: Colors.red,
//         colorText: Colors.white,
//       );
//       return;
//     }
//
//     if (!agreeToTerms.value) {
//       Get.snackbar(
//         "Error",
//         "Please agree to terms and privacy",
//         backgroundColor: Colors.red,
//         colorText: Colors.white,
//       );
//       return;
//     }
//
//     isLoading.value = true;
//     final onboardingController = Get.isRegistered<OnboardingController>()
//         ? Get.find<OnboardingController>()
//         : Get.put(OnboardingController());
//
//     try {
//       final obData = onboardingController.onboardingData;
//
//       final Map<String, dynamic> requestBody = {
//         "name": nameController.text,
//         "email": emailController.text,
//         "password": passwordController.text,
//         "onboarding": {
//           "proudOfText": obData["initialGoalTitle"] ?? "",
//           "useCases": obData["useCases"] ?? [],
//           "personalities": obData["personalities"] ?? [],
//           "energyTimes": obData["energyTimes"] ?? [],
//           "procrastinationFrequencies":
//           obData["procrastinationFrequencies"] ?? [],
//           "habitsToBuild": obData["habitsToBuild"] ?? [],
//           "motivationStyles": obData["motivationStyles"] ?? [],
//           "rewardPreferences": obData["rewardPreferences"] ?? [],
//           "reminderFrequency": obData["reminderFrequency"] ?? "SMART",
//           "personalityDescription": obData["initialMood"] ?? "",
//           "focuses": obData["focuses"] ?? [],
//           "initialGoalTitle": obData["initialGoalTitle"] ?? "",
//           "initialHabitName": obData["initialHabitName"] ?? "",
//           "initialMood": obData["initialMood"] ?? "",
//         },
//       };
//
//       print("===== REGISTER PAYLOAD =====");
//       print(jsonEncode(requestBody));
//       print("============================");
//
//       final response = await http.post(
//         Uri.parse(Apiservices.register),
//         headers: {
//           'Content-Type': 'application/json',
//           'ngrok-skip-browser-warning': 'true',
//           'bypass-tunnel-reminder': 'true',
//         },
//         body: jsonEncode(requestBody),
//       );
//
//       if (response.statusCode == 201 || response.statusCode == 200) {
//         Get.snackbar(
//           "Success",
//           "Account created! Please verify your email.",
//           backgroundColor: const Color(0xff5E4B8B),
//           colorText: Colors.white,
//         );
//         Get.toNamed(AppRoutes.verificationcode);
//       } else {
//         print("===== REGISTER RESPONSE ERR =====");
//         print("Status: ${response.statusCode}");
//         print("Body: ${response.body}");
//         print("=================================");
//
//         String errorMsg = response.body;
//         try {
//           final decoded = jsonDecode(response.body);
//           if (decoded['message'] != null) {
//             errorMsg = decoded['message'];
//           }
//         } catch (_) {}
//
//         if (errorMsg.length > 150) {
//           errorMsg = "${errorMsg.substring(0, 150)}...";
//         }
//
//         Get.snackbar(
//           "Error",
//           errorMsg,
//           backgroundColor: Colors.red,
//           colorText: Colors.white,
//         );
//       }
//     } catch (e) {
//       Get.snackbar(
//         "Error",
//         "An error occurred: $e",
//         backgroundColor: Colors.red,
//         colorText: Colors.white,
//       );
//     } finally {
//       isLoading.value = false;
//     }
//   }
//
//   final RxString userName = 'User'.obs;
//   final RxString userEmail = 'user@example.com'.obs;
//   final RxString userAvatar = ''.obs;
//   String accessToken = '';
//
//   final RxString selectedImagePath = ''.obs;
//   final RxInt dashboardStreak = 0.obs;
//   final RxInt dashboardGoals = 0.obs;
//   final RxInt dashboardGratitude = 0.obs;
//   final RxInt dashboardWins = 0.obs;
//   final RxBool isDashboardLoading = false.obs;
//   final RxString subscriptionPlan = 'FREE'.obs;
//   final RxString subscriptionBadge = 'Free'.obs;
//   final RxString subscriptionStatus = 'INACTIVE'.obs;
//
//   Future<void> pickImage() async {
//     final ImagePicker picker = ImagePicker();
//     final XFile? image = await picker.pickImage(
//       source: ImageSource.gallery,
//       imageQuality: 50,
//       maxWidth: 800,
//       maxHeight: 800,
//     );
//     if (image != null) {
//       selectedImagePath.value = image.path;
//     }
//   }
//
//   void initProfileEditing() {
//     nameController.text = userName.value;
//     emailController.text = userEmail.value;
//     selectedImagePath.value = '';
//   }
//
//   String get initials {
//     if (userName.value.isEmpty) return "U";
//     List<String> names = userName.value.trim().split(" ");
//     if (names.length >= 2) {
//       return "${names[0][0].toUpperCase()}${names[1][0].toUpperCase()}";
//     }
//     return userName.value[0].toUpperCase();
//   }
//   final RxString currentMood = 'good'.obs;
//
//   Future<void> fetchUserMood() async {
//     try {
//       final prefs = await SharedPreferences.getInstance();
//       final token = prefs.getString('accessToken') ?? accessToken;
//       if (token.isEmpty) return;
//
//       final response = await http.get(
//         Uri.parse(Apiservices.mode),
//         headers: {
//           'Content-Type': 'application/json',
//           'Authorization': 'Bearer $token',
//           'ngrok-skip-browser-warning': 'true',
//           'bypass-tunnel-reminder': 'true',
//         },
//       );
//
//       print("===== GET USER MOOD =====");
//       print("StatusCode: ${response.statusCode}");
//       print("Body: ${response.body}");
//       print("=========================");
//
//       if (response.statusCode == 200 || response.statusCode == 201) {
//         final decoded = jsonDecode(response.body);
//         if (decoded['success'] == true && decoded['data'] != null) {
//           if (decoded['data']['mood'] != null) {
//             currentMood.value = decoded['data']['mood'].toString().toLowerCase();
//           }
//         }
//       }
//     } catch (e) {
//       print("Error fetching user mood: $e");
//     }
//   }
//
//   Future<void> updateUserMood(String mood) async {
//     final String cleanMood = mood.trim().toLowerCase();
//     final String capitalizedMood = cleanMood.isEmpty
//         ? ''
//         : "${cleanMood[0].toUpperCase()}${cleanMood.substring(1)}";
//
//     currentMood.value = cleanMood;
//
//     try {
//       final prefs = await SharedPreferences.getInstance();
//       final token = prefs.getString('accessToken') ?? accessToken;
//       if (token.isEmpty) return;
//
//       final body = jsonEncode({
//         "mood": capitalizedMood,
//         "source": "APP_HEADER"
//       });
//
//       print("===== UPDATE USER MOOD PATCH =====");
//       print("URL: ${Apiservices.mode}");
//       print("Body: $body");
//
//       final response = await http.patch(
//         Uri.parse(Apiservices.mode),
//         headers: {
//           'Content-Type': 'application/json',
//           'Authorization': 'Bearer $token',
//           'ngrok-skip-browser-warning': 'true',
//           'bypass-tunnel-reminder': 'true',
//         },
//         body: body,
//       );
//
//       print("StatusCode: ${response.statusCode}");
//       print("Body: ${response.body}");
//       print("============================");
//
//       if (response.statusCode == 200 || response.statusCode == 201) {
//         Get.snackbar(
//           "Mood Updated",
//           "Feeling updated to $capitalizedMood!",
//           snackPosition: SnackPosition.BOTTOM,
//           backgroundColor: const Color(0xFF7B64B0),
//           colorText: Colors.white,
//           duration: const Duration(seconds: 2),
//         );
//         await fetchUserMood();
//       }
//     } catch (e) {
//       print("Error updating user mood: $e");
//     }
//   }
//
//   Future<void> fetchUserProfile() async {
//     try {
//       final response = await http.get(
//         Uri.parse(Apiservices.get_profile),
//         headers: {
//           'Content-Type': 'application/json',
//           'Authorization': 'Bearer $accessToken',
//           'ngrok-skip-browser-warning': 'true',
//           'bypass-tunnel-reminder': 'true',
//         },
//       );
//       if (response.statusCode == 200 || response.statusCode == 201) {
//         final decoded = await compute(jsonDecode, response.body);
//         final data = decoded['data'];
//         if (data != null) {
//           userName.value = data['name'] ?? 'User';
//           userEmail.value = data['email'] ?? 'user@example.com';
//           userAvatar.value = data['avatar'] ?? '';
//           if (data['mood'] != null) {
//             currentMood.value = data['mood'].toString().toLowerCase();
//           }
//           final prefs = await SharedPreferences.getInstance();
//           await prefs.setString('userName', userName.value);
//           await prefs.setString('userEmail', userEmail.value);
//           await prefs.setString('userAvatar', userAvatar.value);
//
//           // Link Current Session with RevenueCat
//           if (userEmail.value.isNotEmpty && userEmail.value != 'user@example.com') {
//              try {
//                 await Purchases.logIn(userEmail.value);
//              } catch (e) {
//                 print("RevenueCat LogIn skipped/failed (Check API Key): $e");
//              }
//           }
//         }
//       }
//     } catch (e) {
//       print("Error fetching profile: $e");
//     }
//   }
//
//   // ── Fetch Dashboard Stats ─────────────────────────────────────
//   Future<void> fetchDashboard() async {
//     try {
//       isDashboardLoading.value = true;
//       final response = await http.get(
//         Uri.parse(Apiservices.profile_dashboard),
//         headers: {
//           'Content-Type': 'application/json',
//           'Authorization': 'Bearer $accessToken',
//           'ngrok-skip-browser-warning': 'true',
//           'bypass-tunnel-reminder': 'true',
//         },
//       );
//
//       print("===== FETCH DASHBOARD =====");
//       print("StatusCode: ${response.statusCode}");
//       print("Body: ${response.body}");
//
//       if (response.statusCode == 200 || response.statusCode == 201) {
//         final decoded = await compute(jsonDecode, response.body);
//         if (decoded['success'] == true && decoded['data'] != null) {
//           final data = decoded['data'];
//
//           // Parse user info
//           if (data['user'] != null) {
//             final user = data['user'];
//             userName.value = user['name'] ?? userName.value;
//             userEmail.value = user['email'] ?? userEmail.value;
//             userAvatar.value = user['avatar'] ?? userAvatar.value;
//
//             final prefs = await SharedPreferences.getInstance();
//             await prefs.setString('userName', userName.value);
//             await prefs.setString('userEmail', userEmail.value);
//             await prefs.setString('userAvatar', userAvatar.value);
//           }
//
//           // Parse stats
//           if (data['stats'] != null) {
//             final stats = data['stats'];
//             dashboardStreak.value = stats['streak'] ?? 0;
//             dashboardGoals.value = stats['goals'] ?? 0;
//             dashboardGratitude.value = stats['gratitude'] ?? 0;
//             dashboardWins.value = stats['wins'] ?? 0;
//           }
//
//           // Parse subscription
//           if (data['subscription'] != null) {
//             final sub = data['subscription'];
//             subscriptionPlan.value = sub['plan'] ?? 'FREE';
//             subscriptionBadge.value = sub['badgeLabel'] ?? 'Free';
//             subscriptionStatus.value = sub['status'] ?? 'INACTIVE';
//           }
//         }
//       }
//     } catch (e) {
//       print("Error fetching dashboard: $e");
//     } finally {
//       isDashboardLoading.value = false;
//     }
//   }
//
//   Future<bool> updateProfile(String newName, String? imagePath) async {
//     isLoading.value = true;
//     try {
//       String? base64Image;
//       if (imagePath != null && imagePath.isNotEmpty) {
//         if (kIsWeb) {
//           // On web, imagePath is a blob URL, we need to fetch it to get bytes
//           final response = await http.get(Uri.parse(imagePath));
//           base64Image =
//           "data:image/png;base64,${base64Encode(response.bodyBytes)}";
//         } else {
//           final bytes = await File(imagePath).readAsBytes();
//           base64Image = "data:image/png;base64,${base64Encode(bytes)}";
//         }
//       }
//
//       final Map<String, dynamic> requestBody = {"name": newName};
//       if (base64Image != null) {
//         requestBody["avatar"] = base64Image;
//       }
//
//       http.Response response = await http.patch(
//         Uri.parse(Apiservices.update_profile),
//         headers: {
//           'Content-Type': 'application/json',
//           'Authorization': 'Bearer $accessToken',
//           'ngrok-skip-browser-warning': 'true',
//           'bypass-tunnel-reminder': 'true',
//         },
//         body: jsonEncode(requestBody),
//       );
//
//       print("===== UPDATE PROFILE RESPONSE =====");
//       print(response.body);
//       print("===================================");
//
//       if (response.statusCode == 200 || response.statusCode == 201) {
//         final decoded = jsonDecode(response.body);
//         final data = decoded['data'];
//         if (data != null) {
//           userName.value = data['name'] ?? userName.value;
//           userAvatar.value = data['avatar'] ?? userAvatar.value;
//         }
//         selectedImagePath.value = ''; // Clear selected image
//         Get.snackbar(
//           "Success",
//           "Profile updated successfully",
//           backgroundColor: const Color(0xff5E4B8B),
//           colorText: Colors.white,
//         );
//         return true;
//       } else {
//         String errorMsg = "Failed to update profile";
//         try {
//           final decoded = jsonDecode(response.body);
//           if (decoded['message'] != null) errorMsg = decoded['message'];
//         } catch (_) {}
//         Get.snackbar(
//           "Error",
//           errorMsg,
//           backgroundColor: Colors.red,
//           colorText: Colors.white,
//         );
//         return false;
//       }
//     } catch (e) {
//       Get.snackbar(
//         "Error",
//         "An error occurred: $e",
//         backgroundColor: Colors.red,
//         colorText: Colors.white,
//       );
//       return false;
//     } finally {
//       isLoading.value = false;
//     }
//   }
//
//   Future<void> signIn(GlobalKey<FormState> formKey) async {
//     if (!formKey.currentState!.validate()) return;
//     await signInWithoutValidation();
//   }
//
//   Future<void> signInWithoutValidation() async {
//     isLoading.value = true;
//
//     try {
//       final Map<String, dynamic> requestBody = {
//         "email": emailController.text,
//         "password": passwordController.text,
//       };
//
//       print("===== LOGIN PAYLOAD =====");
//       print(jsonEncode(requestBody));
//       print("=========================");
//
//       final response = await http.post(
//         Uri.parse(Apiservices.login),
//         headers: {
//           'Content-Type': 'application/json',
//           'ngrok-skip-browser-warning': 'true',
//           'bypass-tunnel-reminder': 'true',
//         },
//         body: jsonEncode(requestBody),
//       );
//
//       if (response.statusCode == 200 || response.statusCode == 201) {
//         try {
//           final decoded = jsonDecode(response.body);
//           if (decoded['data'] != null &&
//               decoded['data']['accessToken'] != null) {
//             accessToken = decoded['data']['accessToken'];
//
//             final prefs = await SharedPreferences.getInstance();
//             await prefs.setString('accessToken', accessToken);
//             await prefs.setBool('isLoggedIn', true);
//             await prefs.setBool('isOnboardingCompleted', true);
//           }
//         } catch (_) {}
//
//         await fetchUserProfile();
//         await fetchDashboard();
//         await fetchUserMood();
//         await sendFCMTokenToBackend();
//
//         try {
//           if (Get.isRegistered<Todaytaskcontroller>()) {
//             Get.find<Todaytaskcontroller>().fetchTasks();
//           }
//           if (Get.isRegistered<MygoallController>()) {
//             Get.find<MygoallController>().fetchGoals();
//           } else {
//             Get.put(MygoallController()).fetchGoals();
//           }
//           if (Get.isRegistered<WinsController>()) {
//             Get.find<WinsController>().fetchWinsDashboard();
//           } else {
//             Get.put(WinsController()).fetchWinsDashboard();
//           }
//           if (Get.isRegistered<QuoteController>()) {
//             Get.find<QuoteController>().fetchQuotes();
//             Get.find<QuoteController>().fetchDailyQuote();
//           } else {
//             Get.put(QuoteController()).fetchQuotes();
//             Get.find<QuoteController>().fetchDailyQuote();
//           }
//         } catch (_) {}
//
//         Get.snackbar(
//           "Success",
//           "Logged in successfully",
//           backgroundColor: const Color(0xff5E4B8B),
//           colorText: Colors.white,
//         );
//         Get.offAllNamed(AppRoutes.subscriptionPromotion);
//       } else {
//         String errorMsg = response.body;
//         try {
//           final decoded = jsonDecode(response.body);
//           if (decoded['message'] != null) {
//             errorMsg = decoded['message'];
//           }
//         } catch (_) {}
//         if (errorMsg.length > 100)
//           errorMsg = "${errorMsg.substring(0, 100)}...";
//         Get.snackbar(
//           "Error",
//           "Failed to login. $errorMsg",
//           backgroundColor: Colors.red,
//           colorText: Colors.white,
//         );
//       }
//     } catch (e) {
//       Get.snackbar(
//         "Error",
//         "An error occurred: $e",
//         backgroundColor: Colors.red,
//         colorText: Colors.white,
//       );
//     } finally {
//       isLoading.value = false;
//     }
//   }
//
//   Future<void> logout() async {
//     final prefs = await SharedPreferences.getInstance();
//     await prefs.remove('accessToken');
//     await prefs.remove('userName');
//     await prefs.remove('userEmail');
//     await prefs.remove('userAvatar');
//     await prefs.setBool('isLoggedIn', false);
//     accessToken = '';
//     userName.value = 'User';
//     userEmail.value = 'user@example.com';
//     userAvatar.value = '';
//     try { await Purchases.logOut(); } catch (_) {}
//     Get.offAllNamed(AppRoutes.singin);
//   }
//
//   Future<void> resetAppAndLogout() async {
//     final prefs = await SharedPreferences.getInstance();
//     await prefs.clear(); // Complete clear for fresh start
//     accessToken = '';
//     userName.value = 'User';
//     userEmail.value = 'user@example.com';
//     userAvatar.value = '';
//     try { await Purchases.logOut(); } catch (_) {}
//     Get.offAllNamed(AppRoutes.onborading);
//   }
//
//   Future<void> sendForgotPasswordCode(GlobalKey<FormState> formKey) async {
//     if (!formKey.currentState!.validate()) return;
//
//     isLoading.value = true;
//     try {
//       final Map<String, dynamic> requestBody = {
//         "email": forgotPasswordEmailController.text,
//       };
//
//       final response = await http.post(
//         Uri.parse(Apiservices.forgot_password),
//         headers: {
//           'Content-Type': 'application/json',
//           'ngrok-skip-browser-warning': 'true',
//           'bypass-tunnel-reminder': 'true',
//         },
//         body: jsonEncode(requestBody),
//       );
//
//       if (response.statusCode == 200 || response.statusCode == 201) {
//         startResendTimer();
//         Get.toNamed(AppRoutes.verificationcode);
//         Get.snackbar(
//           "Success",
//           "Verification code sent to ${forgotPasswordEmailController.text} successfully!",
//           snackPosition: SnackPosition.BOTTOM,
//           backgroundColor: const Color(0xff5E4B8B),
//           colorText: Colors.white,
//         );
//       } else {
//         Get.snackbar(
//           "Error",
//           "Failed to send code. ${response.body}",
//           snackPosition: SnackPosition.BOTTOM,
//           backgroundColor: Colors.red,
//           colorText: Colors.white,
//         );
//       }
//     } catch (e) {
//       Get.snackbar(
//         "Error",
//         "An error occurred: $e",
//         snackPosition: SnackPosition.BOTTOM,
//         backgroundColor: Colors.red,
//         colorText: Colors.white,
//       );
//     } finally {
//       isLoading.value = false;
//     }
//   }
//
//   //========================emailverifcarion ===========
//   Future<void> verifyOtp() async {
//     String otp = otpControllers.map((controller) => controller.text).join();
//     if (otp.length < 6) {
//       Get.snackbar(
//         "Error",
//         "Please enter the complete 6-digit code.",
//         snackPosition: SnackPosition.BOTTOM,
//         backgroundColor: Colors.red,
//         colorText: Colors.white,
//       );
//       return;
//     }
//
//     isLoading.value = true;
//     final String emailToVerify = emailController.text.isNotEmpty
//         ? emailController.text
//         : forgotPasswordEmailController.text;
//
//     if (emailToVerify.isEmpty) {
//       Get.snackbar(
//         "Error",
//         "Email address not found. Please try the process from the beginning.",
//         snackPosition: SnackPosition.BOTTOM,
//         backgroundColor: Colors.red,
//         colorText: Colors.white,
//       );
//       isLoading.value = false;
//       return;
//     }
//
//     bool isForgotPassword =
//         forgotPasswordEmailController.text.isNotEmpty &&
//             emailController.text.isEmpty;
//
//     final String endpoint = isForgotPassword
//         ? Apiservices.verify_reset_otp
//         : Apiservices.verify_otp;
//
//     try {
//       final Map<String, dynamic> requestBody = {
//         "email": emailToVerify,
//         "code": otp,
//       };
//
//       print("===== VERIFY OTP PAYLOAD =====");
//       print(jsonEncode(requestBody));
//       print("Endpoint: $endpoint");
//       print("==============================");
//
//       final response = await http.post(
//         Uri.parse(endpoint),
//         headers: {
//           'Content-Type': 'application/json',
//           'ngrok-skip-browser-warning': 'true',
//           'bypass-tunnel-reminder': 'true',
//         },
//         body: jsonEncode(requestBody),
//       );
//
//       if (response.statusCode == 200 || response.statusCode == 201) {
//         if (isForgotPassword) {
//           Get.toNamed(AppRoutes.resetpassword);
//           Get.snackbar(
//             "Success",
//             "Code verified successfully!",
//             snackPosition: SnackPosition.BOTTOM,
//             backgroundColor: const Color(0xff5E4B8B),
//             colorText: Colors.white,
//           );
//         } else {
//           for (var controller in otpControllers) {
//             controller.clear();
//           }
//           Get.snackbar(
//             "Success",
//             "Email verified! Logging you in...",
//             snackPosition: SnackPosition.BOTTOM,
//             backgroundColor: const Color(0xff5E4B8B),
//             colorText: Colors.white,
//           );
//           await signInWithoutValidation();
//         }
//       } else {
//         String errorMsg = response.body;
//         if (errorMsg.length > 100)
//           errorMsg = "${errorMsg.substring(0, 100)}...";
//         Get.snackbar(
//           "Error",
//           "Verification failed. $errorMsg",
//           snackPosition: SnackPosition.BOTTOM,
//           backgroundColor: Colors.red,
//           colorText: Colors.white,
//         );
//       }
//     } catch (e) {
//       Get.snackbar(
//         "Error",
//         "An error occurred: $e",
//         snackPosition: SnackPosition.BOTTOM,
//         backgroundColor: Colors.red,
//         colorText: Colors.white,
//       );
//     } finally {
//       isLoading.value = false;
//     }
//   }
//   //===========================resendotp_code====================================================
//
//   Future<void> resendOtpCode() async {
//     isLoading.value = true;
//     try {
//       bool isForgotPassword =
//           emailController.text.isEmpty &&
//               forgotPasswordEmailController.text.isNotEmpty;
//
//       final Map<String, dynamic> requestBody = {
//         "email": isForgotPassword
//             ? forgotPasswordEmailController.text
//             : emailController.text,
//       };
//
//       final String endpoint = isForgotPassword
//           ? Apiservices.forgot_password
//           : Apiservices.resend_otp;
//
//       final response = await http.post(
//         Uri.parse(endpoint),
//         headers: {
//           'Content-Type': 'application/json',
//           'ngrok-skip-browser-warning': 'true',
//           'bypass-tunnel-reminder': 'true',
//         },
//         body: jsonEncode(requestBody),
//       );
//
//       if (response.statusCode == 200 || response.statusCode == 201) {
//         Get.snackbar(
//           "Code Resent",
//           "A new verification code has been sent to your email.",
//           snackPosition: SnackPosition.BOTTOM,
//           backgroundColor: const Color(0xff5E4B8B),
//           colorText: Colors.white,
//         );
//       } else {
//         Get.snackbar(
//           "Error",
//           "Failed to resend code. ${response.body}",
//           snackPosition: SnackPosition.BOTTOM,
//           backgroundColor: Colors.red,
//           colorText: Colors.white,
//         );
//       }
//     } catch (e) {
//       Get.snackbar(
//         "Error",
//         "An error occurred: $e",
//         snackPosition: SnackPosition.BOTTOM,
//         backgroundColor: Colors.red,
//         colorText: Colors.white,
//       );
//     } finally {
//       isLoading.value = false;
//     }
//   }
//
//   Future<void> createNewPassword(GlobalKey<FormState> formKey) async {
//     if (!formKey.currentState!.validate()) return;
//
//     if (newPasswordController.text != confirmPasswordController.text) {
//       Get.snackbar(
//         "Error",
//         "Passwords do not match",
//         snackPosition: SnackPosition.BOTTOM,
//         backgroundColor: Colors.red,
//         colorText: Colors.white,
//       );
//       return;
//     }
//
//     String otp = otpControllers.map((controller) => controller.text).join();
//     isLoading.value = true;
//     try {
//       final Map<String, dynamic> requestBody = {
//         "email": forgotPasswordEmailController.text,
//         "code": otp,
//         "newPassword": newPasswordController.text,
//         "confirmPassword": confirmPasswordController.text,
//       };
//
//       final response = await http.post(
//         Uri.parse(Apiservices.reset_password),
//         headers: {
//           'Content-Type': 'application/json',
//           'ngrok-skip-browser-warning': 'true',
//           'bypass-tunnel-reminder': 'true',
//         },
//         body: jsonEncode(requestBody),
//       );
//
//       if (response.statusCode == 200 || response.statusCode == 201) {
//         emailController.text = forgotPasswordEmailController.text;
//         passwordController.text = newPasswordController.text;
//
//         newPasswordController.clear();
//         confirmPasswordController.clear();
//         for (var controller in otpControllers) controller.clear();
//         Get.offAllNamed(AppRoutes.resetsuccess);
//         Get.snackbar(
//           "Success",
//           "Password changed successfully!",
//           snackPosition: SnackPosition.BOTTOM,
//           backgroundColor: const Color(0xff5E4B8B),
//           colorText: Colors.white,
//         );
//       } else {
//         Get.snackbar(
//           "Error",
//           "Failed to reset password. ${response.body}",
//           snackPosition: SnackPosition.BOTTOM,
//           backgroundColor: Colors.red,
//           colorText: Colors.white,
//         );
//       }
//     } catch (e) {
//       Get.snackbar(
//         "Error",
//         "An error occurred: $e",
//         snackPosition: SnackPosition.BOTTOM,
//         backgroundColor: Colors.red,
//         colorText: Colors.white,
//       );
//     } finally {
//       isLoading.value = false;
//     }
//   }
//
//   Future<bool> deleteAccount() async {
//     isLoading.value = true;
//     try {
//       final response = await http.delete(
//         Uri.parse(Apiservices.get_profile), // uses $baseUrl/users/me
//         headers: {
//           'Content-Type': 'application/json',
//           'Authorization': 'Bearer $accessToken',
//           'ngrok-skip-browser-warning': 'true',
//           'bypass-tunnel-reminder': 'true',
//         },
//         body: jsonEncode({
//           "confirmationText": "DELETE",
//         }),
//       );
//       print("===== DELETE ACCOUNT RESPONSE =====");
//       print("Status Code: ${response.statusCode}");
//       print("Body: ${response.body}");
//       print("===================================");
//
//       if (response.statusCode == 200 || response.statusCode == 201 || response.statusCode == 204) {
//         return true;
//       }
//       return false;
//     } catch (e) {
//       print("Delete account error: $e");
//       return false;
//     } finally {
//       isLoading.value = false;
//     }
//   }
//
//   Future<void> sendFCMTokenToBackend() async {
//     if (kIsWeb) {
//       print(
//           "Skipping FCM token generation on Web/Chrome to avoid configuration errors during testing.");
//       return;
//     }
//
//     try {
//       NotificationSettings currentSettings = await FirebaseMessaging.instance.getNotificationSettings();
//       bool isGranted = currentSettings.authorizationStatus == AuthorizationStatus.authorized;
//
//       if (!isGranted) {
//         NotificationSettings settings = await FirebaseMessaging.instance.requestPermission(
//           alert: true,
//           badge: true,
//           sound: true,
//         );
//
//         bool isAndroidGranted = false;
//         if (defaultTargetPlatform == TargetPlatform.android) {
//             final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
//             isAndroidGranted = await flutterLocalNotificationsPlugin
//                 .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
//                 ?.requestNotificationsPermission() ?? false;
//         }
//
//         isGranted = settings.authorizationStatus == AuthorizationStatus.authorized || isAndroidGranted;
//       }
//
//       if (isGranted) {
//         String? fcmToken = await FirebaseMessaging.instance.getToken();
//
//         if (fcmToken != null) {
//           print("FCM Token: $fcmToken");
//
//           var url = Uri.parse(Apiservices.register_token);
//           final prefs = await SharedPreferences.getInstance();
//           final token = prefs.getString('accessToken') ?? accessToken;
//
//           if (token.isEmpty) return;
//
//           var response = await http.post(
//             url,
//             headers: {
//               'Content-Type': 'application/json',
//               'Authorization': 'Bearer $token',
//               'ngrok-skip-browser-warning': 'true',
//               'bypass-tunnel-reminder': 'true',
//             },
//             body: jsonEncode({
//               "fcmToken": fcmToken,
//             }),
//           );
//
//           if (response.statusCode == 200 || response.statusCode == 201) {
//             print("FCM Token successfully registered!");
//           } else {
//             print("Failed to register token: ${response.statusCode} - ${response.body}");
//           }
//         }
//       }
//     } catch (e) {
//       print("Error sending FCM token: $e");
//     }
//   }
//
//   Future<void> signInWithGoogle() async {
//     try {
//       isLoading.value = true;
//
//       await GoogleSignIn.instance.initialize(
//         serverClientId: "PASTE_YOUR_WEB_CLIENT_ID_HERE.apps.googleusercontent.com",
//       );
//       final GoogleSignInAccount googleUser = await GoogleSignIn.instance.authenticate();
//
//       final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
//       final String idToken = googleAuth.idToken ?? '';
//       final String name = googleUser.displayName ?? '';
//
//       await _authenticateSocialLogin(Apiservices.goggle_login, idToken, name);
//     } catch (e) {
//       isLoading.value = false;
//       Get.snackbar("Error", "Google sign in failed: $e", backgroundColor: Colors.red, colorText: Colors.white);
//     }
//   }
//
//   Future<void> signInWithApple() async {
//     try {
//       isLoading.value = true;
//       final AuthorizationCredentialAppleID credential =
//           await SignInWithApple.getAppleIDCredential(
//         scopes: [
//           AppleIDAuthorizationScopes.email,
//           AppleIDAuthorizationScopes.fullName,
//         ],
//       );
//
//       final String idToken = credential.identityToken ?? credential.authorizationCode;
//       final String name = credential.givenName != null ? "${credential.givenName} ${credential.familyName ?? ''}".trim() : '';
//
//       await _authenticateSocialLogin(Apiservices.apple_login, idToken, name);
//     } catch (e) {
//       isLoading.value = false;
//       Get.snackbar("Error", "Apple sign in failed: $e", backgroundColor: Colors.red, colorText: Colors.white);
//     }
//   }
//
//   Future<void> _authenticateSocialLogin(String endpoint, String idToken, String name) async {
//     try {
//       final onboardingController = Get.isRegistered<OnboardingController>()
//           ? Get.find<OnboardingController>()
//           : Get.put(OnboardingController());
//       final obData = onboardingController.onboardingData;
//
//       final Map<String, dynamic> requestBody = {
//         "idToken": idToken,
//         "name": name,
//         "onboarding": {
//           "proudOfText": obData["initialGoalTitle"] ?? "",
//           "useCases": obData["useCases"] ?? [],
//           "personalities": obData["personalities"] ?? [],
//           "energyTimes": obData["energyTimes"] ?? [],
//           "procrastinationFrequencies":
//           obData["procrastinationFrequencies"] ?? [],
//           "habitsToBuild": obData["habitsToBuild"] ?? [],
//           "motivationStyles": obData["motivationStyles"] ?? [],
//           "rewardPreferences": obData["rewardPreferences"] ?? [],
//           "reminderFrequency": obData["reminderFrequency"] ?? "SMART",
//           "personalityDescription": obData["initialMood"] ?? "",
//           "focuses": obData["focuses"] ?? [],
//           "initialGoalTitle": obData["initialGoalTitle"] ?? "",
//           "initialHabitName": obData["initialHabitName"] ?? "",
//           "initialMood": obData["initialMood"] ?? "",
//         }
//       };
//
//       print("===== SOCIAL LOGIN PAYLOAD =====");
//       print(jsonEncode(requestBody));
//       print("Endpoint: $endpoint");
//
//       final response = await http.post(
//         Uri.parse(endpoint),
//         headers: {
//           'Content-Type': 'application/json',
//           'ngrok-skip-browser-warning': 'true',
//           'bypass-tunnel-reminder': 'true',
//         },
//         body: jsonEncode(requestBody),
//       );
//
//       print("===== SOCIAL LOGIN RESPONSE =====");
//       print("StatusCode: ${response.statusCode}");
//       print("Body: ${response.body}");
//
//       if (response.statusCode == 200 || response.statusCode == 201) {
//         try {
//           final decoded = jsonDecode(response.body);
//           if (decoded['data'] != null &&
//               decoded['data']['accessToken'] != null) {
//             accessToken = decoded['data']['accessToken'];
//
//             final prefs = await SharedPreferences.getInstance();
//             await prefs.setString('accessToken', accessToken);
//             await prefs.setBool('isLoggedIn', true);
//             await prefs.setBool('isOnboardingCompleted', true);
//           }
//         } catch (_) {}
//
//         await fetchUserProfile();
//         await fetchDashboard();
//         await fetchUserMood();
//         await sendFCMTokenToBackend();
//
//         try {
//           if (Get.isRegistered<Todaytaskcontroller>()) {
//             Get.find<Todaytaskcontroller>().fetchTasks();
//           }
//           if (Get.isRegistered<MygoallController>()) {
//             Get.find<MygoallController>().fetchGoals();
//           } else {
//             Get.put(MygoallController()).fetchGoals();
//           }
//           if (Get.isRegistered<WinsController>()) {
//             Get.find<WinsController>().fetchWinsDashboard();
//           } else {
//             Get.put(WinsController()).fetchWinsDashboard();
//           }
//           if (Get.isRegistered<QuoteController>()) {
//             Get.find<QuoteController>().fetchQuotes();
//             Get.find<QuoteController>().fetchDailyQuote();
//           } else {
//             Get.put(QuoteController()).fetchQuotes();
//             Get.find<QuoteController>().fetchDailyQuote();
//           }
//         } catch (_) {}
//
//         Get.snackbar(
//           "Success",
//           "Logged in successfully",
//           backgroundColor: const Color(0xff5E4B8B),
//           colorText: Colors.white,
//         );
//         Get.offAllNamed(AppRoutes.subscriptionPromotion);
//       } else {
//         String errorMsg = response.body;
//         try {
//           final decoded = jsonDecode(response.body);
//           if (decoded['message'] != null) {
//             errorMsg = decoded['message'];
//           }
//         } catch (_) {}
//         if (errorMsg.length > 100) {
//           errorMsg = "${errorMsg.substring(0, 100)}...";
//         }
//         Get.snackbar(
//           "Error",
//           "Failed to login. $errorMsg",
//           backgroundColor: Colors.red,
//           colorText: Colors.white,
//         );
//       }
//     } catch (e) {
//       Get.snackbar(
//         "Error",
//         "An error occurred: $e",
//         backgroundColor: Colors.red,
//         colorText: Colors.white,
//       );
//     } finally {
//       isLoading.value = false;
//     }
//   }
// }


import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:rosannalie/core/route/app_pages.dart';
import 'package:rosannalie/core/services/controller/onboarding_controller.dart';
import 'package:rosannalie/core/services/controller/todaytaskcontroller.dart';
import 'package:rosannalie/core/services/controller/mygoall_controller.dart';
import 'package:rosannalie/core/services/controller/wins_controller.dart';
import 'package:rosannalie/core/services/controller/quote_controller.dart';
import 'dart:async';
import 'dart:io';
import 'package:rosannalie/core/services/api_services/apiservices.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class Authcontroller extends GetxController {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController forgotPasswordEmailController =
  TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmPasswordController =
  TextEditingController();

  //========================emailverifcarion ===========
  final List<TextEditingController> otpControllers = List.generate(
    6,
        (_) => TextEditingController(),
  );

  final RxBool isLoading = false.obs;
  final RxBool rememberMe = false.obs;
  final RxBool agreeToTerms = false.obs;

  final RxInt resendTimer = 0.obs;
  Timer? _timer;

  @override
  void onInit() {
    super.onInit();
    _loadSession();
  }

  Future<void> _loadSession() async {
    final prefs = await SharedPreferences.getInstance();
    accessToken = prefs.getString('accessToken') ?? '';
    userName.value = prefs.getString('userName') ?? 'User';
    userEmail.value = prefs.getString('userEmail') ?? 'user@example.com';
    userAvatar.value = prefs.getString('userAvatar') ?? '';

    if (accessToken.isNotEmpty) {
      await fetchUserProfile();
      await fetchDashboard();
      await fetchUserMood();
      await sendFCMTokenToBackend();
    }
  }

  void startResendTimer() {
    resendTimer.value = 30;
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (resendTimer.value > 0) {
        resendTimer.value--;
      } else {
        timer.cancel();
      }
    });
  }

  @override
  void onClose() {
    _timer?.cancel();
    super.onClose();
  }

  Future<void> registerUser() async {
    if (isLoading.value) return;

    if (nameController.text.isEmpty ||
        emailController.text.isEmpty ||
        passwordController.text.isEmpty) {
      Get.snackbar(
        "Error",
        "Please fill all fields",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    if (passwordController.text != confirmPasswordController.text) {
      Get.snackbar(
        "Error",
        "Passwords do not match",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    if (!agreeToTerms.value) {
      Get.snackbar(
        "Error",
        "Please agree to terms and privacy",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    isLoading.value = true;
    final onboardingController = Get.isRegistered<OnboardingController>()
        ? Get.find<OnboardingController>()
        : Get.put(OnboardingController());

    try {
      final obData = onboardingController.onboardingData;

      final Map<String, dynamic> requestBody = {
        "name": nameController.text,
        "email": emailController.text,
        "password": passwordController.text,
        "onboarding": {
          "proudOfText": obData["initialGoalTitle"] ?? "",
          "useCases": obData["useCases"] ?? [],
          "personalities": obData["personalities"] ?? [],
          "energyTimes": obData["energyTimes"] ?? [],
          "procrastinationFrequencies":
          obData["procrastinationFrequencies"] ?? [],
          "habitsToBuild": obData["habitsToBuild"] ?? [],
          "motivationStyles": obData["motivationStyles"] ?? [],
          "rewardPreferences": obData["rewardPreferences"] ?? [],
          "reminderFrequency": obData["reminderFrequency"] ?? "SMART",
          "personalityDescription": obData["initialMood"] ?? "",
          "focuses": obData["focuses"] ?? [],
          "initialGoalTitle": obData["initialGoalTitle"] ?? "",
          "initialHabitName": obData["initialHabitName"] ?? "",
          "initialMood": obData["initialMood"] ?? "",
        },
      };

      print("===== REGISTER PAYLOAD =====");
      print(jsonEncode(requestBody));
      print("============================");

      final response = await http.post(
        Uri.parse(Apiservices.register),
        headers: {
          'Content-Type': 'application/json',
          'ngrok-skip-browser-warning': 'true',
          'bypass-tunnel-reminder': 'true',
        },
        body: jsonEncode(requestBody),
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        Get.snackbar(
          "Success",
          "Account created! Please verify your email.",
          backgroundColor: const Color(0xff5E4B8B),
          colorText: Colors.white,
        );
        Get.toNamed(AppRoutes.verificationcode);
      } else {
        print("===== REGISTER RESPONSE ERR =====");
        print("Status: ${response.statusCode}");
        print("Body: ${response.body}");
        print("=================================");

        String errorMsg = response.body;
        try {
          final decoded = jsonDecode(response.body);
          if (decoded['message'] != null) {
            errorMsg = decoded['message'];
          }
        } catch (_) {}

        if (errorMsg.length > 150) {
          errorMsg = "${errorMsg.substring(0, 150)}...";
        }

        Get.snackbar(
          "Error",
          errorMsg,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        "Error",
        "An error occurred: $e",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  final RxString userName = 'User'.obs;
  final RxString userEmail = 'user@example.com'.obs;
  final RxString userAvatar = ''.obs;
  String accessToken = '';

  final RxString selectedImagePath = ''.obs;
  final RxInt dashboardStreak = 0.obs;
  final RxInt dashboardGoals = 0.obs;
  final RxInt dashboardGratitude = 0.obs;
  final RxInt dashboardWins = 0.obs;
  final RxBool isDashboardLoading = false.obs;
  final RxString subscriptionPlan = 'FREE'.obs;
  final RxString subscriptionBadge = 'Free'.obs;
  final RxString subscriptionStatus = 'INACTIVE'.obs;

  Future<void> pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 50,
      maxWidth: 800,
      maxHeight: 800,
    );
    if (image != null) {
      selectedImagePath.value = image.path;
    }
  }

  void initProfileEditing() {
    nameController.text = userName.value;
    emailController.text = userEmail.value;
    selectedImagePath.value = '';
  }

  String get initials {
    if (userName.value.isEmpty) return "U";
    List<String> names = userName.value.trim().split(" ");
    if (names.length >= 2) {
      return "${names[0][0].toUpperCase()}${names[1][0].toUpperCase()}";
    }
    return userName.value[0].toUpperCase();
  }
  final RxString currentMood = 'good'.obs;

  Future<void> fetchUserMood() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('accessToken') ?? accessToken;
      if (token.isEmpty) return;

      final response = await http.get(
        Uri.parse(Apiservices.mode),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
          'ngrok-skip-browser-warning': 'true',
          'bypass-tunnel-reminder': 'true',
        },
      );

      print("===== GET USER MOOD =====");
      print("StatusCode: ${response.statusCode}");
      print("Body: ${response.body}");
      print("=========================");

      if (response.statusCode == 200 || response.statusCode == 201) {
        final decoded = jsonDecode(response.body);
        if (decoded['success'] == true && decoded['data'] != null) {
          if (decoded['data']['mood'] != null) {
            currentMood.value = decoded['data']['mood'].toString().toLowerCase();
          }
        }
      }
    } catch (e) {
      print("Error fetching user mood: $e");
    }
  }

  Future<void> updateUserMood(String mood) async {
    final String cleanMood = mood.trim().toLowerCase();
    final String capitalizedMood = cleanMood.isEmpty
        ? ''
        : "${cleanMood[0].toUpperCase()}${cleanMood.substring(1)}";

    currentMood.value = cleanMood;

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('accessToken') ?? accessToken;
      if (token.isEmpty) return;

      final body = jsonEncode({
        "mood": capitalizedMood,
        "source": "APP_HEADER"
      });

      print("===== UPDATE USER MOOD PATCH =====");
      print("URL: ${Apiservices.mode}");
      print("Body: $body");

      final response = await http.patch(
        Uri.parse(Apiservices.mode),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
          'ngrok-skip-browser-warning': 'true',
          'bypass-tunnel-reminder': 'true',
        },
        body: body,
      );

      print("StatusCode: ${response.statusCode}");
      print("Body: ${response.body}");
      print("============================");

      if (response.statusCode == 200 || response.statusCode == 201) {
        Get.snackbar(
          "Mood Updated",
          "Feeling updated to $capitalizedMood!",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: const Color(0xFF7B64B0),
          colorText: Colors.white,
          duration: const Duration(seconds: 2),
        );
        await fetchUserMood();
      }
    } catch (e) {
      print("Error updating user mood: $e");
    }
  }

  Future<void> fetchUserProfile() async {
    try {
      final response = await http.get(
        Uri.parse(Apiservices.get_profile),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
          'ngrok-skip-browser-warning': 'true',
          'bypass-tunnel-reminder': 'true',
        },
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        final decoded = await compute(jsonDecode, response.body);
        final data = decoded['data'];
        if (data != null) {
          userName.value = data['name'] ?? 'User';
          userEmail.value = data['email'] ?? 'user@example.com';
          userAvatar.value = data['avatar'] ?? '';
          if (data['mood'] != null) {
            currentMood.value = data['mood'].toString().toLowerCase();
          }
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('userName', userName.value);
          await prefs.setString('userEmail', userEmail.value);
          await prefs.setString('userAvatar', userAvatar.value);

          // Link Current Session with RevenueCat
          if (userEmail.value.isNotEmpty && userEmail.value != 'user@example.com') {
            try {
              await Purchases.logIn(userEmail.value);
            } catch (e) {
              print("RevenueCat LogIn skipped/failed (Check API Key): $e");
            }
          }
        }
      }
    } catch (e) {
      print("Error fetching profile: $e");
    }
  }

  // ── Fetch Dashboard Stats ─────────────────────────────────────
  Future<void> fetchDashboard() async {
    try {
      isDashboardLoading.value = true;
      final response = await http.get(
        Uri.parse(Apiservices.profile_dashboard),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
          'ngrok-skip-browser-warning': 'true',
          'bypass-tunnel-reminder': 'true',
        },
      );

      print("===== FETCH DASHBOARD =====");
      print("StatusCode: ${response.statusCode}");
      print("Body: ${response.body}");

      if (response.statusCode == 200 || response.statusCode == 201) {
        final decoded = await compute(jsonDecode, response.body);
        if (decoded['success'] == true && decoded['data'] != null) {
          final data = decoded['data'];

          // Parse user info
          if (data['user'] != null) {
            final user = data['user'];
            userName.value = user['name'] ?? userName.value;
            userEmail.value = user['email'] ?? userEmail.value;
            userAvatar.value = user['avatar'] ?? userAvatar.value;

            final prefs = await SharedPreferences.getInstance();
            await prefs.setString('userName', userName.value);
            await prefs.setString('userEmail', userEmail.value);
            await prefs.setString('userAvatar', userAvatar.value);
          }

          // Parse stats
          if (data['stats'] != null) {
            final stats = data['stats'];
            dashboardStreak.value = stats['streak'] ?? 0;
            dashboardGoals.value = stats['goals'] ?? 0;
            dashboardGratitude.value = stats['gratitude'] ?? 0;
            dashboardWins.value = stats['wins'] ?? 0;
          }

          // Parse subscription
          if (data['subscription'] != null) {
            final sub = data['subscription'];
            subscriptionPlan.value = sub['plan'] ?? 'FREE';
            subscriptionBadge.value = sub['badgeLabel'] ?? 'Free';
            subscriptionStatus.value = sub['status'] ?? 'INACTIVE';
          }
        }
      }
    } catch (e) {
      print("Error fetching dashboard: $e");
    } finally {
      isDashboardLoading.value = false;
    }
  }

  Future<bool> updateProfile(String newName, String? imagePath) async {
    isLoading.value = true;
    try {
      String? base64Image;
      if (imagePath != null && imagePath.isNotEmpty) {
        if (kIsWeb) {
          // On web, imagePath is a blob URL, we need to fetch it to get bytes
          final response = await http.get(Uri.parse(imagePath));
          base64Image =
          "data:image/png;base64,${base64Encode(response.bodyBytes)}";
        } else {
          final bytes = await File(imagePath).readAsBytes();
          base64Image = "data:image/png;base64,${base64Encode(bytes)}";
        }
      }

      final Map<String, dynamic> requestBody = {"name": newName};
      if (base64Image != null) {
        requestBody["avatar"] = base64Image;
      }

      http.Response response = await http.patch(
        Uri.parse(Apiservices.update_profile),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
          'ngrok-skip-browser-warning': 'true',
          'bypass-tunnel-reminder': 'true',
        },
        body: jsonEncode(requestBody),
      );

      print("===== UPDATE PROFILE RESPONSE =====");
      print(response.body);
      print("===================================");

      if (response.statusCode == 200 || response.statusCode == 201) {
        final decoded = jsonDecode(response.body);
        final data = decoded['data'];
        if (data != null) {
          userName.value = data['name'] ?? userName.value;
          userAvatar.value = data['avatar'] ?? userAvatar.value;
        }
        selectedImagePath.value = ''; // Clear selected image
        Get.snackbar(
          "Success",
          "Profile updated successfully",
          backgroundColor: const Color(0xff5E4B8B),
          colorText: Colors.white,
        );
        return true;
      } else {
        String errorMsg = "Failed to update profile";
        try {
          final decoded = jsonDecode(response.body);
          if (decoded['message'] != null) errorMsg = decoded['message'];
        } catch (_) {}
        Get.snackbar(
          "Error",
          errorMsg,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return false;
      }
    } catch (e) {
      Get.snackbar(
        "Error",
        "An error occurred: $e",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> signIn(GlobalKey<FormState> formKey) async {
    if (!formKey.currentState!.validate()) return;
    await signInWithoutValidation();
  }

  Future<void> signInWithoutValidation() async {
    isLoading.value = true;

    try {
      final Map<String, dynamic> requestBody = {
        "email": emailController.text,
        "password": passwordController.text,
      };

      print("===== LOGIN PAYLOAD =====");
      print(jsonEncode(requestBody));
      print("=========================");

      final response = await http.post(
        Uri.parse(Apiservices.login),
        headers: {
          'Content-Type': 'application/json',
          'ngrok-skip-browser-warning': 'true',
          'bypass-tunnel-reminder': 'true',
        },
        body: jsonEncode(requestBody),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        try {
          final decoded = jsonDecode(response.body);
          if (decoded['data'] != null &&
              decoded['data']['accessToken'] != null) {
            accessToken = decoded['data']['accessToken'];

            final prefs = await SharedPreferences.getInstance();
            await prefs.setString('accessToken', accessToken);
            await prefs.setBool('isLoggedIn', true);
            await prefs.setBool('isOnboardingCompleted', true);
          }
        } catch (_) {}

        await fetchUserProfile();
        await fetchDashboard();
        await fetchUserMood();
        await sendFCMTokenToBackend();

        try {
          if (Get.isRegistered<Todaytaskcontroller>()) {
            Get.find<Todaytaskcontroller>().fetchTasks();
          }
          if (Get.isRegistered<MygoallController>()) {
            Get.find<MygoallController>().fetchGoals();
          } else {
            Get.put(MygoallController()).fetchGoals();
          }
          if (Get.isRegistered<WinsController>()) {
            Get.find<WinsController>().fetchWinsDashboard();
          } else {
            Get.put(WinsController()).fetchWinsDashboard();
          }
          if (Get.isRegistered<QuoteController>()) {
            Get.find<QuoteController>().fetchQuotes();
            Get.find<QuoteController>().fetchDailyQuote();
          } else {
            Get.put(QuoteController()).fetchQuotes();
            Get.find<QuoteController>().fetchDailyQuote();
          }
        } catch (_) {}

        Get.snackbar(
          "Success",
          "Logged in successfully",
          backgroundColor: const Color(0xff5E4B8B),
          colorText: Colors.white,
        );
        Get.offAllNamed(AppRoutes.subscriptionPromotion);
      } else {
        String errorMsg = response.body;
        try {
          final decoded = jsonDecode(response.body);
          if (decoded['message'] != null) {
            errorMsg = decoded['message'];
          }
        } catch (_) {}
        if (errorMsg.length > 100)
          errorMsg = "${errorMsg.substring(0, 100)}...";
        Get.snackbar(
          "Error",
          "Failed to login. $errorMsg",
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        "Error",
        "An error occurred: $e",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('accessToken');
    await prefs.remove('userName');
    await prefs.remove('userEmail');
    await prefs.remove('userAvatar');
    await prefs.setBool('isLoggedIn', false);
    accessToken = '';
    userName.value = 'User';
    userEmail.value = 'user@example.com';
    userAvatar.value = '';
    try { await Purchases.logOut(); } catch (_) {}
    Get.offAllNamed(AppRoutes.singin);
  }

  Future<void> resetAppAndLogout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear(); // Complete clear for fresh start
    accessToken = '';
    userName.value = 'User';
    userEmail.value = 'user@example.com';
    userAvatar.value = '';
    try { await Purchases.logOut(); } catch (_) {}
    Get.offAllNamed(AppRoutes.onborading);
  }

  Future<void> sendForgotPasswordCode(GlobalKey<FormState> formKey) async {
    if (!formKey.currentState!.validate()) return;

    isLoading.value = true;
    try {
      final Map<String, dynamic> requestBody = {
        "email": forgotPasswordEmailController.text,
      };

      final response = await http.post(
        Uri.parse(Apiservices.forgot_password),
        headers: {
          'Content-Type': 'application/json',
          'ngrok-skip-browser-warning': 'true',
          'bypass-tunnel-reminder': 'true',
        },
        body: jsonEncode(requestBody),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        startResendTimer();
        Get.toNamed(AppRoutes.verificationcode);
        Get.snackbar(
          "Success",
          "Verification code sent to ${forgotPasswordEmailController.text} successfully!",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: const Color(0xff5E4B8B),
          colorText: Colors.white,
        );
      } else {
        Get.snackbar(
          "Error",
          "Failed to send code. ${response.body}",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        "Error",
        "An error occurred: $e",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  //========================emailverifcarion ===========
  Future<void> verifyOtp() async {
    String otp = otpControllers.map((controller) => controller.text).join();
    if (otp.length < 6) {
      Get.snackbar(
        "Error",
        "Please enter the complete 6-digit code.",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    isLoading.value = true;
    final String emailToVerify = emailController.text.isNotEmpty
        ? emailController.text
        : forgotPasswordEmailController.text;

    if (emailToVerify.isEmpty) {
      Get.snackbar(
        "Error",
        "Email address not found. Please try the process from the beginning.",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      isLoading.value = false;
      return;
    }

    bool isForgotPassword =
        forgotPasswordEmailController.text.isNotEmpty &&
            emailController.text.isEmpty;

    final String endpoint = isForgotPassword
        ? Apiservices.verify_reset_otp
        : Apiservices.verify_otp;

    try {
      final Map<String, dynamic> requestBody = {
        "email": emailToVerify,
        "code": otp,
      };

      print("===== VERIFY OTP PAYLOAD =====");
      print(jsonEncode(requestBody));
      print("Endpoint: $endpoint");
      print("==============================");

      final response = await http.post(
        Uri.parse(endpoint),
        headers: {
          'Content-Type': 'application/json',
          'ngrok-skip-browser-warning': 'true',
          'bypass-tunnel-reminder': 'true',
        },
        body: jsonEncode(requestBody),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        if (isForgotPassword) {
          Get.toNamed(AppRoutes.resetpassword);
          Get.snackbar(
            "Success",
            "Code verified successfully!",
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: const Color(0xff5E4B8B),
            colorText: Colors.white,
          );
        } else {
          for (var controller in otpControllers) {
            controller.clear();
          }
          Get.snackbar(
            "Success",
            "Email verified! Logging you in...",
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: const Color(0xff5E4B8B),
            colorText: Colors.white,
          );
          await signInWithoutValidation();
        }
      } else {
        String errorMsg = response.body;
        if (errorMsg.length > 100)
          errorMsg = "${errorMsg.substring(0, 100)}...";
        Get.snackbar(
          "Error",
          "Verification failed. $errorMsg",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        "Error",
        "An error occurred: $e",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }
  //===========================resendotp_code====================================================

  Future<void> resendOtpCode() async {
    isLoading.value = true;
    try {
      bool isForgotPassword =
          emailController.text.isEmpty &&
              forgotPasswordEmailController.text.isNotEmpty;

      final Map<String, dynamic> requestBody = {
        "email": isForgotPassword
            ? forgotPasswordEmailController.text
            : emailController.text,
      };

      final String endpoint = isForgotPassword
          ? Apiservices.forgot_password
          : Apiservices.resend_otp;

      final response = await http.post(
        Uri.parse(endpoint),
        headers: {
          'Content-Type': 'application/json',
          'ngrok-skip-browser-warning': 'true',
          'bypass-tunnel-reminder': 'true',
        },
        body: jsonEncode(requestBody),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        Get.snackbar(
          "Code Resent",
          "A new verification code has been sent to your email.",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: const Color(0xff5E4B8B),
          colorText: Colors.white,
        );
      } else {
        Get.snackbar(
          "Error",
          "Failed to resend code. ${response.body}",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        "Error",
        "An error occurred: $e",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> createNewPassword(GlobalKey<FormState> formKey) async {
    if (!formKey.currentState!.validate()) return;

    if (newPasswordController.text != confirmPasswordController.text) {
      Get.snackbar(
        "Error",
        "Passwords do not match",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    String otp = otpControllers.map((controller) => controller.text).join();
    isLoading.value = true;
    try {
      final Map<String, dynamic> requestBody = {
        "email": forgotPasswordEmailController.text,
        "code": otp,
        "newPassword": newPasswordController.text,
        "confirmPassword": confirmPasswordController.text,
      };

      final response = await http.post(
        Uri.parse(Apiservices.reset_password),
        headers: {
          'Content-Type': 'application/json',
          'ngrok-skip-browser-warning': 'true',
          'bypass-tunnel-reminder': 'true',
        },
        body: jsonEncode(requestBody),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        emailController.text = forgotPasswordEmailController.text;
        passwordController.text = newPasswordController.text;

        newPasswordController.clear();
        confirmPasswordController.clear();
        for (var controller in otpControllers) controller.clear();
        Get.offAllNamed(AppRoutes.resetsuccess);
        Get.snackbar(
          "Success",
          "Password changed successfully!",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: const Color(0xff5E4B8B),
          colorText: Colors.white,
        );
      } else {
        Get.snackbar(
          "Error",
          "Failed to reset password. ${response.body}",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        "Error",
        "An error occurred: $e",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> deleteAccount() async {
    isLoading.value = true;
    try {
      final response = await http.delete(
        Uri.parse(Apiservices.delete_account),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
          'ngrok-skip-browser-warning': 'true',
          'bypass-tunnel-reminder': 'true',
        },
        body: jsonEncode({
          "reason": "Leaving the platform",
        }),
      );
      print("===== DELETE ACCOUNT RESPONSE =====");
      print("Status Code: ${response.statusCode}");
      print("Body: ${response.body}");
      print("===================================");

      if (response.statusCode == 200 || response.statusCode == 201 || response.statusCode == 204) {
        print("✅ ============================================");
        print("✅ ACCOUNT DELETED SUCCESSFULLY IN BACKEND! ✅");
        print("✅ ============================================");
        return true;
      }
      return false;
    } catch (e) {
      print("Delete account error: $e");
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> deactivateAccount() async {
    isLoading.value = true;
    try {
      final response = await http.post(
        Uri.parse(Apiservices.deactivate_account),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
          'ngrok-skip-browser-warning': 'true',
          'bypass-tunnel-reminder': 'true',
        },
        body: jsonEncode({
          "reason": "Taking a break from productivity tracking",
        }),
      );
      print("===== DEACTIVATE ACCOUNT RESPONSE =====");
      print("Status Code: ${response.statusCode}");
      print("Body: ${response.body}");
      print("=======================================");

      if (response.statusCode == 200 || response.statusCode == 201 || response.statusCode == 204) {
        return true;
      }
      return false;
    } catch (e) {
      print("Deactivate account error: $e");
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> sendFCMTokenToBackend() async {
    if (kIsWeb) {
      print(
          "Skipping FCM token generation on Web/Chrome to avoid configuration errors during testing.");
      return;
    }

    try {
      bool isGranted;

      if (defaultTargetPlatform == TargetPlatform.android) {
        // Android: flutter_local_notifications is the real source of truth for
        // POST_NOTIFICATIONS. Firebase's authorizationStatus is unreliable on
        // Android and can report "authorized" even when the user denied it,
        // which was causing tokens to be sent even without permission.
        final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
        final androidPlugin = flutterLocalNotificationsPlugin
            .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();

        // On Android <13 this returns true automatically (permission is
        // granted at install time, no popup needed).
        isGranted = await androidPlugin?.areNotificationsEnabled() ?? false;

        // On Android 13+ this will actually show the system popup.
        if (!isGranted) {
          isGranted = await androidPlugin?.requestNotificationsPermission() ?? false;
        }
      } else {
        // iOS: Firebase's authorizationStatus works correctly here.
        NotificationSettings currentSettings = await FirebaseMessaging.instance.getNotificationSettings();
        isGranted = currentSettings.authorizationStatus == AuthorizationStatus.authorized;

        if (!isGranted) {
          NotificationSettings settings = await FirebaseMessaging.instance.requestPermission(
            alert: true,
            badge: true,
            sound: true,
          );
          isGranted = settings.authorizationStatus == AuthorizationStatus.authorized;
        }
      }

      if (isGranted) {
        String? fcmToken = await FirebaseMessaging.instance.getToken();

        if (fcmToken != null) {
          print("FCM Token: $fcmToken");

          var url = Uri.parse(Apiservices.register_token);
          final prefs = await SharedPreferences.getInstance();
          final token = prefs.getString('accessToken') ?? accessToken;

          if (token.isEmpty) return;

          var response = await http.post(
            url,
            headers: {
              'Content-Type': 'application/json',
              'Authorization': 'Bearer $token',
              'ngrok-skip-browser-warning': 'true',
              'bypass-tunnel-reminder': 'true',
            },
            body: jsonEncode({
              "fcmToken": fcmToken,
            }),
          );

          if (response.statusCode == 200 || response.statusCode == 201) {
            print("FCM Token successfully registered!");
          } else {
            print("Failed to register token: ${response.statusCode} - ${response.body}");
          }
        }
      }
    } catch (e) {
      print("Error sending FCM token: $e");
    }
  }

  Future<void> signInWithGoogle() async {
    try {
      isLoading.value = true;

      await GoogleSignIn.instance.initialize(
        serverClientId: "PASTE_YOUR_WEB_CLIENT_ID_HERE.apps.googleusercontent.com",
      );
      final GoogleSignInAccount googleUser = await GoogleSignIn.instance.authenticate();

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final String idToken = googleAuth.idToken ?? '';
      final String name = googleUser.displayName ?? '';

      await _authenticateSocialLogin(Apiservices.goggle_login, idToken, name);
    } catch (e) {
      isLoading.value = false;
      Get.snackbar("Error", "Google sign in failed: $e", backgroundColor: Colors.red, colorText: Colors.white);
    }
  }

  Future<void> signInWithApple() async {
    try {
      isLoading.value = true;
      final AuthorizationCredentialAppleID credential =
      await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );

      final String idToken = credential.identityToken ?? credential.authorizationCode;
      final String name = credential.givenName != null ? "${credential.givenName} ${credential.familyName ?? ''}".trim() : '';

      await _authenticateSocialLogin(Apiservices.apple_login, idToken, name);
    } catch (e) {
      isLoading.value = false;
      Get.snackbar("Error", "Apple sign in failed: $e", backgroundColor: Colors.red, colorText: Colors.white);
    }
  }

  Future<void> _authenticateSocialLogin(String endpoint, String idToken, String name) async {
    try {
      final onboardingController = Get.isRegistered<OnboardingController>()
          ? Get.find<OnboardingController>()
          : Get.put(OnboardingController());
      final obData = onboardingController.onboardingData;

      final Map<String, dynamic> requestBody = {
        "idToken": idToken,
        "name": name,
        "onboarding": {
          "proudOfText": obData["initialGoalTitle"] ?? "",
          "useCases": obData["useCases"] ?? [],
          "personalities": obData["personalities"] ?? [],
          "energyTimes": obData["energyTimes"] ?? [],
          "procrastinationFrequencies":
          obData["procrastinationFrequencies"] ?? [],
          "habitsToBuild": obData["habitsToBuild"] ?? [],
          "motivationStyles": obData["motivationStyles"] ?? [],
          "rewardPreferences": obData["rewardPreferences"] ?? [],
          "reminderFrequency": obData["reminderFrequency"] ?? "SMART",
          "personalityDescription": obData["initialMood"] ?? "",
          "focuses": obData["focuses"] ?? [],
          "initialGoalTitle": obData["initialGoalTitle"] ?? "",
          "initialHabitName": obData["initialHabitName"] ?? "",
          "initialMood": obData["initialMood"] ?? "",
        }
      };

      print("===== SOCIAL LOGIN PAYLOAD =====");
      print(jsonEncode(requestBody));
      print("Endpoint: $endpoint");

      final response = await http.post(
        Uri.parse(endpoint),
        headers: {
          'Content-Type': 'application/json',
          'ngrok-skip-browser-warning': 'true',
          'bypass-tunnel-reminder': 'true',
        },
        body: jsonEncode(requestBody),
      );

      print("===== SOCIAL LOGIN RESPONSE =====");
      print("StatusCode: ${response.statusCode}");
      print("Body: ${response.body}");

      if (response.statusCode == 200 || response.statusCode == 201) {
        try {
          final decoded = jsonDecode(response.body);
          if (decoded['data'] != null &&
              decoded['data']['accessToken'] != null) {
            accessToken = decoded['data']['accessToken'];

            final prefs = await SharedPreferences.getInstance();
            await prefs.setString('accessToken', accessToken);
            await prefs.setBool('isLoggedIn', true);
            await prefs.setBool('isOnboardingCompleted', true);
          }
        } catch (_) {}

        await fetchUserProfile();
        await fetchDashboard();
        await fetchUserMood();
        await sendFCMTokenToBackend();

        try {
          if (Get.isRegistered<Todaytaskcontroller>()) {
            Get.find<Todaytaskcontroller>().fetchTasks();
          }
          if (Get.isRegistered<MygoallController>()) {
            Get.find<MygoallController>().fetchGoals();
          } else {
            Get.put(MygoallController()).fetchGoals();
          }
          if (Get.isRegistered<WinsController>()) {
            Get.find<WinsController>().fetchWinsDashboard();
          } else {
            Get.put(WinsController()).fetchWinsDashboard();
          }
          if (Get.isRegistered<QuoteController>()) {
            Get.find<QuoteController>().fetchQuotes();
            Get.find<QuoteController>().fetchDailyQuote();
          } else {
            Get.put(QuoteController()).fetchQuotes();
            Get.find<QuoteController>().fetchDailyQuote();
          }
        } catch (_) {}

        Get.snackbar(
          "Success",
          "Logged in successfully",
          backgroundColor: const Color(0xff5E4B8B),
          colorText: Colors.white,
        );
        Get.offAllNamed(AppRoutes.subscriptionPromotion);
      } else {
        String errorMsg = response.body;
        try {
          final decoded = jsonDecode(response.body);
          if (decoded['message'] != null) {
            errorMsg = decoded['message'];
          }
        } catch (_) {}
        if (errorMsg.length > 100) {
          errorMsg = "${errorMsg.substring(0, 100)}...";
        }
        Get.snackbar(
          "Error",
          "Failed to login. $errorMsg",
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        "Error",
        "An error occurred: $e",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }
}