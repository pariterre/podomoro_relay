import 'package:flutter/material.dart';

import '/models/projects.dart';
import '/models/users.dart';

class GanttChartScreen extends StatefulWidget {
  const GanttChartScreen({
    super.key,
    required this.startingTime,
    required this.endingTime,
    required this.users,
    required this.projects,
  });

  final DateTime startingTime;
  final DateTime endingTime;
  final List<User> users;
  final List<Project> projects;

  @override
  State<GanttChartScreen> createState() => _GanttChartScreenState();
}

class _GanttChartScreenState extends State<GanttChartScreen> {
  List<int> possibleTimeIncrements = [5, 10, 15, 30, 60];
  int currentTimeIncrement = 2;
  late int timeIncrements = possibleTimeIncrements[currentTimeIncrement];
  late double viewRange =
      calculateNumberOfMinutesBetween(widget.startingTime, widget.endingTime);
  int viewRangeToFitScreen = 60;

  double calculateNumberOfMinutesBetween(DateTime from, DateTime to) {
    return 24 * 60 / timeIncrements * (to.day - from.day) +
        60 / timeIncrements * (to.hour - from.hour) +
        (to.minute - from.minute) / timeIncrements;
  }

  double calculateDistanceToLeftBorder(DateTime projectStartedAt) {
    if (projectStartedAt.compareTo(widget.startingTime) <= 0) {
      return 0;
    } else {
      return calculateNumberOfMinutesBetween(
          widget.startingTime, projectStartedAt);
    }
  }

  double calculateRemainingWidth(
      DateTime projectStartedAt, DateTime projectEndedAt) {
    double projectLength =
        calculateNumberOfMinutesBetween(projectStartedAt, projectEndedAt);
    if (projectStartedAt.compareTo(widget.startingTime) >= 0 &&
        projectStartedAt.compareTo(widget.endingTime) <= 0) {
      if (projectLength <= viewRange) {
        return projectLength;
      } else {
        return viewRange -
            calculateNumberOfMinutesBetween(
                widget.startingTime, projectStartedAt);
      }
    } else if (projectStartedAt.isBefore(widget.startingTime) &&
        projectEndedAt.isBefore(widget.startingTime)) {
      return 0;
    } else if (projectStartedAt.isBefore(widget.startingTime) &&
        projectEndedAt.isBefore(widget.endingTime)) {
      return projectLength -
          calculateNumberOfMinutesBetween(
              projectStartedAt, widget.startingTime);
    } else if (projectStartedAt.isBefore(widget.startingTime) &&
        projectEndedAt.isAfter(widget.endingTime)) {
      return viewRange;
    }
    return 0;
  }

  List<Widget> buildChartBars(List<Project> data, double chartViewWidth) {
    List<Widget> chartBars = [];

    for (int i = 0; i < data.length; i++) {
      var remainingWidth =
          calculateRemainingWidth(data[i].startTime, data[i].endTime);
      if (remainingWidth > 0) {
        chartBars.add(Container(
          decoration: BoxDecoration(
              color: data[i].color.withAlpha(100),
              borderRadius: BorderRadius.circular(10.0)),
          height: 25.0,
          width: remainingWidth * chartViewWidth / viewRangeToFitScreen,
          margin: EdgeInsets.only(
              left: calculateDistanceToLeftBorder(data[i].startTime) *
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

  Widget buildHeader(double chartViewWidth, Color color) {
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

    DateTime tempDate = widget.startingTime;
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
      List<Project> userData, double chartViewWidth, User user) {
    var chartBars = buildChartBars(userData, chartViewWidth);
    return SizedBox(
      height: chartBars.length * 29.0 + 25.0 + 4.0,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          Stack(fit: StackFit.loose, children: <Widget>[
            buildGrid(chartViewWidth),
            buildHeader(chartViewWidth, Colors.blue),
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

  List<Widget> buildChartContent(double chartViewWidth) {
    List<Widget> chartContent = [];

    widget.projects.sort((a, b) {
      return a.startTime.millisecondsSinceEpoch -
          b.startTime.millisecondsSinceEpoch;
    });

    chartContent.add(buildChartForEachUser(
        widget.projects, chartViewWidth, User(id: -1, name: 'Toustes')));

    for (final user in widget.users) {
      List<Project> projectsOfUser = [];

      projectsOfUser = widget.projects
          .where((project) => project.participants.contains(user.id))
          .toList();

      if (projectsOfUser.isNotEmpty) {
        chartContent
            .add(buildChartForEachUser(projectsOfUser, chartViewWidth, user));
      }
    }

    return chartContent;
  }

  void onClickZoom(bool zoomIn) {
    zoomIn ? currentTimeIncrement-- : currentTimeIncrement++;
    if (currentTimeIncrement < 0) currentTimeIncrement = 0;
    if (currentTimeIncrement >= possibleTimeIncrements.length) {
      currentTimeIncrement = possibleTimeIncrements.length - 1;
    }
    timeIncrements = possibleTimeIncrements[currentTimeIncrement];
    viewRange =
        calculateNumberOfMinutesBetween(widget.startingTime, widget.endingTime);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(actions: [
          IconButton(
              icon: const Icon(Icons.zoom_out),
              onPressed: () => onClickZoom(false)),
          IconButton(
              icon: const Icon(Icons.zoom_in),
              onPressed: () => onClickZoom(true)),
        ]),
        body: ListView(children: buildChartContent(3000)));
  }
}
