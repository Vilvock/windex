import 'package:flutter/material.dart';

import '../../res/dimens.dart';
import '../../res/owner_colors.dart';


class DotIndicator extends StatelessWidget {

  final bool isActive;
  final Color color;

  const DotIndicator({Key? key, this.isActive = false, required this.color}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(4, 24, 4, 24),
      child: AnimatedContainer(
          duration: Duration(milliseconds: 300),
          height: isActive ? 8 : 8,
          width: isActive ? 22 : 8,
          decoration: BoxDecoration(
              color: isActive ? color : Colors.white70,
              borderRadius: BorderRadius.all(Radius.circular(12)))),
    );
  }
}