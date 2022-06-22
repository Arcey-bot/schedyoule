import 'package:flutter/material.dart';
import 'package:schedyoule/data/models/models.dart';

Course defaultCourse = Course(
  name: 'Math',
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
  credits: 4,
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
const numSchedulesStartExpaneded = 2;
const TimeOfDay defaultLatest = TimeOfDay(hour: 9, minute: 0);
const int generateAnimationDuration = 1500; // Milliseconds
const double generateAnimationOpacity = 0.4; // Opacity [0, 1]
const double generateAnimationOffset = 0.3; // [0, 1]
const double generateAnimationSize = 0.25; // [0, 1]
