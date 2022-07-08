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

  //* Stack based UI
  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: AlignmentDirectional.center,
      children: [
        Container(
          alignment: Alignment.centerLeft,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              for (final day in schedule.scheduledDays)
                buildTitleCard(Schedule.numToDay(day)),
            ],
          ),
        ),
        Positioned(
          left: 120,
          right: 0, // Simply must be set for scrollview to function
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                for (final day in schedule.scheduledDays)
                  buildCourseDayList(schedule.schedule[day]!),
              ],
            ),
          ),
        ),
      ],
    );
  }

  //* IntrinsicHeight based UI (IntrinsicHeight is slower than Stacks)
  // @override
  // Widget build(BuildContext context) {
  //   return IntrinsicHeight(
  //     child: Row(
  //       children: [
  //         Container(
  //           color: Colors.pink.shade200,
  //           child: Column(
  //             mainAxisSize: MainAxisSize.max,
  //             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  //             crossAxisAlignment: CrossAxisAlignment.start,
  //             children: [
  //               for (final day in schedule.scheduledDays)
  //                 buildTitleCard(Schedule.numToDay(day)),
  //             ],
  //           ),
  //         ),
  //         const SizedBox(width: 4.0),
  //         Expanded(
  //           child: Container(
  //             color: Colors.grey.shade300,
  //             child: SingleChildScrollView(
  //               scrollDirection: Axis.horizontal,
  //               child: Column(
  //                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  //                 crossAxisAlignment: CrossAxisAlignment.start,
  //                 children: [
  //                   for (final day in schedule.scheduledDays)
  //                     buildCourseDayList(schedule.schedule[day]!),
  //                 ],
  //               ),
  //             ),
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  // Widget buildTitleCard(String text) {
  //   return IntrinsicHeight(
  //     child: Row(
  //       crossAxisAlignment: CrossAxisAlignment.stretch,
  //       children: [
  //         Container(
  //           color: Colors.grey.shade400,
  //           child: Card(
  //             elevation: 1,
  //             margin: const EdgeInsets.all(8),
  //             child: Padding(
  //               padding: const EdgeInsets.all(4.0),
  //               child: Text(
  //                 text,
  //                 overflow: TextOverflow.clip,
  //                 maxLines: 1,
  //                 style: const TextStyle(
  //                   fontWeight: FontWeight.bold,
  //                   fontSize: 16,
  //                 ),
  //               ),
  //             ),
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }
  Widget buildTitleCard(String text) {
    // Only band days that start with a T (Tues/Thurs)

    return Row(
      children: [
        text.startsWith('T') ? buildBandedRow(text) : buildRow(text),
      ],
    );
  }

  Expanded buildBandedRow(String text) {
    return Expanded(
      child: Container(
        color: Colors.grey.shade300,
        child: buildRow(text, true),
      ),
    );
  }

  Card buildRow(String text, [bool banded = false]) {
    return Card(
      color: banded ? Colors.grey.shade300 : null,
      elevation: 0,
      margin: const EdgeInsets.all(8),
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Text(
          text,
          overflow: TextOverflow.clip,
          maxLines: 1,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      ),
    );
  }

  Widget buildCourseDayList(List<Course> courses) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (final Course c in courses)
          Card(
            color: Colors.pink.shade50,
            child: Padding(
              padding: const EdgeInsets.all(2.0),
              child: Column(
                children: [
                  Text(c.name),
                  Text(c.time.toString()),
                ],
              ),
            ),
          ),
      ],
    );
  }
}
