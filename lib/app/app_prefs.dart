
import 'package:shared_preferences/shared_preferences.dart';

import '../presentation/resources/language_manager.dart';

const String PREFS_KEY_LANG = "PREFS_KEY_LANG";
const String PREFS_KEY_IS_USER_LOGGED_IN = "PREFS_KEY_IS_USER_LOGGED_IN";

class AppPreferences {
  final SharedPreferences _sharedPreferences;

  AppPreferences(this._sharedPreferences);

  Future<String> getAppLanguage() async {
    String? language = _sharedPreferences.getString(PREFS_KEY_LANG);

    if (language != null && language.isNotEmpty) {
      return language;
    } else {
      return LanguageType.ENGLISH.getValue();
    }
  }

  Future<void> setIsUserLoggedIn() async {
    _sharedPreferences.setBool(PREFS_KEY_IS_USER_LOGGED_IN, true);
  }

  Future<void> setUserLoggedOut() async {
    String deviceToken = getDeviceToken();
    String deviceId = getDeviceId();
    _sharedPreferences.clear();
    print("In logout user id");
    print(getUserId());
    setDeviceToken(deviceToken);
    setDeviceId(deviceId);
    removeRegisterAsOrganijation();
    _sharedPreferences.setBool(PREFS_KEY_IS_USER_LOGGED_IN, false);
  }

  Future<bool> isUserLoggedIn() async {
    return _sharedPreferences.getBool(PREFS_KEY_IS_USER_LOGGED_IN) ?? false;
  }

  Future<void> setUserDetails(userid, fname, lname, uname, email,
      String? mobile, bool? registerAsOrganijation, header,orgid) async {
    _sharedPreferences.setString('userid', userid);
    _sharedPreferences.setString('fname', fname);
    _sharedPreferences.setString('lname', lname);
    _sharedPreferences.setString('uname', uname);
    _sharedPreferences.setString('email', email);
    _sharedPreferences.setString('mobile', mobile ?? "");
    _sharedPreferences.setBool(
        'registerAsOrganijation', registerAsOrganijation ?? true);
    _sharedPreferences.setString('header', header);
    _sharedPreferences.setString('orgid', orgid);
  }

  Future<void> setRegistrationStatus(registerStatus) async {
    _sharedPreferences.setBool("registerStatus", registerStatus);
  }

  Future<void> setForgotPasswordStatus(forgotPasswordStatus) async {
    _sharedPreferences.setBool("forgotPasswordStatus", forgotPasswordStatus);
  }

  Future<void> setLoginStatus(loginStatus) async {
    _sharedPreferences.setBool("loginStatus", loginStatus);
  }

  Future<void> setCompanyId(companyId) async {
    _sharedPreferences.setString("companyId", companyId);
  }

  Future<void> setSurveyPlatformId(platformId) async {
    _sharedPreferences.setString("platformId", platformId);
  }

  Future<void> setSurveyId(surveyId) async {
    _sharedPreferences.setString("surveyId", surveyId);
  }

  Future<void> setSurveyDeliveryAuthToken(authtoken) async {
    _sharedPreferences.setString("authtoken", authtoken);
  }

  Future<void> setSurveyDeliveryPreviewStatus(previewStatus) async {
    _sharedPreferences.setBool("previewStatus", previewStatus);
  }

  Future<void> setSurveyDeliveryName(surveyDeliveryName) async {
    _sharedPreferences.setString("surveyDeliveryName", surveyDeliveryName);
  }

  Future<void> setSurveyDeliveryCompanyName(surveyDeliveryCompanyName) async {
    _sharedPreferences.setString(
        "surveyDeliveryCompanyName", surveyDeliveryCompanyName);
  }

  Future<void> setSurveyDeliveryWebsite(surveyDeliveryWebsite) async {
    _sharedPreferences.setString(
        "surveyDeliveryWebsite", surveyDeliveryWebsite);
  }

  Future<void> setSurveyDeliveryDescription(surveyDeliveryDesctiption) async {
    _sharedPreferences.setString(
        "surveyDeliveryDescription", surveyDeliveryDesctiption);
  }

  Future<void> setSurveyDeliveryCompanyNamePop(
      surveyDeliveryCompanyNamePop) async {
    _sharedPreferences.setString(
        "surveyDeliveryCompanyNamePop", surveyDeliveryCompanyNamePop);
  }

  Future<void> setSurveyDeliveryCompanyWebsitePop(
      surveyDeliveryCompanyWebsitePop) async {
    _sharedPreferences.setString(
        "surveyDeliveryCompanyWebsitePop", surveyDeliveryCompanyWebsitePop);
  }

