import 'package:flutter/material.dart';

import '../../shared/constants/colors.dart';

class ProductDetailsScreen extends StatelessWidget {
  const ProductDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text(
        'Settings',
        style:
            TextStyle(color: AppColors.fontColor, fontWeight: FontWeight.bold),
        textAlign: TextAlign.center,
      )),
    );
  }
}
