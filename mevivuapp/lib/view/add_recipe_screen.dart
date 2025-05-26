import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../untils/app_theme.dart';

class AddRecipeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Thêm công thức mới'),
        backgroundColor: AppTheme.primary500,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.restaurant_menu,
              size: 100,
              color: AppTheme.primary300,
            ),
            SizedBox(height: 24),
            Text(
              'Tạo công thức mới',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppTheme.neutral900,
              ),
            ),
            SizedBox(height: 16),
            Text(
              'Tính năng đang được phát triển',
              style: TextStyle(
                fontSize: 16,
                color: AppTheme.neutral700,
              ),
            ),
            SizedBox(height: 40),
            ElevatedButton(
              onPressed: () => Get.back(),
              child: Text('Quay lại'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primary500,
                padding: EdgeInsets.symmetric(horizontal: 40, vertical: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
