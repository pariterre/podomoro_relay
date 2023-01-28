import 'package:flutter/material.dart';

import '/models/project.dart';
import '/widgets/my_drawer.dart';

class GanttChartScreen extends StatefulWidget {
  const GanttChartScreen({super.key});

  static const String route = '/gantt-screen';

  @override
  State<GanttChartScreen> createState() => _GanttChartScreenState();
}

class _GanttChartScreenState extends State<GanttChartScreen> {
  List<int> possibleTimeIncrements = [5, 10, 15, 30, 60];
  int currentTimeIncrement = 2;
  late int timeIncrements;
  late double viewRange;
  int viewRangeToFitScreen = 60;

  void _initializeLate(Project project) {
    timeIncrements = possibleTimeIncrements[currentTimeIncrement];
    viewRange = calculateNumberOfMinutesBetween(
        project.startingTime, project.endingTime);
  }

  double calculateNumberOfMinutesBetween(DateTime from, DateTime to) {
    return 24 * 60 / timeIncrements * (to.day - from.day) +
        60 / timeIncrements * (to.hour - from.hour) +
        (to.minute - from.minute) / timeIncrements;
  }

  double calculateDistanceToLeftBorder(
      Project project, DateTime taskStartedAt) {
    if (taskStartedAt.compareTo(project.startingTime) <= 0) {
      return 0;
    } else {
      return calculateNumberOfMinutesBetween(
          project.startingTime, taskStartedAt);
    }
  }

  double calculateRemainingWidth(
    Project project,
    DateTime taskStartedAt,
    DateTime taskEndedAt,
  ) {
    double projectLength =
        calculateNumberOfMinutesBetween(taskStartedAt, taskEndedAt);
    if (taskStartedAt.compareTo(project.startingTime) >= 0 &&
        taskStartedAt.compareTo(project.endingTime) <= 0) {
      if (projectLength <= viewRange) {
        return projectLength;
      } else {
        return viewRange -
            calculateNumberOfMinutesBetween(
                project.startingTime, taskStartedAt);
      }
    } else if (taskStartedAt.isBefore(project.startingTime) &&
        taskEndedAt.isBefore(project.startingTime)) {
      return 0;
    } else if (taskStartedAt.isBefore(project.startingTime) &&
        taskEndedAt.isBefore(project.endingTime)) {
      return projectLength -
          calculateNumberOfMinutesBetween(taskStartedAt, project.startingTime);
    } else if (taskStartedAt.isBefore(project.startingTime) &&
        taskEndedAt.isAfter(project.endingTime)) {
      return viewRange;
    }
    return 0;
  }

  List<Widget> buildChartBars(
      Project project, List<Task> data, double chartViewWidth) {
    List<Widget> chartBars = [];

    for (int i = 0; i < data.length; i++) {
      var remainingWidth =
          calculateRemainingWidth(project, data[i].startTime, data[i].endTime);
      if (remainingWidth > 0) {
        chartBars.add(Container(
          decoration: BoxDecoration(
              color: data[i].color.withAlpha(100),
              borderRadius: BorderRadius.circular(10.0)),
          height: 25.0,
          width: remainingWidth * chartViewWidth / viewRangeToFitScreen,
          margin: EdgeInsets.only(
              left: calculateDistanceToLeftBorder(project, data[i].startTime) *
                  chartViewWidth /
                  viewRangeToFitScreen,
              top: i == 0 ? 4.0 : 2.0,
              bottom: i == data.length - 1 ? 4.0 : 2.0),
          alignment: Alignment.centerLeft,
          child: Tooltip(
            message: data[i].name,
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
        ));
      }
    }

    return chartBars;
  }

  Widget buildHeader(Project project, double chartViewWidth, Color color) {
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

  Widget buildGrid(double chartViewWidth) {
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

  Widget buildChartForEachUser(
      Project project, List<Task> userData, double chartViewWidth, User user) {
    var chartBars = buildChartBars(project, userData, chartViewWidth);
    return SizedBox(
      height: chartBars.length * 29.0 + 25.0 + 4.0,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          Stack(fit: StackFit.loose, children: <Widget>[
            buildGrid(chartViewWidth),
            buildHeader(project, chartViewWidth, Colors.blue),
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

  List<Widget> buildChartContent(
      {required Project project, required double chartViewWidth}) {
    List<Widget> chartContent = [];

    final tasks = [...project.tasks];
    tasks.sort((a, b) {
      return a.startTime.millisecondsSinceEpoch -
          b.startTime.millisecondsSinceEpoch;
    });

    chartContent.add(buildChartForEachUser(
        project, tasks, chartViewWidth, User(id: '-1', name: 'Toustes')));

    for (final user in project.users) {
      List<Task> projectsOfUser = [];

      projectsOfUser = tasks
          .where((project) => project.participants.contains(user.id))
          .toList();

      if (projectsOfUser.isNotEmpty) {
        chartContent.add(buildChartForEachUser(
            project, projectsOfUser, chartViewWidth, user));
      }
    }

    return chartContent;
  }

  void onClickZoom(Project project, bool zoomIn) {
    zoomIn ? currentTimeIncrement-- : currentTimeIncrement++;
    if (currentTimeIncrement < 0) currentTimeIncrement = 0;
    if (currentTimeIncrement >= possibleTimeIncrements.length) {
      currentTimeIncrement = possibleTimeIncrements.length - 1;
    }
    timeIncrements = possibleTimeIncrements[currentTimeIncrement];
    viewRange = calculateNumberOfMinutesBetween(
        project.startingTime, project.endingTime);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final jsonPath = (ModalRoute.of(context)?.settings.arguments ??
        'assets/scenario_5_lin.json') as String;

    return FutureBuilder<Project>(
        future: Project.fromJson(context, jsonPath),
        builder: (ctx, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final project = snapshot.data!;
          _initializeLate(project);

          return Scaffold(
              appBar: AppBar(actions: [
                IconButton(
                    icon: const Icon(Icons.zoom_out),
                    onPressed: () => onClickZoom(project, false)),
                IconButton(
                    icon: const Icon(Icons.zoom_in),
                    onPressed: () => onClickZoom(project, true)),
              ]),
              body: ListView(
                children: buildChartContent(
                  project: project,
                  chartViewWidth: 3000,
                ),
              ),
              drawer: const MyDrawer());
        });
  }
}
