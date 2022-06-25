import 'package:flutter/material.dart';
import 'package:schedyoule/constants/constants.dart';

const Set<int> days = {
  DateTime.sunday,
  DateTime.monday,
  DateTime.tuesday,
  DateTime.wednesday,
  DateTime.thursday,
  DateTime.friday,
  DateTime.saturday,
};

/// Both are necessary to prevent all bubbles from animating
/// when any one of them are clicked. Must be global, when stored as state
/// local to [BubbleDayPicker], values are lost since onChanged is modifying a
/// parent, thus the entire widget is slated for disposal.
int? lastClicked;
Key? lastKey;

class BubbleDayPicker extends StatefulWidget {
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
  State<BubbleDayPicker> createState() => _BubbleDayPickerState();
}

class _BubbleDayPickerState extends State<BubbleDayPicker> {
  void _onBubbleTap(int value, bool changed) {
    lastClicked = value;
    lastKey = widget.key;
    if (widget.onChanged != null) widget.onChanged!(value, changed);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        for (final int s in days.difference(widget.exclude!))
          Expanded(
            child: Bubble(
              value: s,
              onTap: _onBubbleTap,
              initiallyEnabled: widget.selected?.contains(s),
              shouldAnimate: lastClicked == s && widget.key == lastKey,
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
  final bool? shouldAnimate;

  const Bubble({
    Key? key,
    required this.value,
    this.onTap,
    this.initiallyEnabled = false,
    this.shouldAnimate = false,
  }) : super(key: key);

  @override
  State<Bubble> createState() => _BubbleState();
}

class _BubbleState extends State<Bubble> with TickerProviderStateMixin {
  late final AnimationController _animController;
  late bool enabled;

  @override
  void initState() {
    _animController = AnimationController(
      vsync: this,
      duration: bubbleAnimationDuration,
    );
    enabled = widget.initiallyEnabled!;
    if (widget.shouldAnimate!) _animController.forward();
    super.initState();
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      customBorder: const CircleBorder(),
      onTap: () {
        setState(() => enabled = !enabled);
        if (widget.onTap != null) widget.onTap!(widget.value, enabled);
      },
      child: buildBubble(),
    );
  }

  Widget buildBubble() {
    // Bubble is enabled
    if (enabled) {
      // Bubble must be animated
      if (widget.shouldAnimate!) {
        return buildAnimatedBubble();
      }
      return buildEnabledBubble();
    }
    return buildDisabledBubble();
  }

  Widget buildDisabledBubble() {
    return Container(
      padding: const EdgeInsets.all(4),
      child: Center(
        child: Text(
          numToDay(widget.value),
        ),
      ),
    );
  }

  Widget buildEnabledBubble() {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: Colors.blue),
      ),
      child: Center(
        child: Text(
          numToDay(widget.value),
          style: const TextStyle(color: Colors.blue),
        ),
      ),
    );
  }

  Widget buildAnimatedBubble() {
    return ScaleTransition(
      scale: _animController,
      child: buildEnabledBubble(),
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
