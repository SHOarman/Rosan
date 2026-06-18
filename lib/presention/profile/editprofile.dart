import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:rosannalie/general_widget/custombutton.dart';
import 'package:rosannalie/utils/appString.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({super.key});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final TextEditingController _nameController = TextEditingController(text: "Ahmad Karimi");
  final TextEditingController _emailController = TextEditingController(text: "ahmed@example.com");

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    super.dispose();
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
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                  Text(
                    "Edit Profile",
                    style: AppTextStyles.plusJakartaSans(
                      fontSize: 20,
                      color: const Color(0xFF161022),
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(width: 40), // spacer to center the title
                ],
              ),
              const SizedBox(height: 30),

              // Profile Avatar with Camera Overlay
              Center(
                child: Stack(
                  children: [
                    Container(
                      width: 110.0,
                      height: 110.0,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                          colors: [Color(0xFF8F7DB5), Color(0xFF7B64B0)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        "AK",
                        style: AppTextStyles.inter(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        width: 32.0,
                        height: 32.0,
                        decoration: BoxDecoration(
                          color: const Color(0xFF7B64B0),
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 2.0),
                        ),
                        child: const Icon(
                          Icons.camera_alt_outlined,
                          color: Colors.white,
                          size: 16.0,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),

              // Full Name Label & Field
              Text(
                "Full Name",
                style: AppTextStyles.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF161022),
                ),
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _nameController,
                style: AppTextStyles.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFF161022),
                ),
                decoration: InputDecoration(
                  prefixIcon: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: SvgPicture.asset(
                      "assets/images/Icon.svg",
                      colorFilter: const ColorFilter.mode(
                        Color(0xFF8F7DB5),
                        BlendMode.srcIn,
                      ),
                      width: 20.0,
                      height: 20.0,
                    ),
                  ),
                  fillColor: Colors.white,
                  filled: true,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14.0),
                    borderSide: const BorderSide(
                      color: Color(0xFFE3E7EB),
                      width: 1.0,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14.0),
                    borderSide: const BorderSide(
                      color: Color(0xFF7B64B0),
                      width: 1.5,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Email Label & Field
              Text(
                "Email",
                style: AppTextStyles.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF161022),
                ),
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                style: AppTextStyles.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFF161022),
                ),
                decoration: InputDecoration(
                  prefixIcon: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: SvgPicture.asset(
                      "assets/images/Icon (9).svg",
                      colorFilter: const ColorFilter.mode(
                        Color(0xFF8F7DB5),
                        BlendMode.srcIn,
                      ),
                      width: 20.0,
                      height: 20.0,
                    ),
                  ),
                  fillColor: Colors.white,
                  filled: true,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14.0),
                    borderSide: const BorderSide(
                      color: Color(0xFFE3E7EB),
                      width: 1.0,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14.0),
                    borderSide: const BorderSide(
                      color: Color(0xFF7B64B0),
                      width: 1.5,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 160),

              // Save Changes Button
              Center(
                child: CustomButton(
                  text: "Save Changes",
                  height: 52.0,
                  onTap: () {
                    print("Save Changes tapped. Name: ${_nameController.text}, Email: ${_emailController.text}");
                    // Get.snackbar(
                    //   "Success",
                    //   "Profile updated successfully",
                    //   snackPosition: SnackPosition.BOTTOM,
                    //   backgroundColor: const Color(0xFFEFE8FF),
                    //   colorText: const Color(0xFF7B64B0),
                    //   margin: const EdgeInsets.all(20),
                    //   borderRadius: 12,
                    //   duration: const Duration(seconds: 2),
                    // );
                    Future.delayed(const Duration(seconds: 2), () {
                      Get.back();
                    });
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
