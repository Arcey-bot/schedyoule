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

const defaultCredits = 3;
