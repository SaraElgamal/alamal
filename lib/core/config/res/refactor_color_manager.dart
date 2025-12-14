// ignore_for_file: prefer_const_constructors, non_constant_identifier_names

import 'package:charity_app/core/config/res/color_manager.dart';
import 'package:flutter/material.dart';

@immutable
class AppColorsExtension extends ThemeExtension<AppColorsExtension> {
  final Color primary;
  final Color primary5;
  final Color secondary;
  final Color primaryLightPrimarydark;
  final Color background;
  final Color scaffoldBackground;
  final Color error;
  final Color red50;
  final Color success;
  final Color text;
  final Color error10;
  final Color successECFDF3;
  final Color success60;
  final Color disabled;
  final Color disabledTextFeiledColor;
  final Color card;
  final Color cardPrimary;
  final Color border;
  final Color divider;
  final Color hintText;
  final Color textFieldBorder;
  final Color whiteBtn;
  final Color deleteButton;
  final Color cancelButtonInSavedAddresses;
  final Color addAddressCard;
  final Color lightPrimaryDarkWhite;
  final Color lightcardDarkWhite;
  final Color lightWhiteDarkPrimary;
  final Color textSubtle;
  final Color textDisabled;
  final Color transparent;
  final Color white;
  final Color whiteF4F5F6;
  final Color black;
  final Color grey;
  final Color amber;
  final Color red;
  final Color actionSecondaryColor;

  final Color black100;
  final Color black90;
  final Color black80;
  final Color black70;
  final Color black60;
  final Color black50;
  final Color black40;
  final Color black30;
  final Color black20;
  final Color black10;
  final Color black5;
  final Color black1;

  final Color toastSuccess;
  final Color toastError;
  final Color toastBackGroundError;

  const AppColorsExtension({
    required this.primary,
    required this.primary5,
    required this.primaryLightPrimarydark,
    required this.secondary,
    required this.background,
    required this.red50,
    required this.scaffoldBackground,
    required this.error,
    required this.success,
    required this.text,
    required this.error10,
    required this.successECFDF3,
    required this.success60,
    required this.disabled,
    required this.disabledTextFeiledColor,
    required this.card,
    required this.cardPrimary,
    required this.border,
    required this.divider,
    required this.hintText,
    required this.textFieldBorder,
    required this.whiteBtn,
    required this.deleteButton,
    required this.cancelButtonInSavedAddresses,
    required this.addAddressCard,
    required this.lightPrimaryDarkWhite,
    required this.lightcardDarkWhite,
    required this.lightWhiteDarkPrimary,
    required this.textSubtle,
    required this.textDisabled,
    required this.transparent,
    required this.white,
    required this.whiteF4F5F6,
    required this.black,
    required this.grey,
    required this.amber,
    required this.red,
    required this.actionSecondaryColor,
    required this.black100,
    required this.black90,
    required this.black80,
    required this.black70,
    required this.black60,
    required this.black50,
    required this.black40,
    required this.black30,
    required this.black20,
    required this.black10,
    required this.black5,
    required this.black1,
    required this.toastSuccess,
    required this.toastError,
    required this.toastBackGroundError,
  });

