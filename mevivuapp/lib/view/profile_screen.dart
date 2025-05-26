import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mevivuapp/untils/app_theme.dart';
import 'package:mevivuapp/widgets/custom_bottom_nav_bar.dart';
import '../controllers/profile_controller.dart';

class ProfileScreen extends StatelessWidget {
  final ProfileController controller = Get.put(ProfileController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true, // Cho phép body chiếm cả vùng của bottomNavigationBar
      appBar: AppBar(
        title: Text('Profile'),
      ),
      body: SafeArea(
        bottom: false, // Không áp dụng SafeArea ở dưới
        child: SingleChildScrollView(
          padding:
              EdgeInsets.only(bottom: 100), // Đảm bảo nội dung không bị che
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 50,
                      backgroundColor: AppTheme.primary200,
                      child: Text('NDT',
                          style: TextStyle(
                              fontSize: 40, color: AppTheme.neutral950)),
                    ),
                    SizedBox(height: 10),
                    Text(
                      controller.username.value,
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.neutral950),
                    ),
                    SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Column(
                          children: [
                            Obx(() => Text(controller.posts.value.toString(),
                                style: TextStyle(color: AppTheme.neutral900))),
                            Text('Bài viết',
                                style: TextStyle(color: AppTheme.neutral700)),
                          ],
                        ),
                        SizedBox(width: 20),
                        Column(
                          children: [
                            Obx(() => Text(
                                controller.followers.value.toString(),
                                style: TextStyle(color: AppTheme.neutral900))),
                            Text('Người theo dõi',
                                style: TextStyle(color: AppTheme.neutral700)),
                          ],
                        ),
                        SizedBox(width: 20),
                        Column(
                          children: [
                            Obx(() => Text(
                                controller.following.value.toString(),
                                style: TextStyle(color: AppTheme.neutral900))),
                            Text('Đang theo dõi',
                                style: TextStyle(color: AppTheme.neutral700)),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          onPressed: () => controller.follow(),
                          child: Text('Follow'),
                        ),
                        SizedBox(width: 10),
                        OutlinedButton(
                          onPressed: () {},
                          child: Text('Message',
                              style: TextStyle(color: AppTheme.neutral900)),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text('Danh sách yêu thích',
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ),
              GridView.count(
                crossAxisCount: 3,
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                children: List.generate(6, (index) {
                  return Card(
                    child: Image.network(
                      'https://www.themealdb.com/images/media/meals/tytyvr1515353282.jpg',
                      fit: BoxFit.cover,
                    ),
                  );
                }),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: CustomBottomNavBar(currentIndex: 4),
    );
  }
}
