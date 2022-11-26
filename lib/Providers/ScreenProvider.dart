
import 'package:algo_visualizer/UI/PathfindingScreen/GridVisualizer.dart';
import 'package:flutter/material.dart';

import '../UI/HomeScreen/BodyHome.dart';
import '../UI/Searching/SearchVisualizer.dart';
import '../UI/SortingScreen/ArrayVisualizer.dart';

enum Screen {
  home,
  grid,
  array,
  search,
}

class ScreenPr extends ChangeNotifier {
  ScreenPr();

  Screen _state = Screen.home;
  Widget _screenWidget = const BodyHome();

  Screen get state => _state;
  Widget get widget => _screenWidget;

  void setScreen(String screen) {
    switch (screen) {
      case 'home':
        if (_state == Screen.home) {
          return;
        }
        _state = Screen.home;
        _screenWidget = const BodyHome();
        break;
      case 'grid':
        if (_state == Screen.grid) {
          return;
        }
        _state = Screen.grid;
        _screenWidget = const GridVisualizer();
        break;
      case 'array':
        if (_state == Screen.array) {
          return;
        }
        _state = Screen.array;
        _screenWidget = const ArrayVisualizer();
        break;
      case 'search':
        if (_state == Screen.search) {
          return;
        }
        _state = Screen.search;
        _screenWidget = const SearchVisualizer();
        break;
      default:
        throw 'screen doesn\'t exist';
    }
    notifyListeners();
  }
}
