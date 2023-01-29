import 'dart:io';

import 'package:flutter/material.dart';

import '/models/project.dart';
import '/screens/gantt_chart_screen.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key, required this.project});

  final Project project;

  void _loadJson(BuildContext context, path) {
    Navigator.of(context)
        .pushReplacementNamed(GanttChartScreen.route, arguments: path);
  }

  Future<void> _save(BuildContext context) async {
    final messenger = ScaffoldMessenger.of(context);
    final navigator = Navigator.of(context);

    TextEditingController textFieldController = TextEditingController();
    final filename = await showDialog<String>(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Nom du fichier'),
            content: TextField(
              controller: textFieldController,
              decoration:
                  const InputDecoration(hintText: "Text Field in Dialog"),
            ),
            actions: <Widget>[
              TextButton(
                  child: const Text('Annuler'),
                  onPressed: () => Navigator.pop(context)),
              TextButton(
                  child: const Text('Valider'),
                  onPressed: () {
                    Navigator.pop(context, textFieldController.text);
                  }),
            ],
          );
        });

    if (filename == null) return;

    final files = Directory('assets/').listSync();
    for (final file in files) {
      final previousFilenames = file.path.split("/").last.split(".").first;
      if (filename == previousFilenames) {
        navigator.pop();
        messenger.showSnackBar(const SnackBar(
          content: Text('Nom de fichier déjà utilisé'),
        ));
        return;
      }
    }

    project.toJson('assets/$filename.json');
    navigator.pop();
  }

  @override
  Widget build(BuildContext context) {
    final files = Directory('assets/').listSync();
    final List<Widget> scenarios = [];
    for (final file in files) {
      final filename = file.path.split("/").last.split(".").first;
      scenarios.add(ListTile(
        title: Text(filename),
        onTap: () => _loadJson(context, file.path),
      ));
    }

    final saveTile = ListTile(
      title: const Text('Sauvegarder'),
      onTap: () => _save(context),
    );

    return Drawer(
        child: ListView(children: [
      ...scenarios,
      const Divider(),
      saveTile,
    ]));
  }
}
