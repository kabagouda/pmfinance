import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'app_text_styles.dart';
import 'size_utils.dart';

class AppButtons {
  static Widget primaryButton(
          {required String text,
          required Function()? onPressed,
          // bool? isOutlined = false,
          double? width,
          bool maxSize = false,
          bool maxtextSize = false,
          double? verticalPadding,
          double? borderRadius,
          Color? color,
          Color? textColor,
          EdgeInsets? margin}) =>
      Align(
        alignment: Alignment.bottomCenter,
        child: Container(
          width: maxSize ? width ?? double.infinity : null,
          margin: margin ??
              EdgeInsets.only(
                bottom: getVerticalSize(10),
              ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: TextButton(
              onPressed: onPressed,
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.resolveWith<Color>(
                    (Set<MaterialState> states) => states.contains(MaterialState.disabled)
                        ? AppColors.grey
                        : color != null
                            ? (color)
                            : AppColors.primaryColor),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(borderRadius ?? 10),
                  ),
                ),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: verticalPadding ?? 10),
                child: Text(text,
                    style: TextStyle(
                      color: textColor ?? AppColors.white,
                      fontSize: maxtextSize ? getFontSize(24) : getFontSize(20),
                      fontWeight: FontWeight.w600,
                    )),
              ),
            ),
          ),
        ),
      );

  static Widget skipButton({required void Function() onTap}) {
    return InkWell(
      onTap: onTap,
      child: Align(
        alignment: Alignment.center,
        child: Padding(
          padding: EdgeInsets.only(bottom: getVerticalSize(10)),
          child: Text(
            'passer',
            style: AppTextStyles.skipTextStyle(),
          ),
        ),
      ),
    );
  }

  static Widget socialLoginButton({required String text, required String logo, void Function()? onPressed}) =>
      OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          fixedSize: Size.fromHeight(getVerticalSize(50)),
          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              logo,
              height: getVerticalSize(24),
              width: getHorizontalSize(24),
            ),
            SizedBox(
              width: getHorizontalSize(10),
            ),
            Text(
              text,
              style: TextStyle(
                fontSize: getFontSize(18),
                fontWeight: FontWeight.w400,
                color: AppColors.black,
              ),
            ),
          ],
        ),
      );
  // text button
  static Widget textButton(
      {required String text,
      Widget? actions,
      void Function()? onPressed,
      bool? underlined,
      TextStyle? textStyle,
      Color? color}) {
    underlined = underlined ?? false;
    return TextButton(
      onPressed: onPressed,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            text,
            style: textStyle ??
                TextStyle(
                    color: color ?? AppColors.primary,
                    fontSize: getFontSize(15),
                    fontWeight: FontWeight.w600,
                    decoration: underlined ? TextDecoration.underline : null),
          ),
          if (actions != null) ...[
            SizedBox(
              width: getHorizontalSize(10),
            ),
            actions
          ]
        ],
      ),
    );
  }

  // outline button
  static Widget outlineButton(
      {required String text,
      void Function()? onPressed,
      double? borderRadius,
      Color? color,
      double? width,
      double? height}) {
    return SizedBox(
      width: width ?? getHorizontalSize(140),
      height: height ?? getVerticalSize(40),
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          side: BorderSide(color: color ?? AppColors.primaryColor),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius ?? 5),
          ),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: Colors.blue,
            fontSize: getFontSize(15),
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
