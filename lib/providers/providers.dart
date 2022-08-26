import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:schedyoule/constants/constants.dart';
import 'package:schedyoule/data/models/models.dart';
import 'package:schedyoule/data/repositories/course_schedule_repository.dart';
import 'package:schedyoule/viewmodels/course_list_viewmodel.dart';

final courseScheduleProvider =
    StateNotifierProvider<CourseListViewModel, CourseScheduleRepository>(
  (ref) {
    return CourseListViewModel(_readSavedCourses());
  },
);

final generateStateProvider =
    StateProvider<GenerateButtonState>((ref) => GenerateButtonState.ready);

/// Returns a list of every course saved in local storage or empty list if none
List<Course> _readSavedCourses() {
  final List<Course> loadedCourses = [];

  // Loads every saved course one at a time
  for (int i = 0; i < Hive.box(coursesBoxKey).length; i++) {
    loadedCourses.add(Course.fromJson(Hive.box(coursesBoxKey).getAt(i)));
  }

  return loadedCourses.isNotEmpty ? loadedCourses : defaultCourseList;
}
