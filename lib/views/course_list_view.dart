import 'package:flutter/material.dart';
import 'package:schedyoule/providers/providers.dart';
import 'package:schedyoule/views/schedule_list_view.dart';
import 'package:schedyoule/views/widgets/course_card.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// TODO: Add field to select latest starting time before generation
// TODO: Prevent generation if no courses are available

class CourseListView extends ConsumerWidget {
  const CourseListView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider = ref.watch(courseScheduleProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Add your courses'),
        actions: [
          IconButton(
            onPressed: () async => await _generateSchedules(context, ref),
            icon: const Icon(Icons.add),
          ),
          IconButton(
            onPressed: () =>
                print('${provider.courses.length} - ${provider.courses}'),
            icon: const Icon(Icons.refresh),
          ),
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
            key: UniqueKey(),
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

  Future<void> _generateSchedules(
    BuildContext context,
    WidgetRef ref,
  ) async {
    final s =
        await ref.read(courseScheduleProvider.notifier).generateSchedules();

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: ((context) => ScheduleListView(schedules: s)),
      ),
    );
  }

  // void _onChanged(int index, String value) {
  //   widget.courses[index] = widget.courses[index].copyWith(name: value);
  // }
}
