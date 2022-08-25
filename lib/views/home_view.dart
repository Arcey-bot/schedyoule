import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:schedyoule/constants/constants.dart';
import 'package:schedyoule/data/models/course.dart';
import 'package:schedyoule/providers/providers.dart';
import 'package:schedyoule/views/course_list_view.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeView extends ConsumerWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Load any preexisting courses before rendering the CourseListView
    SharedPreferences.getInstance().then((instance) =>
        ref.watch(savedCoursesProvider.notifier).state = instance
            .getStringList(savedCourseKey)
            ?.map((e) => Course.fromJson(e))
            .toList());

    return const CourseListView();
  }
}
