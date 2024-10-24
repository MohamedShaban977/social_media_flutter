import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hauui_flutter/core/constants/app_colors.dart';

import '/core/constants/app_dimens.dart';
import '/core/constants/app_fonts.dart';

class ThemeManager {
  ThemeManager._();

  static ThemeData getThemeData() => ThemeData(
        colorScheme: ColorScheme.fromSwatch().copyWith(
          primary: AppColors.primary,
        ),
        fontFamily: AppFonts.fontFamily,
        scaffoldBackgroundColor: AppColors.scaffoldBackgroundColor,
        appBarTheme: _getAppBarTheme(),

        /// In Material 3, If local text style is not set, Flutter uses bodyLarge
        /// style as a default for the input style.
        textTheme: const TextTheme(
          bodyLarge: TextStyle(
            fontSize: AppDimens.textSize14pt,
            fontWeight: FontWeight.w500,
            color: AppColors.veryDarkGrayishBlue,
          ),
        ),
        elevatedButtonTheme: _getElevatedButtonTheme(),
        outlinedButtonTheme: _getOutlinedButtonTheme(),
        textButtonTheme: _getTextButtonTheme(),
        inputDecorationTheme: _getInputDecorationTheme(),
        checkboxTheme: _getCheckBoxTheme(),
        radioTheme: _getRadioThemeData(),
        switchTheme: _getSwitchThemeData(),
      );

  static AppBarTheme _getAppBarTheme() => ThemeData.light().appBarTheme.copyWith(
        foregroundColor: AppColors.veryDarkGrayishBlue,
        backgroundColor: AppColors.transparent,
        centerTitle: true,
        elevation: 0,
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        titleTextStyle: const TextStyle(
          fontFamily: AppFonts.fontFamily,
          fontSize: AppDimens.textSize16pt,
          fontWeight: FontWeight.w500,
          color: AppColors.veryDarkGrayishBlue,
        ),
      );

  static ElevatedButtonThemeData _getElevatedButtonTheme() => ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          foregroundColor: AppColors.white,
          backgroundColor: AppColors.vividPink,
          disabledForegroundColor: AppColors.white,
          disabledBackgroundColor: AppColors.lightGrayishBlue2,
          textStyle: const TextStyle(
            fontFamily: AppFonts.fontFamily,
            fontSize: AppDimens.textSize18pt,
            fontWeight: FontWeight.w600,
            color: AppColors.white,
          ),
          shape: RoundedRectangleBorder(
            side: const BorderSide(
              width: AppDimens.borderWidth1pt,
              color: AppColors.transparent,
            ),
            borderRadius: BorderRadius.circular(
              AppDimens.cornerRadius4pt,
            ),
          ),
          padding: const EdgeInsetsDirectional.symmetric(
            horizontal: AppDimens.spacingNormal,
            vertical: AppDimens.spacingNormal,
          ),
        ),
      );

  static OutlinedButtonThemeData _getOutlinedButtonTheme() => OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.veryDarkGrayishBlue,
          // disabledForegroundColor: AppColors.,
          textStyle: const TextStyle(
            fontFamily: AppFonts.fontFamily,
            fontSize: AppDimens.textSize18pt,
            fontWeight: FontWeight.w600,
          ),
          side: const BorderSide(
            width: AppDimens.borderWidth1pt,
            color: AppColors.veryDarkGrayishBlue,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
              AppDimens.cornerRadius4pt,
            ),
          ),
          padding: const EdgeInsetsDirectional.symmetric(
            horizontal: AppDimens.spacingNormal,
            vertical: AppDimens.spacingNormal,
          ),
        ),
      );

  static TextButtonThemeData _getTextButtonTheme() => TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.veryDarkGrayishBlue,
          disabledForegroundColor: AppColors.grayishBlue,
          textStyle: const TextStyle(
            fontFamily: AppFonts.fontFamily,
            fontSize: AppDimens.textSize12pt,
            fontWeight: FontWeight.w400,
          ),
        ),
      );

  static InputDecorationTheme _getInputDecorationTheme() => const InputDecorationTheme(
        hintStyle: TextStyle(
          fontFamily: AppFonts.fontFamily,
          fontSize: AppDimens.textSize14pt,
          fontWeight: FontWeight.w500,
          color: AppColors.lightGrayishBlue,
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
            width: AppDimens.borderWidth1pt,
            color: AppColors.lightGrayishBlue,
          ),
        ),
        disabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
            width: AppDimens.borderWidth1pt,
            color: AppColors.lightGrayishBlue,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderSide: BorderSide(
            width: AppDimens.borderWidth1pt,
            color: Colors.red,
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderSide: BorderSide(
            width: AppDimens.borderWidth1pt,
            color: Colors.red,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            width: AppDimens.borderWidth1pt,
            color: AppColors.lightGrayishBlue,
          ),
        ),
        outlineBorder: BorderSide(
          width: AppDimens.borderWidth1pt,
          color: AppColors.lightGrayishBlue,
        ),
        border: OutlineInputBorder(
          borderSide: BorderSide(
            width: AppDimens.borderWidth1pt,
            color: AppColors.lightGrayishBlue,
          ),
        ),
        errorStyle: TextStyle(
          height: AppDimens.zero,
        ),
        isDense: true,
        contentPadding: EdgeInsetsDirectional.all(
          AppDimens.spacingNormal,
        ),
        counterStyle: TextStyle(
          color: AppColors.veryDarkGrayishBlue,
        ),
      );

  static CheckboxThemeData _getCheckBoxTheme() => CheckboxThemeData(
        fillColor: MaterialStateProperty.all(
          AppColors.transparent,
        ),
        checkColor: MaterialStateProperty.all(
          AppColors.vividCyan,
        ),
        side: MaterialStateBorderSide.resolveWith(
          (states) {
            if (states.contains(MaterialState.selected)) {
              return const BorderSide(
                color: AppColors.vividCyan,
              );
            } else {
              return const BorderSide(
                color: AppColors.darkGrayishBlue,
              );
            }
          },
        ),
      );

  static RadioThemeData _getRadioThemeData() => RadioThemeData(
        fillColor: MaterialStateProperty.resolveWith<Color>(
          (Set<MaterialState> states) {
            if (states.contains(MaterialState.selected)) {
              return AppColors.vividPink;
            }
            return AppColors.darkGray;
          },
        ),
      );

  static SwitchThemeData _getSwitchThemeData() => SwitchThemeData(
        thumbColor: MaterialStateProperty.all(
          AppColors.white,
        ),
        trackColor: MaterialStateProperty.resolveWith(
          (states) => states.contains(MaterialState.selected) ? AppColors.primary : AppColors.darkGrayishBlue,
        ),
      );
}
