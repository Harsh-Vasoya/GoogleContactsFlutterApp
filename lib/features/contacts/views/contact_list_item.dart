import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/models/contact_model.dart';
import '../../../core/theme/app_color.dart';

class ContactListItem extends StatelessWidget {
  final ContactModel contact;
  final VoidCallback onTap;
  final VoidCallback onCall;
  final VoidCallback onFavorite;

  const ContactListItem({
    super.key,
    required this.contact,
    required this.onTap,
    required this.onCall,
    required this.onFavorite,
  });

  @override
  Widget build(BuildContext context) {
    final initial = contact.displayName.isNotEmpty
        ? contact.displayName[0].toUpperCase()
        : '?';

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
          child: Row(
            children: [
              CircleAvatar(
                radius: 28.r,
                backgroundColor: AppColor.primary.withValues(alpha: 0.2),
                child: Text(
                  initial,
                  style: GoogleFonts.roboto(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColor.primary,
                  ),
                ),
              ),
              SizedBox(width: 16.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      contact.displayName,
                      style: GoogleFonts.roboto(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w500,
                        color: AppColor.onSurface,
                      ),
                    ),
                    if (contact.phone.isNotEmpty)
                      Text(
                        contact.phone,
                        style: GoogleFonts.roboto(
                          fontSize: 14.sp,
                          color: AppColor.onSurfaceVariant,
                        ),
                      ),
                  ],
                ),
              ),
              IconButton(
                onPressed: onCall,
                icon: Icon(
                  Icons.call,
                  color: AppColor.primary,
                  size: 22.sp,
                ),
              ),
              IconButton(
                onPressed: onFavorite,
                icon: Icon(
                  contact.isFavorite ? Icons.star : Icons.star_border,
                  color: contact.isFavorite ? AppColor.favorite : AppColor.onSurfaceVariant,
                  size: 22.sp,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
