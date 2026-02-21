import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../core/theme/app_color.dart';
import '../features/contacts/controllers/contacts_controller.dart';
import '../features/home/controllers/home_controller.dart';
import 'routes/app_pages.dart';
import 'routes/routes.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(392, 781), //Responsive design size
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (_, __) => GetMaterialApp(
        title: 'Contacts',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(
            seedColor: AppColor.primary,
            primary: AppColor.primary,
            surface: AppColor.surface,
            onSurface: AppColor.onSurface,
            error: AppColor.error,
          ),
          textTheme: GoogleFonts.robotoTextTheme(),
          appBarTheme: const AppBarTheme(
            centerTitle: true,
            elevation: 0,
            backgroundColor: AppColor.surface,
            foregroundColor: AppColor.onSurface,
          ),
          floatingActionButtonTheme: const FloatingActionButtonThemeData(
            backgroundColor: AppColor.primary,
            foregroundColor: AppColor.onPrimary,
          ),
          inputDecorationTheme: InputDecorationTheme(
            filled: true,
            fillColor: AppColor.background,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          ),
        ),
        initialRoute: Routes.home,
        getPages: AppPages.routes,
        initialBinding: BindingsBuilder(() {
          Get.lazyPut<ContactsController>(() => ContactsController());
          Get.lazyPut<HomeController>(() => HomeController());
        }),
      ),
    );
  }
}
