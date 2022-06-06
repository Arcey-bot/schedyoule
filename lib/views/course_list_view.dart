import 'package:flutter/material.dart';
import 'package:schedyoule/constants/constants.dart';
import 'package:schedyoule/constants/en_strings.dart';
import 'package:schedyoule/data/repositories/course_schedule_repository.dart';
import 'package:schedyoule/providers/providers.dart';
import 'package:schedyoule/views/schedule_list_view.dart';
import 'package:schedyoule/views/widgets/course_card.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:schedyoule/views/widgets/time_button.dart';

// TODO: Sort courses for schedule generation using a clone of the course list to avoid reshuffling when popping back to courseListView
// TODO: Prevent generation if no courses are available
// TODO: Disable generate button when generating
// TODO: Add limit to number of courses that can be created?

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
            onPressed: () => print(
                '${provider.latest} - ${provider.courses.length} - ${provider.courses}'),
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
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            buildFunctionalityHeader(context, ref),
            const Divider(height: 4),
            Expanded(child: buildCourseCardList(provider, ref)),
          ],
        ),
      ),
    );
  }

  Row buildFunctionalityHeader(BuildContext context, WidgetRef ref) {
    return Row(
      children: [
        Expanded(
          flex: 7,
          child: ElevatedButton(
            onPressed: () async => await _generateSchedules(context, ref),
            child: const Text(courseListViewGenerateButton),
          ),
        ),
        const SizedBox(width: 16),
        TimeButton(
          time: defaultLatest,
          onChange: (time) async {
            await ref.read(courseScheduleProvider.notifier).setLatest(time);
          },
        ),
      ],
    );
  }

  ListView buildCourseCardList(
    CourseScheduleRepository provider,
    WidgetRef ref,
  ) {
    return ListView.separated(
      itemCount: provider.courses.length,
      separatorBuilder: (context, index) => const SizedBox(height: 12),
      itemBuilder: (context, index) => Dismissible(
        key: UniqueKey(),
        onDismissed: (dir) async => await ref
            .read(courseScheduleProvider.notifier)
            .removeCourse(provider.courses[index]),
        child: CourseCard(
          course: provider.courses[index],
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
}
