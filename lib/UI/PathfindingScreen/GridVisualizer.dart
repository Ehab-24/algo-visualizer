import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../Classes/GridNode.dart';
import '../../Globals/constants.dart';
import '../../Globals/functions.dart';
import '../../Providers/GridProvider.dart';

class GridVisualizer extends StatefulWidget {
  const GridVisualizer({super.key});

  @override
  State<GridVisualizer> createState() => _GridVisualizerState();
}

class _GridVisualizerState extends State<GridVisualizer> {
  bool _panStarted = false;
  bool _movingStartNode = false;
  bool _movingTarget = false;
  bool _setTraversableVal = false;

  late final GridPr gridReader;

  @override
  void initState() {
    gridReader = context.read<GridPr>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final List<List<GridNode>> grid = context.select((GridPr gridPr) => gridPr.grid);
    
    final bool showCosts = context.select((GridPr gridPr) => gridPr.showCosts);
    final String algoType = context.select((GridPr gridPr) => gridPr.algoType);
    final int rows = context.select((GridPr gridPr) => gridPr.rows);
    final int cols = context.select((GridPr gridPr) => gridPr.cols);

    final w = screenWidth(context);
    final width = w < sideBarBreakpoint
        ? (w - navBarWidth) / cols - 2
        : (w - sideBarWidth - navBarWidth) / cols - 2;
    final height = screenHeight(context) / rows - 2;

    return Column(
      children: grid
          .map((list) => Row(
                children: list
                    .map((node) => MouseRegion(
                          onEnter: (event) {
                            if (_panStarted) {
                              node.setTraversableTo(_setTraversableVal);
                            } else if (_movingStartNode) {
                              gridReader.setStartingNode(
                                  node.pos.y, node.pos.x);
                            } else if (_movingTarget) {
                              gridReader.setTarget(node.pos.y, node.pos.x);
                            }
                          },
                          child: GestureDetector(
                            onTap: () {
                              gridReader.setTraversable(node);
                              // node.setTraversable();
                            },
                            onPanStart: (details) {
                              _setTraversableVal = !node.isTraversable;
                              node.setTraversableTo(_setTraversableVal);
                              if (node.isStarting) {
                                _movingStartNode = true;
                              } else if (node.isTarget) {
                                _movingTarget = true;
                              } else {
                                _panStarted = true;
                              }
                            },
                            onPanUpdate: (details) {
                              if (_panStarted) {
                                setState(() {});
                              }
                            },
                            onPanEnd: (details) {
                              _movingStartNode = false;
                              _movingTarget = false;
                              _panStarted = false;
                            },
                            child: AnimatedScale(
                              scale: node.scale,
                              duration: _duration(),
                              curve: Curves.easeOut,
                              child: Container(
                                height: height,
                                width: width,
                                alignment: Alignment.center,
                                margin: const EdgeInsets.all(1),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(3),
                                  color: node.color,
                                ),
                                child: showCosts? Text(
                                  _getCost(node, algoType),
                                  style: TextStyle(
                                    color: node.isPath
                                    ? Colors.black
                                    : Colors.white
                                  ),
                                ): null
                              ),
                            ),
                          ),
                        ))
                    .toList(),
              ))
          .toList(),
    );
  }
  
  String _getCost(GridNode node, String algoType) {
    if(!node.isTraversable || node.isBasic) {
      return '';
    }
    switch(algoType) {
      case 'a-star':
        return node.Fcost.toStringAsFixed(1);
      case 'dijkstra':
        return node.G.toStringAsFixed(1);
      case 'best-first':
        return node.H.toStringAsFixed(1);
      default:
        return '';
    }
  }

  Duration _duration() {
    final animateMode = context.watch<GridPr>().animateMode;
    switch(animateMode) {
      case AnimateMode.live:
        return const Duration(microseconds: 0);
      case AnimateMode.fast:
        return d200;
      case AnimateMode.normal:
        return d400;
      case AnimateMode.slow:
        return d800;
    }
  }
}
