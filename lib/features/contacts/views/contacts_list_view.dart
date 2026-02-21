import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../controllers/contacts_controller.dart';
import '../../../core/theme/app_color.dart';
import '../../../core/theme/app_strings.dart';
import '../../../app/routes/routes.dart';
import 'contact_list_item.dart';

class ContactsListView extends StatelessWidget {
  final bool isFavorites;

  const ContactsListView({super.key, required this.isFavorites});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ContactsController>();
    final list = isFavorites ? controller.favoriteContacts : controller.contacts;

    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              floating: true,
              backgroundColor: AppColor.surface,
              elevation: 0,
              title: Text(
                isFavorites ? AppStrings.favorites : AppStrings.contacts,
                style: GoogleFonts.roboto(
                  fontSize: 24.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColor.onSurface,
                ),
              ),
            ),
            Obx(() {
              if (controller.isLoading.value) {
                return SliverFillRemaining(
                  child: Center(
                    child: CircularProgressIndicator(color: AppColor.primary),
                  ),
                );
              }
              if (list.isEmpty) {
                return SliverFillRemaining(
                  child: _EmptyState(isFavorites: isFavorites),
                );
              }
              return SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final contact = list[index];
                    return ContactListItem(
                      contact: contact,
                      onTap: () => Get.toNamed(
                        Routes.contactProfile,
                        arguments: contact,
                      ),
                      onCall: () => controller.callContact(contact.phone),
                      onFavorite: () => controller.toggleFavorite(contact),
                    );
                  },
                  childCount: list.length,
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  final bool isFavorites;

  const _EmptyState({required this.isFavorites});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(32.w),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            isFavorites ? Icons.star_border : Icons.people_outline,
            size: 80.sp,
            color: AppColor.outline,
          ),
          SizedBox(height: 24.h),
          Text(
            isFavorites ? AppStrings.noFavorites : AppStrings.noContacts,
            style: GoogleFonts.roboto(
              fontSize: 18.sp,
              fontWeight: FontWeight.w600,
              color: AppColor.onSurface,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 8.h),
          Text(
            isFavorites ? AppStrings.addFavorites : AppStrings.addFirstContact,
            style: GoogleFonts.roboto(
              fontSize: 14.sp,
              color: AppColor.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
