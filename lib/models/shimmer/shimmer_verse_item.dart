import 'package:flutter/material.dart';
import 'package:hadith/models/shimmer/shimmer_skeleton.dart';

class ShimmerVerseItem extends StatelessWidget {
  const ShimmerVerseItem({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.green.withOpacity(0.7),
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
              children: const [
                ShimmerSkeleton(height: 20,width: 20,),
                SizedBox(height: 17,),
                ShimmerSkeleton(height: 20,width: 20,),
                SizedBox(height: 7,),
                Padding(padding: EdgeInsets.only(right: 70),child: ShimmerSkeleton(height: 20,width: 20,))
              ],
            ),
          ),
        ),
      ),
    );
  }
}





