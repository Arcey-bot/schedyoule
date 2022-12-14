import 'package:flutter/material.dart';
import 'package:schedyoule/data/models/models.dart';

Course defaultCourse = Course(
  name: '',
  time: TimeSlot.fromInt(
    startHour: 9,
    startMinute: 0,
    endHour: 10,
    endMinute: 50,
  ),
  days: {
    DateTime.monday,
    DateTime.wednesday,
    DateTime.friday,
  },
  credits: defaultCredits,
  placeholder: true,
);

final DateTime defaultLatestDateTime = DateTime(
  2022,
  1,
  1,
  defaultLatest.hour,
  defaultLatest.minute,
);

enum GenerateButtonState {
  disabled,
  ready,
  generating,
}

const defaultCredits = 3;
const numSchedulesStartExpanded = 2;
const TimeOfDay defaultLatest = TimeOfDay(hour: 9, minute: 0);
const int generateAnimationDuration = 1500; // Milliseconds
const double generateAnimationOpacity = 0.4; // Opacity [0, 1]
const double generateAnimationOffset = 0.3; // [0, 1]
const double generateAnimationSize = 0.25; // [0, 1]
const Duration bubbleAnimationDuration = Duration(milliseconds: 250);
const String coursesBoxKey = 'courses';

const List<String> courseCardPlaceholderTitles = [
  'Math',
  'Physics',
  'Biology',
  'History',
  'Chemistry',
  'English',
  'Spanish',
];

final List<Course> defaultCourseList = [
  Course(
    name: 'Physics',
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
    name: 'English',
    time: TimeSlot.fromInt(
        startHour: 9, startMinute: 0, endHour: 9, endMinute: 50),
    days: {
      DateTime.tuesday,
      DateTime.thursday,
      DateTime.friday,
    },
  ),
  Course(
    name: 'Math',
    time: TimeSlot.fromInt(
        startHour: 11, startMinute: 0, endHour: 12, endMinute: 50),
    days: {
      DateTime.thursday,
    },
  ),
];
