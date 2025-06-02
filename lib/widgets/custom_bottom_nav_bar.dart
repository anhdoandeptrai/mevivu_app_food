import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../untils/app_theme.dart';

class NavBarClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    final centerWidth = size.width / 2;
    final arcRadius = 40.0;
    path.moveTo(0, 0);
    path.lineTo(centerWidth - arcRadius, 0);
    path.arcToPoint(
      Offset(centerWidth + arcRadius, 0),
      radius: Radius.circular(arcRadius),
      clockwise: false,
    );
    path.lineTo(size.width, 0);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

class CustomBottomNavBar extends StatelessWidget {
  final int currentIndex;

  CustomBottomNavBar({required this.currentIndex});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70,
      width: double.infinity, // Đảm bảo chiếm hết chiều ngang
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned(
            top: 0,
            left: (MediaQuery.of(context).size.width / 2) - 40,
            child: Container(
              width: 80,
              height: 40,
              color: Colors.transparent,
            ),
          ),
          ClipPath(
            clipper: NavBarClipper(),
            child: Container(
              height: 70,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(25),
                  bottom: Radius.circular(0),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: Offset(0, 0),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.only(bottom: 10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildNavItem(Icons.home, 0),
                    _buildNavItem(Icons.search, 1),
                    // Khoảng trống cho FAB
                    Container(width: 80),
                    _buildNavItem(Icons.bookmark_border, 3),
                    _buildNavItem(Icons.person_outline, 4),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            top: -30,
            left: 0,
            right: 0,
            child: Center(
              child: GestureDetector(
                onTap: () => Get.toNamed('/add_recipe'),
                child: Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.yellow[700],
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 5,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Icon(
                    Icons.add,
                    size: 36,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem(IconData icon, int index) {
    final isSelected = currentIndex == index;

    return GestureDetector(
      onTap: () => _onItemTapped(index),
      child: Container(
        width: 50,
        height: 50,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 26,
              color: isSelected ? AppTheme.primary500 : Colors.grey[300],
            ),
          ],
        ),
      ),
    );
  }

  void _onItemTapped(int index) {
    if (currentIndex == index) return;

    try {
      switch (index) {
        case 0:
          Get.toNamed('/home');
          break;
        case 1:
          Get.toNamed('/search');
          break;
        case 3:
          Get.toNamed('/saved');
          break;
        case 4:
          Get.toNamed('/profile');
          break;
      }
    } catch (e) {
      print('Navigation error: $e');
      Get.snackbar(
        'Lỗi',
        'Không thể chuyển đến trang này',
        snackPosition: SnackPosition.BOTTOM,
        duration: Duration(seconds: 2),
      );
    }
  }
}
