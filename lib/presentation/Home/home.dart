import 'dart:io';

import 'package:advertising_id/advertising_id.dart';
import 'package:android_intent_plus/android_intent.dart';
import 'package:app_settings/app_settings.dart';
import 'package:app_tracking_transparency/app_tracking_transparency.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:location_purge_maid_finder/presentation/Home/home_viewmodel.dart';
import 'package:location_purge_maid_finder/presentation/resources/font_manager.dart';
import 'package:location_purge_maid_finder/presentation/resources/styles_manager.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../app/app_prefs.dart';
import '../../app/di.dart';
import '../common/state_renderer/ShowLoadingDialog.dart';
import '../common/state_renderer/state_render_impl.dart';
import '../resources/asset_manager.dart';
import '../resources/color_manager.dart';
import '../resources/string_manager.dart';
import '../resources/values_manager.dart';

class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> with WidgetsBindingObserver {
  String _advertisingId = '';
  bool _isLimitAdTrackingEnabled = false;
  bool isTrakingEnabled = false;
  bool isUserNotRegistred = false;
  int buildVersion = 0;
  final TextEditingController _emailAddressController = TextEditingController();
  final HomeViewModel _loginViewModel = instance<HomeViewModel>();
  final AppPreferences _appPreferences = instance<AppPreferences>();
  @override
  void initState() {
    _bind();
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    if (Platform.isAndroid) {
      initPlatformState();
    }
    WidgetsFlutterBinding.ensureInitialized()
        .addPostFrameCallback((_) => initPlugin());
  }

