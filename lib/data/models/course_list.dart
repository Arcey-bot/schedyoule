import 'package:schedyoule/data/models/course.dart';

class CourseList {
  static final CourseList _instance = CourseList._internal();
  static final List<Course> _courses = [];

  CourseList._internal();
  factory CourseList() => _instance;

  List<Course> get courses => _courses;

  void addCourse(Course course) => _courses.add(course);

  /// Delete a course
  ///
  /// Returns true if the course was deleted,
  /// Returns false if it could not be deleted (not in the list)
  bool deleteCourse(Course course) => _courses.remove(course);
}
