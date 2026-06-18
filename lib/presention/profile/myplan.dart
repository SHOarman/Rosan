import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rosannalie/utils/appString.dart';

class MyPlanPage extends StatefulWidget {
  const MyPlanPage({super.key});

  @override
  State<MyPlanPage> createState() => _MyPlanPageState();
}

class _MyPlanPageState extends State<MyPlanPage> {
  bool _isYearly = true; // Default to Yearly as in mockup

  Widget _buildCheckItem(String iconText, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(3.0),
            decoration: const BoxDecoration(
              color: Color(0xFFEFE8FF),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.check_rounded,
              color: Color(0xFF7B64B0),
              size: 14.0,
            ),
          ),
          const SizedBox(width: 10.0),
          Expanded(
            child: Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: iconText + " ",
                    style: const TextStyle(fontSize: 14.0),
                  ),
                  TextSpan(
                    text: text,
                    style: AppTextStyles.inter(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: const Color(0xFF5E4B8B),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGridItem(String iconText, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            iconText,
            style: const TextStyle(fontSize: 16.0),
          ),
          const SizedBox(width: 8.0),
          Expanded(
            child: Text(
              text,
              style: AppTextStyles.inter(
                fontSize: 11,
                fontWeight: FontWeight.w500,
                color: const Color(0xFF575B61),
              ).copyWith(height: 1.3),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Custom Header Row
              Row(
                children: [
                  GestureDetector(
                    onTap: () => Get.back(),
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: const BoxDecoration(
                        color: Color(0xFFF1EFFF),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.arrow_back,
                        color: Color(0xFF5E4B8B),
                        size: 20,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    "Premium Plan",
                    style: AppTextStyles.plusJakartaSans(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: const Color(0xFF161022),
                    ),
                  ),
                ],
              ),

              // circular premium illustration in center
              Center(
                child: Column(
                  children: [
                    Container(
                      width: 90.0,
                      height: 90.0,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                          colors: [
                            const Color(0xFFFFECEF),
                            const Color(0xFFEFE8FF),
                            const Color(0xFFD6C8FF).withOpacity(0.5),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                      ),
                      alignment: Alignment.center,
                      child: Container(
                        width: 74.0,
                        height: 74.0,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                        ),
                        alignment: Alignment.center,
                        child: ClipOval(
                          child: Image.asset(
                            "assets/images/LOGO (2) 2 (1).png",
                            width: 68.0,
                            height: 68.0,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16.0),
                    // Title "Rise Premium"
                    Text(
                      "Rise Premium ✨",
                      style: AppTextStyles.plusJakartaSans(
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                        color: const Color(0xFF5E4B8B),
                      ),
                    ),
                    const SizedBox(height: 6.0),
                    // Subtitle
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Text(
                        "Unlock your full potential with everything Rise has to offer.",
                        textAlign: TextAlign.center,
                        style: AppTextStyles.inter(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: const Color(0xFF8F7DB5),
                        ).copyWith(height: 1.4),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // 7-day free trial box
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: const Color(0xFFE8F8F0),
                  borderRadius: BorderRadius.circular(20.0),
                  border: Border.all(
                    color: const Color(0xFFC2ECD3),
                    width: 1.0,
                  ),
                ),
                child: Row(
                  children: [
                    // Orange gift box container
                    Container(
                      width: 38.0,
                      height: 38.0,
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFF4EB),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      alignment: Alignment.center,
                      child: const Text(
                        "🎁",
                        style: TextStyle(fontSize: 18.0),
                      ),
                    ),
                    const SizedBox(width: 14.0),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "7-day free trial",
                            style: AppTextStyles.inter(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFF1B633E),
                            ),
                          ),
                          const SizedBox(height: 2.0),
                          Text(
                            "No charge until your trial ends. Cancel anytime.",
                            style: AppTextStyles.inter(
                              fontSize: 11,
                              fontWeight: FontWeight.w500,
                              color: const Color(0xFF349B60),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Plan Selector Toggle (Monthly / Yearly Switcher)
              Container(
                width: double.infinity,
                height: 48.0,
                decoration: BoxDecoration(
                  color: const Color(0xFFF6F5FB),
                  borderRadius: BorderRadius.circular(24.0),
                ),
                padding: const EdgeInsets.all(4.0),
                child: Row(
                  children: [
                    // Monthly option
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            _isYearly = false;
                          });
                        },
                        child: Container(
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: !_isYearly ? Colors.white : Colors.transparent,
                            borderRadius: BorderRadius.circular(20.0),
                            boxShadow: !_isYearly
                                ? [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.05),
                                      blurRadius: 4.0,
                                      offset: const Offset(0, 2),
                                    )
                                  ]
                                : [],
                          ),
                          child: Text(
                            "Monthly",
                            style: AppTextStyles.inter(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: !_isYearly ? const Color(0xFF161022) : const Color(0xFF8F7DB5),
                            ),
                          ),
                        ),
                      ),
                    ),
                    // Yearly option with Save 20% badge
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            _isYearly = true;
                          });
                        },
                        child: Container(
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: _isYearly ? const Color(0xFF7B64B0) : Colors.transparent,
                            borderRadius: BorderRadius.circular(20.0),
                            boxShadow: _isYearly
                                ? [
                                    BoxShadow(
                                      color: const Color(0xFF7B64B0).withOpacity(0.2),
                                      blurRadius: 8.0,
                                      offset: const Offset(0, 4),
                                    )
                                  ]
                                : [],
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Yearly",
                                style: AppTextStyles.inter(
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                  color: _isYearly ? Colors.white : const Color(0xFF8F7DB5),
                                ),
                              ),
                              const SizedBox(width: 6.0),
                              // Save badge
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 6.0, vertical: 2.0),
                                decoration: BoxDecoration(
                                  color: _isYearly ? Colors.white.withOpacity(0.2) : const Color(0xFFFFF1F1),
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                                child: Text(
                                  "Save 20%",
                                  style: AppTextStyles.inter(
                                    fontSize: 9,
                                    fontWeight: FontWeight.bold,
                                    color: _isYearly ? Colors.white : const Color(0xFFEF4444),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Price Details Box Card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20.0),
                decoration: BoxDecoration(
                  color: const Color(0xFFF7F5FC),
                  borderRadius: BorderRadius.circular(24.0),
                  border: Border.all(
                    color: const Color(0xFFE6DCFA),
                    width: 1.0,
                  ),
                ),
                child: Column(
                  children: [
                    // Price Row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          r"$",
                          style: AppTextStyles.plusJakartaSans(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF7B64B0),
                          ).copyWith(height: 1.8),
                        ),
                        const SizedBox(width: 2.0),
                        Text(
                          _isYearly ? "4.99" : "5.99",
                          style: AppTextStyles.plusJakartaSans(
                            fontSize: 32,
                            fontWeight: FontWeight.w800,
                            color: const Color(0xFF5E4B8B),
                          ),
                        ),
                        const SizedBox(width: 4.0),
                        Text(
                          "/mo",
                          style: AppTextStyles.inter(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF8F7DB5),
                          ).copyWith(height: 2.8),
                        ),
                      ],
                    ),
                    const SizedBox(height: 2.0),
                    Text(
                      _isYearly ? "Billed \$59.99/year. Save \$24" : "Billed monthly. Cancel anytime",
                      style: AppTextStyles.inter(
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xFF8F7DB5),
                      ),
                    ),
                    const SizedBox(height: 16.0),
                    const Divider(color: Color(0xFFEFE8FF), height: 1.0),
                    const SizedBox(height: 16.0),

