
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:collection/collection.dart';

import '../Classes/ArrayElement.dart';

class ArrayPr extends ChangeNotifier {

  ArrayPr(int size) {
    generateArray(size);
  }

  List<ArrayElement> _array = [];
  int _max = 0, _swapsCount = 0, _arrayAccesses = 0;

  List<ArrayElement> get array => _array;
  int get length => _array.length;
  int get max => _max;
  int get swapsCount => _swapsCount;
  int get arrayAccesses => _arrayAccesses;

  void generateArray(int size) {
    _array = List.generate(size, (_) {
      int temp = Random().nextInt(3000000000);
      if (temp > _max) {
        _max = temp;
      }
      return ArrayElement(temp);
    });

    notifyListeners();
  }

  void clear() {
    _array = [];
    _max = 0;
    _swapsCount = 0;
    _arrayAccesses = 0;

    notifyListeners();
  }

  Future<void> sort(String type) async {
    _arrayAccesses = _swapsCount = 0;

    switch (type) {
      case 'bubble':
        await _bubbleSort();
        break;
      case 'selection':
        await _selectionSort();
        break;
      case 'insertion':
        await _insertionSort();
        break;
      case 'quick':
        await _quickSort(0, _array.length - 1);
        break;
      case 'heap':
        await _heapSort();
        break;
      case 'cocktail':
        await _cocktailSort();
        break;
      case 'merge':
        // await _mergeSort(0, _array.length - 1);
        break;
      default:
        break;
    }

    await _getHappy();
  }

  Future<void> _getHappy() async {
    double duration;
    int length = _array.length;
    for (int i = 0; i < length; i++) {
      _array[i].markAsHappy();

      await Future.delayed(Duration(microseconds: (length * 0.2).round()));
      notifyListeners();
    }
  }

  Future<void> _displayCurrentEle(ArrayElement current, [int millisecods = 1]) async {
    current.markAsCurrent();
    notifyListeners();
    await Future.delayed(Duration(milliseconds: millisecods));
    current.markAsBasic();
  }

  Future<void> _displayCurrentEleMicro(ArrayElement current) async {
    current.markAsCurrent();
    notifyListeners();
    await Future.delayed(const Duration(microseconds: 1));
    current.markAsBasic();
  }

  Future<void> _bubbleSort() async {
    bool bubbling = true;
    int loops = 0;

    while (bubbling) {
      bubbling = false;
      for (int i = 0; i + 1 < _array.length - loops; i++) {
        if (_array[i] > _array[i + 1]) {
          int holder = _array[i].value;
          _array[i].setValue(_array[i + 1].value);
          _array[i + 1].setValue(holder);
          bubbling = true;

          _swapsCount++;
          _arrayAccesses += 4;

          await _displayCurrentEleMicro(_array[i]);
        }
        _arrayAccesses += 2;
      }
      await Future.delayed(const Duration(milliseconds: 1));
      loops++;
    }
  }

  Future<void> _selectionSort() async {
    int minIndex;
    for (int i = 0; i < _array.length; i++) {
      minIndex = i;
      for (int j = i + 1; j < _array.length; j++) {
        if (_array[j] < _array[minIndex]) {
          minIndex = j;
          await _displayCurrentEle(_array[j]);
        }
        _arrayAccesses += 2;
      }
      if (minIndex != i) {
        int holder = _array[i].value;
        _array[i].setValue(_array[minIndex].value);
        _array[minIndex].setValue(holder);

        _swapsCount++;
        _arrayAccesses += 4;
      }
    }
  }

  Future<void> _insertionSort() async {
    int i, j;
    ArrayElement key;
    for (i = 1; i < _array.length; i++) {
      key = _array[i];
      j = i - 1;

      while (j >= 0 && _array[j] > key) {
        await _displayCurrentEleMicro(_array[j]);
        _array[j + 1] = _array[j];

        j--;
        _arrayAccesses += 2;
      }
      _array[j + 1] = key;
      await Future.delayed(const Duration(milliseconds: 1));
      _arrayAccesses += 3;
    }
  }

  Future<void> _cocktailSort() async {
    int start = 0;
    int end = _array.length - 1;
    bool bubbling = true;

    while (bubbling) {
      bubbling = false;
      for (int i = start; i < end; i++) {
        if (_array[i] > _array[i + 1]) {
          int holder = _array[i].value;
          _array[i].setValue(_array[i + 1].value);
          _array[i + 1].setValue(holder);
          bubbling = true;

          await _displayCurrentEleMicro(_array[i]);

          _swapsCount++;
          _arrayAccesses += 4;
        }
        _arrayAccesses += 2;
      }
      await Future.delayed(const Duration(milliseconds: 1));

      if (!bubbling) {
        break;
      }
      bubbling = false;
      end--;

      for (int i = end - 1; i >= start; i--) {
        if (_array[i] > _array[i + 1]) {
          int holder = _array[i].value;
          _array[i].setValue(_array[i + 1].value);
          _array[i + 1].setValue(holder);
          bubbling = true;

          await _displayCurrentEleMicro(_array[i]);

          _swapsCount++;
          _arrayAccesses += 4;
        }
        _arrayAccesses += 2;
      }
      await Future.delayed(const Duration(milliseconds: 1));
      start++;

      await Future.delayed(const Duration(milliseconds: 1));
      notifyListeners();
    }
  }

  Future<int> _partition(int low, int high) async {
    ArrayElement pivot = _array[high];
    int i = (low - 1);

    for (int j = low; j <= high - 1; j++) {
      if (_array[j] < pivot) {
        i++;
        int holder = _array[i].value;
        _array[i].setValue(_array[j].value);
        _array[j].setValue(holder);

        _swapsCount++;
        _arrayAccesses += 4;

        await _displayCurrentEle(_array[j]);
      }
      _arrayAccesses++;
    }
    int holder = _array[high].value;
    _array[high].setValue(_array[i + 1].value);
    _array[i + 1].setValue(holder);

    _swapsCount++;
    _arrayAccesses += 5;

    return (i + 1);
  }

  Future<void> _heapSort() async {
    PriorityQueue<ArrayElement> pq = PriorityQueue(
      (e0, e1) => e1.value.compareTo(e0.value),
    );
    pq.addAll(_array);

    for(int i = length - 1; i >= 0; i--) {
      await _displayCurrentEle(pq.first, 25);
      _array[i] = pq.removeFirst();
      _arrayAccesses += 2;
    }
  }

  Future<void> _quickSort(int low, int high) async {
    if (low < high) {
      int pi = await _partition(low, high);

      await _quickSort(low, pi - 1);
      await _quickSort(pi + 1, high);
    }
  }

  void _merge(int start, int mid, int end) {
    int start2 = mid + 1;

    _arrayAccesses += 2;
    if (_array[mid] <= _array[start2]) {
      return;
    }
    while (start <= mid && start2 <= end) {
      if (_array[start] <= _array[start2]) {
        start++;
      } else {
        int value = _array[start2].value;
        int index = start2;

        while (index != start) {
          _array[index] = _array[index - 1];
          index--;
          _arrayAccesses += 2;
        }
        _array[start].setValue(value);

        start++;
        mid++;
        start2++;

        _arrayAccesses += 2;
      }
      _arrayAccesses += 2;
    }
  }

  void _mergeSort(int l, int r) {
    if (l < r) {
      int m = (l + (r - l) / 2).toInt();

      _mergeSort(l, m);
      _mergeSort(m + 1, r);
      _merge(l, m, r);
    }
  }
}
