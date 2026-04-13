import 'package:flutter/material.dart';

class CustomLoader extends StatelessWidget {
  final Color color;
  final double size;
  final double strokeWidth;

  const CustomLoader({
    super.key,
    this.color = Colors.green,
    this.size = 24,
    this.strokeWidth = 3,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: size,
      width: size,
      child: CircularProgressIndicator(color: color, strokeWidth: strokeWidth),
    );
  }
}
