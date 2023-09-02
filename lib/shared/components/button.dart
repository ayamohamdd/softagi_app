

import 'package:flutter/material.dart';
import 'package:store_app/shared/constants/colors.dart';

Widget defaultButton({
  double width = double.infinity,
  double height = 50.0,
  Color? background = Colors.indigo,
  bool isUpperCase=true,
  double radius=10.0,
  required void Function() onPressed,
  required String text,
})=> Container(
  width: width,
  height: height,
  decoration: BoxDecoration(
    borderRadius: BorderRadius.circular(radius),
    color: AppColors.buttonColor,
  ),
  child: MaterialButton(
    onPressed: onPressed,
    child:  Text(
      isUpperCase? text.toUpperCase():text,
      style: const TextStyle(
        color: AppColors.backgroundColor,
        fontWeight:FontWeight.bold,
        fontSize: 18.0,
      ),
    ),
  ),
);