  _bind() {
    _loginViewModel.start();
    _emailAddressController.addListener(
        () => _loginViewModel.setEmailAddress(_emailAddressController.text));
    _loginViewModel.isUserLoggedInSuccessfullyStreamController.stream
        .listen((isSuccessLoggedIn) {
      // navigate to main screen

      SchedulerBinding.instance.addPostFrameCallback((_) {
        showAlertDialogForSucsess();
        _emailAddressController.clear();
        _loginViewModel.isCheckBoxSeleccted = false;
        _loginViewModel.isCustomer = false;
      });
    });

    _loginViewModel.isUserUserNotFoundStreamController.stream
        .listen((isSuccessLoggedIn) {
      if (isSuccessLoggedIn == true) {
        isUserNotRegistred = true;
        showAlertDialogForPurgeExpernal();
        print("true");
      } else {
        if (isUserNotRegistred == true) {
          setState(() {
            isUserNotRegistred = false;
          });
        }
      }
      // navigate to main screen

      // SchedulerBinding.instance.addPostFrameCallback((_) {
      //   showAlertDialogForSucsess();
      //   _emailAddressController.clear();
      //   _loginViewModel.isCheckBoxSeleccted = false;
      // });
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  Future<void> initPlugin() async {
    final TrackingStatus status =
        await AppTrackingTransparency.trackingAuthorizationStatus;
    // If the system can show an authorization request dialog
    if (status == TrackingStatus.notDetermined) {
      // Show a custom explainer dialog before the system dialog
      //await showCustomTrackingDialog(context);
      await AppTrackingTransparency.requestTrackingAuthorization();
      _appPreferences.setLoginStatus(true);
      print(_appPreferences.getLoginStatus());
      // Wait for dialog popping animation
      await Future.delayed(const Duration(milliseconds: 200));
      // Request system's tracking authorization dialog
      // final TrackingStatus status =
      //     await AppTrackingTransparency.requestTrackingAuthorization();
    }

    final advertisingId =
        await AppTrackingTransparency.getAdvertisingIdentifier();

    setState(() {
      _advertisingId = advertisingId == ""
          ? "00000000-0000-0000-0000-000000000000"
          : advertisingId;
      isTrakingEnabled = status == TrackingStatus.authorized ? true : false;
    });
    print("UUID: $advertisingId");
    print("status: $status");
  }

  Future<void> showCustomTrackingDialog(BuildContext context) async =>
      await showDialog<void>(
        context: context,
        builder: (context) => AlertDialog(
          actionsPadding: const EdgeInsets.only(
              bottom: AppSize.s24,
              top: AppSize.s24,
              left: AppSize.s24,
              right: AppSize.s24),
          contentPadding: const EdgeInsets.only(
              top: AppSize.s24, left: AppSize.s24, right: AppSize.s24),
          title: const Text('Dear User'),
          content: const Text('Your MAID is currently disabled.\n\n'
              'You likely turned it off to increase your privacy. Good job!\n\n'
              'In order to view your unique MAID you will need to temporarily re-enable it. This will allow us to delete previously leaked location history now in the hands of data brokers,\n\n'
              'You can change your choice at any time. We will encourage you to disable tracking once this process is complete.\n\n'
              'On the next screen, simply toggle "Allow Tracking" on and confirm. Then return to this App.'

              // 'Your MAID is currently disabled. You likely turned it off to increase your privacy. Good job!\n\n'
              // 'However, in order to view your unique MAID and/or to delete any previously leaked location history now in the hands of data brokers, you will need to temporarily re-enable it.\n\n'
              // 'You can change your choice at any time and we will encourage you to re-disable the MAID.'
              ),
          actions: [
            ElevatedButton(
              onPressed: () async {
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: ColorManager.avantisBlue,
              ),
              child: const Text('No Thanks'),
            ),
            ElevatedButton(
              onPressed: () async {
                Navigator.pop(context);
                final TrackingStatus status =
                    await AppTrackingTransparency.trackingAuthorizationStatus;

                if (status == TrackingStatus.authorized) {
                  AppSettings.openAppSettings(type: AppSettingsType.settings);
                  _appPreferences.setLoginStatus(true);
                  print(_appPreferences.getLoginStatus());
                } else if (status == TrackingStatus.denied) {
                  AppSettings.openAppSettings(type: AppSettingsType.settings);
                  _appPreferences.setLoginStatus(true);
                  print(_appPreferences.getLoginStatus());
                } else if (status == TrackingStatus.notDetermined) {
                  await AppTrackingTransparency.requestTrackingAuthorization();
                  _appPreferences.setLoginStatus(true);
                  print(_appPreferences.getLoginStatus());
                  //showAlertDialogForGotoSettings1();
                }
              },
              child: const Text('Continue'),
            ),
          ],
        ),
      );

  initPlatformState() async {
    if (Platform.isAndroid) {
      DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      buildVersion = int.parse(androidInfo.version.release);
      print(buildVersion);
    }

    String? advertisingId;
    bool? isLimitAdTrackingEnabled;
    // Platform messages may fail, so we use a try/catch PlatformException.

    try {
      isLimitAdTrackingEnabled = await AdvertisingId.isLimitAdTrackingEnabled;
    } on PlatformException {
      isLimitAdTrackingEnabled = false;
    }

    try {
      advertisingId = await AdvertisingId.id(true);
      if (Platform.isAndroid) {
        if (buildVersion >= 12) {
          isTrakingEnabled =
              advertisingId == "00000000-0000-0000-0000-000000000000"
                  ? false
                  : true;
        } else {
          isTrakingEnabled = _isLimitAdTrackingEnabled;
        }
      } else if (Platform.isIOS) {
        isTrakingEnabled = advertisingId == "" ? false : true;
        advertisingId = advertisingId == ""
            ? "00000000-0000-0000-0000-000000000000"
            : advertisingId;
      }
    } on PlatformException {
      isTrakingEnabled = false;
      advertisingId = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _advertisingId = advertisingId ?? "";
      _isLimitAdTrackingEnabled = isLimitAdTrackingEnabled ?? false;
      if (Platform.isAndroid) {
        if (buildVersion >= 12) {
          isTrakingEnabled = isTrakingEnabled;
        } else {
          isTrakingEnabled = !_isLimitAdTrackingEnabled;
        }
      }
    });
  }
    initPlatformState1() async {
    if (Platform.isAndroid) {
      DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      buildVersion = int.parse(androidInfo.version.release);
      print(buildVersion);
    }

    String? advertisingId;
    bool? isLimitAdTrackingEnabled;
    // Platform messages may fail, so we use a try/catch PlatformException.

    try {
      isLimitAdTrackingEnabled = await AdvertisingId.isLimitAdTrackingEnabled;
    } on PlatformException {
      isLimitAdTrackingEnabled = false;
    }

    try {
      advertisingId = await AdvertisingId.id(true);
      if (Platform.isAndroid) {
        if (buildVersion >= 12) {
          isTrakingEnabled =
              advertisingId == "00000000-0000-0000-0000-000000000000"
                  ? false
                  : true;
        } else {
          isTrakingEnabled = _isLimitAdTrackingEnabled;
        }
      } else if (Platform.isIOS) {
        isTrakingEnabled = advertisingId == "" ? false : true;
        advertisingId = advertisingId == ""
            ? "00000000-0000-0000-0000-000000000000"
            : advertisingId;
      }
    } on PlatformException {
      isTrakingEnabled = false;
      advertisingId = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _advertisingId = advertisingId ?? "";
      _isLimitAdTrackingEnabled = isLimitAdTrackingEnabled ?? false;
      if (Platform.isAndroid) {
        if (buildVersion >= 12) {
          isTrakingEnabled = isTrakingEnabled;
        } else {
          isTrakingEnabled = !_isLimitAdTrackingEnabled;
        }
      }
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      // This block will be executed when the app comes back into focus.
      // You can reload data or perform any necessary actions here.
      setState(() {
        if(Platform.isAndroid){
        initPlatformState();
        }
        else{
        WidgetsFlutterBinding.ensureInitialized()
              .addPostFrameCallback((_) => initPlugin());  
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: <Widget>[
      Image.asset(
        ImageAssets.bottomImage,
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        fit: BoxFit.fill,
      ),
      Scaffold(
          backgroundColor: Colors.transparent,
          body: StreamBuilder<FlowState>(
            stream: _loginViewModel.outputState,
            builder: (context, snapshot) {
              if (_loginViewModel.isAlreadyErrorState) {
                _loginViewModel.setContentState();
              }
              return ModalProgressHUD(
                  inAsyncCall:
                      snapshot.data == null ? false : _loginViewModel.isLoading,
                  progressIndicator: const ShowLoadingDialog(),
                  child: _loginViewModel.isLoading
                      ? _getContentWidget()
                      : snapshot.data?.getScreenWidget(
                              context, _getContentWidget(), () {}) ??
                          _getContentWidget());
            },
          ))
    ]);
  }

  Widget _getContentWidget() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(
            vertical: AppPadding.p60, horizontal: AppPadding.p16),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Center(
                child: Image(
                  width: AppSize.s250,
                  //height: AppSize.s130,
                  image: AssetImage(ImageAssets.splashLogo),
                ),
              ),
              const SizedBox(
                height: AppPadding.p16,
              ),
              const Center(
                child: Image(
                  width: AppSize.s120,
                  //height: AppSize.s130,
                  image: AssetImage(ImageAssets.homePageMap),
                ),
              ),
              const SizedBox(
                height: AppPadding.p12,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Image(
                    width: AppSize.s80,
                    //height: AppSize.s130,
                    image: AssetImage(ImageAssets.left),
                  ),
                  const SizedBox(
                    width: AppSize.s8,
                  ),
                  //  Container(
                  //     color: ColorManager.avantisGold,
                  //     height: 2,
                  //     width: 100,
                  //   ),
                  Text(
                    "Tracking",
                    style: getBoldStyle(
                        color: ColorManager.avantisGold,
                        fontSize: FontSize.s24),
                  ),
                  const SizedBox(
                    width: AppSize.s8,
                  ),
                  const Image(
                    width: AppSize.s80,
                    //height: AppSize.s130,
                    image: AssetImage(ImageAssets.right),
                  ),

                  //  Container(
                  //   color: ColorManager.avantisGold,
                  //   height: 2,
                  //   width: 100,
                  // ),
                ],
              ),
              const SizedBox(
                height: AppSize.s16,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    isTrakingEnabled
                        ? "Location Tracking is On:"
                        : "Location Tracking is Off:",
                    style: getBoldStyle(
                        color: ColorManager.black, fontSize: FontSize.s18),
                  ),
                  const SizedBox(
                    width: AppSize.s8,
                  ),
                  FlutterSwitch(
                    activeColor: ColorManager.avantisPink,
                    height: AppSize.s26,
                    width: AppSize.s45,
                    value: isTrakingEnabled,
                    onToggle: (val) async {
                      if (Platform.isAndroid) {
                        if (buildVersion < 12) {
                          const intent = AndroidIntent(
                            action: 'android.settings.PRIVACY_SETTINGS',
                          );
                          await intent.launch();
                          setState(() {});
                        } else {
                          if (isTrakingEnabled) {
                            showAlertDialogForDisabledMAID12();
                          } else {
                            showAlertDialogForEnableMAID12(false);
                          }
                        }

                        // String action =
                        //     "com.google.android.gms.settings.ADS_PRIVACY";
                        // AndroidIntent settings = AndroidIntent(action: action);

                        // await settings.launch();
                      } else if (Platform.isIOS) {
                        print(_appPreferences.getLoginStatus());
                        if((!_appPreferences.getLoginStatus())){
                        showAlertDialogForGotoSettings1();
                        }
                        else{
                        final status = await AppTrackingTransparency
                            .trackingAuthorizationStatus;
                        if (status == TrackingStatus.authorized) {
                          AppSettings.openAppSettings(
                              type: AppSettingsType.settings);
                        } else if (status == TrackingStatus.denied) {
                          showCustomTrackingDialog(context);
                        } else if (status == TrackingStatus.notDetermined) {
                          showCustomTrackingDialog(context);
                        }
                      }
                      }

                      //AppSettings.openAppSettings(type: AppSettingsType.settings);
                    },
                  ),
                ],
              ),
              const SizedBox(
                height: AppSize.s8,
              ),
              Text(
                isTrakingEnabled
                    ? "Your MAID is enabled."
                    : "Your MAID is disabled.",
                style: getMediumStyle(
                    color: ColorManager.black, fontSize: FontSize.s14),
              ),
              const SizedBox(
                height: AppSize.s12,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    _advertisingId,
                    style: getRegularStyle(
                        color: ColorManager.avantisAdIDColor,
                        fontSize: FontSize.s16),
                  ),
                  const SizedBox(
                    width: AppSize.s8,
                  ),
                  InkWell(
                    onTap: () {
                      Clipboard.setData(ClipboardData(text: _advertisingId

                          // Constants.surveyDeliveryCopyUrl +
                          //     _mySurveysViewModel
                          //         .displaySurveyId[index]
                          ));
                      final snackBar = SnackBar(
                        behavior: SnackBarBehavior.floating,
                        content: const Text('Copied to clipboard.'),
                        backgroundColor: ColorManager.black,
                        action: SnackBarAction(
                          label: 'dismiss',
                          onPressed: () {},
                        ),
                      );
                      SchedulerBinding.instance.addPostFrameCallback((_) {
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      });
                    },
                    child: Image.asset(
                      ImageAssets.copyIcon,
                      //height: AppSize.s20,
                      //width: AppSize.s20,
                      //color: ColorManager.black,
                    ),
                  )
                ],
              ),
              const SizedBox(
                height: AppPadding.p32,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Image(
                    width: AppSize.s80,
                    //height: AppSize.s130,
                    image: AssetImage(ImageAssets.left),
                  ),
                  const SizedBox(
                    width: AppSize.s8,
                  ),
                  Text(
                    "Purging",
                    style: getBoldStyle(
                        color: ColorManager.avantisGold,
                        fontSize: FontSize.s24),
                  ),
                  const SizedBox(
                    width: AppSize.s8,
                  ),
                  const Image(
                    width: AppSize.s80,
                    //height: AppSize.s130,
                    image: AssetImage(ImageAssets.right),
                  ),
                ],
              ),
              const SizedBox(
                height: AppSize.s16,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Expanded(
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: Container(
                        color: Colors.white,
                        child: Text(
                          "All Users",
                          style: getSemiBoldStyle(
                              color: ColorManager.black,
                              fontSize: FontSize.s16),
                          textAlign: TextAlign.start,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(
                    width: AppSize.s12,
                  ),
                  Expanded(
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Container(
                        color: Colors.white,
                        child: ElevatedButton(
                            onPressed: () {
                              showAlertDialogForLocalPurge();
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: ColorManager.avantisBlue,
                            ),
                            child: Text(
                              "Purge Local",
                              style: getMediumStyle(
                                  fontSize: FontSize.s12,
                                  color: ColorManager.white),
                            )),
                      ),
                    ),
                  ),

                  // Text("All users",style: getRegularStyle(color: ColorManager.black),),
                  // const SizedBox(width: AppSize.s12,),
                  // ElevatedButton(onPressed: () {

                  //       },style: ElevatedButton.styleFrom(
                  //   backgroundColor: ColorManager.avantisBlue,
                  //   ),

                  //       child: Text(
                  //       "Purge Local",
                  //       style: getBoldStyle(
                  //           fontSize: FontSize.s16, color: ColorManager.white),
                  //     ))
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Expanded(
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: Container(
                        color: Colors.white,
                        child: Text(
                          "Avantis Customers",
                          style: getSemiBoldStyle(
                              color: ColorManager.black,
                              fontSize: FontSize.s16),
                          textAlign: TextAlign.start,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: AppSize.s12,
                  ),
                  Expanded(
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Container(
                        color: Colors.white,
                        child: ElevatedButton(
                            onPressed: () {
                              isTrakingEnabled
                                  ? showAlertDialogForPurgeExpernal()
                                  : Platform.isAndroid && buildVersion >= 12
                                      ? showAlertDialogForEnableMAID12(true)
                                      : showAlertDialogForDisabled();
                            },
                            child: Text(
                              "Purge External",
                              style: getMediumStyle(
                                  fontSize: FontSize.s12,
                                  color: ColorManager.white),
                            )),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: AppSize.s12,
              ),
              Text(
                "'Purge External' sends your MAID to Avantis. They can wipe the location history that has leaked from your device and been collected by brokers.",
                style: getSemiBoldStyle(
                    color: ColorManager.avantisAdIDColor,
                    fontSize: FontSize.s14),
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: AppPadding.p28,
              ),
              Platform.isAndroid
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Not an Avantis Customer yet?",
                          style: getSemiBoldStyle(
                              color: ColorManager.avantisAdIDColor,
                              fontSize: FontSize.s14),
                        ),
                        const SizedBox(
                          width: AppSize.s8,
                        ),
                        GestureDetector(
                            onTap: () async {
                              await launchUrl(Uri.parse(
                                  'https://avantisprivacy.com/location-purge-lp/'));
                            },
                            child: Text(
                              "Click to sign up.",
                              style: TextStyle(
                                fontWeight: FontWeightManager.semiBold,
                                fontSize: FontSize.s14,
                                fontFamily: FontConstants.fontFamily,
                                color: ColorManager.avantisAdIDColor,
                                decoration: TextDecoration.underline,
                              ),
                            ))
                      ],
                    )
                  : const SizedBox(
                      height: 0,
                    ),
              Platform.isAndroid
                  ? const SizedBox(
                      height: AppSize.s18,
                    )
                  : const SizedBox(
                      height: 0,
                    ),
              Text(
                "Your smartphone leaks your location data.",
                style: getBoldStyle(
                    color: ColorManager.avantisAdIDColor,
                    fontSize: FontSize.s16),
              ),
              Text(
                "Location Purge cleans up the mess.",
                style: getBoldStyle(
                    color: ColorManager.avantisAdIDColor,
                    fontSize: FontSize.s16),
              ),
              Platform.isIOS
                  ? const SizedBox(
                      height: AppSize.s28,
                    )
                  : const SizedBox(
                      height: 0,
                    ),

              Platform.isIOS
                  ? RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(children: [
                        TextSpan(
                            style: getSemiBoldStyle(
                                color: ColorManager.avantisAdIDColor,
                                fontSize: FontSize.s14),
                            text:
                                "This App is privacy recovery technology from "),
                        TextSpan(
                          style: TextStyle(
                            fontWeight: FontWeightManager.semiBold,
                            fontSize: FontSize.s14,
                            fontFamily: FontConstants.fontFamily,
                            color: ColorManager.avantisAdIDColor,
                            decoration: TextDecoration.underline,
                          ),
                          text: "Avantis Privacy.",
                          recognizer: TapGestureRecognizer()
                            ..onTap = () async {
                              await launchUrl(
                                  Uri.parse('https://avantisprivacy.com/'));
                            },
                        ),
                      ]))
                  : const SizedBox(
                      height: 0,
                    ),

              // Text(
              //   '$_isLimitAdTrackingEnabled',
              //   style: getBoldStyle(
              //       color: ColorManager.avantisAdIDColor,
              //       fontSize: FontSize.s16),
              // ),
              // Text(
              //   _isLimitAdTrackingEnabled ? "true" : "false",
              //   style: getSemiBoldStyle(
              //       color: ColorManager.black, fontSize: FontSize.s14),
              // ),
            ]),
      ),
    );
  }

  showAlertDialogForLocalPurge() {
    AlertDialog alert = AlertDialog(
      actionsAlignment: MainAxisAlignment.center,
      contentPadding: const EdgeInsets.only(
          top: AppSize.s24,
          left: AppSize.s24,
          right: AppSize.s24,
          bottom: AppSize.s24),
      // title: Image.asset(
      //   ImageAssets.alert,
      //   width: AppSize.s60,
      //   height: AppSize.s60,
      // ),
      content: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Purge Local Location Data',
            style: getSemiBoldStyle(
                color: ColorManager.avantisGold, fontSize: FontSize.s18),
          ),
          const SizedBox(
            height: AppSize.s12,
          ),
          Text(
            Platform.isAndroid
                ? "Delete significant locations - Go to Settings >> Location >> Location Services >> Google Location History, then either Disable tracking OR Set to Auto-Delete after 3 Months"
                : 'Delete significant locations - Go to Settings > Privacy & Security > Location Services > System Services, then tap Significant Locations. Tap Clear History',
            style: getMediumStyle(
                color: ColorManager.black, fontSize: FontSize.s14),
          ),
          Platform.isIOS
              ? const SizedBox(
                  height: AppSize.s12,
                )
              : const SizedBox(
                  height: AppSize.s0,
                ),
          Platform.isIOS
              ? Text(
                  'In the same screen, turn off Significant Locations',
                  style: getMediumStyle(
                      color: ColorManager.black, fontSize: FontSize.s14),
                )
              : const SizedBox(
                  height: 0,
                ),
        ],
      ),
    );
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  showAlertDialogForPurgeExpernal() {
    Widget continueButton = StreamBuilder<bool>(
      stream: _loginViewModel.outputIsAllInputsValid,
      builder: (context, snapshot) {
        return ElevatedButton(
            onPressed: (snapshot.data ?? false)
                ? () {
                    FocusScopeNode currentFocus = FocusScope.of(context);

                    if (!currentFocus.hasPrimaryFocus) {
                      currentFocus.unfocus();
                    }

                    Navigator.of(context).pop();

                    _loginViewModel.request(
                        _advertisingId, Platform.operatingSystem);
                    // showAlertDialogForSucsess();
                  }
                : null,
            child: Text(
              "Send",
              style: getBoldStyle(
                  fontSize: FontSize.s16, color: ColorManager.white),
            ));
      },
    );
    // Widget continueButton = ElevatedButton(
    //   child: Text("Send",style: getMediumStyle(color: ColorManager.white,fontSize: FontSize.s12),),
    //   onPressed: () {
    //     setState(() {
    //       Navigator.of(context).pop();
    //       _loginViewModel.login();
    //       showAlertDialogForSucsess();
    //     });
    //   },
    // );

    // AlertDialog alert = AlertDialog(
    //   contentPadding: const EdgeInsets.all(AppPadding.p16),
    //   title: Image.asset(
    //     ImageAssets.alertQuestionMark,
    //     width: AppSize.s60,
    //     height: AppSize.s60,
    //   ),
    //   content: Text(
    //     'Are you sure you want to logout?',
    //     style: TextStyle(color: ColorManager.surveyNameColor),
    //   ),

    AlertDialog alert = AlertDialog(
      actionsAlignment: MainAxisAlignment.center,
      actionsPadding:
          const EdgeInsets.only(bottom: AppSize.s24, top: AppSize.s24),
      contentPadding: const EdgeInsets.only(
          top: AppSize.s24, left: AppSize.s24, right: AppSize.s24),
      // title: Image.asset(
      //   ImageAssets.alert,
      //   width: AppSize.s60,
      //   height: AppSize.s60,
      // ),
      content: StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'If you have an active account with Avantis, use that email below to send us your MAID:',
              style: getMediumStyle(
                  color: ColorManager.black, fontSize: FontSize.s14),
            ),
            const SizedBox(
              height: AppSize.s12,
            ),
            StreamBuilder<String?>(
              stream: _loginViewModel.outputIsEmailAddressValid,
              builder: (context, snapshot) {
                return TextFormField(
                    maxLength: 100,
                    keyboardType: TextInputType.emailAddress,
                    controller: _emailAddressController,
                    decoration: InputDecoration(
                      counterText: "",
                      hintText: AppStrings.emailAddress,
                      labelText: AppStrings.emailAddress,
                      errorText: snapshot.data,
                    ));
              },
            ),

            StreamBuilder<bool>(
                stream: _loginViewModel.outputIsAllInputsValid1,
                builder: (context, snapshot) {
                  return (snapshot.data ?? false) || isUserNotRegistred
                      ? Padding(
                          padding: const EdgeInsets.only(
                              top: AppPadding.p8,
                              left: AppPadding.p16,
                              right: AppPadding.p16),
                          child: Text(
                            "Please use email address entered at signup with Avantis Privacy. If you haven’t signed up for Location Purge, click here.",
                            style: getRegularStyle(
                                color: ColorManager.error,
                                fontSize: FontSize.s12),
                          ),
                        )
                      : const SizedBox(
                          height: AppSize.s0,
                        );
                }),

            // isUserNotRegistred ? Padding(padding: const EdgeInsets.only(top: AppPadding.p8,left: AppPadding.p16,right: AppPadding.p16),child: Text("Please use email address entered at signup with Avantis Privacy. If you haven’t signed up for Location Purge, click here.",style: getRegularStyle(color: ColorManager.error,fontSize: FontSize.s12),),) : const SizedBox(
            // height: AppSize.s16,),
            const SizedBox(
              height: AppSize.s16,
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                InkWell(
                  onTap: () {
                    setState(() {
                      _loginViewModel.setIsCustomer();
                    });
                  },
                  child: checkCheckBox(_loginViewModel.isCustomer),
                ),
                const SizedBox(
                  width: AppSize.s4,
                ),
                Text("I'm an Avantis Location Purge client.",
                    style: getMediumStyle(
                        color: ColorManager.black, fontSize: FontSize.s14)),
              ],
            ),

            const SizedBox(
              height: AppSize.s12,
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                InkWell(
                  onTap: () {
                    setState(() {
                      _loginViewModel.setPassword();
                    });
                  },
                  child: checkCheckBox(_loginViewModel.isCheckBoxSeleccted),
                ),
                const SizedBox(
                  width: AppSize.s4,
                ),
                Text('I agree to the ',
                    style: getMediumStyle(
                        color: ColorManager.black, fontSize: FontSize.s14)),
                InkWell(
                  onTap: () async => await launchUrl(Uri.parse(
                      'https://avantisprivacy.com/privacy-policy-tos/')),
                  child: Text('Terms of Service.',
                      style: getMediumStyle(
                          color: ColorManager.avantisGold,
                          fontSize: FontSize.s14)),
                ),
              ],
            ),
          ],
        );
      }),

      actions: [
        continueButton,
      ],
    );
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  checkCheckBox(bool value) {
    return value ? CheckedCheckBox() : UncheckedCheckBox();
  }

  showAlertDialogForSucsess() {
    AlertDialog alert = AlertDialog(
      actionsAlignment: MainAxisAlignment.center,
      contentPadding: const EdgeInsets.only(
          top: AppSize.s24,
          left: AppSize.s24,
          right: AppSize.s24,
          bottom: AppSize.s24),
      // title: Image.asset(
      //   ImageAssets.alert,
      //   width: AppSize.s60,
      //   height: AppSize.s60,
      // ),
      content: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Text(
          //   'Purge Local Location Data',
          //   style: getBoldStyle(
          //       color: ColorManager.avantisGold, fontSize: FontSize.s20),
          // ),
          // const SizedBox(
          //   height: AppSize.s16,
          // ),
          Text(
            Platform.isAndroid && buildVersion >= 12
                ? 'Your MAID has been successfully sent to Avantis! It is critical that you now delete your MAID to avoid any further tracking.'
                : 'Your MAID has been successfully sent to Avantis! It is critical that you now turn off your MAID to avoid any further tracking.',
            style: getMediumStyle(
                color: ColorManager.black, fontSize: FontSize.s14),
          ),
          const SizedBox(
            height: AppSize.s16,
          ),
          FlutterSwitch(
              activeColor: ColorManager.avantisPink,
              height: AppSize.s26,
              width: AppSize.s45,
              value: isTrakingEnabled,
              onToggle: (val) async {
                if (Platform.isAndroid) {
                  Navigator.of(context).pop();
                  showAlertDialogForGotoSettings();
                  // String action =
                  //     "com.google.android.gms.settings.ADS_PRIVACY";
                  // AndroidIntent settings = AndroidIntent(action: action);

                  // await settings.launch();
                } else if (Platform.isIOS) {
                  Navigator.of(context).pop();
                  showAlertDialogForGotoSettings();
                  // AppSettings.openAppSettings(type: AppSettingsType.security);
                }
              }),

          const SizedBox(
            height: AppSize.s12,
          ),
          Text(
            Platform.isAndroid && buildVersion >= 12
                ? "Click to delete your MAID."
                : 'Click to turn off your MAID.',
            style: getMediumStyle(
                color: ColorManager.black, fontSize: FontSize.s14),
          ),
        ],
      ),
    );
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  showAlertDialogForDisabled() {
    AlertDialog alert = AlertDialog(
      actionsAlignment: MainAxisAlignment.center,
      contentPadding: const EdgeInsets.only(
          top: AppSize.s24,
          left: AppSize.s24,
          right: AppSize.s24,
          bottom: AppSize.s24),
      // title: Image.asset(
      //   ImageAssets.alert,
      //   width: AppSize.s60,
      //   height: AppSize.s60,
      // ),
      content: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Text(
          //   'Purge Local Location Data',
          //   style: getBoldStyle(
          //       color: ColorManager.avantisGold, fontSize: FontSize.s20),
          // ),
          // const SizedBox(
          //   height: AppSize.s16,
          // ),
          Text(
            'Please enable MAID to send it.',
            style: getMediumStyle(
                color: ColorManager.black, fontSize: FontSize.s14),
          ),
          const SizedBox(
            height: AppSize.s16,
          ),
          FlutterSwitch(
              activeColor: ColorManager.avantisPink,
              height: AppSize.s26,
              width: AppSize.s45,
              value: isTrakingEnabled,
              onToggle: (val) async {
                if (Platform.isAndroid) {
                  showAlertDialogForGotoSettings();
                  // String action = "com.google.android.gms.settings.ADS_PRIVACY";
                  // AndroidIntent settings = AndroidIntent(action: action);

                  // await settings.launch();
                } else if (Platform.isIOS) {
                  AppSettings.openAppSettings(type: AppSettingsType.security);
                }
              }),

          const SizedBox(
            height: AppSize.s16,
          ),
          Text(
            'Your MAID is disabled. Temporarily enable it to for an External Purge.',
            style: getMediumStyle(
              color: ColorManager.black,
              fontSize: FontSize.s14,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  showAlertDialogForDisabledMAID12() {
    AlertDialog alert = AlertDialog(
      actionsAlignment: MainAxisAlignment.center,
      contentPadding: const EdgeInsets.only(
          top: AppSize.s24,
          left: AppSize.s24,
          right: AppSize.s24,
          bottom: AppSize.s24),
      // title: Image.asset(
      //   ImageAssets.alert,
      //   width: AppSize.s60,
      //   height: AppSize.s60,
      // ),
      content: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Text(
          //   'Purge Local Location Data',
          //   style: getBoldStyle(
          //       color: ColorManager.avantisGold, fontSize: FontSize.s20),
          // ),
          // const SizedBox(
          //   height: AppSize.s16,
          // ),
          Text(
            'You have not sent your MAID to Avantis. Please consider signing up as only deleting your MAID will do little to protect you. To prevent future tracking through data matching, signup for Location Purge.',
            style: getMediumStyle(
                color: ColorManager.black, fontSize: FontSize.s14),
          ),
          const SizedBox(
            height: AppSize.s12,
          ),
          ElevatedButton(
              onPressed: () async {
                await launchUrl(
                    Uri.parse('https://avantisprivacy.com/location-purge-lp/'));
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: ColorManager.avantisPink,
              ),
              child: Text(
                "Sign up",
                style: getMediumStyle(
                    fontSize: FontSize.s12, color: ColorManager.white),
              )),

          const SizedBox(
            height: AppSize.s24,
          ),
          Text(
            'I understand the risk and want to delete my MAID without sending to Avantis.',
            style: getMediumStyle(
                color: ColorManager.black, fontSize: FontSize.s14),
          ),
          const SizedBox(
            height: AppSize.s12,
          ),
          ElevatedButton(
              onPressed: () async {
                Navigator.of(context).pop();
                showAlertDialogForGotoSettings();
                // const intent = AndroidIntent(
                //         action: 'android.settings.PRIVACY_SETTINGS',
                //       );
                //       await intent.launch();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: ColorManager.avantisBlue,
              ),
              child: Text(
                "Delete Anyway",
                style: getMediumStyle(
                    fontSize: FontSize.s12, color: ColorManager.white),
              )),
        ],
      ),
    );
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  showAlertDialogForEnableMAID12(bool isPergeExternal) {
    AlertDialog alert = AlertDialog(
      //actionsAlignment: MainAxisAlignment.center,
      contentPadding: const EdgeInsets.only(
          top: AppSize.s24,
          left: AppSize.s24,
          right: AppSize.s24,
          bottom: AppSize.s24),
      actionsPadding: const EdgeInsets.only(
          left: AppSize.s24, right: AppSize.s24, bottom: AppSize.s24),
      // title: Image.asset(
      //   ImageAssets.alert,
      //   width: AppSize.s60,
      //   height: AppSize.s60,
      // ),
      content: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Text(
          //   'Purge Local Location Data',
          //   style: getBoldStyle(
          //       color: ColorManager.avantisGold, fontSize: FontSize.s20),
          // ),
          // const SizedBox(
          //   height: AppSize.s16,
          // ),
          // Text(isPergeExternal ? "Unfortunately, we will not be able to receive your MAID to delete your location data as your MAID has been deleted. Please signup for our newsletter as we are adding new services that may be of interest to you!" :
          //   '‘Your MAID has been deleted. If you have sent it to us you are protected. If not, please signup for our newsletter as we are adding new services that may be of interest to you!',
          //   style: getMediumStyle(
          //       color: ColorManager.black, fontSize: FontSize.s14),
          // ),

          Text(
            isPergeExternal
                ? "Your MAID is not available. By turning it off previously, you have deleted it.\n\n"
                    "MAIDs cannot be recovered. Unless you have a record of it, any location history outside your phone cannot be deleted.\n\n"
                    "Turning on tracking will generate a new MAID."
                : "Your MAID is not available. By turning it off previously, you have deleted it.\n\n"
                    "MAIDs cannot be recovered. Unless you have a record of it, any location history outside your phone cannot be deleted.\n\n"
                    "Turning on tracking will generate a new MAID.",

            // "Your MAID is disabled. In newer versions of Android (v 12+), re-enabling MAID tracking will generate a new identifier. Unless you have a record of your previous MAID, it cannot be recovered and purged externally. If you have already sent your MAID to us, you are protected."
            // : 'Your MAID is disabled. In newer versions of Android (v 12+), re-enabling MAID tracking will generate a new identifier. Unless you have a record of your previous MAID, it cannot be recovered and purged externally. If you have already sent your MAID to us, you are protected.',
            style: getMediumStyle(
                color: ColorManager.black, fontSize: FontSize.s14),
          ),

          // const SizedBox(
          //   height: AppSize.s16,
          // ),
          // ElevatedButton(
          //     onPressed: () async {
          //       await launchUrl(
          //           Uri.parse('https://avantisprivacy.com/location-purge-lp/'));
          //     },
          //     style: ElevatedButton.styleFrom(
          //       backgroundColor: ColorManager.avantisPink,
          //     ),
          //     child: Text(
          //       "Sign up",
          //       style: getMediumStyle(
          //           fontSize: FontSize.s12, color: ColorManager.white),
          //     )),
        ],
      ),
      actions: [
        ElevatedButton(
          onPressed: () async {
            Navigator.pop(context);
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: ColorManager.avantisBlue,
          ),
          child: const Text('No Thanks'),
        ),
        ElevatedButton(
          onPressed: () async {
            Navigator.pop(context);
            showAlertDialogForGotoSettings1();
          },
          child: const Text('Get New MAID'),
        ),
      ],
    );
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  // _launchSettings() async {
  //   const url =
  //       'prefs:root=General'; // Use 'General' to open the general settings
  //   if (await canLaunch(url)) {
  //     await launch(url);
  //   } else {
  //     // Handle the case where the user's device does not support launching the settings.
  //     print('Could not launch $url');
  //   }
  // }

  showAlertDialogForGotoSettings() {
    Widget openSettingsBtn = ElevatedButton(
      child: Text(
        "Go to Settings",
        style:
            getMediumStyle(color: ColorManager.white, fontSize: FontSize.s12),
      ),
      onPressed: () {
        setState(() {
          Navigator.of(context).pop();
          AppSettings.openAppSettings(
              type: AppSettingsType.display, asAnotherTask: true);
        });
      },
    );
    AlertDialog alert = AlertDialog(
      actionsAlignment: MainAxisAlignment.center,
      actionsPadding: const EdgeInsets.only(
          left: AppSize.s24, right: AppSize.s24, bottom: AppSize.s24),
      contentPadding: const EdgeInsets.only(
          top: AppSize.s24,
          left: AppSize.s24,
          right: AppSize.s24,
          bottom: AppSize.s24),
      // title: Image.asset(
      //   ImageAssets.alert,
      //   width: AppSize.s60,
      //   height: AppSize.s60,
      // ),
      content: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            Platform.isAndroid ? 'Delete Your MAID' : "Turn off Tracking",
            style: getSemiBoldStyle(
                color: ColorManager.avantisGold, fontSize: FontSize.s18),
          ),
          const SizedBox(
            height: AppSize.s12,
          ),
          Text(
            Platform.isAndroid
                ? 'To delete your MAID - Go to Settings > Privacy > Ads, then tap Delete advertising ID.'
                : "To turn off tracking - Go to Settings >  Privacy & Security > Tracking ,then turn off Allow Apps To Request To Track.",
            style: getMediumStyle(
                color: ColorManager.black, fontSize: FontSize.s14),
          ),
        ],
      ),
      actions: [
        openSettingsBtn,
      ],
    );
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  showAlertDialogForGotoSettings1() {
    Widget openSettingsBtn = ElevatedButton(
      child: Text(
        "Go to Settings",
        style:
            getMediumStyle(color: ColorManager.white, fontSize: FontSize.s12),
      ),
      onPressed: () {
        setState(() {
          Navigator.of(context).pop();
          AppSettings.openAppSettings(
              type: AppSettingsType.device, asAnotherTask: true);
        });
      },
    );
    AlertDialog alert = AlertDialog(
      actionsAlignment: MainAxisAlignment.center,
      actionsPadding: const EdgeInsets.only(bottom: AppSize.s24),
      contentPadding: const EdgeInsets.only(
          top: AppSize.s24,
          left: AppSize.s24,
          right: AppSize.s24,
          bottom: AppSize.s24),
      // title: Image.asset(
      //   ImageAssets.alert,
      //   width: AppSize.s60,
      //   height: AppSize.s60,
      // ),
      content: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Text(
          //   Platform.isAndroid ? 'Get New MAID' : "Turn on Tracking",
          //   style: getSemiBoldStyle(
          //       color: ColorManager.avantisGold, fontSize: FontSize.s18),
          // ),
          // const SizedBox(
          //   height: AppSize.s12,
          // ),

          Text(
            "Your tracking has been globally disabled. To view your MAID, temporarily re-enable global tracking. Instructions are below:\n\n"
            "Go to the Settings menu.\n"
            "Open Privacy & Security menu.\n"
            "Open Tracking.\n"
            'Toggle "Allow Apps to Request to Track" to On.\n'
            "If prompted, confirm.\n\n"
            "Once MAID processing is complete, you can and should disable global tracking. We will prompt you.\n",
            style: getMediumStyle(
                color: ColorManager.black, fontSize: FontSize.s14),
          ),
          RichText(
                      textAlign: TextAlign.left,
                      text: TextSpan(children: [
                        TextSpan(
                            style: getMediumStyle(
                                color: ColorManager.black,
                                fontSize: FontSize.s14),
                            text:
                                "Video of the steps: "),
                        TextSpan(
                          style: TextStyle(
                            fontWeight: FontWeightManager.semiBold,
                            fontSize: FontSize.s14,
                            fontFamily: FontConstants.fontFamily,
                            color: ColorManager.avantisGold,
                            decoration: TextDecoration.underline,
                          ),
                          text: "https://youtu.be/cefO0lm2EC0%22",
                          recognizer: TapGestureRecognizer()
                            ..onTap = () async {
                              await launchUrl(
                                  Uri.parse('https://youtu.be/cefO0lm2EC0%22'));
                            },
                        ),
                      ]))




          
       





          // Text(
          //   Platform.isAndroid
          //       ? 'To get new MAID - Go to Settings > Privacy > Ads, then tap Get new advertising ID.'
          //       : "To turn on tracking - Go to Settings >  Privacy & Security > Tracking ,then turn on Allow Apps To Request To Track.",
          //   style: getMediumStyle(
          //       color: ColorManager.black, fontSize: FontSize.s14),
          // ),
        ],
      ),
      actions: [
        openSettingsBtn,
      ],
    );
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}

class CheckedCheckBox extends StatelessWidget {
  Color radioColor;
  CheckedCheckBox({Key? key, this.radioColor = const Color(0xFFC09960)})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Icon(
      Icons.check_box,
      color: radioColor,
    );
  }
}

class UncheckedCheckBox extends StatelessWidget {
  Color radioColor;
  UncheckedCheckBox({Key? key, this.radioColor = const Color(0xFFC09960)})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Icon(
      Icons.check_box_outline_blank,
      color: radioColor,
    );
  }
}
