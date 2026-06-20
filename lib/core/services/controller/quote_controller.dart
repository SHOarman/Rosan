import 'package:get/get.dart';

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

  final RxList<QuoteItem> quotes = <QuoteItem>[
    QuoteItem(
      id: '1',
      text: 'He who has a why to live can bear almost any how.',
      author: 'Mark Twain',
      category: 'Purpose and Perseverance',
      isSaved: false,
    ),
    QuoteItem(
      id: '2',
      text: 'What you seek is seeking you.',
      author: 'Rumi',
      category: 'Purpose and Perseverance',
      isSaved: true,
    ),
    QuoteItem(
      id: '3',
      text: 'A journey of a thousand miles begins with a single step.',
      author: 'Lao Tzu',
      category: 'Purpose and Perseverance',
      isSaved: false,
    ),
    QuoteItem(
      id: '4',
      text: 'Fall seven times, stand up eight.',
      author: 'Japanese proverb.',
      category: 'Purpose and Perseverance',
      isSaved: true,
    ),
    QuoteItem(
      id: '5',
      text: 'The best time to plant a tree was twenty years ago. The second best time is now.',
      author: 'Chinese proverb',
      category: 'Purpose and Perseverance',
      isSaved: false,
    ),
    QuoteItem(
      id: '6',
      text: 'Be present in all things and thankful for all things.',
      author: 'Maya Angelou',
      category: 'Gratitude and Mindfulness',
      isSaved: true,
    ),
    QuoteItem(
      id: '7',
      text: 'The present moment is filled with joy and happiness. If you are attentive, you will see it.',
      author: 'Thich Nhat Hanh',
      category: 'Gratitude and Mindfulness',
      isSaved: false,
    ),
    QuoteItem(
      id: '8',
      text: 'Success is not final, failure is not fatal: it is the courage to continue that counts.',
      author: 'Winston Churchill',
      category: 'Success and Motivation',
      isSaved: true,
    ),
    QuoteItem(
      id: '9',
      text: 'Believe you can and you\'re halfway there.',
      author: 'Theodore Roosevelt',
      category: 'Success and Motivation',
      isSaved: false,
    ),
    QuoteItem(
      id: '10',
      text: 'Peace comes from within. Do not seek it without.',
      author: 'Buddha',
      category: 'Inner Peace and Calm',
      isSaved: false,
    ),
  ].obs;

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

  void toggleSave(QuoteItem quote) {
    quote.isSaved.value = !quote.isSaved.value;
    quotes.refresh();
  }

  void changeTab(int index) {
    selectedTabIndex.value = index;
  }
}
