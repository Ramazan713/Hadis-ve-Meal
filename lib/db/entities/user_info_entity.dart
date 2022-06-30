


import 'dart:typed_data';

import 'package:floor/floor.dart';

@Entity(tableName: "userInfo")
class UserInfoEntity{

  @PrimaryKey(autoGenerate: true)
  final int?id;

  final String userId;

  final Uint8List? img;

  UserInfoEntity({required this.userId,required this.img,this.id});

}