  Future<void> setSurveyDeliveryDescriptionPop(
      surveyDeliveryDesctiptionPop) async {
    _sharedPreferences.setString(
        "surveyDeliveryDesctiptionPop", surveyDeliveryDesctiptionPop);
  }

  Future<void> setSurveyDeliveryThankyouPageMessage(
      surveyDeliveryThankyouPageMessage) async {
    _sharedPreferences.setString(
        "surveyDeliveryThankyouPageMessage", surveyDeliveryThankyouPageMessage);
  }

  Future<void> setSurveyDeliveryThankyouPageDuration(
      surveyDeliveryThankyouPageDuration) async {
    _sharedPreferences.setString("surveyDeliveryThankyouPageDuration",
        surveyDeliveryThankyouPageDuration);
  }

  Future<void> setSurveyDeliveryRedirectionUrl(
      surveyDeliveryRedirectionUrl) async {
    _sharedPreferences.setString(
        "surveyDeliveryRedirectionUrl", surveyDeliveryRedirectionUrl);
  }

  Future<void> setSurveyDeliverySurveyId(setSurveyDeliverySurveyId) async {
    _sharedPreferences.setString(
        "setSurveyDeliverySurveyId", setSurveyDeliverySurveyId);
  }

  Future<void> redirectIntroPage(redirectIntroPage) async {
    _sharedPreferences.setBool("redirectIntroPage", redirectIntroPage);
  }

  Future<void> setDeviceToken(deviceToken) async {
    _sharedPreferences.setString("deviceToken", deviceToken);
  }

  Future<void> setDeviceId(deviceId) async {
    _sharedPreferences.setString("deviceId", deviceId);
  }

  Future<void> setSurveyDeliveryIntroduction(String introductionText) async {
    _sharedPreferences.setString("introductionText", introductionText);
  }

  Future<void> setSurveyDeliveryStartDate(String startDate) async {
    _sharedPreferences.setString("startDate", startDate);
  }

  Future<void> setSurveyDeliveryEndDate(String endDate) async {
    _sharedPreferences.setString("endDate", endDate);
  }

  Future<void> setSurveyEditDetailsSurveyName(String surveyName) async {
    _sharedPreferences.setString('surveyEditSurveyName', surveyName);
  }

  Future<void> setSurveyEditDetailsSurveyStatus(bool isUpdated) async {
    _sharedPreferences.setBool('surveyEditSurveyStatus', isUpdated);
  }

  Future<void> setSurveyEditDetailsSurveyId(String surveyId) async {
    _sharedPreferences.setString('surveyEditSurveyId', surveyId);
  }

  Future<void> setSurveyEditDetailsSurveyStartDate(
      String surveyStartDate) async {
    _sharedPreferences.setString('surveyEditSurveyStartDate', surveyStartDate);
  }

  Future<void> setSurveyEditDetailsSurveyEndDate(String surveyEndDate) async {
    _sharedPreferences.setString('surveyEditSurveyEndDate', surveyEndDate);
  }

  Future<void> setDataRequestStatusKey(String statusKey) async {
    _sharedPreferences.setString('statusKey', statusKey);
  }

  Future<void> setDataRequestTypeKey(String requestTypeKey) async {
    _sharedPreferences.setString('requestTypeKey', requestTypeKey);
  }

  Future<void> setDescriptiveIndex(String descriptiveIndex) async {
    _sharedPreferences.setString('setDescriptiveIndex', descriptiveIndex);
  }

  Future<void> setIsDeleteKey(String isDeleteKey) async {
    _sharedPreferences.setString('isDeleteKey', isDeleteKey);
  }

  Future<void> setDataRequestTokenKey(String requestTokenKey) async {
    _sharedPreferences.setString('requestTokenKey', requestTokenKey);
  }

  Future<void> setListDataRequestTokenKey(String listRequestTokenKey) async {
    _sharedPreferences.setString('listRequestTokenKey', listRequestTokenKey);
  }

  //getPrefs

  String getSurveyDeliveryName() {
    return _sharedPreferences.getString('surveyDeliveryName') ?? "";
  }

  String getSurveyDeliveryCompanyName() {
    return _sharedPreferences.getString('surveyDeliveryCompanyName') ?? "";
  }

  String getSurveyDeliveryCompanyWebsite() {
    return _sharedPreferences.getString('surveyDeliveryCompanyWebsite') ?? "";
  }

  String getSurveyDeliveryCompanyDescription() {
    return _sharedPreferences.getString('surveyDeliveryCompanyDescription') ??
        "";
  }

