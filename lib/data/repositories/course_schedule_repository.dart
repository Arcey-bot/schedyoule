import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:schedyoule/constants/constants.dart';

import 'package:schedyoule/data/models/models.dart';

@immutable
class CourseScheduleRepository {
  // static late final CourseScheduleRepository? _instance;

  // CourseScheduleRepository._internal(this.availableCourses, [this.latest]);

  // /// Returns the same instance of `CourseScheduleRepository` is always returned
  // /// If there is no existing instance to return, an instance is created from the
  // /// given parameters and saved. If there is an existing instance and
  // /// parameters have been passed, the parameters will be ignored.
  // factory CourseScheduleRepository([List<Course>? courses, DateTime? latest]) =>
  //     _instance ??= CourseScheduleRepository._internal(
  //       courses ?? List.empty(growable: true),
  //       latest,
  //     );

  final List<Course> courses;

  CourseScheduleRepository({required this.courses, DateTime? latest})
      : latest = latest ?? defaultLatestDateTime;

  // The latest time a schedule can start at (Default is 10am)
  DateTime? latest = defaultLatestDateTime;

  Future<void> addCourse(Course course) async {
    courses.add(course);
  }

  /// Delete a course
  ///
  /// Returns true if the course was deleted,
  /// Returns false if it could not be deleted (not in the list)
  Future<bool> removeCourse(Course course) async {
    final List<Course> newCourses = List.from(courses);
    return courses.remove(course);
  }

  /// Update a course's attributes
  Future<void> updateCourse(Key key, Course course) async {
    final index = courses.indexWhere((element) => element.key == key);

    if (index != -1) courses[index] = course;
  }

  Future<void> setLatestStart(DateTime newLatest) async => latest = newLatest;

  /// Generate a number of possible schedules given a list of courses
  ///
  /// Will attempt to maximize amount of courses taken in a schedule.
  Future<List<Schedule>> generateSchedules() async {
    courses.sort();

    final List<Schedule> possibleSchedules = [
      for (Course c in coursesAtOrBefore(latest!)) Schedule()..addCourse(c)
    ];

    for (final Course course in courses) {
      for (final Schedule schedule in possibleSchedules) {
        if (schedule.canAddCourse(course)) {
          schedule.addCourse(course);
        } else {
          final Schedule newSchedule = schedule.deepcopy();
          Course? conflictCourse = newSchedule.conflictingCourse(course);

          // Remove courses until there are no further conflicts
          while (conflictCourse != null) {
            newSchedule.removeCourse(conflictCourse);
            conflictCourse = newSchedule.conflictingCourse(course);
          }
          newSchedule.addCourse(course);
        }
      }
    }

    return possibleSchedules;
  }

  /// Get a list of all courses starting at or before a specified time
  List<Course> coursesAtOrBefore(DateTime time) => courses.sublist(
        0,
        courses.lastIndexWhere(
              (e) => time.compareTo(e.time.start) >= 0,
            ) +
            1,
      );

  CourseScheduleRepository copyWith({
    List<Course>? courses,
    DateTime? latest,
  }) =>
      CourseScheduleRepository(
        courses: courses ?? this.courses,
        latest: latest ?? this.latest,
      );
}
