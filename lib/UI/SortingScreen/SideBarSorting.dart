import 'package:algo_visualizer/Globals/decorations.dart';
import 'package:algo_visualizer/Globals/functions.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../Globals/constants.dart';
import '../../Providers/ArrayProvider.dart';
import '../Helpers/Buttons.dart';
import '../Helpers/Slider.dart';
import '../Helpers/DropdownButton.dart';

ValueNotifier<int> _size = ValueNotifier(10);
String sortType = 'selection';

class SideBarSorting extends StatefulWidget {
  const SideBarSorting({super.key});

  @override
  State<SideBarSorting> createState() => SideBarSortingState();
}

class SideBarSortingState extends State<SideBarSorting> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
      child: Column(
        children: const [
          _Actions(),
          space120v,
          _Properties(),
          space120v,
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
    final int swapsCount =
        context.select<ArrayPr, int>((ArrayPr arrayPr) => arrayPr.swapsCount);
    final int arrayAccesses = context
        .select<ArrayPr, int>((ArrayPr arrayPr) => arrayPr.arrayAccesses);
    final int max =
        context.select<ArrayPr, int>((ArrayPr arrayPr) => arrayPr.max);

    const Divider divider = Divider(
      color: Colors.white38,
      height: 40,
      thickness: 2,
      indent: 40,
      endIndent: 40,
    );

    return ValueListenableBuilder<int>(
      valueListenable: _size,
      builder: (context, length, child) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 30),
        decoration: Decorations.sideBarProperties,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('Swaps count: $swapsCount'),
            divider,
            Text('Array accesses: $arrayAccesses'),
            divider,
            Text('Length: $length'),
            divider,
            Text('Range: 0 ... $max'),
          ],
        ),
      ),
    );
  }
}

class _Actions extends StatefulWidget {
  const _Actions({
    super.key,
  });

  @override
  State<_Actions> createState() => _ActionsState();
}

class _ActionsState extends State<_Actions> {
  @override
  Widget build(BuildContext context) {
    final w = screenWidth(context);
    return SizedBox(
      width: w,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          MDropdownMenuButton(
            value: sortType,
            onChanged: (value) {
              if (value is String) {
                setState(() {
                  sortType = value;
                });
              }
            },
            items: const [
              DropdownMenuItem(
                value: 'bubble',
                child: Text('Bubble Sort'),
              ),
              DropdownMenuItem(
                value: 'selection',
                child: Text('Selection Sort'),
              ),
              DropdownMenuItem(
                value: 'insertion',
                child: Text('Insertion Sort'),
              ),
              DropdownMenuItem(
                value: 'quick',
                child: Text('Quick Sort'),
              ),
              DropdownMenuItem(
                value: 'cocktail',
                child: Text('Cocktail Sort'),
              ),
              DropdownMenuItem(
                value: 'merge',
                child: Text('Merge Sort'),
              ),
            ],
          ),
          space40v,
          MSlider(
            value: _size,
            min: 10,
            max: 1000,
            onChanged: (val) {
              _size.value = val.round();
            },
          )
        ],
      ),
    );
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
  late final ArrayPr arrayReader;

  @override
  void initState() {
    arrayReader = context.read<ArrayPr>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: sideBarWidth / 2 - 28,
          child: MElevatedButton(
            onPressed: _generateArray,
            text: 'Generate',
          ),
        ),
        const Spacer(),
        SizedBox(
          width: sideBarWidth / 2 - 28,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              MElevatedButton(
                onPressed: _clearArray,
                text: 'Clear',
              ),
              space20v,
              MElevatedButton(
                onPressed: () => _startSorting(context),
                text: 'Begin',
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _generateArray() {
    arrayReader.generateArray(_size.value);
  }

  void _startSorting(BuildContext context) {
    arrayReader.sort(sortType);
  }

  void _clearArray() {
    arrayReader.clear();
  }
}
