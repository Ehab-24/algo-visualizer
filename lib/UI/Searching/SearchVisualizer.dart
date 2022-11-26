
import 'package:algo_visualizer/Globals/constants.dart';
import 'package:algo_visualizer/Globals/functions.dart';
import 'package:algo_visualizer/Providers/SortedArrayProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SearchVisualizer extends StatelessWidget {
  const SearchVisualizer({super.key});

  @override
  Widget build(BuildContext context) {
    
    final arrayWatch = context.watch<SortedArrayPr>();
    
    final w = screenWidth(context);

    // final width = 

    return SizedBox(
      width: w - navBarWidth - sideBarWidth,
      child: Wrap(
        alignment: WrapAlignment.center,
        spacing: 4,

        runSpacing: 4,
        children: arrayWatch.array.map((ele) => 
          Container(
            width: 32,
            height: 32,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: ele.color,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(ele.value.toString()),
          )
        ).toList()
      ),
    );
  }
}