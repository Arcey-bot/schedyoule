import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:schedyoule/constants/constants.dart';
import 'package:schedyoule/constants/en_strings.dart';
import 'package:schedyoule/data/models/models.dart';
import 'package:schedyoule/providers/providers.dart';
import 'package:schedyoule/views/widgets/bubble_day_picker.dart';
import 'package:schedyoule/views/widgets/time_button.dart';

class CourseCard extends ConsumerStatefulWidget {
  final Course course;

  const CourseCard({
    Key? key,
    required this.course,
  }) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _CourseCardState();
}

class _CourseCardState extends ConsumerState<CourseCard> {
  late final TextEditingController _nameController;
  late final TextEditingController _creditController;
  bool? _clearNameOnTap;
  bool? _clearCreditOnTap;

  @override
  void initState() {
    _nameController = TextEditingController(text: widget.course.name);
    _creditController = TextEditingController(
      text: widget.course.credits.toString(),
    );

    _clearNameOnTap = widget.course.placeholder;
    _clearCreditOnTap = widget.course.placeholder;
    super.initState();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _creditController.dispose();
    super.dispose();
  }

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
                Flexible(flex: 6, child: buildNameField()),
                const SizedBox(width: 36),
                const Text('Credits:'),
                Flexible(flex: 1, child: buildCreditField()),
              ],
            ),
            const Divider(color: Colors.grey, height: 4.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: BubbleDayPicker(
                    exclude: const {DateTime.saturday, DateTime.sunday},
                    selected: widget.course.days,
                    onChanged: _onDayChanged,
                  ),
                ),
                const SizedBox(width: 8),
                buildTimeButtonPair(),
              ],
            )
          ],
        ),
      ),
    );
  }

  void _onDayChanged(int value, bool enabled) {
    enabled ? widget.course.addDay(value) : widget.course.removeDay(value);
    ref
        .read(courseScheduleProvider.notifier)
        .updateCourse(widget.course.key!, widget.course);
  }

  int dayToNum(String day) {
    switch (day) {
      case 'M':
        return 1;
      case 'T':
        return 2;
      case 'W':
        return 3;
      case 'R':
        return 4;
      case 'F':
        return 5;
      default: // Return Monday by default
        return 1;
    }
  }

  Widget buildNameField() {
    return Focus(
      onFocusChange: (v) {
        // Only updates card when it is no longer selected by the user
        if (!v) {
          ref.read(courseScheduleProvider.notifier).updateCourse(
                widget.course.key!,
                widget.course.copyWith(name: _nameController.text),
              );
        }
      },
      child: TextField(
        decoration: InputDecoration(
          suffixIcon: Icon(Icons.edit),
          hintText: courseEntryCardNameFieldHint,
          hintStyle: _nameController.text.isEmpty
              ? TextStyle(color: Colors.red.shade400)
              : null,
        ),
        controller: _nameController,
        style: const TextStyle(
          fontWeight: FontWeight.w900,
          fontSize: 18.0, // Default is 14
        ),
        onTap: () {
          if (_clearNameOnTap!) {
            _nameController.clear();
            _clearNameOnTap = false;
          }
        },
      ),
    );
  }

  Widget buildCreditField() {
    return Focus(
      onFocusChange: (v) {
        // Only updates card when it is no longer selected by the user
        if (!v) {
          ref.read(courseScheduleProvider.notifier).updateCourse(
                widget.course.key!,
                widget.course.copyWith(
                  credits:
                      int.tryParse(_creditController.text) ?? defaultCredits,
                ),
              );
        }
      },
      child: TextField(
        keyboardType: TextInputType.number,
        controller: _creditController,
        decoration: const InputDecoration(
          hintText: courseEntryCardCreditFieldHint,
        ),
        textAlign: TextAlign.center,
        onTap: () {
          if (_clearCreditOnTap!) {
            _creditController.clear();
            _clearCreditOnTap = false;
          }
        },
      ),
    );
  }

  Widget buildTimeButtonPair() {
    final TimeOfDay startTime = TimeOfDay.fromDateTime(
      widget.course.time.start,
    );

    final TimeOfDay endTime = TimeOfDay.fromDateTime(widget.course.time.end);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        TimeButton(time: startTime, onChange: _onStartChange),
        const Text('-'),
        TimeButton(time: endTime, onChange: _onEndChange),
      ],
    );
  }

  Future<void> _onStartChange(TimeOfDay time) async {
    await ref.read(courseScheduleProvider.notifier).updateCourse(
          widget.course.key!,
          widget.course.copyWith(
            time: TimeSlot(
              start: DateTime(2022, 1, 1, time.hour, time.minute),
              end: widget.course.time.end,
            ),
          ),
        );
  }

  Future<void> _onEndChange(TimeOfDay time) async {
    await ref.read(courseScheduleProvider.notifier).updateCourse(
          widget.course.key!,
          widget.course.copyWith(
            time: TimeSlot(
              start: widget.course.time.start,
              end: DateTime(2022, 1, 1, time.hour, time.minute),
            ),
          ),
        );
  }
}
