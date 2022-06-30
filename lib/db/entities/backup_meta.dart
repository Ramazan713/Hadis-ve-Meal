

import 'package:equatable/equatable.dart';
import 'package:floor/floor.dart';

@Entity(tableName: "BackupMeta")
class BackupMeta extends Equatable{

  @PrimaryKey(autoGenerate: true)
  final int? id;
  final String fileName;
  final String updatedDate;
  final bool isAuto;

  BackupMeta copyWith({int? id,bool keepOldId=true,String? fileName,String? updatedDate,bool? isAuto}){
    return BackupMeta(fileName: fileName??this.fileName,
        updatedDate: updatedDate??this.updatedDate, isAuto: isAuto??this.isAuto,id:keepOldId?id??this.id:id);
  }


  const BackupMeta({required this.fileName,this.id,required this.updatedDate,required this.isAuto});

  @override
  List<Object?> get props => [id,fileName,isAuto];
}