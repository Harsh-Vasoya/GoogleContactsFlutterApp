import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../controllers/contacts_controller.dart';
import '../../../core/models/contact_model.dart';
import '../../../core/theme/app_color.dart';
import '../../../core/theme/app_strings.dart';
import '../../../app/routes/routes.dart';

class ContactProfileScreen extends StatefulWidget {
  const ContactProfileScreen({super.key});

  @override
  State<ContactProfileScreen> createState() => _ContactProfileScreenState();
}

class _ContactProfileScreenState extends State<ContactProfileScreen> {
  late ContactModel _contact;

  @override
  void initState() {
    super.initState();
    _contact = Get.arguments as ContactModel;
  }

  void _toggleFavorite(ContactsController controller) async {
    await controller.toggleFavorite(_contact);
    setState(() {
      _contact = _contact.copyWith(isFavorite: !_contact.isFavorite);
    });
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ContactsController>();

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 200.h,
            pinned: true,
            backgroundColor: AppColor.primary,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => Get.back(),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.edit, color: Colors.white),
                onPressed: () => Get.toNamed(Routes.editContact, arguments: _contact)
                    ?.then((_) {
                  controller.loadContacts();
                  final updated = controller.getContactById(_contact.id!);
                  if (updated != null) setState(() => _contact = updated);
                }),
              ),
              IconButton(
                icon: Icon(
                  _contact.isFavorite ? Icons.star : Icons.star_border,
                  color: _contact.isFavorite ? AppColor.favorite : Colors.white,
                ),
                onPressed: () => _toggleFavorite(controller),
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                color: AppColor.primary,
                child: Center(
                  child: CircleAvatar(
                    radius: 50.r,
                    backgroundColor: Colors.white.withValues(alpha: 0.3),
                    child: Text(
                      _contact.displayName.isNotEmpty
                          ? _contact.displayName[0].toUpperCase()
                          : '?',
                      style: GoogleFonts.roboto(
                        fontSize: 40.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.all(24.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Text(
                      _contact.displayName,
                      style: GoogleFonts.roboto(
                        fontSize: 24.sp,
                        fontWeight: FontWeight.w600,
                        color: AppColor.onSurface,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizedBox(height: 24.h),
                  if (_contact.phone.isNotEmpty)
                    _ProfileTile(
                      icon: Icons.phone,
                      label: AppStrings.phone,
                      value: _contact.phone,
                      onTap: () => controller.callContact(_contact.phone),
                      trailing: IconButton(
                        icon: Icon(Icons.call, color: AppColor.primary),
                        onPressed: () => controller.callContact(_contact.phone),
                      ),
                    ),
                  if (_contact.email.isNotEmpty) ...[
                    SizedBox(height: 16.h),
                    _ProfileTile(
                      icon: Icons.email,
                      label: AppStrings.email,
                      value: _contact.email,
                    ),
                  ],
                  if (_contact.address.isNotEmpty) ...[
                    SizedBox(height: 16.h),
                    _ProfileTile(
                      icon: Icons.location_on,
                      label: AppStrings.address,
                      value: _contact.address,
                    ),
                  ],
                  if (_contact.notes.isNotEmpty) ...[
                    SizedBox(height: 16.h),
                    _ProfileTile(
                      icon: Icons.note,
                      label: AppStrings.notes,
                      value: _contact.notes,
                    ),
                  ],
                  SizedBox(height: 32.h),
                  Center(
                    child: OutlinedButton.icon(
                      onPressed: () => _showDeleteDialog(context, controller, _contact),
                      icon: const Icon(Icons.delete_outline, color: AppColor.error),
                      label: Text(
                        AppStrings.deleteContact,
                        style: GoogleFonts.roboto(
                          color: AppColor.error,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: AppColor.error),
                      ),
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

  void _showDeleteDialog(BuildContext context, ContactsController controller, ContactModel contact) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(AppStrings.deleteContact),
        content: Text(AppStrings.deleteConfirmation),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text(AppStrings.cancel),
          ),
          TextButton(
            onPressed: () async {
              if (contact.id != null) {
                await controller.deleteContact(contact.id!);
                Get.back();
                Get.back();
              }
            },
            child: Text(
              AppStrings.delete,
              style: const TextStyle(color: AppColor.error, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }
}

class _ProfileTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final VoidCallback? onTap;
  final Widget? trailing;

  const _ProfileTile({
    required this.icon,
    required this.label,
    required this.value,
    this.onTap,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColor.background,
      borderRadius: BorderRadius.circular(12.r),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12.r),
        child: Padding(
          padding: EdgeInsets.all(16.w),
          child: Row(
            children: [
              Icon(icon, color: AppColor.primary, size: 24.sp),
              SizedBox(width: 16.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label,
                      style: GoogleFonts.roboto(
                        fontSize: 12.sp,
                        color: AppColor.onSurfaceVariant,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      value,
                      style: GoogleFonts.roboto(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w500,
                        color: AppColor.onSurface,
                      ),
                    ),
                  ],
                ),
              ),
              if (trailing != null) trailing!,
            ],
          ),
        ),
      ),
    );
  }
}
