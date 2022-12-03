import 'package:algo_visualizer/Globals/styles.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../Globals/constants.dart';

class MSlider extends StatelessWidget {
  const MSlider({
    super.key,
    required this.value,
    required this.min,
    required this.max,
    required this.label,
    required this.onChanged,
  });

  final double min, max;
  final ValueListenable<int> value;
  final void Function(double)? onChanged;
  final String label;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: value,
        builder: (context, val, _) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: Styles.neon(),
              ),
              SliderTheme(
                data: SliderTheme.of(context).copyWith(
                  trackHeight: 6.0,
                  trackShape: const RoundedRectSliderTrackShape(),
                  activeTrackColor: secondary,
                  inactiveTrackColor: secondary100,
                  thumbShape: const RoundSliderThumbShape(
                    enabledThumbRadius: 10.0,
                    pressedElevation: 4.0,
                  ),
                  thumbColor: secondary300,
                  overlayColor: secondary300.withOpacity(0.2),
                  overlayShape:
                      const RoundSliderOverlayShape(overlayRadius: 20.0),
                  valueIndicatorShape: const PaddleSliderValueIndicatorShape(),
                  valueIndicatorColor: background,
                  valueIndicatorTextStyle: Styles.neon(12)
                ),
                child: Slider(
                  min: min,
                  max: max,
                  divisions: 990,
                  value: val.toDouble(),
                  label: val.toString(),
                  onChanged: onChanged,
                ),
              ),
            ],
          );
        });
  }
}
