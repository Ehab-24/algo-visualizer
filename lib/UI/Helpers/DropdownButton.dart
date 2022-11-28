
import 'package:algo_visualizer/extensionMethods.dart';
import 'package:flutter/material.dart';

import '../../Globals/constants.dart';
import '../../Globals/decorations.dart';
import '../../Globals/styles.dart';


class MDropdownMenuButton extends StatefulWidget {
  const MDropdownMenuButton({
    super.key,
    required this.items,
    required this.onChanged,
    required this.value,
  });

  final List<DropdownMenuItem<String>> items;
  final void Function(Object?)? onChanged;
  final String value;

  @override
  State<MDropdownMenuButton> createState() => MDropdownMenuButtonState();
}

class MDropdownMenuButtonState extends State<MDropdownMenuButton> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      width: 200,
      decoration: Decorations.elevatedButton,
      child: DropdownButton<String>(
        items: widget.items,
        isExpanded: true,
        underline: const SizedBox.shrink(),
        dropdownColor: background,
        borderRadius: BorderRadius.circular(8),
        value: widget.value,
        onChanged: widget.onChanged,
        style: Styles.neon(),
      ),
    ).withScaleOnHover();
  }
}
