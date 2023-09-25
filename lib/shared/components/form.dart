import 'package:flutter/material.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:store_app/shared/constants/colors.dart';
import 'package:intl_phone_field/intl_phone_field.dart';


Widget defaultFormField({
  required TextEditingController controller,
  required TextInputType type,
  void Function(String x)? onSubmit,
  void Function(String x)? onChange,
  void Function()? onTap,
  bool isPassword = false,
  final String? Function(String?)? validate,
  String? errorText,
  required String label,
  String? initVal,
  IconData? prefix,
  IconData? suffix,
  void Function()? suffixPressed,
  bool isClickable = true,
  double contentLeftPadding = 20,
  double contentRightPadding = 20,
  Color formColor = AppColors.containerColor,
  Color suffixColor = AppColors.buttonColor,

}) =>
    TextFormField(
      controller: controller,
      keyboardType: type,
      obscureText: isPassword,
      onFieldSubmitted: onSubmit,
      onChanged: onChange,
      onTap: onTap,
      initialValue: initVal,
      enabled: isClickable,
      validator: validate,
      decoration: InputDecoration(
        errorMaxLines: 2,
        enabled: true,
        filled: true,
        fillColor: formColor ,
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(
            width: 1,
            color: AppColors.elevColor,
          ),
          borderRadius: BorderRadius.circular(50.0),
        ),
        hintText: label,
        //labelText: label,
        prefixIcon: Icon(prefix,color: AppColors.buttonColor,),
        suffixIcon: suffix != null
            ? IconButton(
                onPressed: suffixPressed,
                icon: Icon(
                  suffix,
                  color: suffixColor,
                ),
              )
            : null,
        contentPadding: EdgeInsets.only(left: contentLeftPadding, right: contentRightPadding),
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(
            width: 0.3,
            color: AppColors.elevColor,
          ),
          borderRadius: BorderRadius.circular(20.0),
        ),
        border: OutlineInputBorder(
          borderSide: const BorderSide(
            width: 1,
            color: AppColors.elevColor,
          ),
          borderRadius: BorderRadius.circular(50.0),
        ),
      ),
    );

Widget defaultPhoneFormField({
  required String label,
  required Function onChangeMethod,
  required TextEditingController phoneController,
  final double bottomPadding = 0,
  final double leftPadding = 30,
  final double rightPadding = 0,
  final double topPadding = 0,
  PhoneInputSelectorType selectorType = PhoneInputSelectorType.BOTTOM_SHEET,
  Color? cursorColor,
  bool format = false,
  PhoneNumber? phoneNumber,

}) =>
    IntlPhoneField(
      
      controller: phoneController,
      decoration: InputDecoration(
        filled: true,
        fillColor: AppColors.formColor,
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(
            width: 1,
            color: AppColors.elevColor,
          ),
          borderRadius: BorderRadius.circular(50.0),
        ),
        hintText: label,
        contentPadding: EdgeInsets.only(left:leftPadding),
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(
            width: 0.3,
            color: AppColors.elevColor,
          ),
          borderRadius: BorderRadius.circular(20.0),
        ),
        border: OutlineInputBorder(
          borderSide: const BorderSide(
            width: 1,
            color: AppColors.elevColor,
          ),
          borderRadius: BorderRadius.circular(50.0),
        ),
      ),
      initialCountryCode: 'EG',
      //showDropdownIcon: true,
      dropdownIconPosition: IconPosition.trailing,
      flagsButtonPadding: EdgeInsets.only(left: leftPadding),
    );
