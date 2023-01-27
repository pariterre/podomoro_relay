import 'package:enhanced_containers/enhanced_containers.dart';
import 'package:flutter/material.dart';

class Project extends ItemSerializable {
  String name;
  DateTime startTime;
  DateTime endTime;
  List<String> participants;
  Color color;

  Project({
    required this.name,
    required this.startTime,
    required this.endTime,
    required this.participants,
    required this.color,
  });

  Project.fromSeralized(map)
      : name = map['name'],
        startTime = map['startTime'],
        endTime = map['endTime'],
        participants = map['participants'],
        color = Color(map['color']),
        super.fromSerialized(map);

  @override
  Map<String, dynamic> serializedMap() => {
        'name': name,
        'startTime': startTime,
        'endTime': endTime,
        'participants': participants,
        'color': color.value
      };
}