  String getSurveyDeliveryCompanyNamePop() {
    return _sharedPreferences.getString('surveyDeliveryCompanyNamePop') ?? "";
  }

  String getSurveyDeliveryCompanyWebsitePop() {
    return _sharedPreferences.getString('surveyDeliveryCompanyWebsitePop') ??
        "";
  }

  String getSurveyDeliveryCompanyDescriptionPop() {
    return _sharedPreferences.getString('surveyDeliveryDesctiptionPop') ?? "";
  }

  String getSurveyDeliveryThankyouPageMessage() {
    return _sharedPreferences.getString('surveyDeliveryThankyouPageMessage') ??
        "";
  }

  String getSurveyDeliveryThankyouPageDuration() {
    return _sharedPreferences.getString('surveyDeliveryThankyouPageDuration') ??
        "";
  }

  String getSurveyDeliveryRedirectionUrl() {
    return _sharedPreferences.getString('surveyDeliveryRedirectionUrl') ?? "";
  }

  String getSurveyDeliverySurveyId() {
    return _sharedPreferences.getString('setSurveyDeliverySurveyId') ?? "";
  }

  String getSurveyDeliveryAuthToken() {
    return _sharedPreferences.getString('authtoken') ?? "";
  }

  String getSurveyPlatformId() {
    return _sharedPreferences.getString('platformId') ?? "";
  }

  String getSurveyId() {
    return _sharedPreferences.getString('surveyId') ?? "";
  }

  String getCompanyId() {
    return _sharedPreferences.getString('companyId') ?? "";
  }

  String getUserId() {
    return _sharedPreferences.getString('userid') ?? "";
  }

  String getFname() {
    return _sharedPreferences.getString('fname') ?? "";
  }

  String getLname() {
    return _sharedPreferences.getString('lname') ?? "";
  }

  String getUname() {
    return _sharedPreferences.getString('uname') ?? "";
  }

  String getEmail() {
    return _sharedPreferences.getString('email') ?? "";
  }

  String getMobile() {
    return _sharedPreferences.getString('mobile') ?? "";
  }
   String getOrgId() {
    return _sharedPreferences.getString('orgid') ?? "";
  }

  bool getRegisterAs() {
    return _sharedPreferences.getBool('registerAsOrganijation') ?? true;
  }

  String getHeader() {
    return _sharedPreferences.getString('header') ?? "";
  }

  bool getRegisterStatus() {
    return _sharedPreferences.getBool('registerStatus') ?? false;
  }

  bool getForgotPasswordStatus() {
    return _sharedPreferences.getBool('forgotPasswordStatus') ?? false;
  }

  bool getLoginStatus() {
    return _sharedPreferences.getBool('loginStatus') ?? false;
  }

  bool getRedirectIntroPage() {
    return _sharedPreferences.getBool('redirectIntroPage') ?? false;
  }

  String getDeviceToken() {
    return _sharedPreferences.getString("deviceToken") ?? "";
  }

  String getSurveyDeliveryIntroductionText() {
    return _sharedPreferences.getString("introductionText") ?? "";
  }

  String getSurveyDeliveryStartDate() {
    return _sharedPreferences.getString("startDate") ?? "";
  }

  String getSurveyDeliveryEndDate() {
    return _sharedPreferences.getString("endDate") ?? "";
  }

  String getDeviceId() {
    return _sharedPreferences.getString("deviceId") ?? "";
  }

  bool getSurveyDeliveryPreviewStatus() {
    print("The status is");
    print(_sharedPreferences.getBool("previewStatus"));
    return _sharedPreferences.getBool("previewStatus") ?? false;
  }

  String getSurveyEditDetailsSurveyName() {
    return _sharedPreferences.getString('surveyEditSurveyName') ?? "";
  }

  String getSurveyEditDetailsSurveyId() {
    return _sharedPreferences.getString('surveyEditSurveyId') ?? "";
  }

  String getSurveyEditDetailsSurveyStartDate() {
    return _sharedPreferences.getString('surveyEditSurveyStartDate') ?? "";
  }

  String getSurveyEditDetailsSurveyEndDate() {
    return _sharedPreferences.getString('surveyEditSurveyEndDate') ?? "";
  }

  bool getSurveyEditDetailsSurveyStatus() {
    return _sharedPreferences.getBool('surveyEditSurveyStatus') ?? true;
  }

  String getDataRequestStatusKey() {
    return _sharedPreferences.getString('statusKey') ?? "";
  }

