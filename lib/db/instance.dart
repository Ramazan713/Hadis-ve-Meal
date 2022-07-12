import 'package:hadith/db/database.dart';
import 'package:hadith/db/migrations/migration_1_to_2.dart';
import 'package:path/path.dart';
import 'dart:io';
import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'package:flutter/services.dart';


Future<AppDatabase> getDatabase() async {

  const String dbName="hadithDb.db";
  final String databasePath = await getDatabasesPath();
  final String path = join(databasePath, dbName);
  final File file = File(path);
  if (!file.existsSync()) {
    ByteData data = await rootBundle.load(join('assets', dbName));
    List<int> bytes = data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
    await file.writeAsBytes(bytes, flush: true);
  }

  return await $FloorAppDatabase.databaseBuilder(dbName)
      .addMigrations([migration1To2])
      .build();
}