// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:location_purge_maid_finder/app/app.dart';


class Test extends StatelessWidget {
  const Test({Key? key}) : super(key: key);

  void updateAppState() {
    MyApp.instance.appState = 10;
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
