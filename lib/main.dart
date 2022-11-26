import 'package:algo_visualizer/Globals/constants.dart';
import 'package:algo_visualizer/Providers/ArrayProvider.dart';
import 'package:algo_visualizer/Providers/ScreenProvider.dart';
import 'package:algo_visualizer/Providers/SortedArrayProvider.dart';
import 'package:flutter/material.dart';

import 'Providers/GridProvider.dart';
import 'package:provider/provider.dart';

import 'UI/HomeScreen/ScreenHome.dart';

void main() {

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<ArrayPr>(create: (_) => ArrayPr()),
        ChangeNotifierProvider<ScreenPr>(create: (_) => ScreenPr()),
        ChangeNotifierProvider<GridPr>(create: (_) => GridPr(15, 15)),
        ChangeNotifierProvider<SortedArrayPr>(create: (_) => SortedArrayPr(260)),
      ],
      child: const MyApp(),
    )
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: secondary600,
            shadowColor: Colors.white54,
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 12)
          )
        ), 
        colorScheme: ColorScheme.fromSwatch().copyWith(
          secondary: foreground,
          brightness: Brightness.dark
        )
      ),
      home: const ScreenHome(),
    );
  }
}