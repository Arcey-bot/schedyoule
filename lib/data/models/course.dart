import 'dart:convert';

import 'package:flutter/material.dart' show Key, UniqueKey;

import 'time_slot.dart';

// A course's start and end times are expected to be in 24 hour format.
class Course implements Comparable<Course> {
  final Key? key; // Unique identifier for a course
  final TimeSlot time; // Period of time the course takes up.
  final int credits; // Credits a course is worth.
  final String name; // Course name.
  final String? crn; // Code representing the course (often used to register).
  final Set<int> days; // Days this course takes place on (Use DateTime consts).
  bool? placeholder; // If the course contains user-created data

  Course({
    Key? key,
    required this.name,
    required this.time,
    this.credits = 3, // Most courses (in US) are three credits.
    this.crn,
    required this.days,
    this.placeholder = false,
  }) : key = key ?? UniqueKey(); // Create unique key if none is given

  /// Compares this to `other`
  ///
  /// Returns -1 if this course start is before `other` start
  /// Returns 1 if this course start is after `other` start
  /// Returns 0 if this course and `other` course share start & end time
  /// Note when start compares to 0, the returned value is determined
  /// exclusively by the result of comparing end times.
  @override
  int compareTo(Course other) {
    return time.compareTo(other.time);
  }

  /// Determines if this course's times overlap at ANY point with `other`'s
  ///
  /// Returns true if `other` starts or ends at any point in time BETWEEN
  /// when this starts and ends.
  /// Otherwise, returns false
  bool conflictsWith(Course other) {
    return time.conflictsWith(other.time);
  }

  void addDay(int day) {
    days.add(day);
  }

  void removeDay(int day) {
    days.remove(day);
  }

  @override
  String toString() => '${crn == null ? '' : '$crn: '}$name @ $time on $days';

  Course copyWith({
    Key? key,
    TimeSlot? time,
    int? credits,
    String? name,
    String? crn,
    Set<int>? days,
  }) {
    return Course(
      key: key ?? this.key,
      time: time ?? this.time,
      credits: credits ?? this.credits,
      name: name ?? this.name,
      crn: crn ?? this.crn,
      days: days ?? this.days,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'key': key?.toString(),
      'time': time.toMap(),
      'credits': credits,
      'name': name,
      'crn': crn,
      'days': days.toList(),
      'placeholder': placeholder,
    };
  }

  factory Course.fromMap(Map<String, dynamic> map) {
    return Course(
      key: Key(map['key']),
      time: TimeSlot.fromMap(map['time']),
      credits: map['credits']?.toInt() ?? 0,
      name: map['name'] ?? '',
      crn: map['crn'],
      days: Set<int>.from(map['days']),
      placeholder: map['placeholder'],
    );
  }

  String toJson() => json.encode(toMap());

  factory Course.fromJson(String source) => Course.fromMap(json.decode(source));
}
