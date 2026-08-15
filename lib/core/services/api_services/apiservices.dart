class Apiservices {
  Apiservices._();

  static const String baseUrl =
      'https://convergence-arg-breeds-genetics.trycloudflare.com/api/v1';

  //========================================================Auth_=======================================

  static const String register = "$baseUrl/auth/register";
  static const String resend_otp = "$baseUrl/auth/resend-otp";
  static const String verify_otp = "$baseUrl/auth/verify-otp";
  static const String verify_reset_otp = "$baseUrl/auth/verify-reset-otp";
  static const String forgot_password = "$baseUrl/auth/forgot-password";
  static const String reset_password = "$baseUrl/auth/reset-password";
  static const String change_password = "$baseUrl/auth/change-password";
  static const String login = "$baseUrl/auth/login";
  static const String get_profile = "$baseUrl/users/me";
  static const String update_profile = "$baseUrl/users/me";
  static const String goggle_login = "$baseUrl/auth/google";
  static const String apple_login = "$baseUrl/auth/apple";
  static const String logout = "$baseUrl/auth/logout";

  //=========================taks================================================
  static const String taks = "$baseUrl/tasks";

  //=================================goal================================
  static const String goals = "$baseUrl/goals";
  static const String listgetgoals = "$baseUrl/goals";

  static const String quotes = "$baseUrl/quotes/daily";

  //============================================win_deshbord========================================================
  static const String win_deshbord = "$baseUrl/wins/dashboard";

  //============================================support========================================================
  static const String supportFaqs = "$baseUrl/support/faqs";
  static const String supportTickets = "$baseUrl/support/tickets";

  //============================================ai_coach========================================================
  static const String aiHistory = "$baseUrl/ai/history";
  static const String aiChat = "$baseUrl/ai/chat";

  //============================================profile_dashboard========================================================
  static const String profile_dashboard = "$baseUrl/users/profile/dashboard";

  //===============================================gratitude============================================
  static const String get_gratitude = "$baseUrl/gratitude";
  static const String add_gratitude = "$baseUrl/gratitude";

  static const String mode="$baseUrl/users/me/mood";

  //============================================future_me========================================================
  static const String futureMeDashboard = "$baseUrl/future-me/dashboard";
  static const String futureMeLetters = "$baseUrl/future-me/letters";
}
