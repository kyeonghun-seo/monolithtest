import 'package:flutter/material.dart';

class TouchBox extends StatelessWidget {
  final Widget child;
  final Function(RenderBox) onTap;

  const TouchBox({
    required this.child,
    required this.onTap,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        RenderBox box = context.findRenderObject() as RenderBox;
        onTap.call(box);
      },
      style: ButtonStyle(
        padding: MaterialStateProperty.all<EdgeInsets>(const EdgeInsets.all(0)),
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            const RoundedRectangleBorder(
              borderRadius: BorderRadius.zero,
            )),
        minimumSize: MaterialStateProperty.all<Size>(Size.zero),
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
      child: child,
    );
  }
}
