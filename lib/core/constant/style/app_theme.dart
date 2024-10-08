import 'package:flutter/material.dart';

import 'app_colors.dart';
import 'app_text.dart';

class AppTheme {
  static ThemeData darkTheme = ThemeData().copyWith(
    scaffoldBackgroundColor: AppColors.primaryColor,
    appBarTheme: AppBarTheme(
      backgroundColor: AppColors.primaryColor,
      titleTextStyle: AppText.text20.copyWith(fontWeight: FontWeight.bold),
      foregroundColor: AppColors.primaryColor,
      surfaceTintColor: AppColors.primaryColor,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.all(5),
        backgroundColor: AppColors.primaryColor,
      ),
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: AppColors.primaryColor,
      type: BottomNavigationBarType.fixed,
      selectedItemColor: AppColors.whiteColor,
      selectedLabelStyle: AppText.text14.copyWith(fontWeight: FontWeight.bold),
      unselectedItemColor: AppColors.greyColor,
      unselectedLabelStyle: AppText.text14
          .copyWith(color: AppColors.greyColor, fontWeight: FontWeight.bold),
    ),
  );
}
