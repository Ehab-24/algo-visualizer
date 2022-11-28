// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'dart:async';
import 'dart:collection';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:collection/collection.dart';

import '../Classes/Pos.dart';
import '../Classes/GridNode.dart';

enum AnimateMode {
  live,
  fast,
  normal,
  slow,
}

class GridPr extends ChangeNotifier {
  GridPr(int rows, int cols) {
    generateGrid(rows, cols);
  }

  /*  ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ FEILDS ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~  */

  double _totalCost = 0.0, _totalFCost = 0.0;
  GridNode? _startingNode, _target;
  final HashSet<GridNode> _closed = HashSet<GridNode>();
  final List<GridNode> _opened = [];
  AnimateMode _animateMode = AnimateMode.fast;
  String _algoType = 'a-star';
  Duration _duration = const Duration(milliseconds: 1);
  List<List<GridNode>> grid = [];

  String get algoType => _algoType;

  int get visitedNodes => _closed.length;
  int get openedNodes => _opened.length;
  int get rows => grid.length;
  int get cols => grid[0].length;

  AnimateMode get animateMode => _animateMode;

  double get totalFCost => _totalFCost;
  double get totalCost => _totalCost;

  bool get isLiveMode => _animateMode == AnimateMode.live;
  bool get isFastMode => _animateMode == AnimateMode.fast;
  bool get isNormalMode => _animateMode == AnimateMode.normal;
  bool get isSlowMode => _animateMode == AnimateMode.slow;

  GridNode get startingNode => _startingNode!;
  GridNode get target => _target!;

  /*  ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ PUBLIC METHODS ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~  */

  GridNode getNode(int r, int c) => grid[r][c];

  Future<void> setStartingNode(int r, int c) async {
    if (!grid[r][c].isTraversable || grid[r][c].isTarget) {
      return;
    }
    _startingNode!.setState(GridNodeState.basic);
    _setStartingNode(r, c);

    if (isLiveMode) {
      clear();
      await findTarget(_algoType);
      await animatePath();
    }
    notifyListeners();
  }

  Future<void> setTarget(int r, int c) async {
    if (!grid[r][c].isTraversable || grid[r][c].isStarting) {
      return;
    }
    _target!.setState(GridNodeState.basic);
    _setTarget(r, c);

    if (isLiveMode) {
      clear();
      await findTarget(_algoType);
      await animatePath();
    }
    notifyListeners();
  }

  void setTraversable(GridNode node) {
    node.setTraversable();
    notifyListeners();
  }

  void setAlgoType(String type) {
    _algoType = type;
    notifyListeners();
  }

  void setAnimateMode(AnimateMode mode) {
    if (_animateMode == mode) {
      return;
    }

    _animateMode = mode;
    switch (mode) {
      case AnimateMode.fast:
        _duration = const Duration(milliseconds: 1);
        break;
      case AnimateMode.normal:
        _duration = const Duration(milliseconds: 10);
        break;
      case AnimateMode.slow:
        _duration = const Duration(milliseconds: 25);
        break;
      default:
        break;
    }
    notifyListeners();
  }

  void clear() {
    for (var list in grid) {
      _clearAttributes();
      for (GridNode node in list) {
        if (node.isTraversable && !(node.isStarting || node.isTarget)) {
          node.markAsBasic();
        } else if (node.isStarting || node.isTarget) {
          node.parent = null;
        }
        node.G = 10000.0;
        node.H = 0;
      }
    }
    notifyListeners();
  }

  void reset() {
    for (var list in grid) {
      _clearAttributes();
      for (GridNode node in list) {
        node.markAsBasic();
        node.G = 10000.0;
        node.H = 0;
      }
    }
    _setStartingNode(0, 0);
    _setTarget(rows - 1, cols - 1);

    notifyListeners();
  }

