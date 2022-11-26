
import 'dart:math';

import 'package:algo_visualizer/Classes/ArrayElement.dart';
import 'package:flutter/material.dart';

class SortedArrayPr extends ChangeNotifier {
  List<ArrayElement> _array = [];

  SortedArrayPr(int size) {
    generateSortedArray(size);
  }
  // int _lowerbound = 0, _upperbound = 999;

  List<ArrayElement> get array => _array;
  int get length => _array.length;

  // int get lowerbound => _lowerbound;
  // int get upperbound => _upperbound;

  void generateSortedArray(int size) {
    _array = List.generate(
      size,
      (_) => ArrayElement(
        Random().nextInt(999),
      ),
    );
    _array.sort((e0, e1) => e0.value.compareTo(e1.value));

    notifyListeners();
  }
}
