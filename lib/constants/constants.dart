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

const defaultCredits = 3;
const TimeOfDay defaultLatest = TimeOfDay(hour: 9, minute: 0);
