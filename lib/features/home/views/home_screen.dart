import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../contacts/controllers/contacts_controller.dart';
import '../../contacts/views/contacts_list_view.dart';
import '../../../core/theme/app_color.dart';
import '../../../core/theme/app_strings.dart';
import '../controllers/home_controller.dart';
import '../../../app/routes/routes.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() {
        final homeController = Get.find<HomeController>();
        return IndexedStack(
          index: homeController.currentIndex.value,
          children: [
            ContactsListView(isFavorites: false),
            ContactsListView(isFavorites: true),
          ],
        );
      }),
      bottomNavigationBar: Obx(() {
        final homeController = Get.find<HomeController>();
        return Container(
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.08),
                blurRadius: 12,
                offset: const Offset(0, -4),
              ),
            ],
            color: AppColor.surface,
          ),
          child: SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 8.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _NavItem(
                    icon: Icons.people_outline,
                    activeIcon: Icons.people,
                    label: AppStrings.contacts,
                    isSelected: homeController.currentIndex.value == 0,
                    onTap: () => homeController.setIndex(0),
                  ),
                  _NavItem(
                    icon: Icons.star_border,
                    activeIcon: Icons.star,
                    label: AppStrings.favorites,
                    isSelected: homeController.currentIndex.value == 1,
                    onTap: () => homeController.setIndex(1),
                  ),
                ],
              ),
            ),
          ),
        );
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Get.toNamed(Routes.addContact)?.then((_) {
          Get.find<ContactsController>().loadContacts();
        }),
        backgroundColor: AppColor.primary,
        child: const Icon(Icons.add, color: AppColor.onPrimary, size: 28),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final IconData activeIcon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _NavItem({
    required this.icon,
    required this.activeIcon,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12.r),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
        decoration: BoxDecoration(
          color: isSelected ? AppColor.primary.withValues(alpha: 0.12) : Colors.transparent,
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isSelected ? activeIcon : icon,
              color: isSelected ? AppColor.primary : AppColor.onSurfaceVariant,
              size: 24.sp,
            ),
            SizedBox(width: 8.w),
            Text(
              label,
              style: GoogleFonts.roboto(
                fontSize: 14.sp,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                color: isSelected ? AppColor.primary : AppColor.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
