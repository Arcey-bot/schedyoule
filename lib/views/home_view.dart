import 'package:flutter/material.dart';
import 'package:schedyoule/views/course_list_view.dart';

import '../data/models/models.dart';

class HomeView extends StatelessWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CourseListView(courses: [
      Course(
        name: 'Physics 2',
        time: TimeSlot.fromInt(
            startHour: 10, startMinute: 0, endHour: 10, endMinute: 50),
        days: {
          DateTime.monday,
          DateTime.tuesday,
          DateTime.thursday,
          DateTime.friday,
        },
      ),
      Course(
        name: 'Test 2',
        time: TimeSlot.fromInt(
            startHour: 9, startMinute: 0, endHour: 9, endMinute: 50),
        days: {
          DateTime.monday,
          DateTime.tuesday,
          DateTime.thursday,
          DateTime.friday,
        },
      ),
    ]);
  }
}
