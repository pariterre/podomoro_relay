import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_time_picker_spinner/flutter_time_picker_spinner.dart';

import '/models/project.dart';

class TaskManager extends StatefulWidget {
  const TaskManager({Key? key, required this.project, this.taskIndex})
      : super(key: key);

  final Project project;
  final int? taskIndex;

  @override
  State<TaskManager> createState() => _TaskManagerState();
}

class _TaskManagerState extends State<TaskManager> {
  String _taskName = '';
  late DateTime _startTime = widget.project.startingTime;
  late DateTime _endTime = widget.project.endingTime;
  final List<String> _participants = [];
  Color _color = Colors.black;

  @override
  void initState() {
    super.initState();

    if (widget.taskIndex != null) {
      final defaultTask = widget.project.tasks[widget.taskIndex!];
      _taskName = defaultTask.name;
      _startTime = defaultTask.startTime;
      _endTime = defaultTask.endTime;

      for (final id in defaultTask.participants) {
        _participants.add(id);
      }
      _color = defaultTask.color;
    }
  }

  void _clickToggleParticipant(String id) {
    if (_participants.contains(id)) {
      _participants.remove(id);
    } else {
      _participants.add(id);
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Ajouter une nouvelle tâche',
                style: TextStyle(fontSize: 20)),
            TextFormField(
              initialValue: _taskName,
              onChanged: (value) {
                _taskName = value;
                setState(() {});
              },
              decoration: const InputDecoration(labelText: 'Nom de la tâche'),
            ),
            const Divider(),
            const SizedBox(height: 20),
            const Text('Choisir la date et l\'heure du début',
                style: TextStyle(fontSize: 20)),
            Row(
              children: [
                SizedBox(
                  width: 300,
                  child: CalendarDatePicker(
                    initialDate: _startTime,
                    firstDate: widget.project.startingTime,
                    lastDate: widget.project.endingTime,
                    onDateChanged: (DateTime value) => _startTime = DateTime(
                      value.year,
                      value.month,
                      value.day,
                      _startTime.hour,
                      _startTime.minute,
                    ),
                  ),
                ),
                const VerticalDivider(),
                TimePickerSpinner(
                  time: _startTime,
                  minutesInterval: 5,
                  onTimeChange: (time) => _startTime = DateTime(
                    _startTime.year,
                    _startTime.month,
                    _startTime.day,
                    time.hour,
                    time.minute,
                  ),
                ),
              ],
            ),
            const Divider(),
            const SizedBox(height: 20),
            const Text('Choisir la date et l\'heure de la fin',
                style: TextStyle(fontSize: 20)),
            Row(
              children: [
                SizedBox(
                  width: 300,
                  child: CalendarDatePicker(
                    initialDate: _endTime,
                    firstDate: widget.project.startingTime,
                    lastDate: widget.project.endingTime,
                    onDateChanged: (DateTime value) => _endTime = DateTime(
                      value.year,
                      value.month,
                      value.day,
                      _endTime.hour,
                      _endTime.minute,
                    ),
                  ),
                ),
                const VerticalDivider(),
                TimePickerSpinner(
                  time: _endTime,
                  minutesInterval: 5,
                  onTimeChange: (time) => _endTime = DateTime(
                    _endTime.year,
                    _endTime.month,
                    _endTime.day,
                    time.hour,
                    time.minute,
                  ),
                ),
              ],
            ),
            const Divider(),
            const SizedBox(height: 20),
            const Text('Choisir les participants',
                style: TextStyle(fontSize: 20)),
            ...widget.project.users.map<Widget>((e) => ListTile(
                title: GestureDetector(
                    onTap: () => _clickToggleParticipant(e.id),
                    child: Text(e.name)),
                leading: Checkbox(
                  value: _participants.contains(e.id),
                  onChanged: (val) => _clickToggleParticipant(e.id),
                ))),
            const Divider(),
            const SizedBox(height: 20),
            const Text('Choisir la couleur de la tâche',
                style: TextStyle(fontSize: 20)),
            ColorPicker(
              pickerColor: _color,
              onColorChanged: (value) => _color = value,
            ),
          ],
        ),
      ),
      actions: <Widget>[
        if (widget.taskIndex != null)
          TextButton(
              child:
                  const Text('Supprimer', style: TextStyle(color: Colors.red)),
              onPressed: () => Navigator.pop(context, 'delete')),
        TextButton(
            child: const Text('Annuler'),
            onPressed: () => Navigator.pop(context)),
        TextButton(
            onPressed: _taskName == '' || _participants.isEmpty
                ? null
                : () => Navigator.pop(
                    context,
                    Task(
                      name: _taskName,
                      startTime: _startTime,
                      endTime: _endTime,
                      participants: _participants,
                      color: _color,
                    )),
            child: const Text('Valider')),
      ],
    );
  }
}
