import 'package:schedyoule/data/models/models.dart';

/// Handles generation of schedules through model interaction
class PossibleSchedulesRepository {
  final List<Course> courses;
  final DateTime latest; // That latest a schedule's first course can be

  PossibleSchedulesRepository({
    required this.courses,
    required this.latest,
  });

  /// Generate a number of possible schedules given a list of courses
  ///
  /// Will attempt to maximize amount of courses taken in a schedule.
  Future<List<Schedule>> generateSchedules() async {
    courses.sort();
    final List<Schedule> possibleSchedules = [
      for (Course c in coursesAtOrBefore(latest)) Schedule()..addCourse(c)
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
        courses.lastIndexWhere((e) => time.compareTo(e.time!.start) >= 0) + 1,
      );
}
