import 'package:flutter/material.dart';
import 'package:location_purge_maid_finder/app/di.dart';
import 'package:location_purge_maid_finder/presentation/Home/home.dart';
import 'package:location_purge_maid_finder/presentation/resources/string_manager.dart';

import '../splash/splash.dart';

class Routes {
  static const String splashRoute = "/";
  static const String homeScreenRoute = "/home";

}

class RouteGenerator {
  static Route<dynamic> getRoute(RouteSettings routeSettings) {
    switch (routeSettings.name) {
      case Routes.splashRoute:
        return MaterialPageRoute(builder: (_) => const SplashView());
       case Routes.homeScreenRoute:
       initLoginModule();
        return MaterialPageRoute(builder: (_) => const HomeView());
      default:
        return unDefinedRoute();
    }
  }

  static Route<dynamic> unDefinedRoute() {
    return MaterialPageRoute(
        builder: (_) => Scaffold(
              appBar: AppBar(
                title: const Text(AppStrings.noRouteFound),
              ),
              body: const Center(child: Text(AppStrings.noRouteFound)),
            ));
  }
}
