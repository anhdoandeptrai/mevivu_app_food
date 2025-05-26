import 'package:flutter/material.dart';

class ContentWrapper extends StatelessWidget {
  final Widget child;

  const ContentWrapper({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      // Thêm padding bottom để tránh bị che khuất bởi phần lõm
      padding: EdgeInsets.only(bottom: 80),
      child: child,
    );
  }
}