  @override
  AppColorsExtension copyWith({
    Color? primary,
    Color? primary5,
    Color? secondary,
    Color? background,
    Color? error,
    Color? success,
    Color? red50,
    Color? primaryLightPrimarydark,
    Color? text,
    Color? error10,
    Color? successECFDF3,
    Color? success60,
    Color? disabled,
    Color? disabledTextFeiledColor,
    Color? card,
    Color? cardPrimary,
    Color? border,
    Color? divider,
    Color? hintText,
    Color? textFieldBorder,
    Color? whiteBtn,
    Color? deleteButton,
    Color? cancelButtonInSavedAddresses,
    Color? addAddressCard,
    Color? iconDefaultAddress,
    Color? cardDefaultAddress,
    Color? textInverse,
    Color? textSubtle,
    Color? textDisabled,
    Color? transparent,
    Color? white,
    Color? whiteF4F5F6,
    Color? black,
    Color? grey,
    Color? amber,
    Color? red,
    Color? actionSecondaryColor,
    Color? black100,
    Color? black90,
    Color? black80,
    Color? black70,
    Color? black60,
    Color? black50,
    Color? black40,
    Color? black30,
    Color? black20,
    Color? black10,
    Color? black5,
    Color? scaffoldBackground,
    Color? black1,
    Color? toastSuccess,
    Color? toastError,
    Color? toastBackGroundError,
  }) {
    return AppColorsExtension(
      primary: primary ?? this.primary,
      red50: red50 ?? this.red50,
      primaryLightPrimarydark:
          primaryLightPrimarydark ?? this.primaryLightPrimarydark,
      primary5: primary5 ?? this.primary5,
      secondary: secondary ?? this.secondary,
      background: background ?? this.background,
      scaffoldBackground: scaffoldBackground ?? this.scaffoldBackground,
      error: error ?? this.error,
      success: success ?? this.success,
      text: text ?? this.text,
      error10: error10 ?? this.error10,
      successECFDF3: successECFDF3 ?? this.successECFDF3,
      success60: success60 ?? this.success60,
      disabled: disabled ?? this.disabled,
      disabledTextFeiledColor:
          disabledTextFeiledColor ?? this.disabledTextFeiledColor,
      card: card ?? this.card,
      cardPrimary: cardPrimary ?? this.cardPrimary,
      border: border ?? this.border,
      divider: divider ?? this.divider,
      hintText: hintText ?? this.hintText,
      textFieldBorder: textFieldBorder ?? this.textFieldBorder,
      whiteBtn: whiteBtn ?? this.whiteBtn,
      deleteButton: deleteButton ?? this.deleteButton,
      cancelButtonInSavedAddresses:
          cancelButtonInSavedAddresses ?? this.cancelButtonInSavedAddresses,
      addAddressCard: addAddressCard ?? this.addAddressCard,
      lightPrimaryDarkWhite: iconDefaultAddress ?? lightPrimaryDarkWhite,
      lightcardDarkWhite: cardDefaultAddress ?? lightcardDarkWhite,
      lightWhiteDarkPrimary: textInverse ?? lightWhiteDarkPrimary,
      textSubtle: textSubtle ?? this.textSubtle,
      textDisabled: textDisabled ?? this.textDisabled,
      transparent: transparent ?? this.transparent,
      white: white ?? this.white,
      whiteF4F5F6: whiteF4F5F6 ?? this.whiteF4F5F6,
      black: black ?? this.black,
      grey: grey ?? this.grey,
      amber: amber ?? this.amber,
      red: red ?? this.red,
      actionSecondaryColor: actionSecondaryColor ?? this.actionSecondaryColor,
      black100: black100 ?? this.black100,
      black90: black90 ?? this.black90,
      black80: black80 ?? this.black80,
      black70: black70 ?? this.black70,
      black60: black60 ?? this.black60,
      black50: black50 ?? this.black50,
      black40: black40 ?? this.black40,
      black30: black30 ?? this.black30,
      black20: black20 ?? this.black20,
      black10: black10 ?? this.black10,
      black5: black5 ?? this.black5,
      black1: black1 ?? this.black1,
      toastSuccess: toastSuccess ?? this.toastSuccess,
      toastError: toastError ?? this.toastError,
      toastBackGroundError: toastBackGroundError ?? this.toastBackGroundError,
    );
  }

