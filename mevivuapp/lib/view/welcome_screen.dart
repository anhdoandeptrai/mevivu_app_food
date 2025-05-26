import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../untils/app_theme.dart';

class WelcomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: NetworkImage(
                'https://www.themealdb.com/images/media/meals/tytyvr1515353282.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Spacer(flex: 2),
              Text(
                'MeViVu',
                style: TextStyle(
                  color: AppTheme.neutral50,
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Spacer(),
              Container(
                padding: EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.5),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(24),
                    topRight: Radius.circular(24),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'BẮT ĐẦU VỚI NHỮNG MÓN ĂN',
                      style: TextStyle(
                        color: AppTheme.neutral50,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 16),
                    Text(
                      'Khám phá các công thức nấu ăn, lưu trữ món ăn yêu thích và tìm kiếm các món ăn mới',
                      style: TextStyle(
                        color: AppTheme.neutral200,
                        fontSize: 16,
                      ),
                    ),
                    SizedBox(height: 32),
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton(
                        onPressed: () => Get.offAllNamed('/home'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.primary500,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(
                          'Bắt đầu',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
