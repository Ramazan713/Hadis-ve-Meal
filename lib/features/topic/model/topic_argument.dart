import 'package:hadith/constants/enums/book_enum.dart';

class TopicArgument{
  final BookEnum bookEnum;
  final int sectionId;
  final String title;
  TopicArgument({this.bookEnum=BookEnum.serlevha
    ,this.sectionId=1,this.title="Bölüm"});
}