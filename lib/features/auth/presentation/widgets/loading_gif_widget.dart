import 'package:flutter/material.dart';
import 'package:nodelabs_shartflix/core/constants/app_colors.dart';

class LoadingGifWidget extends StatelessWidget {
  final double width;
  final double height;
  final Color? color;

  const LoadingGifWidget({
    super.key,
    this.width = 100,
    this.height = 100,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      'assets/animations/Film.gif',
      width: width,
      height: height,
      color:color ?? AppColors.red,
      fit: BoxFit.contain,
    );
  }
}
