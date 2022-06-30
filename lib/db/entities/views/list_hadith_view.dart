import 'package:floor/floor.dart';
import 'package:hadith/db/entities/views/i_list_view.dart';


@DatabaseView("""select L.id,L.name,L.isRemovable,count(LH.hadithId)itemCounts,L.isArchive,L.sourceId,ifnull(max(LH.pos),0)contentMaxPos,L.pos listPos 
  from List L left join ListHadith LH on  L.id=LH.listId where L.sourceId=1 group by L.id""",
    viewName: "ListHadithView")
class ListHadithView extends IListView{

  ListHadithView({ required int id,required int contentMaxPos,required String name,required bool isArchive,required int sourceId,
    required int itemCounts,required bool isRemovable,required int listPos})
      :super(id: id,name: name,itemCounts: itemCounts,contentMaxPos:contentMaxPos,
      isRemovable: isRemovable,isArchive:isArchive,sourceId:sourceId,listPos:listPos);

}