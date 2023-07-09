import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_colors.dart';
import 'size_utils.dart';

class AppTextStyles {
  static TextStyle title({Color? color, bool usePoppins = false, double? fontSize, FontWeight? fontWeight}) =>
      usePoppins
          ? GoogleFonts.poppins(
              color: color ?? AppColors.black,
              fontSize: fontSize ?? getFontSize(22),
              fontWeight: fontWeight ?? FontWeight.bold,
            )
          : TextStyle(
              color: color ?? AppColors.black,
              fontSize: fontSize ?? getFontSize(22),
              fontWeight: fontWeight ?? FontWeight.bold,
            );

  static TextStyle body({Color? color, double? fontSize, bool usePoppins = false, FontWeight? fontWeight}) => usePoppins
      ? GoogleFonts.poppins(
          fontSize: fontSize ?? getFontSize(15),
          fontWeight: fontWeight ?? FontWeight.w400,
          color: color ?? AppColors.black,
        )
      : TextStyle(
          fontSize: fontSize ?? getFontSize(15),
          fontWeight: fontWeight ?? FontWeight.w400,
          color: color ?? AppColors.black,
        );

  static TextStyle buttonTextStyle = TextStyle(
    color: AppColors.white,
    fontSize: getFontSize(20),
    fontWeight: FontWeight.w600,
  );

  static TextStyle hintTextStyle([Color? color]) => TextStyle(
        color: color ?? AppColors.hintColor,
        fontSize: getFontSize(16),
        fontWeight: FontWeight.w400,
      );

  static TextStyle skipTextStyle([Color? color]) => TextStyle(
        color: color ?? AppColors.darkGreyColor,
        fontSize: getFontSize(18),
        fontWeight: FontWeight.w600,
      );

  static TextStyle errorTextStyle = TextStyle(
    fontSize: getFontSize(13),
    color: AppColors.fromHex('#FF0000'),
    height: 0.5,
  );
}
