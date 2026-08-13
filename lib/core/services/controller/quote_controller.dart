import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:rosannalie/core/services/api_services/apiservices.dart';

class QuoteItem {
  final String id;
  final String text;
  final String author;
  final String category;
  final RxBool isSaved;

  QuoteItem({
    required this.id,
    required this.text,
    required this.author,
    required this.category,
    bool isSaved = false,
  }) : isSaved = isSaved.obs;
}

class QuoteController extends GetxController {
  final RxInt selectedTabIndex = 0.obs;
  final RxBool isLoading = false.obs;

  final RxList<QuoteItem> quotes = <QuoteItem>[].obs;
  final Rx<QuoteItem?> dailyQuote = Rx<QuoteItem?>(null);

  // Get only saved quotes
  List<QuoteItem> get savedQuotes => quotes.where((q) => q.isSaved.value).toList();

  // Get quotes grouped by category
  Map<String, List<QuoteItem>> get quotesByCategory {
    final Map<String, List<QuoteItem>> grouped = {};
    for (var quote in quotes) {
      final cat = (quote.category.isNotEmpty) ? quote.category : 'Daily Motivation';
      if (!grouped.containsKey(cat)) {
        grouped[cat] = [];
      }
      grouped[cat]!.add(quote);
    }
    return grouped;
  }

  @override
  void onInit() {
    super.onInit();
    fetchQuotes();
    fetchDailyQuote();
  }

  Future<void> fetchDailyQuote() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final accessToken = prefs.getString('accessToken') ?? '';
      
      if (accessToken.isEmpty) {
        return;
      }

      print("===== FETCH DAILY QUOTE =====");
      final url = '${Apiservices.baseUrl}/quotes/daily';
      print("GET $url");
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $accessToken',
          'Content-Type': 'application/json',
          'ngrok-skip-browser-warning': 'true',
          'bypass-tunnel-reminder': 'true',
        },
      );

      print("StatusCode: ${response.statusCode}");
      print("Body: ${response.body}");
      print("=============================");

      if (response.statusCode == 200 || response.statusCode == 201) {
        final decoded = jsonDecode(response.body);
        if (decoded['success'] == true && decoded['data'] != null) {
          final data = decoded['data'];
          dailyQuote.value = QuoteItem(
            id: data['id']?.toString() ?? '',
            text: data['content'] ?? data['text'] ?? '',
            author: data['author'] ?? 'Unknown',
            category: 'Daily Motivation',
            isSaved: data['isFavorite'] == true || data['isSaved'] == true,
          );
        }
      }
    } catch (e) {
      print("Error fetching daily quote: $e");
    }
  }

  Future<void> fetchQuotes({int page = 1, int pageSize = 10}) async {
    try {
      isLoading.value = true;
      final prefs = await SharedPreferences.getInstance();
      final accessToken = prefs.getString('accessToken') ?? '';
      
      if (accessToken.isEmpty) {
        isLoading.value = false;
        return;
      }

      print("===== FETCH QUOTES =====");
      final url = '${Apiservices.baseUrl}/quotes?page=$page&pageSize=$pageSize';
      print("GET $url");
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $accessToken',
          'Content-Type': 'application/json',
          'ngrok-skip-browser-warning': 'true',
          'bypass-tunnel-reminder': 'true',
        },
      );

      print("StatusCode: ${response.statusCode}");
      print("Body: ${response.body}");
      print("========================");

      if (response.statusCode == 200 || response.statusCode == 201) {
        final decoded = jsonDecode(response.body);
        if (decoded['success'] == true && decoded['data'] != null) {
          final data = decoded['data'];
          
          List rawList = [];
          if (data is List) {
            rawList = data;
          } else if (data is Map && data['quotes'] is List) {
            rawList = data['quotes'];
          }

          final List<QuoteItem> fetchedQuotes = rawList.map((q) {
            return QuoteItem(
              id: q['id']?.toString() ?? '',
              text: q['content'] ?? q['text'] ?? '',
              author: q['author'] ?? 'Unknown',
              category: (q['category'] != null && q['category'].toString().isNotEmpty)
                  ? q['category'].toString()
                  : 'Daily Motivation',
              isSaved: q['isFavorite'] == true || q['isSaved'] == true,
            );
          }).toList();
          
          quotes.value = fetchedQuotes;
        }
      }
    } catch (e) {
      print("Error fetching quotes: $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> toggleSave(QuoteItem quote) async {
    final bool newSavedState = !quote.isSaved.value;
    // Optimistic UI update
    quote.isSaved.value = newSavedState;
    quotes.refresh();

    try {
      final prefs = await SharedPreferences.getInstance();
      final accessToken = prefs.getString('accessToken') ?? '';
      
      if (accessToken.isNotEmpty) {
        final headers = {
          'Authorization': 'Bearer $accessToken',
          'Content-Type': 'application/json',
          'ngrok-skip-browser-warning': 'true',
          'bypass-tunnel-reminder': 'true',
        };

        if (newSavedState) {
          // SAVE / FAVORITE QUOTE (POST /quotes/:id/favorite)
          final url = '${Apiservices.baseUrl}/quotes/${quote.id}/favorite';
          print("===== FAVORITE / SAVE QUOTE =====");
          print("POST $url");
          
          var response = await http.post(
            Uri.parse(url),
            headers: headers,
          );
          
          print("StatusCode: ${response.statusCode}");
          print("Body: ${response.body}");

          if (response.statusCode != 200 && response.statusCode != 201) {
            final fallbackUrl = '${Apiservices.baseUrl}/quotes/${quote.id}/save';
            print("Retrying save with fallback POST $fallbackUrl");
            response = await http.post(
              Uri.parse(fallbackUrl),
              headers: headers,
            );
            print("Fallback StatusCode: ${response.statusCode}");
          }

          if (response.statusCode != 200 && response.statusCode != 201) {
            quote.isSaved.value = !newSavedState;
            quotes.refresh();
          }
        } else {
          // UNSAVE / UNFAVORITE QUOTE (DELETE /quotes/:id/unsave)
          final url = '${Apiservices.baseUrl}/quotes/${quote.id}/unsave';
          print("===== UNSAVE / UNFAVORITE QUOTE =====");
          print("DELETE $url");
          
          var response = await http.delete(
            Uri.parse(url),
            headers: headers,
          );
          
          print("StatusCode: ${response.statusCode}");
          print("Body: ${response.body}");

          if (response.statusCode != 200 && response.statusCode != 201 && response.statusCode != 204) {
            final fallbackUrl = '${Apiservices.baseUrl}/quotes/${quote.id}/favorite';
            print("Retrying unsave with fallback DELETE $fallbackUrl");
            response = await http.delete(
              Uri.parse(fallbackUrl),
              headers: headers,
            );
            print("Fallback StatusCode: ${response.statusCode}");
          }

          if (response.statusCode != 200 && response.statusCode != 201 && response.statusCode != 204) {
            quote.isSaved.value = !newSavedState;
            quotes.refresh();
          }
        }

        print("======================");
      }
    } catch (e) {
      print("Error toggling save quote: $e");
      quote.isSaved.value = !newSavedState;
      quotes.refresh();
    }
  }

  void changeTab(int index) {
    selectedTabIndex.value = index;
  }
}
