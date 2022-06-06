import 'package:flutter/material.dart';

// TODO: Animate between enabled/disabled state

const Set<int> days = {
  DateTime.sunday,
  DateTime.monday,
  DateTime.tuesday,
  DateTime.wednesday,
  DateTime.thursday,
  DateTime.friday,
  DateTime.saturday,
};

class BubbleDayPicker extends StatelessWidget {
  // Days listed here will not be rendered to the screen.
  final Set<int>? exclude;

  // List of days that will start as enabled.
  final Set<int>? selected;

  // Called whenever an item is picked/unpicked with the modified item & state.
  final void Function(int, bool)? onChanged;

  const BubbleDayPicker({
    Key? key,
    this.exclude = const {},
    this.selected = const {},
    this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Ensure excluded days aren't rendered
        for (final int s in days.difference(exclude!))
          Expanded(
            child: Bubble(
              value: s,
              onTap: onChanged,
              initiallyEnabled: selected?.contains(s),
            ),
          ),
      ],
    );
  }
}

class Bubble extends StatefulWidget {
  final int value;
  final void Function(int, bool)? onTap;
  final bool? initiallyEnabled;

  const Bubble({
    Key? key,
    required this.value,
    this.onTap,
    this.initiallyEnabled = false,
  }) : super(key: key);

  @override
  State<Bubble> createState() => _BubbleState();
}

class _BubbleState extends State<Bubble> {
  late bool enabled;

  @override
  void initState() {
    enabled = widget.initiallyEnabled!;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      customBorder: const CircleBorder(),
      child: Container(
        padding: const EdgeInsets.all(4),
        decoration: enabled
            ? BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.blue),
              )
            : null,
        child: Center(
          child: Text(
            numToDay(widget.value),
            style: TextStyle(color: enabled ? Colors.blue : null),
          ),
        ),
      ),
      onTap: () {
        setState(() => enabled = !enabled);
        if (widget.onTap != null) widget.onTap!(widget.value, enabled);
      },
    );
  }
}

String numToDay(int day) {
  switch (day) {
    case DateTime.monday:
      return 'M';
    case DateTime.tuesday:
      return 'T';
    case DateTime.wednesday:
      return 'W';
    case DateTime.thursday:
      return 'R';
    case DateTime.friday:
      return 'F';
    case DateTime.saturday:
      return 'S';
    case DateTime.sunday:
      return 'U';
    default:
      return 'M';
  }
}
