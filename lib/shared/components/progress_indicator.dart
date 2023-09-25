import 'package:flutter/material.dart';
import 'package:store_app/shared/constants/colors.dart';

Widget defaultCircularProgressIndicator() => const Center(
      child: CircularProgressIndicator(
        color: AppColors.buttonColor,
      ),
    );

Widget defaultLinearProgressIndicator() => const Center(
      child: LinearProgressIndicator(
        minHeight: 5,
        valueColor: AlwaysStoppedAnimation<Color>(AppColors.buttonColor),
        backgroundColor: AppColors.containerColor,
      ),
    );
