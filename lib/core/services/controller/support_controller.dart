import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:rosannalie/core/services/api_services/apiservices.dart';

class SupportController extends GetxController {
  final RxList<Map<String, String>> faqs = <Map<String, String>>[].obs;
  final RxList<Map<String, String>> privacyPolicies = <Map<String, String>>[].obs;
  final RxList<Map<String, String>> termsPolicies = <Map<String, String>>[].obs;
  final RxBool isLoading = false.obs;
  final RxBool isPrivacyLoading = false.obs;
  final RxBool isTermsLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchFaqs();
    fetchPrivacy();
    fetchTerms();
  }

  Future<void> fetchFaqs() async {
    try {
      isLoading.value = true;
      final prefs = await SharedPreferences.getInstance();
      final accessToken = prefs.getString('accessToken') ?? '';
      
      if (accessToken.isEmpty) {
        isLoading.value = false;
        return;
      }

      print("===== FETCH FAQS =====");
      final url = Apiservices.supportFaqs;
      print("GET $url");
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $accessToken',
          'Content-Type': 'application/json',
        },
      );

      print("StatusCode: ${response.statusCode}");
      print("======================");

      if (response.statusCode == 200 || response.statusCode == 201) {
        final decoded = jsonDecode(response.body);
        if (decoded['success'] == true && decoded['data'] != null) {
          final data = decoded['data'];
          if (data is List) {
            final List<Map<String, String>> fetchedFaqs = data.map((item) {
              return {
                "question": item['question']?.toString() ?? '',
                "answer": item['answer']?.toString() ?? ''
              };
            }).toList();
            faqs.value = fetchedFaqs;
          }
        }
      }
    } catch (e) {
      print("Error fetching FAQs: $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchPrivacy() async {
    try {
      isPrivacyLoading.value = true;
      final prefs = await SharedPreferences.getInstance();
      final accessToken = prefs.getString('accessToken') ?? '';
      
      if (accessToken.isEmpty) {
        isPrivacyLoading.value = false;
        return;
      }

      print("===== FETCH PRIVACY =====");
      final url = Apiservices.supportPrivacy;
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $accessToken',
          'Content-Type': 'application/json',
          'ngrok-skip-browser-warning': 'true',
        },
      );

      print("Privacy StatusCode: ${response.statusCode}");
      print("Privacy Body: ${response.body}");

      if (response.statusCode == 200 || response.statusCode == 201) {
        final decoded = jsonDecode(response.body);
        List<dynamic> policiesList = [];
        
        if (decoded is List) {
          policiesList = decoded;
        } else if (decoded is Map) {
          if (decoded['data'] is List) {
            policiesList = decoded['data'];
          } else if (decoded['data'] != null && decoded['data'] is Map) {
             if (decoded['data']['sections'] is List) {
                policiesList = decoded['data']['sections'];
             } else if (decoded['data']['privacy'] is List) {
                policiesList = decoded['data']['privacy'];
             }
          }
        }

        List<Map<String, String>> fetchedPolicies = [];
        for (var item in policiesList) {
          if (item is Map) {
            fetchedPolicies.add({
              "title": item['title']?.toString() ?? '',
              "content": item['content']?.toString() ?? ''
            });
          }
        }
        privacyPolicies.value = fetchedPolicies;
      }
    } catch (e) {
      print("Error fetching privacy policy: $e");
    } finally {
      isPrivacyLoading.value = false;
    }
  }

  Future<void> fetchTerms() async {
    try {
      isTermsLoading.value = true;
      final prefs = await SharedPreferences.getInstance();
      final accessToken = prefs.getString('accessToken') ?? '';
      
      if (accessToken.isEmpty) {
        isTermsLoading.value = false;
        return;
      }

      print("===== FETCH TERMS =====");
      final url = Apiservices.supportTerms;
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $accessToken',
          'Content-Type': 'application/json',
          'ngrok-skip-browser-warning': 'true',
        },
      );

      print("Terms StatusCode: ${response.statusCode}");
      print("Terms Body: ${response.body}");

      if (response.statusCode == 200 || response.statusCode == 201) {
        final decoded = jsonDecode(response.body);
        List<dynamic> policiesList = [];
        
        if (decoded is List) {
          policiesList = decoded;
        } else if (decoded is Map) {
          if (decoded['data'] is List) {
            policiesList = decoded['data'];
          } else if (decoded['data'] != null && decoded['data'] is Map) {
             if (decoded['data']['sections'] is List) {
                policiesList = decoded['data']['sections'];
             } else if (decoded['data']['terms'] is List) {
                policiesList = decoded['data']['terms'];
             }
          }
        }

        List<Map<String, String>> fetchedPolicies = [];
        for (var item in policiesList) {
          if (item is Map) {
            fetchedPolicies.add({
              "title": item['title']?.toString() ?? '',
              "content": item['content']?.toString() ?? ''
            });
          }
        }
        termsPolicies.value = fetchedPolicies;
      }
    } catch (e) {
      print("Error fetching terms: $e");
    } finally {
      isTermsLoading.value = false;
    }
  }

  Future<bool> createSupportTicket({
    required String email,
    required String subject,
    required String message,
    required String category,
  }) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final accessToken = prefs.getString('accessToken') ?? '';
      
      if (accessToken.isEmpty) {
        return false;
      }

      print("===== CREATE SUPPORT TICKET =====");
      final url = Apiservices.supportTickets;
      print("POST $url");
      final body = jsonEncode({
        "email": email,
        "subject": subject,
        "message": message,
        "category": category,
      });

      final request = http.Request('POST', Uri.parse(url));
      request.headers['Authorization'] = 'Bearer $accessToken';
      request.headers['Content-Type'] = 'application/json';
      request.headers['Accept'] = 'application/json';
      request.body = body;

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      print("Request Body: $body");

      print("StatusCode: ${response.statusCode}");
      print("Body: ${response.body}");
      print("=================================");

      if (response.statusCode == 200 || response.statusCode == 201) {
        return true;
      }
      return false;
    } catch (e) {
      print("Error creating support ticket: $e");
      return false;
    }
  }
}
