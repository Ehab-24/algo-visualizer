
import 'package:flutter/material.dart';

import '../../Globals/constants.dart';
import 'BodyExplanation.dart';

class ScreenExplanation extends StatelessWidget {
  const ScreenExplanation({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: background,
      body: BodyExplanation(),
    );
  }
}