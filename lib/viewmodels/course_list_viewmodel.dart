import 'package:flutter/foundation.dart' show Key;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:schedyoule/constants/constants.dart';
import 'package:schedyoule/data/models/models.dart';
import 'package:schedyoule/data/repositories/course_schedule_repository.dart';

// TODO: Logging
class CourseListViewModel extends StateNotifier<CourseScheduleRepository> {
  CourseListViewModel([List<Course>? courses, DateTime? latest])
      : super(CourseScheduleRepository(
          courses: courses ?? List.empty(growable: true),
          latest: latest,
        ));

  List<Course> get courses => state.courses;

  /// Creates a new defaultCourse and adds appends it to the state's courselist
  Future<Course> createDefaultCourse() async {
    state = state.copyWith(courses: [...courses, defaultCourse]);
    return defaultCourse;
  }

  /// Add a course to the list
  Future<void> addCourse(Course course) async {
    state = state.copyWith(courses: [...courses, course]);
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
    final List<Course> newCourses = List.from(courses);
    final int index = newCourses.indexWhere((e) => e.key == course.key);
    newCourses.replaceRange(index, index + 1, [course]);
    state = state.copyWith(courses: newCourses);
  }

  Future<void> setLatest(DateTime latest) async =>
      state = state.copyWith(latest: latest);

  /// Generate a number of possible schedules given a list of courses
  ///
  /// Will attempt to maximize amount of courses taken in a schedule.
  Future<List<Schedule>> generateSchedules() async {
    courses.sort();

    final List<Schedule> possibleSchedules = [
      for (Course c in coursesAtOrBefore(state.latest!))
        Schedule()..addCourse(c)
    ];

    /// Offset is index + 1 of the only existing course in a schedule at the
    /// same index in `possibleSchedules`. For example, if a Course named Bio
    /// was the starting course in possibleSchedules[0], then offset would be 1.
    int offset = 1;
    for (int i = 0 + offset; i < courses.length; i++) {
      for (final Schedule schedule in possibleSchedules) {
        if (schedule.canAddCourse(courses[i])) {
          schedule.addCourse(courses[i]);
        } else {
          final Schedule newSchedule = schedule.deepcopy();
          Course? conflictCourse = newSchedule.conflictingCourse(courses[i]);

          // Remove courses until there are no further conflicts
          while (conflictCourse != null) {
            newSchedule.removeCourse(conflictCourse);
            conflictCourse = newSchedule.conflictingCourse(courses[i]);
          }
          newSchedule.addCourse(courses[i]);
        }
      }
      // Ensure courses that couldn't be starting courses will all be tested.
      if (offset <= possibleSchedules.length) offset++;
    }

    return possibleSchedules;
  }

  /// Get a list of all courses starting at or before a specified time
  List<Course> coursesAtOrBefore(DateTime time) {
    return courses.sublist(
      0,
      courses.lastIndexWhere((e) => time.compareTo(e.time.start) >= 0) + 1,
    );
  }
}
