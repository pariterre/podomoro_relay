import 'package:flutter/material.dart';
import 'package:flutter_cupertino_datetime_picker/flutter_cupertino_datetime_picker.dart';
import 'package:pomodoro_relay/widgets/manage_user_dialog.dart';
import 'package:pomodoro_relay/widgets/my_drawer.dart';

import '/models/project.dart';
import '/widgets/task_manager.dart';

class GanttChartScreen extends StatefulWidget {
  const GanttChartScreen({super.key});

  static const String route = '/gantt-screen';

  @override
  State<GanttChartScreen> createState() => _GanttChartScreenState();
}

enum TimeZone {
  europe,
  quebec,
}

class _GanttChartScreenState extends State<GanttChartScreen> {
  Project project = Project();
  List<int> possibleTimeIncrements = [5, 10, 15, 30, 60];
  int currentTimeIncrement = 2;
  late int timeIncrements = possibleTimeIncrements[currentTimeIncrement];
  late double viewRange = _calculateNumberOfMinutesBetween(
      project.startingTime, project.endingTime);
  int viewRangeToFitScreen = 60;
  TimeZone currentTimeZone = TimeZone.quebec;

  @override
  void initState() {
    super.initState();

    Future.delayed(Duration.zero, () async {
      final path = ModalRoute.of(context)!.settings.arguments as String?;
      if (path == null) return;
      _loadProject(await Project.fromJson(path));
    });
  }

  void _loadProject(Project newProject) {
    project = newProject;
    viewRange = _calculateNumberOfMinutesBetween(
        project.startingTime, project.endingTime);
    setState(() {});
  }

  double _calculateNumberOfMinutesBetween(DateTime from, DateTime to) {
    return 24 * 60 / timeIncrements * (to.day - from.day) +
        60 / timeIncrements * (to.hour - from.hour) +
        (to.minute - from.minute) / timeIncrements;
  }

  double _calculateDistanceToLeftBorder(DateTime taskStartedAt) {
    if (taskStartedAt.compareTo(project.startingTime) <= 0) {
      return 0;
    } else {
      return _calculateNumberOfMinutesBetween(
          project.startingTime, taskStartedAt);
    }
  }

  double _calculateRemainingWidth(
      DateTime taskStartedAt, DateTime taskEndedAt) {
    double projectLength =
        _calculateNumberOfMinutesBetween(taskStartedAt, taskEndedAt);
    if (taskStartedAt.compareTo(project.startingTime) >= 0 &&
        taskStartedAt.compareTo(project.endingTime) <= 0) {
      if (projectLength <= viewRange) {
        return projectLength;
      } else {
        return viewRange -
            _calculateNumberOfMinutesBetween(
                project.startingTime, taskStartedAt);
      }
    } else if (taskStartedAt.isBefore(project.startingTime) &&
        taskEndedAt.isBefore(project.startingTime)) {
      return 0;
    } else if (taskStartedAt.isBefore(project.startingTime) &&
        taskEndedAt.isBefore(project.endingTime)) {
      return projectLength -
          _calculateNumberOfMinutesBetween(taskStartedAt, project.startingTime);
    } else if (taskStartedAt.isBefore(project.startingTime) &&
        taskEndedAt.isAfter(project.endingTime)) {
      return viewRange;
    }
    return 0;
  }

  List<Widget> _buildChartBars(List<Task> data, double chartViewWidth) {
    List<Widget> chartBars = [];

    for (int i = 0; i < data.length; i++) {
      var remainingWidth =
          _calculateRemainingWidth(data[i].startTime, data[i].endTime);
      if (remainingWidth > 0) {
        chartBars.add(
          GestureDetector(
            onTap: () => _onClickModifyTask(data[i]),
            child: Container(
              decoration: BoxDecoration(
                  color: data[i].color,
                  borderRadius: BorderRadius.circular(10.0)),
              height: 25.0,
              width: remainingWidth * chartViewWidth / viewRangeToFitScreen,
              margin: EdgeInsets.only(
                  left: _calculateDistanceToLeftBorder(data[i].startTime) *
                      chartViewWidth /
                      viewRangeToFitScreen,
                  top: i == 0 ? 4.0 : 2.0,
                  bottom: i == data.length - 1 ? 4.0 : 2.0),
              alignment: Alignment.centerLeft,
              child: Tooltip(
                message: '${data[i].name}\n'
                    'Période : ${data[i].startTime.hour}:${data[i].startTime.minute} -> '
                    '${data[i].endTime.hour}:${data[i].endTime.minute}\n'
                    'Participants : ${data[i].participants}',
                child: Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Text(
                    data[i].name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                        fontSize: 12.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                ),
              ),
            ),
          ),
        );
      }
    }

    return chartBars;
  }

