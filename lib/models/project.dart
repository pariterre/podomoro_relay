import 'dart:convert';

import 'package:flutter/material.dart';

import 'task.dart';
import 'users.dart';

export 'task.dart';
export 'users.dart';

class Project {
  final List<User> users;
  final List<Task> tasks;

  Project({this.users = const [], this.tasks = const []});

  static Future<Project> fromJson(BuildContext context, String jsonPath) async {
    String data = await DefaultAssetBundle.of(context).loadString(jsonPath);
    final jsonResult = jsonDecode(data);

    final users =
        jsonResult["users"].map<User>((e) => User.fromSerialized(e)).toList();
    final tasks =
        jsonResult["tasks"].map<Task>((e) => Task.fromSerialized(e)).toList();

    return Project(users: users, tasks: tasks);
  }
}
