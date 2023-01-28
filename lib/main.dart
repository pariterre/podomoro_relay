import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '/screens/gantt_chart_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyCustomScrollBehavior extends MaterialScrollBehavior {
  @override
  Set<PointerDeviceKind> get dragDevices =>
      {PointerDeviceKind.touch, PointerDeviceKind.mouse};
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        scrollBehavior: MyCustomScrollBehavior(),
        debugShowCheckedModeBanner: false,
        initialRoute: GanttChartScreen.route,
        routes: {
          GanttChartScreen.route: (context) => const GanttChartScreen(),
        });
  }
}
