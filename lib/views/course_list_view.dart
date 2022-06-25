import 'package:flutter/material.dart';
import 'package:schedyoule/constants/constants.dart';
import 'package:schedyoule/constants/en_strings.dart';
import 'package:schedyoule/data/repositories/course_schedule_repository.dart';
import 'package:schedyoule/providers/providers.dart';
import 'package:schedyoule/views/schedule_list_view.dart';
import 'package:schedyoule/views/widgets/course_card.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:schedyoule/views/widgets/generate_schedules_button.dart';

class CourseListView extends ConsumerWidget {
  const CourseListView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider = ref.watch(courseScheduleProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text(courseListViewAppBarTitle),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await ref.read(courseScheduleProvider.notifier).createDefaultCourse();

          // If generation was disabled, enable it since a valid course exists
          if (ref.read(generateStateProvider) == GenerateButtonState.disabled) {
            ref.read(generateStateProvider.notifier).state =
                GenerateButtonState.ready;
          }
        },
        child: const Icon(Icons.add),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Flexible(flex: 1, child: buildFunctionalityHeader(context, ref)),
            const Divider(height: 4),
            Expanded(flex: 12, child: buildCourseCardList(provider, ref)),
          ],
        ),
      ),
    );
  }

  Row buildFunctionalityHeader(BuildContext context, WidgetRef ref) {
    return Row(
      children: [
        Expanded(
          child: GenerateSchedulesButton(
            onPressed: () async => await _generateSchedules(context, ref),
          ),
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
        onDismissed: (dir) async {
          await ref
              .read(courseScheduleProvider.notifier)
              .removeCourse(provider.courses[index]);

          // If there are no courses left, disable generation
          if (ref.read(courseScheduleProvider).courses.isEmpty) {
            ref.read(generateStateProvider.notifier).state =
                GenerateButtonState.disabled;
          }
        },
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
    // Give button loading animation
    ref.read(generateStateProvider.notifier).state =
        GenerateButtonState.generating;

    final s =
        await ref.read(courseScheduleProvider.notifier).generateSchedules();

    Navigator.of(context)
        .push(MaterialPageRoute(
          builder: ((context) => ScheduleListView(schedules: s)),
        ))
        .then((value) => ref.read(generateStateProvider.notifier).state =
            GenerateButtonState.ready);
  }
}
