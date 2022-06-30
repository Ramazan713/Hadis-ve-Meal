import 'package:floor/floor.dart';
import 'package:hadith/db/entities/views/i_list_view.dart';

@DatabaseView("""select L.id,L.name,L.isRemovable,L.isArchive,L.sourceId,count(LV.verseId)itemCounts,ifnull(max(LH.pos),0)contentMaxPos,L.pos listPos 
  from List L left join ListVerse LV on L.id=LV.listId where L.sourceId=2  group by L.id""",
    viewName: "ListVerseView")

class ListVerseView extends IListView{
  ListVerseView({ required int id,required int contentMaxPos,required String name,required bool isArchive,required int sourceId,
    required int itemCounts,required bool isRemovable,required int listPos})
      :super(id: id,contentMaxPos:contentMaxPos,name: name,itemCounts: itemCounts,
        isRemovable: isRemovable,isArchive:isArchive,sourceId:sourceId,listPos:listPos);
}
