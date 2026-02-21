import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/models/contact_model.dart';
import '../../../core/utils/database_helper.dart';

class ContactsController extends GetxController {
  final DatabaseHelper _db = DatabaseHelper.instance;

  final RxList<ContactModel> contacts = <ContactModel>[].obs;
  final RxList<ContactModel> favoriteContacts = <ContactModel>[].obs;
  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadContacts();
  }

  Future<void> loadContacts() async {
    isLoading.value = true;
    try {
      final all = await _db.getAllContacts();
      final favorites = await _db.getFavoriteContacts();
      contacts.value = all;
      favoriteContacts.value = favorites;
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> addContact(ContactModel contact) async {
    await _db.insertContact(contact);
    await loadContacts();
  }

  Future<void> updateContact(ContactModel contact) async {
    if (contact.id == null) return;
    await _db.updateContact(contact);
    await loadContacts();
  }

  Future<void> deleteContact(int id) async {
    await _db.deleteContact(id);
    await loadContacts();
  }

  Future<void> toggleFavorite(ContactModel contact) async {
    if (contact.id == null) return;
    final newFavorite = !contact.isFavorite;
    await _db.toggleFavorite(contact.id!, newFavorite);
    await loadContacts();
  }

  Future<void> callContact(String phone) async {
    final uri = Uri.parse('tel:$phone');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  ContactModel? getContactById(int id) {
    try {
      return contacts.firstWhere((c) => c.id == id);
    } catch (_) {
      return null;
    }
  }
}