  Future<void> animatePath() async {
    GridNode? path = target;

    while (path != null) {
      _markAsPath(path);
      _incerementFCost(path);

      double cost = 0.0;
      if (path.parent != null && path.pos.inlineWith(path.parent!.pos)) {
        cost = 1.0;
      } else if (path.parent != null) {
        cost = sqrt(2);
      }

      _incerementCost(cost);
      if (!isLiveMode) {
        notifyListeners();
        await Future.delayed(const Duration(milliseconds: 10));
      }
      path = path.parent;
    }
  }

  void generateGrid(int rows, int cols) {
    _clearAttributes();
    grid.clear();
    //Create nodes.
    for (int r = 0; r < rows; r++) {
      grid.add([]);
      for (int c = 0; c < cols; c++) {
        grid[r].add(GridNode(Pos(r, c)));
      }
    }
    //Assign neighbours.
    for (int r = 0; r < rows; r++) {
      for (int c = 0; c < cols; c++) {
        _addNeighbour(r, c);
      }
    }

    _setStartingNode(0, 0);
    _setTarget(rows - 1, cols - 1);

    notifyListeners();
  }

  Future<void> findTarget(String type) async {
    switch (type) {
      case 'depth-first':
        await _findTargetDepthFirst();
        break;
      case 'breadth-first':
        await _findTargetBreadthFirst();
        break;
      case 'dijkstra':
        await _findTargetDijkstra();
        break;
      default:
        await _findTarget(type);
        break;
    }
    notifyListeners();
  }

  /*  ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ PRIVATE METHODS ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~  */

  Future<void> _delay() async {
    if (_animateMode != AnimateMode.live) {
      await Future.delayed(_duration);
    }
  }

  void _setStartingNode(int r, int c) {
    _startingNode = grid[r][c];
    _startingNode!.setState(GridNodeState.starting);
  }

  void _setTarget(int r, int c) {
    _target = grid[r][c];
    _target!.setState(GridNodeState.target);
  }

  void _clearAttributes() {
    _opened.clear();
    _closed.clear();
    _totalCost = _totalFCost = 0.0;
  }

  GridNode _bestInOpenedF() {
    GridNode min = _opened.first;
    for (GridNode node in _opened) {
      if (node.Fcost < min.Fcost) {
        min = node;
      }
    }
    return min;
  }

  GridNode _bestInOpenedH() {
    GridNode best = _opened.first;
    for (GridNode node in _opened) {
      if (node.H < best.H) {
        best = node;
      }
    }
    return best;
  }

  void _markAsPath(GridNode node) {
    if (node.isStarting || node.isTarget) {
      return;
    }
    grid[node.pos.y][node.pos.x].setState(GridNodeState.path);
  }

  void _incerementFCost(GridNode node) {
    _totalFCost += node.H + node.G - 10000.0;
  }

  void _incerementCost(double val) {
    _totalCost += val;
  }

  void _addNeighbour(int r, int c) {
    GridNode node = grid[r][c];
    if (c != 0) {
      node.neighbours.add(grid[r][c - 1]);
    }
    if (c != cols - 1) {
      node.neighbours.add(grid[r][c + 1]);
    }
    if (r != 0) {
      node.neighbours.add(grid[r - 1][c]);
    }
    if (r != rows - 1) {
      node.neighbours.add(grid[r + 1][c]);
    }
    if (c != 0 && r != 0) {
      node.neighbours.add(grid[r - 1][c - 1]);
    }
    if (c != 0 && r != rows - 1) {
      node.neighbours.add(grid[r + 1][c - 1]);
    }
    if (c != cols - 1 && r != 0) {
      node.neighbours.add(grid[r - 1][c + 1]);
    }
    if (c != cols - 1 && r != rows - 1) {
      node.neighbours.add(grid[r + 1][c + 1]);
    }
  }

