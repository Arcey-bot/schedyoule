import 'package:flutter/material.dart';
import 'package:schedyoule/providers/providers.dart';
import 'package:schedyoule/views/schedule_list_view.dart';
import 'package:schedyoule/views/widgets/course_card.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// TODO: Centralize courses storage so course card can also access course
// TODO: If default course generated, let card know to autoclear text on click
// TODO: Add field to select latest starting time

class CourseListView extends ConsumerWidget {
  const CourseListView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider = ref.watch(courseScheduleProvider);

    print('CourseListView: ${provider.courses}');
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add your courses'),
        actions: [
          IconButton(
            onPressed: () {
              print(provider.courses);
              generateSchedules(context);
            },
            icon: const Icon(Icons.add),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async => await ref
            .read(courseScheduleProvider.notifier)
            .createDefaultCourse(),
        child: const Icon(Icons.add),
      ),
      body: ListView.builder(
        itemCount: provider.courses.length,
        itemBuilder: (context, index) => Padding(
          padding: const EdgeInsets.all(8.0),
          child: Dismissible(
            key: provider.courses[index].key!,
            onDismissed: (dir) async => await ref
                .read(courseScheduleProvider.notifier)
                .removeCourse(provider.courses[index]),
            child: CourseCard(
              course: provider.courses[index],
              onChanged: (value) {},
            ),
          ),
        ),
      ),
    );
  }

  // void _onChanged(int index, String value) {
  //   widget.courses[index] = widget.courses[index].copyWith(name: value);
  // }

  void generateSchedules(BuildContext context) async {
    // TODO: Prune bad courses before generating
    // TODO: Call ViewModel or provider to run generation

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: ((context) => ScheduleListView(schedules: [])),
      ),
    );
  }
}
