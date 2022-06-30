import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:focus_detector/focus_detector.dart';

import '../bloc/bottom_nav_bloc.dart';
import '../bloc/bottom_nav_event.dart';

abstract class BottomNavWidgetState<T extends StatefulWidget> extends State<T> {
  Widget buildPage(BuildContext context);

  @override
  Widget build(BuildContext context) {
    final bottomNavBloc = context.read<BottomNavBloc>();
    return FocusDetector(
        onFocusLost: () {
          bottomNavBloc.add(BottomNavChangeVisibility(isCollapsed: true,withAnimation: false));
        },
        onFocusGained: () {
          bottomNavBloc.add(BottomNavChangeVisibility(isCollapsed: false,withAnimation: false));
        },
        child: buildPage(context));
  }
}
