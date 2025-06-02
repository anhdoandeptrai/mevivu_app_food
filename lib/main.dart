import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:get/get.dart';
import 'package:mevivuapp/app/routes.dart';
import 'package:mevivuapp/models/recipe_model.dart';
import 'package:mevivuapp/untils/app_theme.dart';
import 'controllers/saved_controller.dart';

void main() async {
  await Hive.initFlutter();
  Hive.registerAdapter(RecipeAdapter());
  await Hive.openBox('recipesBox');
  Get.put(SavedController());
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Food Recipe App',
      initialRoute: '/',
      getPages: AppRoutes.routes,
      theme: AppTheme.lightTheme,
    );
  }
}
