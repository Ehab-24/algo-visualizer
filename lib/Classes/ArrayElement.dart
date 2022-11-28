
import 'package:algo_visualizer/Globals/constants.dart';
import 'package:flutter/material.dart';

enum EleState {
  basic,
  happy,
  current,
}

class ArrayElement {
  ArrayElement(this._value);

  int _value;
  EleState _state = EleState.basic;

  int get value => _value;

  bool get isCurrent => _state == EleState.current;

  Color get color {
    switch (_state) {
      case EleState.basic:
        return primary400;
      case EleState.happy:
        return secondary;
      case EleState.current:
        return Colors.green;
    }
  }

  void setValue(int val) {
    _value = val;
  }

  void markAsCurrent() {
    _state = EleState.current;
  }

  void markAsBasic() {
    _state = EleState.basic;
  }

  void markAsHappy() {
    _state = EleState.happy;
  }

  bool operator >(ArrayElement other) {
    return value > other.value;
  }

  bool operator <(ArrayElement other) {
    return value < other.value;
  }

  bool operator <=(ArrayElement other) {
    return value <= other.value;
  }
}
