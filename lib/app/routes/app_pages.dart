import 'package:get/get.dart';

import '../../features/contacts/views/add_edit_contact_screen.dart';
import '../../features/contacts/views/contact_profile_screen.dart';
import '../../features/home/views/home_screen.dart';

import 'routes.dart';

class AppPages {
  static final routes = [
    GetPage(
      name: Routes.home,
      page: () => const HomeScreen(),
    ),
    GetPage(
      name: Routes.addContact,
      page: () => const AddEditContactScreen(),
    ),
    GetPage(
      name: Routes.editContact,
      page: () => const AddEditContactScreen(),
    ),
    GetPage(
      name: Routes.contactProfile,
      page: () => const ContactProfileScreen(),
    ),
  ];
}
