import 'dart:math';

import 'package:flutter/material.dart' show Key, TimeOfDay, UniqueKey;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:schedyoule/constants/constants.dart';
import 'package:schedyoule/data/models/models.dart';
import 'package:schedyoule/data/repositories/course_schedule_repository.dart';

class CourseListViewModel extends StateNotifier<CourseScheduleRepository> {
  CourseListViewModel([List<Course>? courses, DateTime? latest])
      : super(CourseScheduleRepository(
          courses: courses ?? List.empty(growable: true),
          latest: latest,
        ));

  List<Course> get courses => state.courses;

  /// Creates a new defaultCourse and adds appends it to the state's courselist
  Future<Course> createDefaultCourse() async {
    final Course emptyCourse = Course(
      key: UniqueKey(),
      name: courseCardPlaceholderTitles[
          Random().nextInt(courseCardPlaceholderTitles.length)],
      time: TimeSlot.fromInt(
        startHour: 10,
        startMinute: 0,
        endHour: 11,
        endMinute: 0,
      ),
      days: {
        DateTime.monday,
        DateTime.wednesday,
        DateTime.friday,
      },
      credits: defaultCredits,
      placeholder: true,
    );

    state = state.copyWith(courses: [...courses, emptyCourse]);
    // state.addCourse(emptyCourse);
    return emptyCourse;
  }

  /// Add a course to the list
  Future<void> addCourse(Course course) async {
    state = state.copyWith(courses: [...courses, course]);
    // state.courses.add(course);
  }

  /// Remove a course from the list, returns true if successfully removed.
  Future<bool> removeCourse(Course course) async {
    final List<Course> newCourses = List.from(courses);
    final r = newCourses.remove(course);
    state = state.copyWith(courses: newCourses);
    return r;
  }

  /// Replace a course in the list with the given course
  Future<void> updateCourse(Key key, Course course) async {
    // final List<Course> newCourses = List.from(courses);
    // final int index = newCourses.indexWhere((e) => e.key == course.key);
    // newCourses.replaceRange(index, index + 1, [course]);
    // state = state.copyWith(courses: newCourses);
    final int replaceAt = state.courses.indexWhere((e) => e.key == course.key);
    state.courses.replaceRange(replaceAt, replaceAt + 1, [course]);
  }

  /// Replace a course in the list with the given course and forces a rebuild
  Future<void> updateCourseRebuild(Key key, Course course) async {
    final List<Course> newCourses = List.from(courses);
    final int index = newCourses.indexWhere((e) => e.key == course.key);
    newCourses.replaceRange(index, index + 1, [course]);
    state = state.copyWith(courses: newCourses);
  }

  Future<void> setLatest(TimeOfDay latest) async => state = state.copyWith(
        latest: DateTime(
          2022,
          1,
          1,
          latest.hour,
          latest.minute,
        ),
      );

  /// Generate a number of possible schedules given a list of courses
  ///
  /// Will attempt to maximize amount of courses taken in a schedule.
  Future<List<Schedule>> generateSchedules() async {
    state = state; // Ensure everything is up to date
    final List<Course> courses = List.of(state.courses);
    courses.sort();

    // Ensure that if a course is the first course added for a day, that it is not after latest
    // final List<Schedule> possibleSchedules = [
    //   for (Course c in coursesAtOrBefore(state.latest!))
    //     Schedule()..addCourse(c)
    // ];

    // EVERY course can be a possible first course!
    final List<Schedule> possibleSchedules = [
      for (final Course c in courses) Schedule()..addCourse(c)
    ];

    /// Offset is index + 1 of the only existing course in a schedule at the
    /// same index in `possibleSchedules`. For example, if a Course named Bio
    /// was the starting course in possibleSchedules[0], then offset would be 1.
    int offset = 1;
    for (int j = 0; j < possibleSchedules.length; j++) {
      for (int i = offset; i < courses.length; i++) {
        final int code = possibleSchedules[j].canAddCourse(courses[i]);
        switch (code) {
          case 1: // Course already in schedule
            break;
          case 0: // Course can be added without issue
            possibleSchedules[j].addCourse(courses[i]);
            break;
          case -1: // Course is not in schedule and causes a conflict
            final Schedule newSchedule = possibleSchedules[j].deepcopy();
            Course? conflictCourse = newSchedule.conflictingCourse(courses[i]);

            // Remove courses until there are no further conflicts
            while (conflictCourse != null) {
              newSchedule.removeCourse(conflictCourse);
              conflictCourse = newSchedule.conflictingCourse(courses[i]);
            }
            newSchedule.addCourse(courses[i]);
            possibleSchedules.add(newSchedule);
            break;
        }
      }
      // Ensure courses that are starting courses are not unnecessarily tested.
      //// Because of sorted courses, it is guaranteed that every existing schedule
      //// already has/conflicts with offset-1.
      if (offset <= possibleSchedules.length) offset++;
    }

    // Sort schedules from highest -> lowest credits
    possibleSchedules.sort();
    return possibleSchedules.reversed.toList();
  }

  /// Get a list of all courses starting at or before a specified time
  List<Course> coursesAtOrBefore(DateTime time) {
    return courses.sublist(
      0,
      courses.lastIndexWhere((e) => time.compareTo(e.time.start) >= 0) + 1,
    );
  }
}
