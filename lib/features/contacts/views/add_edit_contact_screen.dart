import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../controllers/contacts_controller.dart';
import '../../../core/models/contact_model.dart';
import '../../../core/theme/app_color.dart';
import '../../../core/theme/app_strings.dart';

class AddEditContactScreen extends StatelessWidget {
  const AddEditContactScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final contact = Get.arguments as ContactModel?;
    final isEdit = contact != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          isEdit ? AppStrings.editContact : AppStrings.addContact,
          style: GoogleFonts.roboto(
            fontSize: 20.sp,
            fontWeight: FontWeight.w600,
            color: AppColor.onSurface,
          ),
        ),
        backgroundColor: AppColor.surface,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColor.onSurface),
          onPressed: () => Get.back(),
        ),
      ),
      body: _AddEditContactForm(initialContact: contact, isEdit: isEdit),
    );
  }
}

class _AddEditContactForm extends StatefulWidget {
  final ContactModel? initialContact;
  final bool isEdit;

  const _AddEditContactForm({this.initialContact, required this.isEdit});

  @override
  State<_AddEditContactForm> createState() => _AddEditContactFormState();
}

class _AddEditContactFormState extends State<_AddEditContactForm> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _addressController = TextEditingController();
  final _notesController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.initialContact != null) {
      final c = widget.initialContact!;
      _nameController.text = c.name;
      _phoneController.text = c.phone;
      _emailController.text = c.email;
      _addressController.text = c.address;
      _notesController.text = c.notes;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _addressController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    final controller = Get.find<ContactsController>();
    final contact = ContactModel(
      id: widget.initialContact?.id,
      name: _nameController.text.trim(),
      phone: _phoneController.text.trim(),
      email: _emailController.text.trim(),
      address: _addressController.text.trim(),
      notes: _notesController.text.trim(),
      isFavorite: widget.initialContact?.isFavorite ?? false,
      createdAt: widget.initialContact?.createdAt,
    );

    if (widget.isEdit) {
      await controller.updateContact(contact);
    } else {
      await controller.addContact(contact);
    }
    Get.back();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(24.w),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildTextField(
              controller: _nameController,
              label: AppStrings.name,
              icon: Icons.person_outline,
              validator: (v) {
                if (v == null || v.trim().isEmpty) return 'Name is required';
                return null;
              },
            ),
            SizedBox(height: 16.h),
            _buildTextField(
              controller: _phoneController,
              label: AppStrings.phone,
              icon: Icons.phone_outlined,
              keyboardType: TextInputType.phone,
              validator: (v) {
                if (v == null || v.trim().isEmpty) return 'Phone is required';
                return null;
              },
            ),
            SizedBox(height: 16.h),
            _buildTextField(
              controller: _emailController,
              label: AppStrings.email,
              icon: Icons.email_outlined,
              keyboardType: TextInputType.emailAddress,
            ),
            SizedBox(height: 16.h),
            _buildTextField(
              controller: _addressController,
              label: AppStrings.address,
              icon: Icons.location_on_outlined,
              maxLines: 2,
            ),
            SizedBox(height: 16.h),
            _buildTextField(
              controller: _notesController,
              label: AppStrings.notes,
              icon: Icons.note_outlined,
              maxLines: 3,
            ),
            SizedBox(height: 32.h),
            FilledButton(
              onPressed: _save,
              style: FilledButton.styleFrom(
                backgroundColor: AppColor.primary,
                foregroundColor: AppColor.onPrimary,
                padding: EdgeInsets.symmetric(vertical: 16.h),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
              ),
              child: Text(
                AppStrings.save,
                style: GoogleFonts.roboto(fontSize: 16.sp, fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType? keyboardType,
    int maxLines = 1,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      maxLines: maxLines,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: AppColor.onSurfaceVariant, size: 22.sp),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.r)),
        filled: true,
        fillColor: AppColor.background,
      ),
    );
  }
}
