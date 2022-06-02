import 'package:flutter/material.dart';

import '../data/models/schedule.dart';

class ScheduleListView extends StatelessWidget {
  final List<Schedule> schedules;
  const ScheduleListView({Key? key, required this.schedules}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print(schedules);
    return Scaffold(
      appBar: AppBar(
        title: Text('Schedules'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: schedules.length,
          itemBuilder: (context, index) => Card(
            child: Text(
                'Schedule $index: ${schedules[index].totalCredits} Credits'),
          ),
        ),
      ),
    );
  }
}
