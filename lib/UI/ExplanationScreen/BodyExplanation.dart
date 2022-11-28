
import 'package:flutter/material.dart';

import '../../Globals/constants.dart';
import '../../Globals/functions.dart';

class BodyExplanation extends StatelessWidget {
  const BodyExplanation({super.key});

  @override
  Widget build(BuildContext context) {

    final w = screenWidth(context);
    final h = screenHeight(context);
    return SizedBox(
      width: w,
      child: Column(
        // crossAxisAlignment: CrossAxisAlignment.center,
        children: [

          Container(
            color: secondary,
            width: 750,
            height: h,
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
              child: Column(
                children: [

                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}