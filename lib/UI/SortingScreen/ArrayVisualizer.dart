import 'package:algo_visualizer/Classes/ArrayElement.dart';
import 'package:algo_visualizer/Globals/constants.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../Globals/functions.dart';
import '../../Providers/ArrayProvider.dart';

class ArrayVisualizer extends StatelessWidget {
  const ArrayVisualizer({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    
    final int count = context.select((ArrayPr arrayPr) => arrayPr.length);

    final h = screenHeight(context);
    final w = screenWidth(context);

    if (count == 0) {
      return SizedBox(
        width: w - navBarWidth - sideBarWidth,
      );
    }

    final width = (w - navBarWidth - sideBarWidth - 32) / count;

    return Consumer<ArrayPr>(
      builder: (_, arrayPr, ___) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.9),
        child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: arrayPr.array
                .map((ele) => Container(
                      height: ele.value / arrayPr.max * (h - 60),
                      width: ele.isCurrent ? width + 0.2 : width,
                      color: ele.color,
                    ))
                .toList()),
      ),
    );
  }
}
