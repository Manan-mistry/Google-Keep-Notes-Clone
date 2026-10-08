import 'package:keeps_note_clone/utils/color.dart';
import 'package:flutter/material.dart';


class CustomTheme {
  static ThemeData get lightTheme { //1
    return ThemeData(
        scaffoldBackgroundColor: AppColor.bgColor,
        fontFamily: 'Poppins',
        brightness: Brightness.light,
        primaryColor: AppColor.black,
        appBarTheme:  AppBarTheme(
          backgroundColor: AppColor.bgColor,
          titleTextStyle: CustomTheme.primaryTextStyle,
          iconTheme: const IconThemeData(color: AppColor.white),
          surfaceTintColor: AppColor.black,
        ),
        floatingActionButtonTheme: const FloatingActionButtonThemeData (
            backgroundColor: AppColor.bgColor,
            foregroundColor: AppColor.white
        )
    );
  }

  static ButtonStyle get primaryButton {
    return TextButton.styleFrom(
      textStyle: CustomTheme.primaryTextStyle,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      foregroundColor: AppColor.white,
      backgroundColor: AppColor.cardColor,
    );
  }

  static ButtonStyle get secondaryButton {
    return TextButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        textStyle: CustomTheme.secondaryTextStyle,
        foregroundColor: AppColor.white,
        backgroundColor: AppColor.cardColor
    );
  }

  static TextStyle get primaryTextStyle {
    return const TextStyle(
        color: AppColor.white,
        fontSize: 16,
        fontWeight: FontWeight.w600,
        fontStyle: FontStyle.normal
    );
  }

  static TextStyle get secondaryTextStyle {
    return TextStyle(
        color: AppColor.white.withOpacity(0.7),
        fontSize: 16,
        fontWeight: FontWeight.w600,
        fontStyle: FontStyle.normal
    );
  }


}

class CustomText extends Text {
  const CustomText(
      super.data, {
        super.key,
        TextStyle? style,
        super.textAlign,
        super.textDirection,
        super.softWrap,
        super.overflow,
        super.maxLines,
        super.semanticsLabel,
      }) : super(
    style: style ?? const TextStyle(
      fontSize: 18.0,
      color: Colors.white,
      fontWeight: FontWeight.w500,
    ),
  );
}
