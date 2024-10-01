import 'package:flutter/material.dart';
import 'package:location_purge_maid_finder/presentation/resources/styles_manager.dart';
import 'package:location_purge_maid_finder/presentation/resources/values_manager.dart';


import 'color_manager.dart';
import 'font_manager.dart';

ThemeData getApplicationTheme() {
  return ThemeData(
      // main colors of the app
      primaryColor: ColorManager.surveyNameColor,
      primaryColorLight: ColorManager.primaryOpacity70,
      primaryColorDark: ColorManager.darkPrimary,
      disabledColor: ColorManager.disabledTextColor,

      //todo if you are getting everywhere transparent background then comment this
      // canvasColor: Colors.transparent,

      colorScheme:
          ColorScheme.fromSwatch().copyWith(secondary: ColorManager.grey),

      checkboxTheme: CheckboxThemeData(
          fillColor: MaterialStateProperty.all(ColorManager.surveysortBorderColor)),


      // card view theme
      cardTheme: CardTheme(
        color: ColorManager.white,
        shadowColor: ColorManager.grey,
        elevation: AppSize.s4,
      ),
      // App bar theme
      appBarTheme: AppBarTheme(
          centerTitle: true,
          color: ColorManager.primary,
          elevation: AppSize.s4,
          shadowColor: ColorManager.primaryOpacity70,
          titleTextStyle: getRegularStyle(
              color: ColorManager.white, fontSize: FontSize.s16)),
      // Button theme
      buttonTheme: ButtonThemeData(
          shape: const StadiumBorder(),
          disabledColor: ColorManager.grey1,
          buttonColor: ColorManager.primary,
          splashColor: ColorManager.primaryOpacity70),

      // elevated button theme
      elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
              textStyle: getRegularStyle(color: ColorManager.white),
              primary: ColorManager.avantisPink,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppSize.s18))
                  )),
      // Text theme
      textTheme: TextTheme(
          headline1: getSemiBoldStyle(
              color: ColorManager.darkGrey, fontSize: FontSize.s16),
          subtitle1: getMediumStyle(
              color: ColorManager.lightGrey, fontSize: FontSize.s14),
          caption: getRegularStyle(color: ColorManager.grey1),
          bodyText1: getRegularStyle(color: ColorManager.grey)),
      // input decoration theme (text form field)
      inputDecorationTheme: InputDecorationTheme(
        contentPadding: const EdgeInsets.symmetric(
            horizontal: AppPadding.p16, vertical: AppPadding.p12),
        // hint style
        hintStyle: getRegularStyle(color: ColorManager.grey1),

        // label style
        labelStyle: getMediumStyle(
            color: ColorManager.surveyNameColor, fontSize: FontSize.s12),
        // error style
        errorStyle: getRegularStyle(color: ColorManager.error),
        // enabled border
        enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
                color: ColorManager.textFieldBorderColor, width: AppSize.s1_5),
            borderRadius: const BorderRadius.all(Radius.circular(AppSize.s18))),

        // focused border
        focusedBorder: OutlineInputBorder(
            borderSide:
                BorderSide(color: ColorManager.primary, width: AppSize.s1_5),
            borderRadius: const BorderRadius.all(Radius.circular(AppSize.s8))),

        // error border
        errorBorder: OutlineInputBorder(
            borderSide:
                BorderSide(color: ColorManager.error, width: AppSize.s1_5),
            borderRadius: const BorderRadius.all(Radius.circular(AppSize.s8))),
        // focused error border
        focusedErrorBorder: OutlineInputBorder(
            borderSide:
                BorderSide(color: ColorManager.primary, width: AppSize.s1_5),
            borderRadius: const BorderRadius.all(Radius.circular(AppSize.s8))),
        disabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
                color: ColorManager.textFieldBorderColor, width: AppSize.s1_5),
            borderRadius: const BorderRadius.all(Radius.circular(AppSize.s18))),
      ));
}
