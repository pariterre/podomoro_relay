import 'package:enhanced_containers/enhanced_containers.dart';
import 'package:flutter/material.dart';

class Task extends ItemSerializable {
  String name;
  DateTime startTime;
  DateTime endTime;
  List<String> participants;
  Color color;

  Task({
    required this.name,
    required this.startTime,
    required this.endTime,
    required this.participants,
    required this.color,
  });

  Task.fromSerialized(map)
      : name = map['name'],
        startTime = DateTime(1, 1, map['startTime'][0], map['startTime'][1],
            map['startTime'][2]),
        endTime = DateTime(1, 1, map['endTime'][0], map['endTime'][1],
            map['endTime'][2]),
        participants = (map['participants'] as List<dynamic>).cast<String>(),
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
