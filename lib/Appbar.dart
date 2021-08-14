import 'dart:ui';

import 'package:flutter/material.dart';

class IAppBar extends PreferredSize {
  final Widget child;
  final double height;
  final Color color;
  final Alignment align;

  IAppBar({
    @required this.child,
    this.color,
    this.height,
    this.align

  });

  // double appBarHeight = (window.p > 0) ? 100 : 60;

  @override
  Size get preferredSize => Size.fromHeight(height);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      height: preferredSize.height,
      color: color ?? Color(0xFF2C51BE),
      alignment: Alignment.center,
      child: child,
    );
  }
}