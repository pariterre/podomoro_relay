import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '/screens/gantt_chart_screen.dart';
import '/models/projects.dart';
import '/models/users.dart';

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

  DateTime get startingTime => DateTime(1, 1, 1, 12, 00);
  DateTime get endingTime => DateTime(1, 1, 2, 14, 00);
  List<User> get users => [
        User(id: '1', name: 'Streamer 1'),
        User(id: '2', name: 'Streamer 2'),
        User(id: '3', name: 'Streamer 3'),
        User(id: '4', name: 'Streamer 4'),
        User(id: '5', name: 'Streamer 5'),
      ];

  List<Project> get projects => [
        Project(
            name: 'Accueil',
            startTime: DateTime(1, 1, 1, 12, 30),
            endTime: DateTime(1, 1, 1, 12, 40),
            participants: ['1', '2', '3', '4', '5'],
            color: Colors.green),
        Project(
            name: 'Prez 1',
            startTime: DateTime(1, 1, 1, 12, 40),
            endTime: DateTime(1, 1, 1, 12, 43),
            participants: ['1'],
            color: Colors.green),
        Project(
            name: 'Prez 2',
            startTime: DateTime(1, 1, 1, 12, 43),
            endTime: DateTime(1, 1, 1, 12, 46),
            participants: ['2'],
            color: Colors.green),
        Project(
            name: 'Prez 3',
            startTime: DateTime(1, 1, 1, 12, 46),
            endTime: DateTime(1, 1, 1, 12, 49),
            participants: ['3'],
            color: Colors.green),
        Project(
            name: 'Prez 4',
            startTime: DateTime(1, 1, 1, 12, 49),
            endTime: DateTime(1, 1, 1, 12, 52),
            participants: ['4'],
            color: Colors.green),
        Project(
            name: 'Prez 5',
            startTime: DateTime(1, 1, 1, 12, 52),
            endTime: DateTime(1, 1, 1, 12, 55),
            participants: ['5'],
            color: Colors.green),
        Project(
            name: 'Pomodoro',
            startTime: DateTime(1, 1, 1, 12, 55),
            endTime: DateTime(1, 1, 1, 17, 00),
            participants: ['1'],
            color: Colors.purple),
        Project(
            name: 'Pomodoro',
            startTime: DateTime(1, 1, 1, 17, 55),
            endTime: DateTime(1, 1, 1, 22, 00),
            participants: ['2'],
            color: Colors.purple),
        Project(
            name: 'Pomodoro',
            startTime: DateTime(1, 1, 1, 22, 55),
            endTime: DateTime(1, 1, 2, 3, 00),
            participants: ['3'],
            color: Colors.purple),
        Project(
            name: 'Pomodoro',
            startTime: DateTime(1, 1, 2, 3, 55),
            endTime: DateTime(1, 1, 2, 8, 00),
            participants: ['4'],
            color: Colors.purple),
        Project(
            name: 'Pomodoro',
            startTime: DateTime(1, 1, 2, 8, 55),
            endTime: DateTime(1, 1, 2, 13, 00),
            participants: ['5'],
            color: Colors.purple),
        Project(
            name: 'Connection 2',
            startTime: DateTime(1, 1, 1, 16, 50),
            endTime: DateTime(1, 1, 1, 17, 00),
            participants: ['2'],
            color: Colors.orange),
        Project(
            name: '1 et 2',
            startTime: DateTime(1, 1, 1, 17, 00),
            endTime: DateTime(1, 1, 1, 17, 15),
            participants: ['1', '2'],
            color: Colors.green),
        Project(
            name: 'Connection 3',
            startTime: DateTime(1, 1, 1, 21, 50),
            endTime: DateTime(1, 1, 1, 22, 00),
            participants: ['3'],
            color: Colors.orange),
        Project(
            name: '2 et 3',
            startTime: DateTime(1, 1, 1, 22, 00),
            endTime: DateTime(1, 1, 1, 22, 15),
            participants: ['2', '2'],
            color: Colors.green),
        Project(
            name: 'Connection 4',
            startTime: DateTime(1, 1, 2, 2, 50),
            endTime: DateTime(1, 1, 2, 3, 00),
            participants: ['4'],
            color: Colors.orange),
        Project(
            name: '3 et 4',
            startTime: DateTime(1, 1, 2, 3, 00),
            endTime: DateTime(1, 1, 2, 3, 15),
            participants: ['3', '4'],
            color: Colors.green),
        Project(
            name: 'Connection 5',
            startTime: DateTime(1, 1, 2, 7, 50),
            endTime: DateTime(1, 1, 2, 8, 00),
            participants: ['5'],
            color: Colors.orange),
        Project(
            name: '4 et 5',
            startTime: DateTime(1, 1, 2, 8, 00),
            endTime: DateTime(1, 1, 2, 8, 15),
            participants: ['4', '5'],
            color: Colors.green),
        Project(
            name: 'Connection 1',
            startTime: DateTime(1, 1, 2, 12, 50),
            endTime: DateTime(1, 1, 2, 13, 00),
            participants: ['1'],
            color: Colors.orange),
        Project(
            name: '5 et 1',
            startTime: DateTime(1, 1, 2, 13, 00),
            endTime: DateTime(1, 1, 2, 13, 15),
            participants: ['5', '1'],
            color: Colors.green),
        Project(
            name: 'Pause',
            startTime: DateTime(1, 1, 1, 17, 15),
            endTime: DateTime(1, 1, 1, 17, 30),
            participants: ['1', '2', '3', '4', '5'],
            color: Colors.blue),
        Project(
            name: 'Pause',
            startTime: DateTime(1, 1, 1, 22, 15),
            endTime: DateTime(1, 1, 1, 22, 30),
            participants: ['1', '2', '3', '4', '5'],
            color: Colors.blue),
        Project(
            name: 'Pause',
            startTime: DateTime(1, 1, 2, 3, 15),
            endTime: DateTime(1, 1, 2, 3, 30),
            participants: ['1', '2', '3', '4', '5'],
            color: Colors.blue),
        Project(
            name: 'Pause',
            startTime: DateTime(1, 1, 2, 8, 15),
            endTime: DateTime(1, 1, 2, 8, 30),
            participants: ['1', '2', '3', '4', '5'],
            color: Colors.blue),
        Project(
            name: 'Connection 4',
            startTime: DateTime(1, 1, 1, 17, 20),
            endTime: DateTime(1, 1, 1, 17, 30),
            participants: ['4'],
            color: Colors.orange),
        Project(
            name: '2 et 4',
            startTime: DateTime(1, 1, 1, 17, 30),
            endTime: DateTime(1, 1, 1, 17, 55),
            participants: ['2', '4'],
            color: Colors.green),
        Project(
            name: 'Connection 5',
            startTime: DateTime(1, 1, 1, 22, 20),
            endTime: DateTime(1, 1, 1, 22, 30),
            participants: ['5'],
            color: Colors.orange),
        Project(
            name: '3 et 5',
            startTime: DateTime(1, 1, 1, 22, 30),
            endTime: DateTime(1, 1, 1, 22, 55),
            participants: ['3', '5'],
            color: Colors.green),
        Project(
            name: 'Connection 1',
            startTime: DateTime(1, 1, 2, 3, 20),
            endTime: DateTime(1, 1, 2, 3, 30),
            participants: ['1'],
            color: Colors.orange),
        Project(
            name: '4 et 1',
            startTime: DateTime(1, 1, 2, 3, 30),
            endTime: DateTime(1, 1, 2, 3, 55),
            participants: ['4', '1'],
            color: Colors.green),
        Project(
            name: 'Connection 2',
            startTime: DateTime(1, 1, 2, 8, 20),
            endTime: DateTime(1, 1, 2, 8, 30),
            participants: ['2'],
            color: Colors.orange),
        Project(
            name: '5 et 2',
            startTime: DateTime(1, 1, 2, 8, 30),
            endTime: DateTime(1, 1, 2, 8, 55),
            participants: ['5', '2'],
            color: Colors.green),
        Project(
            name: 'Connection Tous',
            startTime: DateTime(1, 1, 2, 13, 15),
            endTime: DateTime(1, 1, 2, 13, 20),
            participants: ['1', '2', '3', '4', '5'],
            color: Colors.orange),
        Project(
            name: 'FIN!',
            startTime: DateTime(1, 1, 2, 13, 20),
            endTime: DateTime(1, 1, 2, 13, 30),
            participants: ['1', '2', '3', '4', '5'],
            color: Colors.green),
      ];

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        scrollBehavior: MyCustomScrollBehavior(),
        debugShowCheckedModeBanner: false,
        home: GanttChartScreen(
          startingTime: startingTime,
          endingTime: endingTime,
          users: users,
          projects: projects,
        ));
  }
}
