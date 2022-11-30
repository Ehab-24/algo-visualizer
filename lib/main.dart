import 'package:algo_visualizer/Globals/constants.dart';
import 'package:algo_visualizer/Providers/ArrayProvider.dart';
import 'package:algo_visualizer/Providers/ScreenProvider.dart';
import 'package:flutter/material.dart';

import 'Providers/GridProvider.dart';
import 'package:provider/provider.dart';

import 'UI/HomeScreen/ScreenHome.dart';
import 'UI/SubScreenManager.dart';

void main() {
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider<ArrayPr>(create: (_) => ArrayPr(100)),
      ChangeNotifierProvider<ScreenPr>(create: (_) => ScreenPr()),
      ChangeNotifierProvider<GridPr>(create: (_) => GridPr(10, 10)),
    ],
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final screen = context.watch<ScreenPr>().state;

    return MaterialApp(
      title: 'Algorithm Visualizer',
      theme: ThemeData(
        scrollbarTheme: const ScrollbarThemeData(
          crossAxisMargin: 2,
          thickness: MaterialStatePropertyAll(6),
          thumbVisibility: MaterialStatePropertyAll(true),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
              backgroundColor: secondary600,
              shadowColor: Colors.white54,
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 12)),
        ),
        colorScheme: ColorScheme.fromSwatch()
            .copyWith(secondary: foreground, brightness: Brightness.dark),
      ),
      home:
          screen == Screen.home ? const ScreenHome() : const SubScreenManager(),
    );
  }
}
