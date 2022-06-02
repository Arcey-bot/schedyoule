import 'package:flutter/foundation.dart' show Key;
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

  /// Expose CourseScheduleRepository functions
  List<Course> get courses => state.courses;

  /// Creates a new defaultCourse and adds appends it to the state's courselist
  Future<Course> createDefaultCourse() async {
    state = state.copyWith(courses: [...state.courses, defaultCourse]);
    return defaultCourse;
  }

  /// Add a course to the list
  Future<void> addCourse(Course course) async {
    state = state.copyWith(courses: [...state.courses, course]);
  }

  /// Remove a course from the list, returns true if successfully removed.
  Future<bool> removeCourse(Course course) async {
    final List<Course> newCourses = List.from(state.courses);
    final r = newCourses.remove(course);
    state = state.copyWith(courses: newCourses);
    return r;
  }

  /// Replace a course in the list with the given course
  Future<void> updateCourse(Key key, Course course) async {
    state = state.copyWith(courses: state.courses);
  }

  /// Run check to validate that all courses are actually usable
}
