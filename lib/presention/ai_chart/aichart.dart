import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:rosannalie/general_widget/custom_background.dart';
import 'package:rosannalie/general_widget/customnav_button.dart';
import 'package:rosannalie/utils/appString.dart';
import 'package:rosannalie/core/services/controller/ai_coach_controller.dart';

// ── Screen ───────────────────────────────────────────────────────────────────

class Aichart extends StatefulWidget {
  const Aichart({super.key});

  @override
  State<Aichart> createState() => _AichartState();
}

class _AichartState extends State<Aichart> {
  final TextEditingController _inputController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final AiCoachController _chatController = Get.isRegistered<AiCoachController>()
      ? Get.find<AiCoachController>()
      : Get.put(AiCoachController());

  bool _isQuickStartExpanded = true;

  final List<String> _quickStarts = [
    'Help me beat procrastination today',
    'Give me a morning routine',
    "I'm feeling overwhelmed",
    'Celebrate my wins with me',
  ];

  @override
  void initState() {
    super.initState();
    _chatController.fetchChatHistory(isRefresh: true);
  }

  @override
  void dispose() {
    _inputController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _sendMessage() {
    final text = _inputController.text.trim();
    if (text.isEmpty) return;
    _chatController.sendMessage(text);
    _inputController.clear();
    setState(() {
      _isQuickStartExpanded = false;
    });
    _scrollToBottom();
  }

  void _sendQuickStart(String text) {
    _chatController.sendMessage(text);
    setState(() {
      _isQuickStartExpanded = false;
    });
    _scrollToBottom();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          0.0, // Since reverse: true is set, bottom is 0.0
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  // ── Build ─────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return CustomBackground(
      useSafeArea: false,
      backgroundImageAsset: 'assets/images/image.png',
      child: Stack(
        children: [
          // ── Main content ───────────────────────────────────────────────
          Positioned.fill(
            bottom: 118.0, // nav(70) + navBottom(40) + gap(8)
            child: SafeArea(
              bottom: false,
              child: Column(
                children: [
                  _buildHeader(context),
                  _buildQuickStartBar(),
                  Expanded(child: _buildMessageList()),
                  _buildInputBar(),
                ],
              ),
            ),
          ),

          // ── Bottom nav ─────────────────────────────────────────────────
          const Positioned(
            bottom: 50.0,
            left: 0,
            right: 0,
            child: Center(child: CustomBottomNavBar(selectedIndex: 2)),
          ),
        ],
      ),
    );
  }

  // ── Header ────────────────────────────────────────────────────────────────

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          const SizedBox(width: 12),

