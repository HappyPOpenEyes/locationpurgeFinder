import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../../resources/asset_manager.dart';
import '../../resources/color_manager.dart';
import '../../resources/values_manager.dart';


class ShowLoadingDialog extends StatelessWidget {
  const ShowLoadingDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _getPopUpDialog(context, [_getAnimatedImage(JsonAssets.loading)]);
  }

  Widget _getPopUpDialog(BuildContext context, List<Widget> children) {
    return Dialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSize.s14)),
      elevation: AppSize.s1_5,
      backgroundColor: Colors.transparent,
      child: Container(
        decoration: BoxDecoration(
            color: ColorManager.white,
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.circular(AppSize.s14),
            boxShadow: const [
              BoxShadow(
                  color: Colors.black26,
                  blurRadius: AppSize.s12,
                  offset: Offset(AppSize.s0, AppSize.s12))
            ]),
        child: _getDialogContent(context, children),
      ),
    );
  }

  Widget _getDialogContent(BuildContext context, List<Widget> children) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: children,
    );
  }

  Widget _getAnimatedImage(String animationName) {
    return SizedBox(
      height: AppSize.s65,
      width: AppSize.s100,
      child: Lottie.asset(animationName),
    );
  }
}
