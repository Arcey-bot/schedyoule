import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:schedyoule/data/models/models.dart';
import 'package:schedyoule/data/repositories/course_schedule_repository.dart';
import 'package:schedyoule/viewmodels/course_list_viewmodel.dart';

final courseScheduleProvider =
    StateNotifierProvider<CourseListViewModel, CourseScheduleRepository>(
  (ref) => CourseListViewModel(courses),
);

final courses = [
  Course(
    key: UniqueKey(),
    name: 'Physics 2',
    time: TimeSlot.fromInt(
        startHour: 10, startMinute: 0, endHour: 10, endMinute: 50),
    days: {
      DateTime.monday,
      DateTime.tuesday,
      DateTime.thursday,
      DateTime.friday,
    },
    credits: 4,
  ),
  Course(
    key: UniqueKey(),
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
];