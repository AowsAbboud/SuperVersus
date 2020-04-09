
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_database/firebase_database.dart';
import '../models/Category.dart';
import '../models/categories.dart';
import '../providers/Compare.dart';
import '../models/Item.dart';

//////////////////////////////////////////////////////
/// All Firebase Operations
/// 
/////////////////////////////////////////////////////
class MyFireBase {


//mmmmmmmmmmmmm Upload Pic to Firebase Storage mmmmmmmmmmmmmmmm
  static Future<String> uploadPicAndGetURL(File _image,String id) async {
    if (_image == null) return null;
    try {
      StorageReference firebaseStorageRef =
          FirebaseStorage.instance.ref().child(id);
      StorageUploadTask uploadTask = firebaseStorageRef.putFile(_image);
      await uploadTask.onComplete;
      return await firebaseStorageRef.getDownloadURL() as String;
    } catch (error) {
      return null;
    }
  }
//mmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmm

  /*--------------------------------------------*/

//mmmmmmmmmmmmmm Fetch Categories from firebase mmmmmmmmmmmmmmmmmm
  static Future<void> fetchCategories() async {
    var cateDB = FirebaseDatabase.instance.reference().child('categories');
    return cateDB.once().then((snapShot) {
      Map<dynamic, dynamic> values = snapShot.value;
      List<Category> li = [];
      values.forEach((key, values) {
        li.add(Category(id: key, name: values['name']));
      });
      Categories.setCategories(li);
    });
  }
//mmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmm

/*--------------------------------------------*/

//mmmmmmmmmmmmmmmmmmmmmm Fetch User Compares mmmmmmmmmmmmmmmmmmmmmmmmm
  static Future<List<Compare>> fetchMyComapres(String userID) async {
    var cateDB = FirebaseDatabase.instance.reference().child('compares');
    return cateDB
       // .orderByChild('userId')
       // .equalTo(userID)
        .once()
        .then((snapShot) {
      Map<dynamic, dynamic> values = snapShot.value;
      
      List<Compare> li = [];
      if(values == null) 
      return li;
      values.forEach((key, values) {
        var compr = Compare(
            id: key,
            userId: values['userId'],
            categoryId: values['categoryId'],
            isPrivate: values['isPrivate']);
        List<dynamic> items = values['items'] == null ? [] :  values['items'];
        items.forEach((itm) {
          Item itt = Item(
              id: itm['id'] == null ? DateTime.now().millisecondsSinceEpoch.toString() :  itm['id']  ,
              imageUrl: itm['imageUrl'],
              name: itm['name']);
          List<dynamic> attrs = itm['attributes'] == null ? [] : itm['attributes'];
          attrs.forEach((att) {
            itt.addAttribObj(Attrib(
                id: DateTime.now().millisecondsSinceEpoch.toString(),
                name: att['name'],
                weight: att['weight'],
                val: att['value']));
          });
          compr.addItem(itt);
        });
        li.add(compr);
      });
      return li;
    });
  }
//mmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmm

  //------------------------------------------------------

//mmmmmmmmmmmmmmmmm Delete User Compare From Firebase mmmmmmmmmmmmmmm
  static Future<void> deleteCompare(Compare compare) async {
    for(int i=0; i < compare.items.length; i++)
    {
      try{
       await FirebaseStorage.instance.ref().child(compare.items[i].id).delete();
      }
      catch(error){}

    }
     return FirebaseDatabase.instance.reference().child('compares').child(compare.id).remove();
  }
//mmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmm

//----------------------------------------------------------

//mmmmmmmmmmmmmmmmm Save User Compare on Firebase mmmmmmmmmmmmmmmmmmmm
  static Future<void> saveCompare(Compare compare) async {
    for (int i = 0; i < compare.items.length; i++) {
      if (compare.items[i].needUpload) {
        compare.items[i].imageUrl =
            await uploadPicAndGetURL(compare.items[i].image , compare.items[i].id);
      }
    }
    var compareDB =
        FirebaseDatabase.instance.reference().child('compares').child(compare.id);
    return await compareDB.set(<String, Object>{
      "userId": compare.userId,
      "categoryId": compare.categoryId,
      "isPrivate": compare.isPrivate,
      "items": compare.items.map((item) {
        return {
          'id': item.id,
          'name': item.name,
          'imageUrl': item.imageUrl,
          'attributes': item.attributes.map((attr) {
            return {
              'name': attr.name,
              'weight': attr.weight,
              'value': attr.val
            };
          }).toList()
        };
      }).toList()
    });
  }
//mmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmm


}
