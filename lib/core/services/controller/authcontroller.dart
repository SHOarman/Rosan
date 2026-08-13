import 'dart:convert';
import 'package:flutter/material.dart';
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
import 'package:flutter/foundation.dart' show kIsWeb;

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
    if (accessToken.isNotEmpty) {
      await fetchUserProfile();
      await fetchDashboard();
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

      isLoading.value = false;
      if (response.statusCode == 201 || response.statusCode == 200) {
        Get.snackbar(
          "Success",
          "Account created! Please verify your email.",
          backgroundColor: const Color(0xff5E4B8B),
          colorText: Colors.white,
        );
        Get.toNamed(AppRoutes.verificationcode);
      } else {
        String errorMsg = response.body;
        if (errorMsg.length > 100)
          errorMsg = "${errorMsg.substring(0, 100)}...";
        Get.snackbar(
          "Error",
          "Failed to register. $errorMsg",
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      isLoading.value = false;
      Get.snackbar(
        "Error",
        "An error occurred: $e",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  final RxString userName = 'User'.obs;
  final RxString userEmail = 'user@example.com'.obs;
  final RxString userAvatar = ''.obs;
  String accessToken = '';

  final RxString selectedImagePath = ''.obs;

  // ── Dashboard Stats ──────────────────────────────────────────────
  final RxInt dashboardStreak = 0.obs;
  final RxInt dashboardGoals = 0.obs;
  final RxInt dashboardGratitude = 0.obs;
  final RxInt dashboardWins = 0.obs;
  final RxBool isDashboardLoading = false.obs;

  // ── Subscription ─────────────────────────────────────────────────
  final RxString subscriptionPlan = 'FREE'.obs;
  final RxString subscriptionBadge = 'Free'.obs;
  final RxString subscriptionStatus = 'INACTIVE'.obs;

  Future<void> pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
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

  Future<void> updateUserMood(String mood) async {
    final String cleanMood = mood.trim().toLowerCase();
    currentMood.value = cleanMood;

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('accessToken') ?? accessToken;

      if (token.isEmpty) return;

      final body = jsonEncode({
        "mood": cleanMood,
      });

      print("===== UPDATE USER MOOD =====");
      print("URL: ${Apiservices.mode}");
      print("Body: $body");

      final response = await http.post(
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
          "Feeling updated to ${cleanMood.capitalizeFirst}!",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: const Color(0xFF7B64B0),
          colorText: Colors.white,
          duration: const Duration(seconds: 2),
        );
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
        final decoded = jsonDecode(response.body);
        final data = decoded['data'];
        if (data != null) {
          userName.value = data['name'] ?? 'User';
          userEmail.value = data['email'] ?? 'user@example.com';
          userAvatar.value = data['avatar'] ?? '';
          if (data['mood'] != null) {
            currentMood.value = data['mood'].toString().toLowerCase();
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
        final decoded = jsonDecode(response.body);
        if (decoded['success'] == true && decoded['data'] != null) {
          final data = decoded['data'];

          // Parse user info
          if (data['user'] != null) {
            final user = data['user'];
            userName.value = user['name'] ?? userName.value;
            userEmail.value = user['email'] ?? userEmail.value;
            userAvatar.value = user['avatar'] ?? userAvatar.value;
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

      isLoading.value = false;

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
      isLoading.value = false;
      Get.snackbar(
        "Error",
        "An error occurred: $e",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('accessToken');
    await prefs.setBool('isLoggedIn', false);
    accessToken = '';
    userName.value = 'User';
    userEmail.value = 'user@example.com';
    Get.offAllNamed(AppRoutes.singin);
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

      isLoading.value = false;
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
      isLoading.value = false;
      Get.snackbar(
        "Error",
        "An error occurred: $e",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
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

    if (isForgotPassword) {
      isLoading.value = false;
      Get.toNamed(AppRoutes.resetpassword);
      return;
    }

    try {
      final Map<String, dynamic> requestBody = {
        "email": emailToVerify,
        "code": otp,
      };

      print("===== VERIFY OTP PAYLOAD =====");
      print(jsonEncode(requestBody));
      print("==============================");

      final response = await http.post(
        Uri.parse(Apiservices.verify_otp),
        headers: {
          'Content-Type': 'application/json',
          'ngrok-skip-browser-warning': 'true',
          'bypass-tunnel-reminder': 'true',
        },
        body: jsonEncode(requestBody),
      );

      isLoading.value = false;
      if (response.statusCode == 200 || response.statusCode == 201) {
        for (var controller in otpControllers) {
          controller.clear();
        }
        Get.toNamed(AppRoutes.singin);
        Get.snackbar(
          "Success",
          "Email verified successfully!",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: const Color(0xff5E4B8B),
          colorText: Colors.white,
        );
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
      isLoading.value = false;
      Get.snackbar(
        "Error",
        "An error occurred: $e",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
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

      isLoading.value = false;
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
      isLoading.value = false;
      Get.snackbar(
        "Error",
        "An error occurred: $e",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
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

      isLoading.value = false;
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
      isLoading.value = false;
      Get.snackbar(
        "Error",
        "An error occurred: $e",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }
}
