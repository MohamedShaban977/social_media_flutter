import 'package:flutter/material.dart';
import 'package:hauui_flutter/core/constants/app_colors.dart';
import 'package:hauui_flutter/core/constants/app_dimens.dart';
import 'package:hauui_flutter/core/constants/app_fonts.dart';

class TextStyleManager {
  TextStyleManager._();

  static TextStyle _base({
    required FontWeight fontWeight,
    double? size,
    Color? color,
    TextDecoration? textDecoration,
    Color? decorationColor,
  }) =>
      TextStyle(
        fontFamily: AppFonts.fontFamily,
        fontWeight: fontWeight,
        fontSize: size ?? AppDimens.textSize16pt,
        decoration: textDecoration ?? TextDecoration.none,
        decorationColor: decorationColor ?? AppColors.veryDarkGrayishBlue,
        color: color ?? AppColors.veryDarkGrayishBlue,
        height: 1.2,
      );

  static TextStyle extraLight({
    double? size,
    Color? color,
    TextDecoration? textDecoration,
    Color? decorationColor,
  }) =>
      _base(
        fontWeight: FontWeight.w200,
        size: size,
        color: color,
        textDecoration: textDecoration,
        decorationColor: decorationColor,
      );

  static TextStyle light({
    double? size,
    Color? color,
    TextDecoration? textDecoration,
    Color? decorationColor,
  }) =>
      _base(
        fontWeight: FontWeight.w300,
        size: size,
        color: color,
        textDecoration: textDecoration,
        decorationColor: decorationColor,
      );

  static TextStyle regular({
    double? size,
    Color? color,
    TextDecoration? textDecoration,
    Color? decorationColor,
  }) =>
      _base(
        fontWeight: FontWeight.w400,
        size: size,
        color: color,
        textDecoration: textDecoration,
        decorationColor: decorationColor,
      );

  static TextStyle medium({
    double? size,
    Color? color,
    TextDecoration? textDecoration,
    Color? decorationColor,
  }) =>
      _base(
        fontWeight: FontWeight.w500,
        size: size,
        color: color,
        textDecoration: textDecoration,
        decorationColor: decorationColor,
      );

  static TextStyle semiBold({
    double? size,
    Color? color,
    TextDecoration? textDecoration,
    Color? decorationColor,
  }) =>
      _base(
        fontWeight: FontWeight.w600,
        size: size,
        color: color,
        textDecoration: textDecoration,
        decorationColor: decorationColor,
      );

  static TextStyle bold({
    double? size,
    Color? color,
    TextDecoration? textDecoration,
    Color? decorationColor,
  }) =>
      _base(
        fontWeight: FontWeight.w700,
        size: size,
        color: color,
        textDecoration: textDecoration,
        decorationColor: decorationColor,
      );

  static TextStyle extraBold({
    double? size,
    Color? color,
    TextDecoration? textDecoration,
    Color? decorationColor,
  }) =>
      _base(
        fontWeight: FontWeight.w800,
        size: size,
        color: color,
        textDecoration: textDecoration,
        decorationColor: decorationColor,
      );

  static TextStyle black({
    double? size,
    Color? color,
    TextDecoration? textDecoration,
    Color? decorationColor,
  }) =>
      _base(
        fontWeight: FontWeight.w900,
        size: size,
        color: color,
        textDecoration: textDecoration,
        decorationColor: decorationColor,
      );
}