          // Avatar
          Container(
            width: 44,
            height: 44,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [Color(0xFF9E6AC3), Color(0xFFC9698E)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Center(
              child: SvgPicture.asset(
                'assets/images/SparkleIcon (1).svg',
                width: 22,
                height: 22,
              ),
            ),
          ),
          const SizedBox(width: 10),

          // Name + status
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Rise AI Coach',
                  style: AppTextStyles.plusJakartaSans(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF161022),
                  ),
                ),
                const SizedBox(height: 2),
                Row(
                  children: [
                    Container(
                      width: 7,
                      height: 7,
                      decoration: const BoxDecoration(
                        color: Color(0xFF4CAF50),
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 5),
                    Text(
                      'Always here for you',
                      style: AppTextStyles.plusJakartaSans(
                        fontSize: 13,
                        fontWeight: FontWeight.w400,
                        color: const Color(0xFF575B61),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ── Quick-start chips bar ─────────────────────────────────────────────────

  Widget _buildQuickStartBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Toggle button row
          GestureDetector(
            onTap: () {
              setState(() {
                _isQuickStartExpanded = !_isQuickStartExpanded;
              });
            },
            behavior: HitTestBehavior.opaque,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: const Color(0xFFC5B8E8).withValues(alpha: 0.5),
                  width: 1,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Quick start ',
                    style: AppTextStyles.plusJakartaSans(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF666370),
                    ),
                  ),
                  const Text('✨ ', style: TextStyle(fontSize: 12)),
                  Icon(
                    _isQuickStartExpanded
                        ? Icons.keyboard_arrow_up_rounded
                        : Icons.keyboard_arrow_down_rounded,
                    size: 18,
                    color: const Color(0xFF7B64B0),
                  ),
                ],
              ),
            ),
          ),

          // Animated sliding container for quick start chips
          AnimatedSize(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            child: _isQuickStartExpanded
                ? Column(
                    children: [
                      const SizedBox(height: 10),
                      Wrap(
                        alignment: WrapAlignment.center,
                        spacing: 8,
                        runSpacing: 8,
                        children: _quickStarts.map((label) => _QuickStartChip(
                          label: label,
                          onTap: () => _sendQuickStart(label),
                        )).toList(),
                      ),
                      const SizedBox(height: 8),
                    ],
                  )
                : const SizedBox(height: 4),
          ),
        ],
      ),
    );
  }

  // ── Message list ──────────────────────────────────────────────────────────

  Widget _buildMessageList() {
    return Obx(() {
      if (_chatController.isLoading.value && _chatController.messages.isEmpty) {
        return const Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF9E6AC3)),
          ),
        );
      }

      final msgs = _chatController.messages;
      final isSending = _chatController.isSending.value;
      final totalCount = isSending ? msgs.length + 1 : msgs.length;

      return RefreshIndicator(
        color: const Color(0xFF9E6AC3),
        onRefresh: () => _chatController.fetchChatHistory(isRefresh: true),
        child: ListView.builder(
          controller: _scrollController,
          reverse: true, // Show last message first (at the bottom)
          physics: const AlwaysScrollableScrollPhysics(
            parent: BouncingScrollPhysics(),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          itemCount: totalCount,
          itemBuilder: (context, index) {
            if (isSending && index == 0) {
              return const _TypingBubble();
            }
            final msgIndex = isSending ? index - 1 : index;
            final msg = msgs[msgIndex];
            return msg.isUser
                ? _UserBubble(message: msg)
                : _AiBubble(message: msg);
          },
        ),
      );
    });
  }

  // ── Input bar ─────────────────────────────────────────────────────────────

  Widget _buildInputBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // ── Text field box ───────────────────────────────────────────────
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(100),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                child: Container(
                  height: 44,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.80),
                    borderRadius: BorderRadius.circular(100),
                    border: Border(
                      top: BorderSide(
                        color: const Color(0xFFC5B8E8).withValues(alpha: 0.40),
                        width: 1,
                      ),
                    ),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  child: TextField(
                    controller: _inputController,
                    style: AppTextStyles.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: const Color(0xFF2E2252),
                    ),
                    decoration: InputDecoration(
                      hintText: 'Talk to your coach...',
                      hintStyle: AppTextStyles.inter(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: const Color(0xFF9E9AA8),
                      ),
                      border: InputBorder.none,
                      isDense: true,
                      contentPadding: EdgeInsets.zero,
                    ),
                    textInputAction: TextInputAction.send,
                    onSubmitted: (_) => _sendMessage(),
                  ),
                ),
              ),
            ),
          ),

          const SizedBox(width: 10),

          // ── Send button (separate / alda) ────────────────────────────────
          GestureDetector(
            onTap: _sendMessage,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(22),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                child: Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.80),
                    shape: BoxShape.circle,
                    border: Border(
                      top: BorderSide(
                        color: const Color(0xFFC5B8E8).withValues(alpha: 0.40),
                        width: 1,
                      ),
                    ),
                  ),
                  child: Center(
                    child: SvgPicture.asset(
                      'assets/images/SendIcon.svg',
                      width: 20,
                      height: 20,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}


// ── Quick-start chip ──────────────────────────────────────────────────────────

class _QuickStartChip extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const _QuickStartChip({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(100),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.60),
              borderRadius: BorderRadius.circular(100),
              border: Border.all(
                color: const Color(0xFFC5B8E8),
                width: 1,
              ),
            ),
            child: Text(
              label,
              style: AppTextStyles.inter(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: const Color(0xFF7B64B0),
              ),
            ),
          ),
        ),
      ),
    );
  }
}


