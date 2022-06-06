import 'package:day_night_time_picker/lib/daynight_timepicker.dart';
import 'package:flutter/material.dart';

class TimeButton extends StatelessWidget {
  /// Time to display on first build
  final TimeOfDay time;
  final void Function(TimeOfDay)? onChange;

  const TimeButton({
    Key? key,
    required this.time,
    this.onChange,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        Navigator.of(context).push(
          showPicker(
            value: time,
            onChange: (t) {
              if (onChange != null) onChange!(t);
            },
          ),
        );
      },
      child: Text(time.format(context)),
    );
  }
}
