import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:schedyoule/constants/constants.dart';
import 'package:schedyoule/data/models/models.dart';
import 'package:schedyoule/data/repositories/course_schedule_repository.dart';
import 'package:schedyoule/viewmodels/course_list_viewmodel.dart';

final savedCoursesProvider = StateProvider<List<Course>?>(
  (ref) => [],
);

final courseScheduleProvider =
    StateNotifierProvider<CourseListViewModel, CourseScheduleRepository>(
  (ref) {
    return CourseListViewModel(ref.watch(savedCoursesProvider));
  },
);

final generateStateProvider =
    StateProvider<GenerateButtonState>((ref) => GenerateButtonState.ready);

final courses = [
  Course(
    key: UniqueKey(),
    name: 'Physics 2',
    time: TimeSlot.fromInt(
        startHour: 10, startMinute: 0, endHour: 10, endMinute: 50),
    days: {
      DateTime.monday,
      DateTime.wednesday,
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
      DateTime.tuesday,
      DateTime.thursday,
      DateTime.friday,
    },
  ),
  Course(
    key: UniqueKey(),
    name: 'Math',
    time: TimeSlot.fromInt(
        startHour: 2, startMinute: 0, endHour: 2, endMinute: 50),
    days: {
      DateTime.thursday,
    },
  ),
  Course(
    key: UniqueKey(),
    name: 'Sci',
    time: TimeSlot.fromInt(
        startHour: 11, startMinute: 0, endHour: 12, endMinute: 50),
    days: {
      DateTime.thursday,
    },
  ),
  Course(
    key: UniqueKey(),
    name: 'Bio',
    time: TimeSlot.fromInt(
        startHour: 8, startMinute: 0, endHour: 8, endMinute: 50),
    days: {
      DateTime.thursday,
    },
  ),
];
