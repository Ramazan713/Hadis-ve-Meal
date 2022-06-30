

import 'package:flutter/material.dart';

enum ListEditEnum{
  rename,
  remove,
  removeItems,
  exportAs,
  archive,
  unArchive,
  newCopy
}

extension ListEditEnumExtension on ListEditEnum{
  String get name{
    switch(this){
      case ListEditEnum.rename:
        return "Yeniden İsimlendir";
      case ListEditEnum.remove:
        return "Sil";
      case ListEditEnum.removeItems:
        return "İçindekileri Sil";
      case ListEditEnum.exportAs:
        return "Dışa Aktar";
      case ListEditEnum.archive:
        return "Arşivle";
      case ListEditEnum.unArchive:
        return "Arşivden Kaldır";
      case ListEditEnum.newCopy:
        return "Kopyasını Oluştur";
    }
  }

  IconData get iconData{
    switch(this){
      case ListEditEnum.rename:
        return Icons.drive_file_rename_outline;
      case ListEditEnum.remove:
        return Icons.folder_delete;
      case ListEditEnum.removeItems:
        return Icons.delete;
      case ListEditEnum.exportAs:
        return Icons.share;
      case ListEditEnum.archive:
        return Icons.send_and_archive;
      case ListEditEnum.unArchive:
        return Icons.unarchive;
      case ListEditEnum.newCopy:
        return Icons.copy;
    }
  }

}