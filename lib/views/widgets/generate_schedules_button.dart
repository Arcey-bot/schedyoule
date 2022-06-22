import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:simple_animations/simple_animations.dart';

import '../../constants/constants.dart';
import '../../providers/providers.dart';
import '../../constants/en_strings.dart';

class GenerateSchedulesButton extends ConsumerWidget {
  const GenerateSchedulesButton({
    Key? key,
    required this.onPressed,
  }) : super(key: key);

  final Function? onPressed;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(generateStateProvider);

    switch (state) {
      case GenerateButtonState.disabled:
        return _buildDisabledButton();
      case GenerateButtonState.ready:
        return _buildReadyButton(onPressed);
      case GenerateButtonState.generating:
        return _buildGeneratingButton();
    }
  }

  Widget _buildReadyButton(onPressed) {
    return ElevatedButton(
      onPressed: onPressed,
      style: const ButtonStyle(),
      child: const Text(courseListViewGenerateButton),
    );
  }

  Widget _buildDisabledButton() {
    return const ElevatedButton(
      onPressed: null, // Disabled button, do nothing on press
      child: Text(courseListViewGenerateButton),
    );
  }

  Widget _buildGeneratingButton() => GradientButton();
}

class GradientButton extends StatelessWidget {
  GradientButton({Key? key}) : super(key: key);
  final GlobalKey _key = GlobalKey();

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;

    return Stack(
      key: _key,
      alignment: AlignmentDirectional.bottomStart,
      fit: StackFit.loose,
      children: [
        SizedBox(
          width: double.maxFinite,
          child: ElevatedButton(
            onPressed: () {},
            child: const Text(courseListViewGenerateButtonGenerating),
          ),
        ),
        MirrorAnimation<double>(
          builder: (context, child, value) {
            return Transform.translate(offset: Offset(value, 0), child: child);
          },
          tween: Tween(begin: -width * generateAnimationOffset, end: width),
          duration: const Duration(milliseconds: generateAnimationDuration),
          curve: Curves.easeInOut,
          child: FractionallySizedBox(
            widthFactor: generateAnimationSize,
            child: Container(
              color: Colors.white.withOpacity(generateAnimationOpacity),
            ),
          ),
        ),
      ],
    );
  }
}
