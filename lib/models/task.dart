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
        startTime = DateTime(
          map['startTime'][0],
          map['startTime'][1],
          map['startTime'][2],
          map['startTime'][3],
          map['startTime'][4],
        ),
        endTime = DateTime(
          map['endTime'][0],
          map['endTime'][1],
          map['endTime'][2],
          map['endTime'][3],
          map['endTime'][4],
        ),
        participants = (map['participants'] as List<dynamic>).cast<String>(),
        color = Color(map['color']),
        super.fromSerialized(map);

  @override
  Map<String, dynamic> serializedMap() => {
        'name': name,
        'startTime': [
          startTime.year,
          startTime.month,
          startTime.day,
          startTime.hour,
          startTime.minute
        ],
        'endTime': [
          endTime.year,
          endTime.month,
          endTime.day,
          endTime.hour,
          endTime.minute
        ],
        'participants': participants,
        'color': color.value
      };
}
