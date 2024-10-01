import 'package:flutter/material.dart';

import '../presentation/resources/color_manager.dart';
import '../presentation/resources/font_manager.dart';

class Constants {
  static const String baseUrl =
       "https://avantisprivacy.com/id";


    
  static String token = "you app token here";

  static const String mobilePlatformId = "b1662f71-0740-11ec-af38-1908de41ac9c";
  static const String webPlatformId = "b1662f0a-0740-11ec-af38-1908de41ac9c";

  static RegExp emailValidatorRegExp =
      RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+");

  static RegExp imageValidatorRegExp =
      RegExp('[^\\s]+(.*?)\\.(jpg|jpeg|png|gif|JPG|JPEG|PNG|GIF)\$');

  static RegExp passwordValidatorRegExp = RegExp(
      '^(?=.*[!,@,#,\$,%,^,&,*,(,),-,=,_,+,.])(?=.*d)(?=.*[a-z])(?=.*[A-Z]).{6,32}\$,');

  static RegExp htmlParserRegExp =
      RegExp(r"<[^>]*>", multiLine: true, caseSensitive: true);

  static final RegExp nameValidatorRegExp = RegExp('[a-zA-Z ]');

  static final RegExp userNameValidatorRegExp = RegExp('[a-zA-Z0-9]');

  static final RegExp surveyNameValidatorRegExp = RegExp('[a-z A-Z0-9.]');

  static final RegExp urlValidatorRegExp = RegExp(
      r'^((?:.|\n)*?)((http:\/\/www\.|https:\/\/www\.|http:\/\/|https:\/\/)?[a-z0-9]+([\-\.]{1}[a-z0-9]+)([-A-Z0-9.]+)(/[-A-Z0-9+&@#/%=~_|!:,.;]*)?(\?[A-Z0-9+&@#/%=~_|!:‌​,.;]*)?)');

  static final RegExp urlValidatorRegExpNew = RegExp(
      r'^((?:.|\n)*?)((http:\/\/www\.|https:\/\/www\.|http:\/\/|https:\/\/)?[a-z0-9]+([\-\.]{1}[a-z0-9]+)([-A-Z0-9.]+)(/[-A-Z0-9+&@#/%=~_|!:,.;]*)?(\?[A-Z0-9+&@#/%=~_|!:‌​,.;]*)?)');


  static const String passwordIntroPageId =
      "cd090577-1d18-11ec-a7ce-de3d953443b5";

  static const String responseLimitIntroPageId =
      "3cdb424a-1d1a-11ec-a7ce-de3d953443b5";

  static const String disclaimerIntroPageDisplayText = "Disclaimer Survey";

  //Survey Delivery question types
  static const String mcqQuestionTypeId =
      "b166063b-0740-11ec-af38-1908de41ac9c";
  static const String dropdownSingleSelectionQuestionTypeId =
      "b1662a30-0740-11ec-af38-1908de41ac9c";
  static const String shortAnswerQuestionTypeId =
      "b1662dde-0740-11ec-af38-1908de41ac9c";
  static const String descriptiveQuestionTypeId =
      "b16631e5-0740-11ec-af38-1908de41ac9c";
  static const String mcqMultiSelectionQuestionTypeId =
      "b1662e42-0740-11ec-af38-1908de41ac9c";
  static const String ratingQuestionTypeId =
      "77b55f4a-639e-4708-9412-5b46f7e3972b";
  static const String groupRatingQuestionTypeId =
      "ec856a6e-a071-4496-829e-ce407ad3d3fa";

  //Survey Settings Types
  static String textSetting = "text";
  static String textAreaSetting = "textarea";
  static String dropdownSetting = "dropdown";
  static String toggleSetting = "toggle";
  static String radioSetting = "radio";
  static String checkboxSetting = "checkbox";
  static String passwordSetting = "password";

  

  //Required styles
  static TextStyle defaultStyle =
      TextStyle(color: ColorManager.surveyNameColor, fontSize: FontSize.s12);
  static TextStyle mendatoryStyle = TextStyle(color: ColorManager.error);
}
