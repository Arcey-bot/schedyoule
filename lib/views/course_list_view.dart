import 'package:flutter/material.dart';
import 'package:schedyoule/data/models/models.dart';
import 'package:schedyoule/data/repositories/possible_schedules_repository.dart';
import 'package:schedyoule/views/schedule_list_view.dart';
import 'package:schedyoule/views/widgets/course_entry_card.dart';

// TODO: Handle clicking generate when cards are missing data

class CourseListView extends StatefulWidget {
  final List<Course> courses;

  const CourseListView({Key? key, required this.courses}) : super(key: key);

  @override
  State<CourseListView> createState() => _CourseListViewState();
}

class _CourseListViewState extends State<CourseListView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add your courses'),
        actions: [
          IconButton(
            onPressed: () => generateSchedules(),
            icon: const Icon(Icons.add),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: const Icon(Icons.add),
      ),
      body: ListView.builder(
        itemCount: 3,
        itemBuilder: (context, index) => const Padding(
          padding: EdgeInsets.all(8.0),
          child: CourseEntryCard(),
        ),
      ),
    );
  }

  void generateSchedules() async {
    final poss = PossibleSchedulesRepository(
        courses: widget.courses, latest: DateTime(2022, 1, 1, 9));

    final schedules = await poss.generateSchedules();

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: ((context) => ScheduleListView(schedules: schedules)),
      ),
    );
  }
}
