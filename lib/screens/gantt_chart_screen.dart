import 'package:flutter/material.dart';

import '/models/project.dart';
import '/widgets/my_drawer.dart';
import '/widgets/task_manager.dart';

class GanttChartScreen extends StatefulWidget {
  const GanttChartScreen({super.key});

  static const String route = '/gantt-screen';

  @override
  State<GanttChartScreen> createState() => _GanttChartScreenState();
}

class _GanttChartScreenState extends State<GanttChartScreen> {
  Project? project;
  List<int> possibleTimeIncrements = [5, 10, 15, 30, 60];
  int currentTimeIncrement = 2;
  late int timeIncrements;
  late double viewRange;
  int viewRangeToFitScreen = 60;

  @override
  void initState() {
    super.initState();

    Future.delayed(Duration.zero, () {
      project = Project.fromJson((ModalRoute.of(context)?.settings.arguments ??
          'assets/scenario_5_lin.json') as String);
      timeIncrements = possibleTimeIncrements[currentTimeIncrement];
      viewRange = _calculateNumberOfMinutesBetween(
          project!.startingTime, project!.endingTime);
      setState(() {});
    });
  }

  double _calculateNumberOfMinutesBetween(DateTime from, DateTime to) {
    return 24 * 60 / timeIncrements * (to.day - from.day) +
        60 / timeIncrements * (to.hour - from.hour) +
        (to.minute - from.minute) / timeIncrements;
  }

  double _calculateDistanceToLeftBorder(DateTime taskStartedAt) {
    if (taskStartedAt.compareTo(project!.startingTime) <= 0) {
      return 0;
    } else {
      return _calculateNumberOfMinutesBetween(
          project!.startingTime, taskStartedAt);
    }
  }

  double _calculateRemainingWidth(
      DateTime taskStartedAt, DateTime taskEndedAt) {
    double projectLength =
        _calculateNumberOfMinutesBetween(taskStartedAt, taskEndedAt);
    if (taskStartedAt.compareTo(project!.startingTime) >= 0 &&
        taskStartedAt.compareTo(project!.endingTime) <= 0) {
      if (projectLength <= viewRange) {
        return projectLength;
      } else {
        return viewRange -
            _calculateNumberOfMinutesBetween(
                project!.startingTime, taskStartedAt);
      }
    } else if (taskStartedAt.isBefore(project!.startingTime) &&
        taskEndedAt.isBefore(project!.startingTime)) {
      return 0;
    } else if (taskStartedAt.isBefore(project!.startingTime) &&
        taskEndedAt.isBefore(project!.endingTime)) {
      return projectLength -
          _calculateNumberOfMinutesBetween(
              taskStartedAt, project!.startingTime);
    } else if (taskStartedAt.isBefore(project!.startingTime) &&
        taskEndedAt.isAfter(project!.endingTime)) {
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
        chartBars.add(GestureDetector(
          onTap: () => _onClickModifyTask(data[i]),
          child: Container(
            decoration: BoxDecoration(
                color: data[i].color.withAlpha(100),
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
                  style: const TextStyle(fontSize: 10.0),
                ),
              ),
            ),
          ),
        ));
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

    DateTime tempDate = project!.startingTime;
    for (int i = 0; i < viewRange; i++) {
      headerItems.add(SizedBox(
        width: chartViewWidth / viewRangeToFitScreen,
        child: Text(
          '${tempDate.hour}:${tempDate.minute != 0 ? tempDate.minute : '00'}',
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 10.0,
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

    final tasks = [...project!.tasks];
    tasks.sort((a, b) {
      return a.startTime.millisecondsSinceEpoch -
          b.startTime.millisecondsSinceEpoch;
    });

    chartContent.add(_buildChartForEachUser(
        tasks, chartViewWidth, User(id: '-1', name: 'Toustes')));

    for (final user in project!.users) {
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

  void _onClickZoom(bool isZoomingIn) {
    isZoomingIn ? currentTimeIncrement-- : currentTimeIncrement++;
    if (currentTimeIncrement < 0) currentTimeIncrement = 0;
    if (currentTimeIncrement >= possibleTimeIncrements.length) {
      currentTimeIncrement = possibleTimeIncrements.length - 1;
    }
    timeIncrements = possibleTimeIncrements[currentTimeIncrement];
    viewRange = _calculateNumberOfMinutesBetween(
        project!.startingTime, project!.endingTime);
    setState(() {});
  }

  void _onClickAddTask() async {
    final task = await showDialog<Task>(
        context: context,
        builder: (context) {
          return TaskManager(project: project!);
        });

    if (task == null) return;

    project!.tasks.add(task);
    setState(() {});
  }

  void _onClickModifyTask(Task taskToModify) async {
    final idx = project!.tasks.indexOf(taskToModify);

    final modifiedTask = await showDialog(
        context: context,
        builder: (context) {
          return TaskManager(project: project!, taskIndex: idx);
        });

    if (modifiedTask == null) return;

    if (modifiedTask.runtimeType == String) {
      if (modifiedTask == 'delete') {
        final confirm = await showDialog<bool>(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: const Text('Confirmer la suppression de la tâcher'),
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
          project!.tasks.removeAt(idx);
          setState(() {});
        }
        return;
      }
    }

    project!.tasks[idx] = modifiedTask;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return project == null // This is true for a single frame
        ? Container()
        : Scaffold(
            appBar: AppBar(actions: [
              IconButton(
                icon: const Icon(Icons.zoom_out),
                onPressed:
                    currentTimeIncrement == possibleTimeIncrements.length - 1
                        ? null
                        : () => _onClickZoom(false),
                iconSize: 40,
              ),
              IconButton(
                icon: const Icon(Icons.zoom_in),
                onPressed:
                    currentTimeIncrement == 0 ? null : () => _onClickZoom(true),
                iconSize: 40,
              ),
              IconButton(
                icon: const Icon(Icons.add),
                onPressed: () => _onClickAddTask(),
                iconSize: 40,
              ),
            ]),
            body: ListView(
              children: _buildChartContent(
                chartViewWidth: 3000,
              ),
            ),
            drawer: MyDrawer(project: project!));
  }
}
