import 'package:day_night_time_picker/lib/daynight_timepicker.dart';
import 'package:flutter/material.dart';
import 'package:schedyoule/constants/en_strings.dart';

// TODO: Add optional course parameter to generate prefilled card

class CourseEntryCard extends StatelessWidget {
  const CourseEntryCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Flexible(flex: 7, child: buildNameField()),
                const SizedBox(width: 36),
                Flexible(flex: 1, child: buildCreditField()),
              ],
            ),
            const Divider(color: Colors.grey, height: 4.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Text('S M T W R F S'),
                TimeButtonPair(),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget buildNameField() {
    return const TextField(
      decoration: InputDecoration(
        hintText: courseEntryCardNameFieldHint,
      ),
      style: TextStyle(
        fontWeight: FontWeight.w900,
        fontSize: 18.0, // Default is 14
      ),
    );
  }

  Widget buildCreditField() {
    return const TextField(
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        hintText: courseEntryCardCreditFieldHint,
      ),
      textAlign: TextAlign.center,
    );
  }
}

class TimeButtonPair extends StatefulWidget {
  const TimeButtonPair({Key? key}) : super(key: key);

  @override
  State<TimeButtonPair> createState() => _TimeButtonPairState();
}

class _TimeButtonPairState extends State<TimeButtonPair> {
  TimeOfDay start = const TimeOfDay(hour: 9, minute: 0);
  TimeOfDay end = const TimeOfDay(hour: 9, minute: 50);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildTimeButton(context, start),
        const Text('-'),
        _buildTimeButton(context, end),
      ],
    );
  }

  TextButton _buildTimeButton(BuildContext context, TimeOfDay time) {
    return TextButton(
      onPressed: () {
        Navigator.of(context).push(
          showPicker(
            value: time,
            onChange: (t) => setState(() => start = t),
          ),
        );
      },
      child: Text(time.format(context)),
    );
  }
}
