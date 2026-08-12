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

  final RxList<QuoteItem> quotes = <QuoteItem>[].obs;
  final Rx<QuoteItem?> dailyQuote = Rx<QuoteItem?>(null);

  // Get only saved quotes
  List<QuoteItem> get savedQuotes => quotes.where((q) => q.isSaved.value).toList();

  // Get quotes grouped by category
  Map<String, List<QuoteItem>> get quotesByCategory {
    final Map<String, List<QuoteItem>> grouped = {};
    for (var quote in quotes) {
      if (!grouped.containsKey(quote.category)) {
        grouped[quote.category] = [];
      }
      grouped[quote.category]!.add(quote);
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
            text: data['content'] ?? '',
            author: data['author'] ?? 'Unknown',
            category: 'Daily Motivation',
            isSaved: data['isFavorite'] == true,
          );
        }
      }
    } catch (e) {
      print("Error fetching daily quote: $e");
    }
  }

  Future<void> fetchQuotes() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final accessToken = prefs.getString('accessToken') ?? '';
      
      if (accessToken.isEmpty) {
        return;
      }

      print("===== FETCH QUOTES =====");
      final url = '${Apiservices.baseUrl}/quotes';
      print("GET $url");
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $accessToken',
          'Content-Type': 'application/json',
        },
      );

      print("StatusCode: ${response.statusCode}");
      print("Body: ${response.body}");
      print("========================");

      if (response.statusCode == 200 || response.statusCode == 201) {
        final decoded = jsonDecode(response.body);
        if (decoded['success'] == true && decoded['data'] != null) {
          final data = decoded['data'];
          
          if (data is List) {
            final List<QuoteItem> fetchedQuotes = data.map((q) {
              return QuoteItem(
                id: q['id']?.toString() ?? '',
                text: q['content'] ?? '',
                author: q['author'] ?? 'Unknown',
                category: q['category'] ?? 'Daily Motivation',
                isSaved: q['isFavorite'] == true || q['isSaved'] == true,
              );
            }).toList();
            
            if (fetchedQuotes.isNotEmpty) {
               quotes.value = fetchedQuotes;
            }
          }
        }
      }
    } catch (e) {
      print("Error fetching quotes: $e");
    }
  }

  Future<void> toggleSave(QuoteItem quote) async {
    // Optimistic UI update
    quote.isSaved.value = !quote.isSaved.value;
    quotes.refresh();

    try {
      final prefs = await SharedPreferences.getInstance();
      final accessToken = prefs.getString('accessToken') ?? '';
      
      if (accessToken.isNotEmpty) {
        final url = '${Apiservices.baseUrl}/quotes/${quote.id}/save';
        print("===== SAVE QUOTE =====");
        print("POST $url");
        
        final response = await http.post(
          Uri.parse(url),
          headers: {
            'Authorization': 'Bearer $accessToken',
            'Content-Type': 'application/json',
          },
        );
        
        print("StatusCode: ${response.statusCode}");
        print("Body: ${response.body}");
        print("======================");
      }
    } catch (e) {
      print("Error saving quote: $e");
      // Revert if API call fails
      quote.isSaved.value = !quote.isSaved.value;
      quotes.refresh();
    }
  }

  void changeTab(int index) {
    selectedTabIndex.value = index;
  }
}
