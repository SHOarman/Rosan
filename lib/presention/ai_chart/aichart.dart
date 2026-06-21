import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:rosannalie/general_widget/custom_background.dart';
import 'package:rosannalie/general_widget/customnav_button.dart';
import 'package:rosannalie/utils/appString.dart';

// ── Data model ──────────────────────────────────────────────────────────────

enum _Sender { ai, user }

class _Message {
  final _Sender sender;
  final String text;
  final String time;

  const _Message({
    required this.sender,
    required this.text,
    required this.time,
  });
}

// ── Screen ───────────────────────────────────────────────────────────────────

class Aichart extends StatefulWidget {
  const Aichart({super.key});

  @override
  State<Aichart> createState() => _AichartState();
}

class _AichartState extends State<Aichart> {
  final TextEditingController _inputController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  final List<String> _quickStarts = [
    'Help me beat procrastination today',
    'Give me a morning routine',
    "I'm feeling overwhelmed",
    'Celebrate my wins with me',
  ];

  final List<_Message> _messages = [
    const _Message(
      sender: _Sender.ai,
      text:
          "Hey there! I'm so glad you're here. 🌟 I'm your Rise AI coach — I'm here to cheer you on, help you think clearly, and keep you moving forward. What's on your mind today?",
      time: '9:41 AM',
    ),
    const _Message(
      sender: _Sender.user,
      text: 'Celebrate my wins with me',
      time: '07:20 PM',
    ),
    const _Message(
      sender: _Sender.ai,
      text:
          "Yes! Let's celebrate! 🎉 Tell me what you accomplished — big or small, everything counts. I want to hear it!",
      time: '07:20 PM',
    ),
  ];

  @override
  void dispose() {
    _inputController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _sendMessage() {
    final text = _inputController.text.trim();
    if (text.isEmpty) return;
    setState(() {
      _messages.add(_Message(
        sender: _Sender.user,
        text: text,
        time: _currentTime(),
      ));
    });
    _inputController.clear();
    _scrollToBottom();
  }

  void _sendQuickStart(String text) {
    setState(() {
      _messages.add(_Message(
        sender: _Sender.user,
        text: text,
        time: _currentTime(),
      ));
    });
    _scrollToBottom();
  }

  String _currentTime() {
    final now = DateTime.now();
    final h = now.hour % 12 == 0 ? 12 : now.hour % 12;
    final m = now.minute.toString().padLeft(2, '0');
    final period = now.hour >= 12 ? 'PM' : 'AM';
    return '$h:$m $period';
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
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
            bottom: 40.0,
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
          // Back button
          // GestureDetector(
          //   onTap: () => Navigator.maybePop(context),
          //   child: Container(
          //     width: 36,
          //     height: 36,
          //     decoration: BoxDecoration(
          //       color: Colors.white.withValues(alpha: 0.25),
          //       shape: BoxShape.circle,
          //       border: Border.all(
          //         color: Colors.white.withValues(alpha: 0.4),
          //         width: 1,
          //       ),
          //     ),
          //     child: const Icon(
          //       Icons.arrow_back_ios_new_rounded,
          //       size: 16,
          //       color: Colors.white,
          //     ),
          //   ),
          // ),
          const SizedBox(width: 12),

          // Avatar
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: const LinearGradient(
                colors: [Color(0xFF9E6AC3), Color(0xFFC9698E)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              // border: Border.all(color: Colors.white, width: 2),
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
          // Title
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Quick start ',
                style: AppTextStyles.plusJakartaSans(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFF666370),
                ),
              ),
              const Text('✨', style: TextStyle(fontSize: 13)),
            ],
          ),
          const SizedBox(height: 12),
          // Chips — Wrap so they flow into rows like the design
          Wrap(
            alignment: WrapAlignment.center,
            spacing: 8,
            runSpacing: 8,
            children: _quickStarts.map((label) => _QuickStartChip(
              label: label,
              onTap: () => _sendQuickStart(label),
            )).toList(),
          ),
          const SizedBox(height: 12),
        ],
      ),
    );
  }

  // ── Message list ──────────────────────────────────────────────────────────

  Widget _buildMessageList() {
    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      itemCount: _messages.length,
      itemBuilder: (context, index) {
        final msg = _messages[index];
        return msg.sender == _Sender.ai
            ? _AiBubble(message: msg)
            : _UserBubble(message: msg);
      },
    );
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
  final _Message message;

  const _AiBubble({required this.message});

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
                      child: Text(
                        message.text,
                        style: AppTextStyles.inter(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: const Color(0xFF2E2252),
                        ).copyWith(height: 1.5),
                      ),
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
  final _Message message;

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
