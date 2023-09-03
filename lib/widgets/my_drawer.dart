import 'dart:convert';
import 'dart:io';

import 'package:universal_html/html.dart' as html;

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '/models/project.dart';
import '/screens/gantt_chart_screen.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key, required this.project});

  final Project project;

  Future<void> _newFile(BuildContext context) async {
    final navigator = Navigator.of(context);
    final shouldCreateNewFile = await showDialog<bool?>(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Êtes vous certain?'),
            actions: [
              TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: const Text('Annuler')),
              TextButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  child: const Text('Confirmer'))
            ],
          );
        });
    if (shouldCreateNewFile == null || !shouldCreateNewFile) return;

    navigator.pushNamed(GanttChartScreen.route);
  }

  Future<void> _load(BuildContext context) async {
    final navigator = Navigator.of(context);

    final filename = await FilePicker.platform.pickFiles(
        allowMultiple: false,
        allowedExtensions: ['json'],
        type: FileType.custom);
    if (filename == null) return;

    final serializedData =
        String.fromCharCodes(filename.files.last.bytes!.toList());

    navigator.pushReplacementNamed(GanttChartScreen.route,
        arguments: serializedData);
  }

  Future<void> _save(BuildContext context) async {
    final navigator = Navigator.of(context);

    final map = project.serialize();
    JsonEncoder encoder = const JsonEncoder.withIndent('  ');
    String json = encoder.convert(map);

    if (kIsWeb) {
      // prepare
      final bytes = utf8.encode(json);
      final blob = html.Blob([bytes]);
      final url = html.Url.createObjectUrlFromBlob(blob);
      final anchor = html.document.createElement('a') as html.AnchorElement
        ..href = url
        ..download = 'mon_projet.json';
      html.document.body!.children.add(anchor);

      // download
      anchor.click();

      // cleanup
      html.document.body!.children.remove(anchor);
      html.Url.revokeObjectUrl(url);
    } else {
      String? filename = await FilePicker.platform.saveFile(
          //allowMultiple: false,
          allowedExtensions: ['json'],
          type: FileType.custom);
      if (filename == null) return;

      if (!RegExp(r'^.*\.json$').hasMatch(filename)) filename += '.json';
      final file = File(filename);
      file.writeAsStringSync(json);
    }

    navigator.pop();
  }

  @override
  Widget build(BuildContext context) {
    final newFile = ListTile(
      title: const Text('Nouveau fichier'),
      onTap: () => _newFile(context),
    );

    final loadTile = ListTile(
      title: const Text('Charger'),
      onTap: () => _load(context),
    );

    final saveTile = ListTile(
      title: const Text('Sauvegarder'),
      onTap: () => _save(context),
    );

    return Drawer(
        child: ListView(children: [
      newFile,
      loadTile,
      saveTile,
    ]));
  }
}
