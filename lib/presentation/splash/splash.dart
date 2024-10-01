// ignore_for_file: library_private_types_in_public_api

import 'dart:async';


import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../resources/asset_manager.dart';
import '../resources/color_manager.dart';
import '../resources/routes_manager.dart';
import '../resources/values_manager.dart';


class SplashView extends StatefulWidget {
  const SplashView({Key? key}) : super(key: key);

  @override
  _SplashViewState createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  Timer? _timer;
  _startDelay() {
    _timer = Timer(const Duration(seconds: 2), _goNext);
  }

  _goNext() async {
   
      Navigator.pushReplacementNamed(context, Routes.homeScreenRoute);
    
  }

  @override
  void initState() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: SystemUiOverlay.values);
    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(statusBarColor: ColorManager.avantisGold));
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
    super.initState();
    _startDelay();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
        children: <Widget>[
          Image.asset(
            ImageAssets.bottomImage,
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            fit: BoxFit.fill,
          ), const Scaffold(
      backgroundColor: Colors.transparent,
      body: Column(crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
                    Center(
              child: Image(
                width: AppSize.s280,
                //height: AppSize.s130,
                image: AssetImage(ImageAssets.splashLogo),
              ),
            ),
            SizedBox(height: AppSize.s120,),
Center(
              child: Image(
                width: AppSize.s180,
                //height: AppSize.s130,
                image: AssetImage(ImageAssets.homePageMap),
              ),
            ),

      ],
      )
    )],
      );
  }

  
  }

