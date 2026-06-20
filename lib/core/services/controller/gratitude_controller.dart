import 'package:get/get.dart';

class GratitudeEntry {
  final String text;
  final String emoji;
  final String dateLabel; // e.g. 'Today', 'Yesterday', 'Jun 5'

  GratitudeEntry({
    required this.text,
    required this.emoji,
    required this.dateLabel,
  });
}

class GratitudeController extends GetxController {
  final RxList<GratitudeEntry> entries = <GratitudeEntry>[
    GratitudeEntry(
      text: 'The warm cup of coffee this morning. That quiet moment before the day started.',
      emoji: '☕',
      dateLabel: 'Today',
    ),
    GratitudeEntry(
      text: 'My friend checking in on me out of nowhere. Felt so seen.',
      emoji: '💛',
      dateLabel: 'Yesterday',
    ),
    GratitudeEntry(
      text: 'The sunset on my walk. It reminded me that beauty is always there.',
      emoji: '🌅',
      dateLabel: 'Jun 5',
    ),
  ].obs;

  int get totalEntries => entries.length;
  int get dayStreak => 3;
  int get daysThisMonth => 7;

  void addEntry(String text, String emoji) {
    entries.insert(
      0,
      GratitudeEntry(
        text: text,
        emoji: emoji,
        dateLabel: 'Today',
      ),
    );
  }

  void deleteEntry(GratitudeEntry entry) {
    entries.remove(entry);
  }
}