  String getDataRequestTypeKey() {
    return _sharedPreferences.getString('requestTypeKey') ?? "";
  }

  Future<void> getDescriptiveIndex() async {
    _sharedPreferences.getString('setDescriptiveIndex');
  }

  String getIsDeleteKey() {
    return _sharedPreferences.getString('isDeleteKey') ?? "";
  }

  String getDataRequestTokenKey() {
    return _sharedPreferences.getString('requestTokenKey') ?? "";
  }

  String getDataListRequestTokenKey() {
    return _sharedPreferences.getString('listRequestTokenKey') ?? "";
  }

  //Remove Shared Prefs

  void removeSurveyDeliveryName() {
    _sharedPreferences.remove('surveyDeliveryName');
  }

  removeSurveyDeliveryCompanyName() {
    _sharedPreferences.remove('surveyDeliveryCompanyName');
  }

  removeSurveyDeliveryWebsite() {
    _sharedPreferences.remove('surveyDeliveryWebsite');
  }

  removeSurveyDeliveryDescription() {
    _sharedPreferences.remove('surveyDeliveryDescription');
  }

  removeSurveyDeliveryThankyouPageMessage() {
    _sharedPreferences.remove('surveyDeliveryThankyouPageMessage');
  }

  removeSurveyDeliveryThankyouPageDuration() {
    _sharedPreferences.remove('surveyDeliveryThankyouPageDuration');
  }

  removeSurveyDeliveryRedirectionUrl() {
    _sharedPreferences.remove('surveyDeliveryRedirectionUrl');
  }

  removeSurveyDeliverySurveyId() {
    _sharedPreferences.remove('setSurveyDeliverySurveyId');
  }

  removeSurveyDeliveryAuthToken() {
    _sharedPreferences.remove('authtoken');
  }

  removeSurveyDeliveryPreviewStatus() async {
    _sharedPreferences.remove("previewStatus");
  }

  removeSurveyPlatformId() {
    _sharedPreferences.remove('platformId');
  }

  removeSurveyId() {
    _sharedPreferences.remove('surveyId');
  }

  removeCompanyId() {
    _sharedPreferences.remove('companyId');
  }

  removeUserId() {
    _sharedPreferences.remove('userid');
  }

  removeFname() {
    _sharedPreferences.remove('fname');
  }

  removeLname() {
    _sharedPreferences.remove('lname');
  }

  removeUname() {
    _sharedPreferences.remove('uname');
  }

  removeOrgId() {
    _sharedPreferences.remove('orgid');
  }

  removeEmail() {
    _sharedPreferences.remove('email');
  }

  removeMobile() {
    _sharedPreferences.remove('mobile');
  }

  removeRegisterAsOrganijation() {
    _sharedPreferences.remove('registerAsOrganijation');
  }

  removeHeader() {
    _sharedPreferences.remove('header');
  }

  removeRegisterStatus() {
    _sharedPreferences.remove('registerStatus');
  }

  removeForgotPasswordStatus() {
    _sharedPreferences.remove('forgotPasswordStatus');
  }

  removeLoginStatus() {
    _sharedPreferences.remove('loginStatus');
  }

  removeRedirectIntroPage() {
    _sharedPreferences.remove('redirectIntroPage');
  }

  removeDeviceToken() {
    _sharedPreferences.remove("deviceToken");
  }

  removeSurveyDeliveryIntroductionText() {
    _sharedPreferences.remove("introductionText");
  }

  removeSurveyDeliveryStartDate() {
    _sharedPreferences.remove("startDate");
  }

  removeSurveyDeliveryEndDate() {
    _sharedPreferences.remove("endDate");
  }

  removeDeviceId() {
    _sharedPreferences.remove("deviceId");
  }

  removeSurveyEditDetailsSurveyName() {
    _sharedPreferences.remove('surveyEditSurveyName');
  }

  removeSurveyEditDetailsSurveyId() {
    _sharedPreferences.remove('surveyEditSurveyId');
  }

  removeSurveyEditDetailsSurveyStartDate() {
    _sharedPreferences.remove('surveyEditSurveyStartDate');
  }

  removeSurveyEditDetailsSurveyEndDate() {
    _sharedPreferences.remove('surveyEditSurveyEndDate');
  }

  removeSurveyEditDetailsSurveyStatus() {
    _sharedPreferences.remove('surveyEditSurveyStatus');
  }

  removeIsDeleteKey() {
    _sharedPreferences.remove('isDeleteKey');
  }

  removeDataRequestTokenKey() {
    _sharedPreferences.remove('requestTokenKey');
  }
}
