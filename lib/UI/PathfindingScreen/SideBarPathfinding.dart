// ignore_for_file: non_constant_identifier_names

import 'package:algo_visualizer/Globals/decorations.dart';
import 'package:algo_visualizer/extensionMethods.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../Globals/constants.dart';
import '../../Globals/styles.dart';
import '../../Providers/GridProvider.dart';
import '../Helpers/Buttons.dart';
import '../Helpers/DropdownButton.dart';
import '../Helpers/Slider.dart';

ValueNotifier<int> _rows = ValueNotifier(10);
ValueNotifier<int> _cols = ValueNotifier(10);

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
          space60v,
          _Properties(),
          space60v,
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
    final int visitedNodes =
        context.select<GridPr, int>((GridPr gridPr) => gridPr.visitedNodes);

    const Divider divider = Divider(
      color: Colors.white38,
      height: 40,
      thickness: 2,
      indent: 40,
      endIndent: 40,
    );

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 30),
      decoration: Decorations.sideBarContainers,
      child: Column(
        children: [
          const _RowsAndCols(),
          divider,
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('Visited nodes: ', style: Styles.b4,),
              Text(visitedNodes.toString(), style: Styles.b3,),
            ],
          ),
          divider,
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('Total Cost: ', style: Styles.b4,),
              Text(cost.toStringAsFixed(1), style: Styles.b3,),
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
                    Row(
                      children: [
                        const Text('Columns: ', style: Styles.b4,),
                        Text(cols.toString(), style: Styles.b3,),
                      ],
                    ),
                    space10v,
                    Row(
                      children: [
                        const Text('Rows: ', style: Styles.b4,),
                        Text(rows.toString(), style: Styles.b3,),
                      ],
                    ),
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
    final algoType = context.watch<GridPr>().algoType;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        MDropdownMenuButton(
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
            // DropdownMenuItem(
            //   value: 'jps',
            //   child: Text('Jump Point Search'),
            // ),
          ],
        ),
        space30v,
        const _ChoiceChips(),
        space30v,
        const _Sliders(),
      ],
    );
  }

  void _onDropdownChanged(BuildContext context, value) {
    if (value is String) {
      Provider.of<GridPr>(context, listen: false).setAlgoType(value);
    }
  }
}

class _Sliders extends StatelessWidget {
  const _Sliders({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 30),
      decoration: Decorations.sideBarContainers,
      child: Column(
        children: [
          MSlider(
            value: _rows,
            min: 4,
            max: 20,
            label: 'Rows',
            onChanged: (val) {
              _rows.value = val.toInt();
            },
          ),
          space20v,
          MSlider(
            value: _cols,
            min: 4,
            max: 30,
            label: 'Columns',
            onChanged: (val) {
              _cols.value = val.toInt();
            },
          ),
        ],
      ),
    );
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
          label: Text(
            'Live',
            style: Styles.neon(14),
          ),
          selected: gridWatch.isLiveMode,
          onSelected: (_) => _setAnimateMode(context, AnimateMode.live),
        ).withScaleOnHover(1.1),
        ChoiceChip(
          backgroundColor: secondary.withOpacity(0.2),
          selectedColor: secondary.withOpacity(0.6),
          label: Text(
            'Fast',
            style: Styles.neon(14),
          ),
          selected: gridWatch.isFastMode,
          onSelected: (_) => _setAnimateMode(context, AnimateMode.fast),
        ).withScaleOnHover(1.1),
        ChoiceChip(
          backgroundColor: secondary.withOpacity(0.2),
          selectedColor: secondary.withOpacity(0.6),
          label: Text(
            'Normal',
            style: Styles.neon(14),
          ),
          selected: gridWatch.isNormalMode,
          onSelected: (_) => _setAnimateMode(context, AnimateMode.normal),
        ).withScaleOnHover(1.1),
        ChoiceChip(
          backgroundColor: secondary.withOpacity(0.2),
          selectedColor: secondary.withOpacity(0.6),
          label: Text(
            'Slow',
            style: Styles.neon(14),
          ),
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
