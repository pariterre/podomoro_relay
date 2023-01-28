import 'dart:io';

import 'package:flutter/material.dart';
import '/screens/gantt_chart_screen.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key});

  void _loadJson(BuildContext context) {
    Navigator.of(context).pushReplacementNamed(GanttChartScreen.route);
  }

  @override
  Widget build(BuildContext context) {
    final files = Directory('assets/').listSync();
    final List<Widget> scenarios = [];
    for (final file in files) {
      final filename = file.path.split("/").last.split(".").first;
      scenarios.add(ListTile(
        title: Text(filename),
        onTap: () => _loadJson(context),
      ));
    }

    ListView(children: scenarios);

    return Container();
  }
}
