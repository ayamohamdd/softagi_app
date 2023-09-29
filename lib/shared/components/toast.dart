import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../constants/colors.dart';

void defaultToast({
  required String message,
  required ToastState state,
}) =>
    Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 5,
        backgroundColor: chooseToastColor(state),
        textColor: AppColors.backgroundColor,
        fontSize: 16.0);

// ignore: constant_identifier_names
enum ToastState { SUCCESS, ERROR, WARNING }

Color chooseToastColor(ToastState state) {
  Color? color;
  switch (state) {
    case ToastState.SUCCESS:
      color = AppColors.successColor;
      break;
    case ToastState.ERROR:
      color = AppColors.errorColor;
      break;
    case ToastState.WARNING:
      color = AppColors.warningColor;
      break;
  }
  return color;
}
