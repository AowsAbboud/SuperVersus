import '../models/Category.dart';

 class Categories {
  static List<Category> _categories = [];
//-------------------------------
  static List<Category> get categories {
    return [..._categories];
  }


//Set List mmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmm
  static setCategories(List<Category> li)
  {
    _categories = li;
  }
//Find By Id mmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmm
  static Category findById(String id) {
    try{
    return _categories.firstWhere((cat) => cat.id == id);
    }
    catch(err){
      return null;
    }
  }
//get id by name mmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmm

  static String getIdByName(String name) {
    try{
    return _categories.firstWhere((cat) => cat.name == name).id;
    }catch(error){
      return null;
    }
  }
//serach by name mmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmm
  static List<String> search(String val) {
    return _categories.where((cat) => cat.name.toLowerCase().contains(val.toLowerCase().trim())).map((ct)=>ct.name).toList();
  }
//mmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmm



 
}
