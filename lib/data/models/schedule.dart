import 'dart:collection';

import 'course.dart';

class Schedule implements Comparable<Schedule> {
  /// Dict of days (int) mapped to a list of courses scheduled for said day.
  final Map<int, List<Course>> schedule = {
    1: [],
    2: [],
    3: [],
    4: [],
    5: [],
    6: [],
    7: [],
  };

  /// Names of all currently taken courses.
  final Set<String> courseNames = <String>{};

  /// Days that have at least one course on the schedule
  // SplayTreeSet allows for the set to be sorted - useful for printing.
  final SplayTreeSet<int> scheduledDays = SplayTreeSet<int>();

  /// Sum of credits in each course in schedule.
  int totalCredits = 0;

  /// Create an empty Course Schedule
  Schedule();

  /// Create a Course Schedule from a given list of Courses
  ///
  /// Note that NO checks will be done to determine if these courses are actually
  /// compatible and able to make a real, viable schedule. Provided courses are
  /// assumed to have already been checked and validated by the caller.
  Schedule.fromCourses(List<Course> courses) : super() {
    for (final Course c in courses) {
      addCourse(c);
    }
  }

  /// Determines if a course can be added to the current schedule
  /// without causing conflicts
  /// Returns -1 if the course conflicts with another course in the schedule
  /// Returns 0 if course can be added without issue
  /// Returns 1 if a course with the same name already exists in schedule
  int canAddCourse(Course course) {
    // Check if course is already in the schedule to prevent duplicates
    if (courseNames.contains(course.name)) return 1;

    // if (scheduledDays.isEmpty) return true;

    // Intersection of course.days and scheduledDays returns potential conflicts
    for (final int day in scheduledDays.intersection(course.days)) {
      // Check that the last course's timeslot doesn't conflict with `course`'s
      // timeslot
      if (schedule[day]!.last.conflictsWith(course)) return -1;
    }

    // If empty, then there are no courses to cause a conflict with
    return 0;
  }

  /// Add a course to the schedule
  ///
  /// This function will ALWAYS add a course and does NOT perform any checks
  /// with regard to the addition's validity.
  void addCourse(Course course) {
    courseNames.add(course.name); // Save the course name for future ref
    scheduledDays.addAll(
      // Add any new days to scheduledDays
      scheduledDays.union(course.days),
    );

    totalCredits += course.credits;

    for (final int day in course.days) {
      schedule[day]!.add(course);
    }
  }

  @override
  String toString() {
    final StringBuffer str = StringBuffer();

    int spaces = 10;
    for (final int day in scheduledDays) {
      final String d = numToDay(day);
      str.write(d + ' ' * (spaces - d.length));
      str.writeAll(schedule[day]!.where((element) => true), ' -> ');
      str.writeln();
    }

    return str.toString();
  }

  static String numToDay(final int num) {
    switch (num) {
      case DateTime.monday:
        return 'Monday';
      case DateTime.tuesday:
        return 'Tuesday';
      case DateTime.wednesday:
        return 'Wednesday';
      case DateTime.thursday:
        return 'Thursday';
      case DateTime.friday:
        return 'Friday';
      case DateTime.saturday:
        return 'Saturday';
      case DateTime.sunday:
        return 'Sunday';
      default:
        return 'Sunday';
    }
  }

  /// Compares this to `other` based on `totalCredits`
  ///
  /// Returns -1 if this has less credits than `other`
  /// Returns 0 if this and `other` have the same number of credits
  /// Returns 1 if this has more credits than `other`
  @override
  int compareTo(Schedule other) {
    if (totalCredits < other.totalCredits) {
      return -1;
    } else if (totalCredits == other.totalCredits) {
      return 0;
    }
    return 1;
  }

  /// Returns null if conflicting course is the same course as whats's trying to be added
  Course? conflictingCourse(Course c) {
    // Check if course is already in the schedule to prevent duplicates
    if (courseNames.contains(c.name)) return null;

    // Intersection returns only possible conflict point between courses
    for (final int day in scheduledDays.intersection(c.days)) {
      // Ensure courses exist to check for conflicts
      if (schedule[day]!.isNotEmpty && schedule[day]!.last.conflictsWith(c)) {
        return schedule[day]!.last;
      }
    }
    return null;
  }

  /// Returns a deep copy of `this`
  Schedule deepcopy() {
    final Set<Course> courses = {};

    // Each value in the schedule is a list of courses that must be copied
    for (final List<Course> l in schedule.values) {
      courses.addAll(l);
    }
    // schedule.values.map((element) => courses.addAll(element));

    return Schedule.fromCourses(courses.toList());
  }

  /// Remove given course on every day it is in the schedule
  ///
  /// If given course is not in the schedule, this function does nothing.
  void removeCourse(Course c) {
    // If remove is successful, course is in schedule and will be removed.
    if (courseNames.remove(c.name)) {
      totalCredits -= c.credits;

      for (final int day in c.days) {
        schedule[day]!.remove(c);
      }
    }
  }
}
