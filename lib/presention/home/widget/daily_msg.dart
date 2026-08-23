import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:rosannalie/utils/appString.dart';
import 'package:get/get.dart';
import 'package:rosannalie/core/services/controller/quote_controller.dart';

class DailyMsg extends StatelessWidget {
  const DailyMsg({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10.0,
            spreadRadius: 0,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40.0,
            height: 40.0,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [Color(0xFFF4A0C0), Color(0xFFC9A8E0)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            alignment: Alignment.center,
            child: SvgPicture.asset(
              "assets/icon/QuoteIcon.svg",
              width: 18.0,
              height: 18.0,
            ),
          ),
          const SizedBox(width: 14.0),
          Expanded(
            child: Obx(() {
              final controller = Get.isRegistered<QuoteController>() ? Get.find<QuoteController>() : Get.put(QuoteController());
              final dailyQuote = controller.dailyQuote.value;
              final quoteText = dailyQuote?.text ?? "Loading quote...";
              final quoteAuthor = dailyQuote?.author ?? "";

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '“$quoteText”',
                    style: AppTextStyles.plusJakartaSans(
                      fontSize: 15.5,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF3D2E6B),
                    ).copyWith(fontStyle: FontStyle.italic),
                  ),
                  const SizedBox(height: 8.0),
                  Text(
                    quoteAuthor.isNotEmpty ? '— $quoteAuthor' : '',
                    style: AppTextStyles.plusJakartaSans(
                      fontSize: 12.5,
                      fontWeight: FontWeight.w500,
                      color: const Color(0xFF575B61),
                    ).copyWith(fontStyle: FontStyle.italic)
                  ),
                ],
              );
            }),
          ),
        ],
      ),
    );
  }
}
