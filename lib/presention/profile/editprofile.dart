import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:rosannalie/general_widget/custombutton.dart';
import 'package:rosannalie/utils/appString.dart';
import 'package:rosannalie/core/services/controller/authcontroller.dart';
import 'package:rosannalie/core/route/app_pages.dart';
import 'dart:io';
import 'dart:convert';
import 'package:flutter/foundation.dart' show kIsWeb;

class EditProfile extends StatelessWidget {
  EditProfile({super.key}) {
    final authController = Get.find<Authcontroller>();
    authController.initProfileEditing();
  }

  @override
  Widget build(BuildContext context) {
    final authController = Get.find<Authcontroller>();
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
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
                        color: Color(0xFFF1EFFF),
                      ),
                      clipBehavior: Clip.antiAlias,
                      alignment: Alignment.center,
                      child: Obx(() {
                        if (authController.selectedImagePath.value.isNotEmpty) {
                          return kIsWeb
                              ? Image.network(
                                  authController.selectedImagePath.value,
                                  fit: BoxFit.cover,
                                  width: 110,
                                  height: 110,
                                )
                              : Image.file(
                                  File(authController.selectedImagePath.value),
                                  fit: BoxFit.cover,
                                  width: 110,
                                  height: 110,
                                );
                        } else {
                          final avatar = authController.userAvatar.value;
                          if (avatar.isNotEmpty) {
                            if (avatar.startsWith('data:image')) {
                              final base64String = avatar.substring(avatar.indexOf(',') + 1);
                              return Image.memory(
                                base64Decode(base64String),
                                fit: BoxFit.cover,
                                width: 110,
                                height: 110,
                                errorBuilder: (context, error, stackTrace) => _buildInitialsAvatar(authController.initials),
                              );
                            }
                            return Image.network(
                              avatar,
                              fit: BoxFit.cover,
                              width: 110,
                              height: 110,
                              errorBuilder: (context, error, stackTrace) => _buildInitialsAvatar(authController.initials),
                            );
                          } else {
                            return _buildInitialsAvatar(authController.initials);
                          }
                        }
                      }),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: GestureDetector(
                        onTap: authController.pickImage,
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
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),

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
                controller: authController.nameController,
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
                controller: authController.emailController,
                keyboardType: TextInputType.emailAddress,
                readOnly: true,
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

              Center(
                child: Obx(() => authController.isLoading.value
                    ? const CircularProgressIndicator(color: Color(0xFF7B64B0))
                    : CustomButton(
                        text: "Save Changes",
                        height: 52.0,
                        onTap: () async {
                          String? imagePath;
                          if (authController.selectedImagePath.value.isNotEmpty) {
                            imagePath = authController.selectedImagePath.value;
                          }
                          bool success = await authController.updateProfile(
                            authController.nameController.text,
                            imagePath,
                          );
                          if (success) {
                            Get.offAllNamed(AppRoutes.home);
                          }
                        },
                      )),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInitialsAvatar(String initials) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF8F7DB5), Color(0xFF7B64B0)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      alignment: Alignment.center,
      child: Text(
        initials,
        style: AppTextStyles.inter(
          fontSize: 28,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    );
  }
}
