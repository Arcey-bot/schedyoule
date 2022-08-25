import 'dart:convert';

import 'package:intl/intl.dart';

class TimeSlot implements Comparable<TimeSlot> {
  /// Doesn't matter, just for DateTime init.
  static const _year = 2022;
  final DateTime start;
  final DateTime end;

  const TimeSlot({
    required this.start,
    required this.end,
  });

  /// Expects a base 10 string of numbers to represent a fragment of time
  /// Example: For a start time of 7:45 A.M. and end time of 1:00 P.M.
  /// You would call like so:
  ///   ```dart
  ///   TimeSlot.fromString(
  ///     startHour: '7',
  ///     startMinute: '45',
  ///     endHour: '13',
  ///     endMinute: '0',
  ///   );```
  TimeSlot.fromString({
    required final String startHour,
    required final String startMinute,
    required final String endHour,
    required final String endMinute,
  }) : this.fromInt(
          startHour: int.parse(startHour),
          startMinute: int.parse(startMinute),
          endHour: int.parse(endHour),
          endMinute: int.parse(endMinute),
        );

  /// Expects hours to be given in 24 hour format.
  TimeSlot.fromInt({
    required final int startHour,
    required final int startMinute,
    required final int endHour,
    required final int endMinute,
  }) : this(
          start: DateTime(_year, 1, 1, startHour, startMinute),
          end: DateTime(_year, 1, 1, endHour, endMinute),
        );

  @override
  String toString() {
    //* Can use jm() instead of Hm() for localized 12hr time.
    return '${DateFormat.jm().format(start)} - ${DateFormat.jm().format(end)}';
  }

  /// Compares this to `other`
  ///
  /// Returns -1 if this course start is before `other` start
  /// Returns 1 if this course start is after `other` start
  /// Returns 0 if this course and `other` course share start & end time
  /// Note when start compares to 0, the returned value is determined
  /// exclusively by the result of comparing end times.
  @override
  int compareTo(TimeSlot other) {
    final int startComp = start.compareTo(other.start);

    return startComp != 0 ? startComp : end.compareTo(other.end);
  }

  /// Determines if the timeslots overlap at ANY point
  ///
  /// Returns true if `other` starts or ends at any point in time BETWEEN
  /// when this starts and ends.
  /// Otherwise, returns false
  bool conflictsWith(TimeSlot other) {
    // Let A = this, B = other:
    // Check B starts at or before A ends && B ends when or after A starts
    if (other.start.compareTo(end) <= 0 && other.end.compareTo(start) >= 0) {
      return true;
    }
    return false;
  }

  Map<String, dynamic> toMap() {
    return {
      'start': start.millisecondsSinceEpoch,
      'end': end.millisecondsSinceEpoch,
    };
  }

  factory TimeSlot.fromMap(Map<String, dynamic> map) {
    return TimeSlot(
      start: DateTime.fromMillisecondsSinceEpoch(map['start']),
      end: DateTime.fromMillisecondsSinceEpoch(map['end']),
    );
  }

  String toJson() => json.encode(toMap());

  factory TimeSlot.fromJson(String source) =>
      TimeSlot.fromMap(json.decode(source));
}