class _AiBubble extends StatelessWidget {
  final ChatMessage message;

  const _AiBubble({required this.message});

  Widget _buildFormattedText(String text) {
    final List<InlineSpan> spans = [];
    final RegExp exp = RegExp(r'\*\*(.*?)\*\*');
    int lastMatchEnd = 0;

    for (final Match match in exp.allMatches(text)) {
      if (match.start > lastMatchEnd) {
        spans.add(TextSpan(
          text: text.substring(lastMatchEnd, match.start),
          style: AppTextStyles.inter(
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: const Color(0xFF2E2252),
          ).copyWith(height: 1.5),
        ));
      }

      spans.add(TextSpan(
        text: match.group(1),
        style: AppTextStyles.inter(
          fontSize: 14,
          fontWeight: FontWeight.w700,
          color: const Color(0xFF161022),
        ).copyWith(height: 1.5),
      ));

      lastMatchEnd = match.end;
    }

    if (lastMatchEnd < text.length) {
      spans.add(TextSpan(
        text: text.substring(lastMatchEnd),
        style: AppTextStyles.inter(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: const Color(0xFF2E2252),
        ).copyWith(height: 1.5),
      ));
    }

    return RichText(
      text: TextSpan(children: spans),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          // Small avatar
          Container(
            width: 28,
            height: 28,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [Color(0xFF9B7FD4), Color(0xFF5E4B8B)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Center(
              child: SvgPicture.asset(
                'assets/images/SparkleIcon (1).svg',
                width: 14,
                height: 14,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(18),
                    topRight: Radius.circular(18),
                    bottomRight: Radius.circular(18),
                    bottomLeft: Radius.circular(4),
                  ),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.65),
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(18),
                          topRight: Radius.circular(18),
                          bottomRight: Radius.circular(18),
                          bottomLeft: Radius.circular(4),
                        ),
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.8),
                          width: 1,
                        ),
                      ),
                      child: _buildFormattedText(message.text),
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  message.time,
                  style: AppTextStyles.inter(
                    fontSize: 10,
                    fontWeight: FontWeight.w400,
                    color: const Color(0xFF9E9AA8),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 48),
        ],
      ),
    );
  }
}


class _UserBubble extends StatelessWidget {
  final ChatMessage message;

  const _UserBubble({required this.message});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              const SizedBox(width: 48),
              Flexible(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0xFF9B7FD4), Color(0xFF5E4B8B)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(18),
                      topRight: Radius.circular(18),
                      bottomLeft: Radius.circular(18),
                      bottomRight: Radius.circular(4),
                    ),
                  ),
                  child: Text(
                    message.text,
                    style: AppTextStyles.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ).copyWith(height: 1.4),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            message.time,
            style: AppTextStyles.inter(
              fontSize: 10,
              fontWeight: FontWeight.w400,
              color: const Color(0xFF9E9AA8),
            ),
          ),
        ],
      ),
    );
  }
}

class _TypingBubble extends StatelessWidget {
  const _TypingBubble();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Container(
            width: 28,
            height: 28,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [Color(0xFF9B7FD4), Color(0xFF5E4B8B)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Center(
              child: SvgPicture.asset(
                'assets/images/SparkleIcon (1).svg',
                width: 14,
                height: 14,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.65),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(18),
                topRight: Radius.circular(18),
                bottomRight: Radius.circular(18),
                bottomLeft: Radius.circular(4),
              ),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.8),
                width: 1,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(
                  width: 14,
                  height: 14,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF9E6AC3)),
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  'Thinking...',
                  style: AppTextStyles.inter(
                    fontSize: 13,
                    fontWeight: FontWeight.w400,
                    color: const Color(0xFF8F7DB5),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
