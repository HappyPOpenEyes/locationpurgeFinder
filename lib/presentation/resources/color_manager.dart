import 'package:flutter/material.dart';

class ColorManager {

static Color avantisBlue = HexColor.fromHex("#0749A9");
static Color avantisGold = HexColor.fromHex("#C09960");
static Color avantisPink = HexColor.fromHex("#DC3F96");
static Color avantisGray = HexColor.fromHex("#9E9E9E");
static Color avantisLime = HexColor.fromHex("#6EC64E");
static Color avantisOrange = HexColor.fromHex("#F45B22");
static Color avantisBloodRed = HexColor.fromHex("#962940");
static Color avantisAdIDColor = HexColor.fromHex("#828282");



  static Color primary = HexColor.fromHex("#0696FD");
  static Color darkGrey = HexColor.fromHex("#525252");
  static Color grey = HexColor.fromHex("##DDDDD3");
  static Color lightGrey = HexColor.fromHex("#9E9E9E");
  static Color primaryOpacity70 = HexColor.fromHex("#0696FD").withOpacity(0.5);
  static Color green = HexColor.fromHex("#61cd8f");
  static Color greenButton = HexColor.fromHex("#306647");

  // new colors
  static Color darkPrimary = HexColor.fromHex("#d17d11");
  static Color grey1 = HexColor.fromHex("#707070");
  static Color grey2 = HexColor.fromHex("#797979");
  static Color greyDialog = HexColor.fromHex("#2B2D2F");
  static Color white = HexColor.fromHex("#FFFFFF");
  static Color whiteOpacity = const Color.fromRGBO(255, 255, 255, 0.85);
  static Color error = HexColor.fromHex("#e61f34");
  static Color dropShadow = HexColor.fromHex("#00000040");
  static Color black = HexColor.fromHex("#000000"); // // red color

  static Color closeSurveyColor = HexColor.fromHex("#D88181");
  static Color openSurveyColor = HexColor.fromHex("#81D888");
  static Color upcommingSurveyColor = HexColor.fromHex("#F9B437");
  static Color draftSurveyColor = HexColor.fromHex("#F8D79E");
  static Color surveyNameColor = HexColor.fromHex("#3D3D3C");
  static Color surveyDivLineColor = HexColor.fromHex("#D8D8D8");
  static Color surveysortBorderColor = HexColor.fromHex("#32C5FF");
  static Color gradiantColor1 = HexColor.fromHex("#1FA2FF");
  static Color gradiantColor2 = HexColor.fromHex("#12D8FA");
  static Color splaceGradiantColor1 = HexColor.fromHex("#0B95F7");
  static Color splaceGradiantColor2 = HexColor.fromHex("#12D8FA");
  static Color boxBorderColor = HexColor.fromHex("#70707026");
  static Color surveyNumberBorderColor = HexColor.fromHex("#70707040");
  static Color questionBorderColor = HexColor.fromHex("#DFDFDF");
  static Color questionNumberColor = HexColor.fromHex("#3D3D3C");
  static Color greenColor = HexColor.fromHex("#81D888");
  static Color textFieldBorderColor = HexColor.fromHex("#B5B5B5");
  static Color disabledTextColor = HexColor.fromHex("#B1B1B1");
  static Color rangeSliderInActiveColor = HexColor.fromHex("#3D3D3C4D");
  static Color rangeSliderActiveColor = HexColor.fromHex("#64D3FF");
  static Color historyBoxBorderColor = HexColor.fromHex("#DFDFDF");
  static Color textFieldDisableColor = HexColor.fromHex("#EEEEEE");
  static Color clearFilterButtenColor = HexColor.fromHex("#FE2F2F");
  static Color disableTextfieldTextColor = HexColor.fromHex("#B1B1B1");
  static Color requestedStatusColor = HexColor.fromHex("#007BFF");
  static Color inprogressStatusColor = HexColor.fromHex("#FFC107");
  static Color completedStatusColor = HexColor.fromHex("#28A745");
  static Color cancelStatusColor = HexColor.fromHex("#FE2F2F");
}

extension HexColor on Color {
  static Color fromHex(String hexColorString) {
    hexColorString = hexColorString.replaceAll('#', '');
    if (hexColorString.length == 6) {
      hexColorString = "FF$hexColorString"; // 8 char with opacity 100%
    }
    return Color(int.parse(hexColorString, radix: 16));
  }
}
