import 'package:flutter/material.dart';
import 'package:pluto_grid/pluto_grid.dart';
import 'package:schedyoule/data/models/models.dart';

import '../data/models/schedule.dart';

class ScheduleListView extends StatelessWidget {
  final List<Schedule> schedules;
  const ScheduleListView({Key? key, required this.schedules}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Schedules'),
      ),
      body: ListView.builder(
        itemCount: schedules.length,
        itemBuilder: (context, index) {
          return Card(
            child: ExpansionTile(
              title: Text(
                'Schedule $index (${schedules[index].totalCredits} Credits )',
              ),
              childrenPadding: const EdgeInsets.all(8),
              children: [ScheduleBlock(schedule: schedules[index])],
            ),
          );
        },
      ),
    );
  }
}

class ScheduleBlock extends StatelessWidget {
  final Schedule schedule;

  const ScheduleBlock({Key? key, required this.schedule}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            for (final day in schedule.scheduledDays)
              buildTitleCard(
                Schedule.numToDay(day),
              ),
          ],
        ),
        Expanded(
          child: Container(
            color: Colors.grey.shade300,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  for (final day in schedule.scheduledDays)
                    buildCourseDayList(schedule.schedule[day]!)
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget buildTitleCard(String text) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.all(8),
      color: Colors.teal.shade100,
      child: Text(text),
    );
  }

  Widget buildCourseDayList(List<Course> courses) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (final Course c in courses)
          SizedBox(child: buildTitleCard('${c.name} (${c.time})'))
      ],
    );
  }
}