  @override
  AppColorsExtension lerp(ThemeExtension<AppColorsExtension>? other, double t) {
    if (other is! AppColorsExtension) {
      return this;
    }
    return AppColorsExtension(
      primary: Color.lerp(primary, other.primary, t)!,
      primary5: Color.lerp(primary5, other.primary5, t)!,
      secondary: Color.lerp(secondary, other.secondary, t)!,
      primaryLightPrimarydark: Color.lerp(
        primaryLightPrimarydark,
        other.primaryLightPrimarydark,
        t,
      )!,
      red50: Color.lerp(red50, other.red50, t)!,
      background: Color.lerp(background, other.background, t)!,
      error: Color.lerp(error, other.error, t)!,
      success: Color.lerp(success, other.success, t)!,
      scaffoldBackground: Color.lerp(
        scaffoldBackground,
        other.scaffoldBackground,
        t,
      )!,
      text: Color.lerp(text, other.text, t)!,
      error10: Color.lerp(error10, other.error10, t)!,
      successECFDF3: Color.lerp(successECFDF3, other.successECFDF3, t)!,
      success60: Color.lerp(success60, other.success60, t)!,
      disabled: Color.lerp(disabled, other.disabled, t)!,
      disabledTextFeiledColor: Color.lerp(
        disabledTextFeiledColor,
        other.disabledTextFeiledColor,
        t,
      )!,
      card: Color.lerp(card, other.card, t)!,
      cardPrimary: Color.lerp(cardPrimary, other.cardPrimary, t)!,
      border: Color.lerp(border, other.border, t)!,
      divider: Color.lerp(divider, other.divider, t)!,
      hintText: Color.lerp(hintText, other.hintText, t)!,
      textFieldBorder: Color.lerp(textFieldBorder, other.textFieldBorder, t)!,
      whiteBtn: Color.lerp(whiteBtn, other.whiteBtn, t)!,
      deleteButton: Color.lerp(deleteButton, other.deleteButton, t)!,
      cancelButtonInSavedAddresses: Color.lerp(
        cancelButtonInSavedAddresses,
        other.cancelButtonInSavedAddresses,
        t,
      )!,
      addAddressCard: Color.lerp(addAddressCard, other.addAddressCard, t)!,
      lightPrimaryDarkWhite: Color.lerp(
        lightPrimaryDarkWhite,
        other.lightPrimaryDarkWhite,
        t,
      )!,
      lightcardDarkWhite: Color.lerp(
        lightcardDarkWhite,
        other.lightcardDarkWhite,
        t,
      )!,
      lightWhiteDarkPrimary: Color.lerp(
        lightWhiteDarkPrimary,
        other.lightWhiteDarkPrimary,
        t,
      )!,
      textSubtle: Color.lerp(textSubtle, other.textSubtle, t)!,
      textDisabled: Color.lerp(textDisabled, other.textDisabled, t)!,
      transparent: Color.lerp(transparent, other.transparent, t)!,
      white: Color.lerp(white, other.white, t)!,
      whiteF4F5F6: Color.lerp(whiteF4F5F6, other.whiteF4F5F6, t)!,
      black: Color.lerp(black, other.black, t)!,
      grey: Color.lerp(grey, other.grey, t)!,
      amber: Color.lerp(amber, other.amber, t)!,
      red: Color.lerp(red, other.red, t)!,
      actionSecondaryColor: Color.lerp(
        actionSecondaryColor,
        other.actionSecondaryColor,
        t,
      )!,
      black100: Color.lerp(black100, other.black100, t)!,
      black90: Color.lerp(black90, other.black90, t)!,
      black80: Color.lerp(black80, other.black80, t)!,
      black70: Color.lerp(black70, other.black70, t)!,
      black60: Color.lerp(black60, other.black60, t)!,
      black50: Color.lerp(black50, other.black50, t)!,
      black40: Color.lerp(black40, other.black40, t)!,
      black30: Color.lerp(black30, other.black30, t)!,
      black20: Color.lerp(black20, other.black20, t)!,
      black10: Color.lerp(black10, other.black10, t)!,
      black5: Color.lerp(black5, other.black5, t)!,
      black1: Color.lerp(black1, other.black1, t)!,
      toastSuccess: Color.lerp(toastSuccess, other.toastSuccess, t)!,
      toastError: Color.lerp(toastError, other.toastError, t)!,
      toastBackGroundError: Color.lerp(
        toastBackGroundError,
        other.toastBackGroundError,
        t,
      )!,
    );
  }
}

