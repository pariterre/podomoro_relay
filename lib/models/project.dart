import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';

import 'task.dart';
import 'users.dart';

export 'task.dart';
export 'users.dart';

class Project {
  final DateTime startingTime;
  final DateTime endingTime;
  final List<User> users;
  final List<Task> tasks;

  const Project({
    required this.startingTime,
    required this.endingTime,
    this.users = const [],
    this.tasks = const [],
  });

  static Future<Project> fromJson(BuildContext context, String jsonPath) async {
    final data = await File(jsonPath).readAsString();
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
}
