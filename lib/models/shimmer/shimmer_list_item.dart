

import 'package:flutter/material.dart';
import 'package:hadith/models/shimmer/shimmer_skeleton.dart';

class ShimmerListItem extends StatelessWidget {
  const ShimmerListItem({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.blueGrey.withOpacity(0.9),
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
                const SizedBox(height: 13,),

                Table(
                  columnWidths: const {
                    0: FlexColumnWidth(0.7),
                    1: FlexColumnWidth(1.0),
                    2: FlexColumnWidth(7.0),
                    3: FlexColumnWidth(1.0),
                    4: FlexColumnWidth(0.4),
                  },
                  children: [
                    TableRow(
                        children: [
                          const TableCell(verticalAlignment: TableCellVerticalAlignment.middle,
                            child: ShimmerSkeleton(height: 25,width: 30,),),
                          const SizedBox(),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: const [
                              ShimmerSkeleton(height: 20,width: 50,),
                              SizedBox(height: 7,),
                              Padding(padding: EdgeInsets.only(right: 30),
                                  child: ShimmerSkeleton(height: 20,width: 20,)),

                            ],
                          ),
                          const SizedBox(),
                          const TableCell(verticalAlignment: TableCellVerticalAlignment.middle,
                            child: ShimmerSkeleton(height: 40,width: 30,),),
                        ]
                    )
                  ],
                ),
                const SizedBox(height: 13,),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