const AppColorsExtension lightColors = AppColorsExtension(
  primary: Color(0xff41ab5d),
  primary5: Color(0xffC9F1D4), // Lighter Green
  primaryLightPrimarydark: Color(0xff5DBD80), // Darker Green
  scaffoldBackground: AppColors.lightGrey,
  secondary: AppColors.secondary,
  background: AppColors.scaffoldBackground,
  error: AppColors.error,
  red50: AppColors.error10,
  success: AppColors.success,
  text: AppColors.black,

  error10: AppColors.error10,
  successECFDF3: AppColors.successECFDF3,
  success60: AppColors.success60,
  disabled: AppColors.black30,
  disabledTextFeiledColor: AppColors.disabledTextFeiledColor,
  card: AppColors.card,
  cardPrimary: Color(0xff5DBD80), // Darker Green
  border: AppColors.black10,
  divider: AppColors.black5,
  hintText: AppColors.hintText,
  textFieldBorder: AppColors.textFieldBorder,
  whiteBtn: AppColors.white,
  deleteButton: AppColors.error,
  cancelButtonInSavedAddresses: AppColors.black60,
  addAddressCard: AppColors.grey,
  lightPrimaryDarkWhite: AppColors.primary,
  lightcardDarkWhite: AppColors.card,
  lightWhiteDarkPrimary: AppColors.white,
  textSubtle: AppColors.black50,
  textDisabled: AppColors.black30,
  transparent: AppColors.transparent,
  white: AppColors.white,
  whiteF4F5F6: AppColors.whiteF4F5F6,
  black: AppColors.black,
  grey: AppColors.grey,
  amber: AppColors.amber,
  red: AppColors.red,
  actionSecondaryColor: AppColors.actionSecondaryColor,
  black100: AppColors.black100,
  black90: AppColors.black90,
  black80: AppColors.black80,
  black70: AppColors.black70,
  black60: AppColors.black60,
  black50: AppColors.black50,
  black40: AppColors.black40,
  black30: AppColors.black30,
  black20: AppColors.black20,
  black10: AppColors.black10,
  black5: AppColors.black5,
  black1: AppColors.black1,
  toastSuccess: AppColors.success,
  toastError: AppColors.error,
  toastBackGroundError: AppColors.error10,
);

const AppColorsExtension darkColors = AppColorsExtension(
  primary: AppColors.primary,
  primary5: Color(0xff2E5C3E), // Dark Green
  secondary: Color(0xffB3CEE7),
  red50: AppColors.red50,
  background: Color(0xff0F172A),
  error: AppColors.error,
  scaffoldBackground: Color(0xff0B1120),
  success: AppColors.success,
  primaryLightPrimarydark: AppColors.primary,
  text: AppColors.primary50,
  error10: Color(0xff3B1A21),
  successECFDF3: AppColors.green00,
  success60: AppColors.white,
  disabled: Color(0xff1F2937),
  disabledTextFeiledColor: Color(0xff243047),
  card: Color(0xff1F2937),
  cardPrimary: Color(0xff2E5C3E), // Dark Green
  border: AppColors.transparent,
  //border: Color(0xff2A3547),
  divider: Color(0xff1C2534),
  hintText: Color(0xff8A93A7),
  textFieldBorder: Color(0xff293342),
  whiteBtn: Color(0xff1C2534),
  deleteButton: AppColors.white,
  cancelButtonInSavedAddresses: Color(0xffCBD5F5),
  addAddressCard: Color(0xff1F2937),
  lightPrimaryDarkWhite: AppColors.white,
  lightcardDarkWhite: AppColors.white,
  lightWhiteDarkPrimary: AppColors.primary,
  textSubtle: Color(0xffB0B9CD),
  textDisabled: AppColors.black30,
  transparent: AppColors.transparent,
  white: AppColors.white,
  whiteF4F5F6: Color(0xff1C2534),
  black: Color(0xff05070B),
  grey: Color(0xff152032),
  amber: AppColors.amber,
  red: AppColors.red,
  actionSecondaryColor: Color(0xff172033),
  black100: AppColors.black100,
  black90: AppColors.black90,
  black80: AppColors.black80,
  black70: AppColors.black70,
  black60: AppColors.black60,
  black50: AppColors.black50,
  black40: AppColors.black40,
  black30: AppColors.black30,
  black20: AppColors.black20,
  black10: AppColors.black10,
  black5: AppColors.black5,
  black1: AppColors.black1,
  toastSuccess: AppColors.success,
  toastError: AppColors.error,
  toastBackGroundError: Color(0xff3B1A21),
);
