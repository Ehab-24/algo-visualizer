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
    grid[startingNode.pos.y][startingNode.pos.x].setState(GridNodeState.basic);
    grid[target.pos.y][target.pos.x].setState(GridNodeState.basic);

    _setStartingNode(0, 0);
    _setTarget(rows - 1, cols - 1);

    notifyListeners();
  }

  Future<void> animatePath() async {
    GridNode? path = target;

    while (path != null) {
      _markAsPath(path);
      _incerementFCost(path.Fcost);

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
    if(_closed.isNotEmpty) {
      clear();
    }
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
      // case 'jps':
      //   await _findTargetJPS();
      //   break;
      case 'a-star':
        await _findTarget(_bestInOpenedF);
        break;
      case 'best-first':
        await _findTarget(_bestInOpenedH);
        break;
    }
    notifyListeners();
  }

  /*  ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ PRIVATE METHODS ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~  */

  GridNode _getNode(Pos pos) => grid[pos.y][pos.x];

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

  void _incerementFCost(double val) {
    _totalFCost += val;
  }

  void _incerementCost(double val) {
    _totalCost += val;
  }

  bool _isValidIndex(Pos pos) {
    return pos.y >= 0 && pos.y < rows && pos.x >= 0 && pos.x < cols;
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

  Future<void> _checkNeighbour(
      GridNode current, Pos pos, PriorityQueue<GridNode> pq) async {
    if (!_isValidIndex(pos)) {
      return;
    }
    final node = _getNode(pos);
    if (!_closed.contains(node) && node.isTraversable) {
      bool isPresent1 = _opened.contains(node);
      if (!isPresent1) {
        node.setH(target.pos);
      }

      double newGCost = current.G + current.dist(node);
      double newFCost = newGCost + node.H;

      if (!isPresent1 || newFCost < node.Fcost) {
        node.G = newGCost;
        node.parent = current;

        if (!isPresent1) {
          _opened.add(node);
          pq.add(node);
          node.markAsOpened();

          await _delay();
        }
      }
    }
  }

  // Future<void> _checkNeighboursForDiagonalMove(
  //     GridNode current, Pos dp, PriorityQueue<GridNode> pq) async {
  //   //2. calculate 'd1' and 'd2'.
  //   final Pos d1 = Pos(dp.y, 0);
  //   final Pos d2 = Pos(0, dp.x);

  //   //3. Check for forced neighbours.
  //   if (!_getNode(current.pos + d1).isTraversable) {
  //     final Pos f1 = Pos(-dp.y, dp.x);
  //     await _checkNeighbour(current, f1, pq);
  //   }
  //   if (!_getNode(current.pos + d2).isTraversable) {
  //     final Pos f2 = Pos(dp.y, -dp.x);
  //     await _checkNeighbour(current, f2, pq);
  //   }

  //   //4. Open actual neighbours.
  //   final Pos n1 = current.pos - dp;
  //   await _checkNeighbour(current, n1, pq);
  //   final Pos n2 = current.pos - d1;
  //   await _checkNeighbour(current, n2, pq);
  //   final Pos n3 = current.pos - d2;
  //   await _checkNeighbour(current, n3, pq);
  // }

  // Future<void> _checkNeighboursForNonDiagonalMove(
  //     GridNode current, Pos dp, PriorityQueue<GridNode> pq) async {
  //   //2. calculate 'd1' and 'd2'.
  //   final Pos d1 = dp.y == 0 ? Pos(-1, 0) : Pos(0, -1);
  //   final d2 = -d1;

  //   //3. Check for forced neighbours.
  //   final obs1 = current.pos + d1; //Postion of possible obstacle1.
  //   if (_isValidIndex(obs1) && !_getNode(obs1).isTraversable) {
  //     final Pos f1 = current.pos + (d1 - dp);
  //     await _checkNeighbour(current, f1, pq);
  //   }
  //   final obs2 = current.pos + d2; //Postion of possible obstacle2.
  //   if (_isValidIndex(obs2) && !_getNode(obs2).isTraversable) {
  //     final Pos f2 = current.pos + (d2 - dp);
  //     await _checkNeighbour(current, f2, pq);
  //   }

  //   //4. Open actual neighbours.
  //   final Pos n1 = current.pos - dp;
  //   await _checkNeighbour(current, n1, pq);
  // }

  // Future<void> _findTargetJPS() async {
  //   PriorityQueue<GridNode> pq =
  //       PriorityQueue((n0, n1) => n0.Fcost.compareTo(n1.Fcost));
  //   GridNode current;

  //   startingNode.markAsCurrent();
  //   startingNode.G = 0.0;
  //   for (GridNode node in startingNode.neighbours) {
  //     node.parent = startingNode;
  //     node.setH(target.pos);

  //     _opened.add(node);
  //     pq.add(node);

  //     await _delay();
  //   }
  //   _closed.add(startingNode);

  //   while (_opened.isNotEmpty) {
  //     current = pq.first;
  //     current.markAsCurrent();

  //     if (current == target) {
  //       return;
  //     }
  //     _opened.remove(current);
  //     pq.removeFirst();

  //     _closed.add(current);

  //     //1. calculate 'dp'
  //     final Pos dp = Pos(
  //       current.parent!.pos.y - current.pos.y,
  //       current.parent!.pos.x - current.pos.x,
  //     );

  //     if (dp.x == 0 || dp.y == 0) {
  //       await _checkNeighboursForNonDiagonalMove(current, dp, pq);
  //     } else {
  //       await _checkNeighboursForDiagonalMove(current, dp, pq);
  //     }

  //     if (!isLiveMode) {
  //       notifyListeners();
  //     }
  //     current.markAsClosed();
  //   }
  //   // TODO:
  //   // throw 'Path does not exist';
  // }

  Future<void> _findTarget(GridNode Function() bestInOpened) async {
    //This function finds the target node using either A* Search algorithm or
    //Best First Seacrh algorithm depending upon the 'bestInOpened' parameter.

    GridNode current;

    _opened.add(startingNode);
    startingNode.G = 0.0;

    while (_opened.isNotEmpty) {
      current = bestInOpened();
      current.markAsCurrent();

      if (current == target) {
        return;
      }
      _opened.remove(current);

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
