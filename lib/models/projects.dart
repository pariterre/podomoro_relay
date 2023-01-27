import 'package:flutter/material.dart';

class Project {
  String name;
  DateTime startTime;
  DateTime endTime;
  List<int> participants;
  Color color;

  Project({
    required this.name,
    required this.startTime,
    required this.endTime,
    required this.participants,
    required this.color,
  });
}
