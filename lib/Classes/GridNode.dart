// ignore_for_file: non_constant_identifier_names

import 'dart:math';
import 'package:algo_visualizer/Globals/constants.dart';

import 'Pos.dart';
import 'package:flutter/material.dart';

enum GridNodeState {
  basic,
  opened,
  closed,
  starting,
  target,
  obstacle,
  path,
  current,
}

class GridNode {
  GridNode(this.pos);

  Pos pos;
  GridNodeState _state = GridNodeState.basic;
  GridNode? parent;
  double G = 10000.0, H = 0.0;
  List<GridNode> neighbours = [];

  double get Fcost => G + H;

  GridNodeState get state => _state;

  bool get isTraversable => _state != GridNodeState.obstacle;
  bool get isStarting => _state == GridNodeState.starting;
  bool get isTarget => _state == GridNodeState.target;
  bool get isBasic => _state == GridNodeState.basic;

  Color get color {
    switch (_state) {
      case GridNodeState.starting:
        return Colors.green;
      case GridNodeState.target:
        return Colors.red;
      case GridNodeState.path:
        return secondary100;
      case GridNodeState.current:
        return Colors.amber;
      case GridNodeState.basic:
        return secondary.withOpacity(0.4);
      case GridNodeState.obstacle:
        return secondary800;
      case GridNodeState.opened:
        return secondary300;
      case GridNodeState.closed:
        return secondary;
    }
  }

  double get scale {
    if(_state == GridNodeState.path || _state == GridNodeState.obstacle || _state == GridNodeState.current) {
      return 1.0;
    }
    if(_state == GridNodeState.basic) {
      return 0.4;
    }
    return 0.8;
  }

  void setState(GridNodeState state) {
    _state = state;
  }

  void markAsBasic() {
    if (!isStarting && !isTarget) {
      _state = GridNodeState.basic;
      parent = null;
    }
  }

  void markAsOpened() {
    if (!isStarting && !isTarget) {
      _state = GridNodeState.opened;
    }
  }

  void markAsCurrent() {
    if (!isStarting && !isTarget) {
      _state = GridNodeState.current;
    }
  }

  void markAsClosed() {
    if (!isStarting && !isTarget) {
      _state = GridNodeState.closed;
    }
  }

  void setTraversable() {
    if (isStarting || isTarget) {
      return;
    }
    _state = isTraversable ? GridNodeState.obstacle : GridNodeState.basic;
  }

  //Only for calcuating distances from immediate (horizontal, vertical or diagonal) neighbours.
  double dist(GridNode node) {
    if (pos.x == node.pos.x || pos.y == node.pos.y) {
      return 1.0;
    }
    return sqrt(2);
  }

  bool operator <(GridNode node) {
    return Fcost < node.Fcost;
  }

  void setH(Pos target) {
    double dist = 0.0;
    int dx = (pos.x - target.x).abs(), dy = (pos.y - target.y).abs();

    //'ddiag' gives the number of diagonal steps.
    int ddiag = min(dx, dy);
    dist += ddiag * sqrt(2);

    //'dstraight' gives the number of straight steps.
    int dstraight = max(dx, dy) - ddiag;
    dist += dstraight;

    H = dist;
  }

  void setG(GridNode parent) {
    double newG;
    if(parent.pos.inlineWith(pos)) {
      newG = parent.G + 1.0;
    }
    else {
      newG = parent.G + sqrt(2);
    }

    if(newG < G) {
      G = newG;
      this.parent = parent;
    }
  }
}
