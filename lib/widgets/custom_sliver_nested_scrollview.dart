import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hadith/features/bottom_nav/bloc/bottom_nav_bloc.dart';
import 'package:hadith/features/bottom_nav/bloc/bottom_nav_event.dart';


class CustomSliverNestedView extends NestedScrollView {
  CustomSliverNestedView(
    BuildContext context, {Key? key,
    required Widget child,
    required List<Widget> Function(BuildContext, bool) headerSliverBuilder,
        bool isBottomNavAffected=false,
        ScrollController? scrollController
  }) : super(key: key,
          body: child,
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            if(isBottomNavAffected){
              context.read<BottomNavBloc>().add(BottomNavChangeVisibility(isCollapsed: innerBoxIsScrolled));
            }
            return headerSliverBuilder(context, innerBoxIsScrolled);
          },controller: scrollController
        );
}
