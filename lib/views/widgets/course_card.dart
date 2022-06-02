import 'package:day_night_time_picker/lib/daynight_timepicker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:schedyoule/constants/constants.dart';
import 'package:schedyoule/constants/en_strings.dart';
import 'package:schedyoule/data/models/models.dart';
import 'package:schedyoule/providers/providers.dart';

class CourseCard extends ConsumerStatefulWidget {
  final Course course;

  /// Called whenever a course's attribute changes.
  ///
  /// `course` is the course with modified attributes
  final Function(Course course)? onChanged;

  const CourseCard({
    Key? key,
    required this.course,
    this.onChanged,
  }) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _CourseCardState();
}

class _CourseCardState extends ConsumerState<CourseCard> {
  late final TextEditingController _nameController;
  late final TextEditingController _creditController;
  bool? _clearNameOnTap;
  bool? _clearCreditOnTap;
  bool? _clearDaysOnTap;

  @override
  void initState() {
    _nameController = TextEditingController(text: widget.course.name);
    _creditController = TextEditingController(
      text: widget.course.credits.toString(),
    );

    _clearNameOnTap = widget.course.placeholder;
    _clearCreditOnTap = widget.course.placeholder;
    _clearDaysOnTap = widget.course.placeholder;
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
    final provider = ref.watch(courseScheduleProvider);

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
              children: [
                const Text('S M T W R F S'),
                buildTimeButtonPair(),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget buildNameField() {
    return TextField(
      decoration: const InputDecoration(
        hintText: courseEntryCardNameFieldHint,
      ),
      controller: _nameController,
      style: const TextStyle(
        fontWeight: FontWeight.w900,
        fontSize: 18.0, // Default is 14
      ),
      onChanged: (text) {
        ref.read(courseScheduleProvider.notifier).updateCourse(
              widget.course.key!,
              widget.course.copyWith(name: text),
            );
      },
      onTap: () {
        if (_clearNameOnTap!) {
          _nameController.clear();
          _clearNameOnTap = false;
        }
      },
    );
  }

  Widget buildCreditField() {
    return TextField(
      keyboardType: TextInputType.number,
      controller: _creditController,
      decoration: const InputDecoration(
        hintText: courseEntryCardCreditFieldHint,
      ),
      textAlign: TextAlign.center,
      onChanged: (text) {
        ref.read(courseScheduleProvider.notifier).updateCourse(
              widget.course.key!,
              widget.course.copyWith(
                credits: int.tryParse(text) ?? defaultCredits,
              ),
            );
      },
      onTap: () {
        if (_clearCreditOnTap!) {
          _creditController.clear();
          _clearCreditOnTap = false;
        }
      },
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

  void _onStartChange(TimeOfDay time) {
    ref.read(courseScheduleProvider.notifier).updateCourse(
          widget.course.key!,
          widget.course.copyWith(
            time: TimeSlot(
              start: DateTime(2022, 1, 1, time.hour, time.minute),
              end: widget.course.time.end,
            ),
          ),
        );
  }

  void _onEndChange(TimeOfDay time) {
    ref.read(courseScheduleProvider.notifier).updateCourse(
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

class TimeButton extends ConsumerWidget {
  final TimeOfDay time;
  final void Function(TimeOfDay)? onChange;

  const TimeButton({
    Key? key,
    required this.time,
    this.onChange,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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

// class TimeButton extends ConsumerStatefulWidget {
//   final TimeOfDay time;
//   final void Function(TimeOfDay)? onChange;

//   const TimeButton({
//     Key? key,
//     required this.time,
//     this.onChange,
//   }) : super(key: key);

//   @override
//   ConsumerState<ConsumerStatefulWidget> createState() => _TimeButtonState();
// }

// class _TimeButtonState extends ConsumerState<TimeButton> {
//   @override
//   Widget build(BuildContext context) {
//     return TextButton(
//       onPressed: () {
//         Navigator.of(context).push(
//           showPicker(
//             value: widget.time,
//             onChange: (t) {
//               if (widget.onChange != null) widget.onChange!(t);
//             },
//           ),
//         );
//       },
//       child: Text(widget.time.format(context)),
//     );
//   }
// }

// class TimeButton extends StatefulWidget {
//   final TimeOfDay time;
//   final void Function(TimeOfDay)? onChange;

//   const TimeButton({
//     Key? key,
//     required this.time,
//     this.onChange,
//   }) : super(key: key);

//   @override
//   State<TimeButton> createState() => _TimeButtonState();
// }

// class _TimeButtonState extends State<TimeButton> {
//   late TimeOfDay time;

//   @override
//   void initState() {
//     time = widget.time;
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return TextButton(
//       onPressed: () {
//         Navigator.of(context).push(
//           showPicker(
//             value: time,
//             onChange: (t) {
//               if (widget.onChange != null) widget.onChange!(t);
//               setState(() => time = t);
//             },
//           ),
//         );
//       },
//       child: Text(time.format(context)),
//     );
//   }
// }


// class CourseCard extends StatefulWidget {
//   Course course;
//   void Function(Course val)? onChanged;

//   CourseCard({
//     Key? key,
//     required this.course,
//     this.onChanged,
//   }) : super(key: key);

//   @override
//   State<CourseCard> createState() => _CourseCardState();
// }

// class _CourseCardState extends State<CourseCard> {
//   late final TextEditingController _nameController;
//   late final TextEditingController _creditController;

//   @override
//   void initState() {
//     _nameController = TextEditingController(text: widget.course.name);
//     _creditController = TextEditingController(
//       text: widget.course.credits.toString(),
//     );
//     super.initState();
//   }

//   @override
//   void dispose() {
//     _nameController.dispose();
//     _creditController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       child: Padding(
//         padding: const EdgeInsets.all(8.0),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             Row(
//               children: [
//                 Flexible(flex: 7, child: buildNameField()),
//                 const SizedBox(width: 36),
//                 Flexible(flex: 1, child: buildCreditField()),
//               ],
//             ),
//             const Divider(color: Colors.grey, height: 4.0),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 const Text('S M T W R F S'),
//                 buildTimeButtonPair(),
//               ],
//             )
//           ],
//         ),
//       ),
//     );
//   }

//   Widget buildNameField() {
//     return TextField(
//       decoration: const InputDecoration(
//         hintText: courseEntryCardNameFieldHint,
//       ),
//       controller: _nameController,
//       style: const TextStyle(
//         fontWeight: FontWeight.w900,
//         fontSize: 18.0, // Default is 14
//       ),
//       onChanged: (text) {
//         setState(() {
//           widget.course = widget.course.copyWith(name: text);
//           if (widget.onChanged != null) widget.onChanged!(widget.course);
//         });
//       },
//     );
//   }

//   Widget buildCreditField() {
//     return TextField(
//       keyboardType: TextInputType.number,
//       controller: _creditController,
//       decoration: const InputDecoration(
//         hintText: courseEntryCardCreditFieldHint,
//       ),
//       textAlign: TextAlign.center,
//       onChanged: (text) {
//         setState(() {
//           widget.course = widget.course.copyWith(credits: int.tryParse(text));
//           if (widget.onChanged != null) widget.onChanged!(widget.course);
//         });
//       },
//     );
//   }

//   Widget buildTimeButtonPair() {
//     final TimeOfDay startTime = TimeOfDay.fromDateTime(
//       widget.course.time.start,
//     );

//     final TimeOfDay endTime = TimeOfDay.fromDateTime(widget.course.time.end);

//     return Row(
//       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//       children: [
//         TimeButton(time: startTime),
//         const Text('-'),
//         TimeButton(time: endTime),
//       ],
//     );
//   }
// }