  Future<void> _findTargetBreadthFirst() async {
    _opened.add(startingNode);
    _closed.add(startingNode);

    GridNode current = startingNode;
    while (_opened.isNotEmpty) {
      current = _opened.first;
      current.markAsCurrent();
      _opened.removeAt(0);

      for (GridNode node in current.neighbours) {
        if (_closed.contains(node) || !node.isTraversable) {
          continue;
        }
        node.parent = current;
        if (node == target) {
          return;
        }

        _opened.add(node);
        _closed.add(node);
        node.markAsClosed();
      }
      await _delay();
      notifyListeners();

      current.markAsClosed();
    }
  }

  Future<void> _findTargetDepthFirst() async {
    _opened.add(startingNode);

    GridNode current;
    while (_opened.isNotEmpty) {
      current = _opened.last;
      current.markAsCurrent();

      _opened.removeLast();
      _closed.add(current);

      GridNode node;
      for (int i = current.neighbours.length - 1; i >= 0; i--) {
        node = current.neighbours[i];
        if (_closed.contains(node) || !node.isTraversable) {
          continue;
        }
        node.parent = current;
        if (node.isTarget) {
          return;
        }
        await _delay();

        _opened.add(node);
        _closed.add(node);
        node.markAsClosed();

        notifyListeners();
      }
      current.markAsClosed();
    }
  }

  Future<void> _findTarget(String type) async {
    //This function finds the target node using either A* Search algorithm or
    //Best First Seacrh algorithm depending upon the 'bestInOpened' parameter.
    int Function(GridNode, GridNode) comparator;
    switch (type) {
      case 'a-star':
        comparator = (n0, n1) => n0.Fcost.compareTo(n1.Fcost);
        break;
      case 'best-first':
        comparator = (n0, n1) => n0.H.compareTo(n1.H);
        break;
      default:
        throw 'Algo Type: $type does not exist.';
    }

    PriorityQueue<GridNode> pq = PriorityQueue(comparator);
    GridNode current;

    _opened.add(startingNode);
    pq.add(startingNode);

    while (_opened.isNotEmpty) {
      current = pq.first;
      current.markAsCurrent();

      if (current == target) {
        return;
      }
      _opened.remove(current);
      pq.removeFirst();

      _closed.add(current);

      for (GridNode node in current.neighbours) {
        if (_closed.contains(node) || node.state == GridNodeState.obstacle) {
          continue;
        }

        bool isPresent = _opened.contains(node);
        if (!isPresent) {
          node.setH(target.pos);
        }

        double newGCost = current.G + current.dist(node);
        double newFCost = newGCost + node.H;

        if (!isPresent || newFCost < node.Fcost) {
          node.G = newGCost;
          node.parent = current;

          if (!isPresent) {
            _opened.add(node);
            pq.add(node);
            node.markAsOpened();

            await _delay();
          }
        }
      }
      if (!isLiveMode) {
        notifyListeners();
      }
      current.markAsClosed();
    }
    throw 'Path does not exist';
  }

  Future<void> _findTargetDijkstra() async {
    startingNode.G = 0.0;
    PriorityQueue<GridNode> pq =
        PriorityQueue((n0, n1) => n0.G.compareTo(n1.G));

    _closed.add(startingNode);
    pq.add(startingNode);

    GridNode current;
    while (pq.isNotEmpty) {
      current = pq.first;
      current.markAsCurrent();

      _opened.remove(current);
      pq.removeFirst();

      for (GridNode node in current.neighbours) {
        if (node.isTarget) {
          node.parent = current;
          return;
        }
        if (_closed.contains(node) || !node.isTraversable) {
          continue;
        }

        node.setG(current);

        _opened.add(node);
        node.markAsOpened();
        
        if (!pq.contains(node)) {
          pq.add(node);
      _opened.remove(node);
        }
      }
      if (!isLiveMode) {
        await _delay();
        notifyListeners();
      }
      _closed.add(current);
      current.markAsClosed();
    }
    throw 'Path does not exist';
  }
}