  Widget _buildHeader(double chartViewWidth, Color color) {
    List<Widget> headerItems = [];

    headerItems.add(SizedBox(
      width: chartViewWidth / viewRangeToFitScreen,
      child: const Text(
        'NAME',
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 10.0,
        ),
      ),
    ));

    DateTime tempDate = project.startingTime;
    int timeZoneOffset = currentTimeZone == TimeZone.quebec ? 0 : 6;
    for (int i = 0; i < viewRange; i++) {
      headerItems.add(SizedBox(
        width: chartViewWidth / viewRangeToFitScreen,
        child: Text(
          '${(tempDate.hour + timeZoneOffset) % 24}:${tempDate.minute != 0 ? tempDate.minute : '00'}',
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 10.0,
            fontWeight: FontWeight.bold,
          ),
        ),
      ));
      tempDate = tempDate.add(Duration(minutes: timeIncrements));
    }

    return Container(
      height: 25.0,
      color: color.withAlpha(100),
      child: Row(
        children: headerItems,
      ),
    );
  }

  Widget _buildGrid(double chartViewWidth) {
    List<Widget> gridColumns = [];

    for (int i = 0; i <= viewRange; i++) {
      gridColumns.add(Container(
        decoration: BoxDecoration(
            border: Border(
                right:
                    BorderSide(color: Colors.grey.withAlpha(100), width: 1.0))),
        width: chartViewWidth / viewRangeToFitScreen,
      ));
    }

    return Row(
      children: gridColumns,
    );
  }

  Widget _buildChartForEachUser(
      List<Task> userData, double chartViewWidth, User user) {
    var chartBars = _buildChartBars(userData, chartViewWidth);
    return SizedBox(
      height: chartBars.length * 29.0 + 25.0 + 4.0,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          Stack(fit: StackFit.loose, children: <Widget>[
            _buildGrid(chartViewWidth),
            _buildHeader(chartViewWidth, Colors.blue),
            Container(
                margin: const EdgeInsets.only(top: 25.0),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Container(
                            width: chartViewWidth / viewRangeToFitScreen,
                            height: chartBars.length * 29.0 + 4.0,
                            color: Colors.blue.withAlpha(100),
                            child: Center(
                              child: RotatedBox(
                                quarterTurns: -45,
                                child: Text(
                                  user.name,
                                  textAlign: TextAlign.center,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            )),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: chartBars,
                        ),
                      ],
                    ),
                  ],
                )),
          ]),
        ],
      ),
    );
  }

  List<Widget> _buildChartContent({required double chartViewWidth}) {
    List<Widget> chartContent = [];

    final tasks = [...project.tasks];
    tasks.sort((a, b) {
      return a.startTime.millisecondsSinceEpoch -
          b.startTime.millisecondsSinceEpoch;
    });

    chartContent.add(_buildChartForEachUser(
        tasks, chartViewWidth, User(id: -1, name: 'Toustes')));

    for (final user in project.users) {
      List<Task> projectsOfUser = [];

      projectsOfUser = tasks
          .where((project) => project.participants.contains(user.id))
          .toList();

      if (projectsOfUser.isNotEmpty) {
        chartContent
            .add(_buildChartForEachUser(projectsOfUser, chartViewWidth, user));
      }
    }

    return chartContent;
  }

  void _onClickedZoom(bool isZoomingIn) {
    isZoomingIn ? currentTimeIncrement-- : currentTimeIncrement++;
    if (currentTimeIncrement < 0) currentTimeIncrement = 0;
    if (currentTimeIncrement >= possibleTimeIncrements.length) {
      currentTimeIncrement = possibleTimeIncrements.length - 1;
    }
    timeIncrements = possibleTimeIncrements[currentTimeIncrement];
    viewRange = _calculateNumberOfMinutesBetween(
        project.startingTime, project.endingTime);
    setState(() {});
  }

  void _onClickedChangeTimeZone() => setState(() {
        currentTimeZone = currentTimeZone == TimeZone.quebec
            ? TimeZone.europe
            : TimeZone.quebec;
      });

  void _onClickedChangeDates() async {
    DateTime? dateTimeStart;
    await showDialog(
      context: context,
      builder: (context) => Dialog(
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 12.0, left: 12.0),
            child: Text(
              'Sélectionner la date de début',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 12.0, right: 12.0),
            child: DateTimePickerWidget(
              dateFormat: 'dd MMMM yyyy HH:mm',
              locale: DateTimePickerLocale.fr,
              onConfirm: (dateTime, selectedIndex) => dateTimeStart = dateTime,
            ),
          )
        ],
      )),
    );
    if (!mounted || dateTimeStart == null) return;

    DateTime? dateTimeEnd;
    await showDialog(
      context: context,
      builder: (context) => Dialog(
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 12.0, left: 12.0),
            child: Text(
              'Sélectionner la date de début',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 12.0, right: 12.0),
            child: DateTimePickerWidget(
              dateFormat: 'dd MMMM yyyy HH:mm',
              locale: DateTimePickerLocale.fr,
              onConfirm: (dateTime, selectedIndex) => dateTimeEnd = dateTime,
            ),
          )
        ],
      )),
    );
    if (!mounted || dateTimeEnd == null) return;

    project.startingTime = dateTimeStart!;
    project.endingTime = dateTimeEnd!;
    setState(() {});
  }

  void _onClickedAddUser() async {
    await showDialog(
        context: context,
        builder: (context) => ManageUserDialog(project: project));
    setState(() {});
  }

  void _onClickedAddTask() async {
    final task = await showDialog<Task>(
        context: context, builder: (context) => TaskManager(project: project));

    if (task == null) return;

    project.tasks.add(task);
    setState(() {});
  }

  void _onClickModifyTask(Task taskToModify) async {
    final idx = project.tasks.indexOf(taskToModify);

    final modifiedTask = await showDialog(
        context: context,
        builder: (context) {
          return TaskManager(project: project, taskIndex: idx);
        });

    if (modifiedTask == null || !mounted) return;

    if (modifiedTask.runtimeType == String) {
      if (modifiedTask == 'delete') {
        final confirm = await showDialog<bool>(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: const Text('Confirmer la suppression de la tâche'),
                actions: <Widget>[
                  TextButton(
                    onPressed: () => Navigator.pop(context, false),
                    child: const Text('Annuler'),
                  ),
                  TextButton(
                      onPressed: () => Navigator.pop(context, true),
                      child: const Text('Confirmer')),
                ],
              );
            });
        if (confirm!) {
          project.tasks.removeAt(idx);
          setState(() {});
        }
        return;
      }
    }

    project.tasks[idx] = modifiedTask;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(actions: [
        IconButton(
          icon: const Icon(Icons.add_task),
          onPressed: _onClickedAddTask,
          iconSize: 40,
        ),
        IconButton(
          icon: const Icon(Icons.person_add),
          onPressed: _onClickedAddUser,
          iconSize: 40,
        ),
        IconButton(
          icon: const Icon(Icons.date_range),
          onPressed: _onClickedChangeDates,
          iconSize: 40,
        ),
        IconButton(
            onPressed: _onClickedChangeTimeZone,
            icon: Text(currentTimeZone == TimeZone.quebec ? 'Qc' : 'Fr')),
        IconButton(
          icon: const Icon(Icons.zoom_out),
          onPressed: currentTimeIncrement == possibleTimeIncrements.length - 1
              ? null
              : () => _onClickedZoom(false),
          iconSize: 40,
        ),
        IconButton(
          icon: const Icon(Icons.zoom_in),
          onPressed:
              currentTimeIncrement == 0 ? null : () => _onClickedZoom(true),
          iconSize: 40,
        ),
      ]),
      body: ListView(
        children: _buildChartContent(
          chartViewWidth: 3000,
        ),
      ),
      drawer: MyDrawer(project: project),
    );
  }
}