                    // Feature checks list
                    _buildCheckItem("🤖", "Unlimited AI coaching sessions"),
                    _buildCheckItem("🎯", "Unlimited goals & tasks"),
                    _buildCheckItem("📊", "Advanced progress analytics"),
                    _buildCheckItem("🏆", "Premium achievement badges"),
                    _buildCheckItem("🎵", "Music sync & focus playlists"),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Feature Grid Box Card ("Everything included:")
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20.0),
                decoration: BoxDecoration(
                  color: const Color(0xFFFAFAFC),
                  borderRadius: BorderRadius.circular(24.0),
                  border: Border.all(
                    color: const Color(0xFFF1EFFF),
                    width: 1.0,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Everything included:",
                      style: AppTextStyles.plusJakartaSans(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF161022),
                      ),
                    ),
                    const SizedBox(height: 12.0),

                    // 2-Column Row Layout
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Column 1
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildGridItem("🤖", "Unlimited AI coaching sessions"),
                              _buildGridItem("📊", "Advanced progress analytics"),
                              _buildGridItem("🎵", "Music sync & focus playlists"),
                              _buildGridItem("🔮", "Future Me deep visualization"),
                            ],
                          ),
                        ),
                        const SizedBox(width: 14.0),
                        // Column 2
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildGridItem("🎯", "Unlimited goals & tasks"),
                              _buildGridItem("🏆", "Premium achievement badges"),
                              _buildGridItem("📅", "Smart calendar integration"),
                              _buildGridItem("✨", "Exclusive quote collections"),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),

              // Start Free Trial Button
              SizedBox(
                width: double.infinity,
                height: 52.0,
                child: ElevatedButton(
                  onPressed: () {
                    print("Subscription flow started. Yearly: $_isYearly");
                    Get.snackbar(
                      "Processing",
                      "Starting your 7-day free trial...",
                      snackPosition: SnackPosition.BOTTOM,
                      backgroundColor: const Color(0xFFEFE8FF),
                      colorText: const Color(0xFF7B64B0),
                      margin: const EdgeInsets.all(20),
                      borderRadius: 12,
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF7B64B0),
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16.0),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Start Free Trial",
                        style: AppTextStyles.inter(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 6.0),
                      const Icon(Icons.arrow_forward_rounded, size: 18.0),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 12),

              // Button subtext
              Center(
                child: Text(
                  "7 days free · Cancel anytime · No surprises",
                  style: AppTextStyles.inter(
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFF8F7DB5),
                  ),
                ),
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}
