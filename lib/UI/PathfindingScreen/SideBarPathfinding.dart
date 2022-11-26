// ignore_for_file: non_constant_identifier_names

import 'dart:math';

import 'package:algo_visualizer/Globals/decorations.dart';
import 'package:algo_visualizer/Globals/functions.dart';
import 'package:algo_visualizer/extensionMethods.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../Classes/GridNode.dart';
import '../../Globals/constants.dart';
import '../../Providers/GridProvider.dart';
import '../Helpers/Buttons.dart';
import '../Helpers/DropdownButton.dart';
import '../Helpers/Slider.dart';

ValueNotifier<int> _rows = ValueNotifier(15);
ValueNotifier<int> _cols = ValueNotifier(15);

class SideBarPathfinding extends StatefulWidget {
  const SideBarPathfinding({super.key});

  @override
  State<SideBarPathfinding> createState() => SideBarPathfindingState();
}

class SideBarPathfindingState extends State<SideBarPathfinding> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
      child: Column(
        children: const [
          _Actions(),
          space80v,
          _Properties(),
          space80v,
          _ActionButtons(),
        ],
      ),
    );
  }
}

class _Properties extends StatelessWidget {
  const _Properties({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final double cost =
        context.select<GridPr, double>((GridPr gridPr) => gridPr.totalCost);
    final double Fcost =
        context.select<GridPr, double>((GridPr gridPr) => gridPr.totalFCost);
    final int visitedNodes =
        context.select<GridPr, int>((GridPr gridPr) => gridPr.visitedNodes);
    final int openedNodes =
        context.select<GridPr, int>((GridPr gridPr) => gridPr.openedNodes);

    const Divider divider = Divider(
      color: Colors.white38,
      height: 40,
      thickness: 2,
      indent: 40,
      endIndent: 40,
    );

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 30),
      decoration: Decorations.sideBarProperties,
      child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const _RowsAndCols(),
                divider,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Opened nodes: $openedNodes'),
                    space10v,
                    Text('Visited nodes: $visitedNodes'),
                  ],
                ),
                divider,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Total F_cost: ${Fcost.toStringAsFixed(1)}'),
                    space10v,
                    Text('Total Cost: ${cost.toStringAsFixed(1)}'),
                  ],
                ),
              ],
            ),
    );
  }
}

class _RowsAndCols extends StatelessWidget {
  const _RowsAndCols({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<int>(
        valueListenable: _cols,
        builder: (context, cols, _) {
          return ValueListenableBuilder<int>(
              valueListenable: _rows,
              builder: (context, rows, _) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Columns: $cols'),
                    space10v,
                    Text('Rows: $rows'),
                  ],
                );
              });
        });
  }
}

class _Actions extends StatelessWidget {
  const _Actions({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final h = screenHeight(context);
    final algoType = context.watch<GridPr>().algoType;
    return h < 640
        ? const SizedBox.shrink()
        : Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              h < 700
                  ? space0
                  : MDropdownMenuButton(
                      value: algoType,
                      onChanged: (value) => _onDropdownChanged(context, value),
                      items: const [
                        DropdownMenuItem(
                          value: 'a-star',
                          child: Text('A* Search'),
                        ),
                        DropdownMenuItem(
                          value: 'dijkstra',
                          child: Text('Dijkstra\'s'),
                        ),
                        DropdownMenuItem(
                          value: 'best-first',
                          child: Text('Best First Search'),
                        ),
                        DropdownMenuItem(
                          value: 'depth-first',
                          child: Text('Depth First Search'),
                        ),
                        DropdownMenuItem(
                          value: 'breadth-first',
                          child: Text('Breadth First Search'),
                        ),
                      ],
                    ),
              space40v,
              const _ChoiceChips(),
              space40v,
              MSlider(
                value: _rows,
                min: 5,
                max: 26,
                onChanged: (val) {
                  _rows.value = val.toInt();
                },
              ),
              MSlider(
                value: _cols,
                min: 4,
                max: 40,
                onChanged: (val) {
                  _cols.value = val.toInt();
                },
              ),
            ],
          );
  }

  void _onDropdownChanged(BuildContext context, value) {
    if (value is String) {
      Provider.of<GridPr>(context, listen: false).setAlgoType(value);
    }
  }
}

