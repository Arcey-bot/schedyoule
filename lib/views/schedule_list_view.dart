import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:schedyoule/constants/constants.dart';
import 'package:schedyoule/data/models/models.dart';

// TODO: Prettify
class ScheduleListView extends ConsumerWidget {
  final List<Schedule> schedules;
  const ScheduleListView({Key? key, required this.schedules}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Schedules'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Text('Generated ${schedules.length} schedules'),
          ),
          const Divider(thickness: 4),
          Expanded(
            child: ListView.builder(
              itemCount: schedules.length,
              itemBuilder: (context, index) {
                return Card(
                  child: ExpansionTile(
                    title: Text(
                      'Schedule ${index + 1} (${schedules[index].totalCredits} Credits )',
                    ),
                    initiallyExpanded: index < numSchedulesStartExpaneded,
                    childrenPadding: const EdgeInsets.all(8),
                    children: [ScheduleBlock(schedule: schedules[index])],
                  ),
                );
              },
            ),
          ),
        ],
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
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            for (final day in schedule.scheduledDays)
              buildTitleCard(
                Schedule.numToDay(day),
              ),
          ],
        ),
        const SizedBox(width: 4.0),
        Expanded(
          child: Container(
            color: Colors.grey.shade300,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  for (final day in schedule.scheduledDays)
                    buildCourseDayList(schedule.schedule[day]!),
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
          Container(
            color: Colors.pink.shade50,
            child: Column(
              children: [
                Text(c.name),
                Text(c.time.toString()),
              ],
            ),
          ),
      ],
    );
  }
}
