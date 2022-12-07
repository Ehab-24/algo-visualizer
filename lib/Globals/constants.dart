import 'package:flutter/material.dart';

/*  ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ COLORS ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~*/

const Color primary = Color.fromRGBO(59, 24, 95, 1);
const Color primary400 = Color.fromARGB(255, 108, 36, 129);
const Color primary700 = Color.fromARGB(255, 40, 21, 83);
const Color background = Color.fromARGB(255, 14, 10, 22);
// const Color background = Color.fromARGB(255, 24, 0, 44);

// const MaterialColor primarySwatch = Colors.pink;
// const Color foreground = Colors.white;
// const Color secondary = Colors.pink;
// const Color secondary200 = Color.fromRGBO(244, 143, 177, 1);
// const Color secondary300 = Color.fromRGBO(240, 98, 146, 1);
// const Color secondary600 = Color.fromRGBO(216, 27, 96, 1);
// const Color secondary800 = Color.fromRGBO(173, 20, 87, 1);

// const MaterialColor primarySwatch = Colors.lightBlue;
const Color foreground = Colors.black;
const Color secondary = Color.fromRGBO(192, 96, 161, 1);
const Color secondary100 = Color.fromARGB(255, 255, 202, 238);
const Color secondary300 = Color.fromARGB(255, 231, 147, 202);
const Color secondary600 = Color.fromRGBO(171, 85, 143, 1);
const Color secondary800 = Color.fromRGBO(130, 70, 105, 1);

/*  ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ DURATIONS ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~*/

const d0 = Duration(milliseconds: 0);
const d40 = Duration(milliseconds: 40);
const d80 = Duration(milliseconds: 80);
const d100 = Duration(milliseconds: 100);
const d200 = Duration(milliseconds: 200);
const d300 = Duration(milliseconds: 300);
const d400 = Duration(milliseconds: 400);
const d500 = Duration(milliseconds: 500);
const d600 = Duration(milliseconds: 600);
const d700 = Duration(milliseconds: 700);
const d800 = Duration(milliseconds: 800);
const d900 = Duration(milliseconds: 900);
const d1000 = Duration(seconds: 1);
const d2000 = Duration(seconds: 2);

/*  ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ SPACES ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~*/

const space0 = SizedBox.shrink();

const space10h = SizedBox(
  width: 10,
);
const space20h = SizedBox(
  width: 20,
);
const space30h = SizedBox(
  width: 30,
);
const space40h = SizedBox(
  width: 40,
);
const space60h = SizedBox(
  width: 60,
);
const space80h = SizedBox(
  width: 80,
);
const space120h = SizedBox(
  width: 120,
);

const space10v = SizedBox(
  height: 10,
);
const space20v = SizedBox(
  height: 20,
);
const space30v = SizedBox(
  height: 30,
);
const space40v = SizedBox(
  height: 40,
);
const space60v = SizedBox(
  height: 60,
);
const space80v = SizedBox(
  height: 80,
);
const space120v = SizedBox(
  height: 120,
);

/*  ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ DIVIDERS ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~*/

const Divider divider = Divider(
  color: Colors.white,
  thickness: 2,
  indent: 20,
  endIndent: 20,
  height: 40,
);

/*  ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ NUMBERS ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~*/

const double navBarWidth = 66;
const double sideBarWidth = 300;
const double sideBarBreakpoint = 720;

const double iconButtonSize = 50;
