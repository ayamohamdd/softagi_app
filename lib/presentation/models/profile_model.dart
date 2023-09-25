import 'package:flutter/material.dart';

class SettingsModel {
  IconData icon;
  String settingName;
  IconData arrow = Icons.arrow_forward_ios;
  Widget? navigateWidget;
  SettingsModel({
    required this.icon,
    required this.settingName,
     this.navigateWidget
  });
}
