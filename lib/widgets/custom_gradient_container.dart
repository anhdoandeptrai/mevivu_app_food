import 'package:flutter/material.dart';
import 'package:mevivuapp/untils/app_theme.dart';

class CustomGradientContainer extends StatelessWidget {
  final Widget child;
  final double height;
  final double width;

  const CustomGradientContainer({
    Key? key,
    required this.child,
    this.height = 200,
    this.width = double.infinity,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            AppTheme.primary600, 
            AppTheme.primary500, 
          ],
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: child,
    );
  }
}
