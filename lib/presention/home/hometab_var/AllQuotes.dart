import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:rosannalie/core/services/controller/quote_controller.dart';
import 'package:rosannalie/utils/appString.dart';

class AllQuotesTab extends StatelessWidget {
  const AllQuotesTab({super.key});

  LinearGradient _getCardGradient(int index) {
    final List<List<Color>> gradients = [
      [const Color(0xFFC5B8E8), const Color(0xFFF4C0C0)],
      [const Color(0xFFFFD4B5), const Color(0xFFFFC0C0)],
      [const Color(0xFFC5B8E8), const Color(0xFFF4C0C0)],
      [const Color(0xFFFFD4B5), const Color(0xFFFFC0C0)],
      [const Color(0xFFC6E7C4), const Color(0xFFF3C0C0)],
    ];
    final colors = gradients[index % gradients.length];
    return LinearGradient(
      colors: colors,
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    );
  }

  @override
  Widget build(BuildContext context) {
    final QuoteController controller = Get.find<QuoteController>();

    return Obx(() {
      final groupedQuotes = controller.quotesByCategory;
      final categories = groupedQuotes.keys.toList();

      if (categories.isEmpty) {
        return Center(
          child: Text(
            "No quotes available.",
            style: AppTextStyles.inter(
              color: const Color(0xFF8F7DB5),
              fontSize: 14,
            ),
          ),
        );
      }

      return ListView.builder(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.only(bottom: 24),
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final categoryName = categories[index];
          final categoryQuotes = groupedQuotes[categoryName] ?? [];

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 8.0, bottom: 16.0),
                child: Text(
                  categoryName,
                  style: AppTextStyles.plusJakartaSans(
                    color: const Color(0xFF161022),
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              ...categoryQuotes.asMap().entries.map((entry) {
                final quoteIndex = entry.key;
                final quote = entry.value;
                return _buildQuoteCard(quote, controller, quoteIndex);
              }),
              const SizedBox(height: 16),
            ],
          );
        },
      );
    });
  }

  Widget _buildQuoteCard(QuoteItem quote, QuoteController controller, int cardIndex) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 16.0),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        gradient: _getCardGradient(cardIndex),
        borderRadius: BorderRadius.circular(20.0),
        border: Border(
          top: BorderSide(color: Colors.white.withValues(alpha: 0.9), width: 1.0),
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF4A3870).withValues(alpha: 0.1),
            blurRadius: 32.0,
            spreadRadius: 0,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top Left Quote Icon (new.svg)
          SvgPicture.asset(
            "assets/icon/new.svg",
            colorFilter: const ColorFilter.mode(
              Color(0x264A3870),
              BlendMode.srcIn,
            ),
            width: 16.0,
            height: 14.0,
          ),
          const SizedBox(height: 10.0),
          // Quote Text
          Text(
            quote.text,
            style: AppTextStyles.plusJakartaSans(
              fontSize: 15.0,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF161022),
            ),
          ),
          const SizedBox(height: 12.0),
          // Bottom Author + Save Button Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '— ${quote.author}',
                style: AppTextStyles.inter(
                  fontSize: 12.0,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFF7A68A6),
                ),
              ),
              Obx(() => GestureDetector(
                    onTap: () => controller.toggleSave(quote),
                    child: Container(
                      width: 32.0,
                      height: 32.0,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF4A3870).withValues(alpha: 0.08),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      alignment: Alignment.center,
                      child: Icon(
                        quote.isSaved.value
                            ? Icons.favorite
                            : Icons.favorite_border,
                        color: quote.isSaved.value
                            ? const Color(0xFFFF5A79)
                            : const Color(0xFF8F7DB5),
                        size: 18,
                      ),
                    ),
                  )),
            ],
          ),
        ],
      ),
    );
  }
}
