import 'package:flutter/material.dart';

class CustomSliverAppBar extends SliverAppBar {
  const CustomSliverAppBar(
      {Key? key,
      PreferredSizeWidget? bottom,
      Widget? title,
      bool pinned = false,
      bool snap = false,
      bool floating = false,
      List<Widget>? actions})
      : super(
            pinned: pinned,
            snap: snap,
            floating: floating,
            key: key,
            bottom: bottom,
            title: title,
            actions: actions,
           );
}
