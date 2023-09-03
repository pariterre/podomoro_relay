import 'dart:convert';

import 'task.dart';
import 'users.dart';

export 'task.dart';
export 'users.dart';

class Project {
  DateTime startingTime;
  DateTime endingTime;
  List<User> users;
  List<Task> tasks;

  Project({
    DateTime? startingTime,
    DateTime? endingTime,
    List<User>? users,
    List<Task>? tasks,
  })  : startingTime = startingTime ?? DateTime.now(),
        endingTime = endingTime ?? DateTime.now().add(const Duration(days: 1)),
        users = users ?? [],
        tasks = tasks ?? [];

  static Future<Project> fromSerialized(String data) async {
    final jsonResult = jsonDecode(data);

    final s = jsonResult["startingTime"];
    final startingTime = DateTime(s[0], s[1], s[2], s[3], s[4]);

    final e = jsonResult["endingTime"];
    final endingTime = DateTime(e[0], e[1], e[2], e[3], e[4]);

    final users =
        jsonResult["users"].map<User>((e) => User.fromSerialized(e)).toList();
    final tasks =
        jsonResult["tasks"].map<Task>((e) => Task.fromSerialized(e)).toList();

    return Project(
      startingTime: startingTime,
      endingTime: endingTime,
      users: users,
      tasks: tasks,
    );
  }

  Map<String, dynamic> serialize() {
    final map = {
      "startingTime": [
        startingTime.year,
        startingTime.month,
        startingTime.day,
        startingTime.hour,
        startingTime.minute
      ],
      "endingTime": [
        endingTime.year,
        endingTime.month,
        endingTime.day,
        endingTime.hour,
        endingTime.minute
      ],
      "users": users.map<Map<String, dynamic>>((e) => e.serialize()).toList(),
      "tasks": tasks.map<Map<String, dynamic>>((e) => e.serialize()).toList(),
    };

    return map;
  }
}
