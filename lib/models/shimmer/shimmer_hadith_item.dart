

import 'package:flutter/material.dart';
import 'package:hadith/models/shimmer/shimmer_skeleton.dart';

class ShimmerHadithItem extends StatelessWidget{
  const ShimmerHadithItem({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.blueGrey.withOpacity(0.5),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 3,horizontal: 5),
        child: Container(
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(10),
            border: Border.all(color:Colors.black,width: 2)
            ,
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 5,horizontal: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 7,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    ShimmerSkeleton(height: 20,width: 30,),
                    ShimmerSkeleton(height: 20,width: 100,),
                    SizedBox(width: 20,)
                  ],
                ),
                const SizedBox(height: 17,),
                const ShimmerSkeleton(height: 20,width: 20,),
                const SizedBox(height: 7,),
                const Padding(padding: EdgeInsets.only(right: 30),
                    child: ShimmerSkeleton(height: 20,width: 20,)),
                const SizedBox(height: 23,),
                const Padding(padding: EdgeInsets.symmetric(horizontal: 80),
                    child: ShimmerSkeleton(height: 20,width: 20,)),
                const SizedBox(height: 7,),
              ],
            ),
          ),
        ),
      ),
    );
  }



}