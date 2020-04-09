import 'package:flutter/foundation.dart';
import '../models/Item.dart';

class Compare with ChangeNotifier{
  final String id;
  final String userId;
  String categoryId;
  bool isPrivate;
  List<Item> _items = [];
  //-------------------------------
  List<Item> get items{
    return [... _items];
  }
  //------------------------------

  //init--------------------------
  Compare({
    @required this.id,
    @required this.userId,
    @required this.categoryId,
    this.isPrivate = false,
  });
  //--------------------------------

 //mmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmm 
  void setPrivate(bool val)
  {
    this.isPrivate = val;
  }
 //mmmm Add Item or replace existing one mmmmmmmmmmmmmmmmm 
  void addItem(Item item){
    if(_items.where((tt)=>tt.id == item.id).length > 0)
    {
        var inx = _items.indexOf(_items.firstWhere((tm)=>tm.id == item.id));
        _items.removeAt(inx);
        _items.insert(inx, item);
    }
    else
    _items.add(item);
  }
 //mmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmm 
  void delItem(String id)
  {
    _items.removeWhere((it)=>it.id == id);
  }
 //mmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmm 


// ADD only can be called from the first item in a compare
// and should syncronize all other items 
//mmmmmmmmm Add Attribue for all Items mmmmmmmmmmmmmmmmmmmmm
  void addAttrib(String name , String weight , String val){
      try{
      String id = DateTime.now().millisecondsSinceEpoch.toString();
      int w = int.parse(weight.trim());
      int v = int.parse(val.trim());
      if(name.trim().isEmpty)
      return;

      _items.forEach((it)=>it.addAttribObj(Attrib(id: id,name: name , weight: w , val: v)));
      }catch(error){
        
      }
  }


// delete only can be called from the first item in a compare
// and should syncronize all other items 
//mmmmmmmmm Delete Attribue for all Items mmmmmmmmmmmmmmmmmmmmm
  void delAttrib(String id)
  {
   _items.forEach((it)=> it.delAttrib(id));
  }
//mmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmm

  /*void updateAttrib(Item item)
  {
    final index = _items.indexWhere((at) => at.id == item.id);
    _items[index] = item;
  }*/

}
