import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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

  Widget _buildGeneratingButton() => const GradientButton();
}

class GradientButton extends StatelessWidget {
  const GradientButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: AlignmentDirectional.bottomStart,
      fit: StackFit.loose,
      children: [
        SizedBox(
          width: double.maxFinite,
          child: ElevatedButton(
            style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(Colors.red)),
            onPressed: () {},
            child: const Text(courseListViewGenerateButtonGenerating),
          ),
        ),
      ],
    );
  }
}
