import 'package:flutter/material.dart';
import 'package:monolithtest/ui/common/TouchBox.dart';

class TouchIconBox extends StatelessWidget {
  final String icon;
  final double? padding;
  final Function(RenderBox) onTap;

  const TouchIconBox({
    required this.icon,
    required this.onTap,
    this.padding,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TouchBox(
      onTap: (RenderBox box) {},
      child: Padding(
        padding: EdgeInsets.all(padding ?? 0.0),
        child: Image.asset(
          'assets/images/$icon.png',
          width: 24,
        ),
      ),
    );
  }
}
