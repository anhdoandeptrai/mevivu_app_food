import 'package:get/get.dart';
import 'package:mevivuapp/view/detail_screen.dart';
import 'package:mevivuapp/view/home_screen.dart';
import 'package:mevivuapp/view/profile_screen.dart'; // Thêm dòng này
import 'package:mevivuapp/view/news_screen.dart';
import 'package:mevivuapp/view/search_screen.dart';
import 'package:mevivuapp/view/welcome_screen.dart';
import 'package:mevivuapp/view/add_recipe_screen.dart';

class AppRoutes {
  static final routes = [
    GetPage(name: '/', page: () => WelcomeScreen()),
    GetPage(name: '/home', page: () => HomeScreen()),
    GetPage(name: '/search', page: () => SearchScreen()),
    GetPage(name: '/detail', page: () => DetailScreen()),
    GetPage(name: '/profile', page: () => ProfileScreen()), // Thêm dòng này
    GetPage(name: '/saved', page: () => NewsScreen()),
    GetPage(name: '/add_recipe', page: () => AddRecipeScreen()),
  ];
}