class _ChoiceChips extends StatelessWidget {
  const _ChoiceChips({super.key});

  @override
  Widget build(BuildContext context) {
    final gridWatch = context.watch<GridPr>();
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        ChoiceChip(
          backgroundColor: secondary.withOpacity(0.2),
          selectedColor: secondary.withOpacity(0.6),
          label: const Text('Live'),
          selected: gridWatch.isLiveMode,
          onSelected: (_) => _setAnimateMode(context, AnimateMode.live),
        ).withScaleOnHover(1.1),
        ChoiceChip(
          backgroundColor: secondary.withOpacity(0.2),
          selectedColor: secondary.withOpacity(0.6),
          label: const Text('Fast'),
          selected: gridWatch.isFastMode,
          onSelected: (_) => _setAnimateMode(context, AnimateMode.fast),
        ).withScaleOnHover(1.1),
        ChoiceChip(
          backgroundColor: secondary.withOpacity(0.2),
          selectedColor: secondary.withOpacity(0.6),
          label: const Text('Normal'),
          selected: gridWatch.isNormalMode,
          onSelected: (_) => _setAnimateMode(context, AnimateMode.normal),
        ).withScaleOnHover(1.1),
        ChoiceChip(
          backgroundColor: secondary.withOpacity(0.2),
          selectedColor: secondary.withOpacity(0.6),
          label: const Text('Slow'),
          selected: gridWatch.isSlowMode,
          onSelected: (_) => _setAnimateMode(context, AnimateMode.slow),
        ).withScaleOnHover(1.1),
      ],
    );
  }

  void _setAnimateMode(BuildContext context, AnimateMode mode) {
    Provider.of<GridPr>(context, listen: false).setAnimateMode(mode);
  }
}

class _ActionButtons extends StatefulWidget {
  const _ActionButtons({
    super.key,
  });

  @override
  State<_ActionButtons> createState() => _ActionButtonsState();
}

class _ActionButtonsState extends State<_ActionButtons> {
  late final GridPr gridReader;

  @override
  void initState() {
    gridReader = context.read<GridPr>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: sideBarWidth / 2 - 28,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              MElevatedButton(
                onPressed: _generateGrid,
                text: 'Generate',
              ),
              space20v,
              MElevatedButton(
                onPressed: _resetGrid,
                text: 'Reset',
              ),
            ],
          ),
        ),
        const Spacer(),
        SizedBox(
          width: sideBarWidth / 2 - 28,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              MElevatedButton(
                onPressed: _clearGrid,
                text: 'Clear',
              ),
              space20v,
              MElevatedButton(
                onPressed: _onPathfindingBegin,
                text: 'Begin',
              ),
            ],
          ),
        ),
      ],
    );
  }

  Future<void> _onPathfindingBegin() async {
    final algoType = gridReader.algoType;

    bool isLiveMode = gridReader.isLiveMode;

    await gridReader.findTarget(algoType);

    if (!isLiveMode) {
      await Future.delayed(d400);
    }
    await gridReader.animatePath();
  }

  void _resetGrid() {
    gridReader.reset();
  }

  void _clearGrid() {
    gridReader.clear();
  }

  void _generateGrid() {
    gridReader.generateGrid(_rows.value, _cols.value);
  }
}

// class _Slider extends StatelessWidget {
//   const _Slider({
//     super.key,
//     required this.value,
//     required this.min,
//     required this.max,
//     required this.onChanged,
//   });

//   final double min, max;
//   final ValueListenable<int> value;
//   final void Function(double)? onChanged;

//   @override
//   Widget build(BuildContext context) {
//     return ValueListenableBuilder(
//         valueListenable: value,
//         builder: (context, val, _) {
//           return Column(
//             children: [
//               Row(
//                 children: [
//                   Text(min.toInt().toString()),
//                   space120h,
//                   Text(max.toInt().toString()),
//                 ],
//               ),
//               Slider(
//                 min: min,
//                 max: max,
//                 // divisions: 17,
//                 value: val.toDouble(),
//                 onChanged: onChanged,
//               ),
//             ],
//           );
//         });
//   }
// }
