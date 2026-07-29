import 'package:flutter/material.dart';

class ResponsiveFlexChild extends StatelessWidget {
  const ResponsiveFlexChild({
    super.key,
    required this.expand,
    required this.child,
  });

  final bool expand;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return expand ? Expanded(child: child) : child;
  }
}

class OptionalVerticalScroll extends StatelessWidget {
  const OptionalVerticalScroll({
    super.key,
    required this.enabled,
    required this.child,
    this.padding,
  });

  final bool enabled;
  final Widget child;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    if (enabled) {
      return SingleChildScrollView(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        padding: padding,
        child: child,
      );
    }
    return padding == null ? child : Padding(padding: padding!, child: child);
  }
}

Widget scrollWholePageInPortrait({
  required bool isPortrait,
  required Widget child,
}) {
  if (!isPortrait) return child;
  return SingleChildScrollView(
    keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
    child: child,
  );
}
