

import 'package:hadith/db/entities/cuz.dart';
import 'package:hadith/db/services/cuz_dao.dart';

class CuzRepo{
  final CuzDao cuzDao;

  CuzRepo({required this.cuzDao});

  Future<List<Cuz>>getAllCuz()=>cuzDao.getAllCuz();
}