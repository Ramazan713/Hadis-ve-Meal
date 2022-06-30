

import 'package:flutter/material.dart';

class ShimmerSkeleton extends StatelessWidget {
  const ShimmerSkeleton({Key? key, this.height, this.width,this.defaultPadding=10}) : super(key: key);

  final double? height, width;
  final int defaultPadding;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      padding:  EdgeInsets.all(defaultPadding / 2),
      decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.3),
          borderRadius:
          BorderRadius.all(Radius.circular(defaultPadding.toDouble()))),
    );
  }
}