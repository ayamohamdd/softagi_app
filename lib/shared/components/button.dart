

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
  FontWeight fontWeight=FontWeight.bold,
  double fontSize=18.0,
  Color color=AppColors.buttonColor,
  Color textColor=AppColors.fontColor,

})=> Container(
  width: width,
  height: height,
  decoration: BoxDecoration(
    borderRadius: BorderRadius.circular(radius),
    color: color,
  ),
  child: MaterialButton(
    onPressed: onPressed,
    child:  Text(
      isUpperCase? text.toUpperCase():text,
      style:  TextStyle(
        color: textColor,
        fontWeight:fontWeight,
        fontSize: fontSize,
      ),
    ),
  ),
);
