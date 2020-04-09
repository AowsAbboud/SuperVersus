import 'package:flutter/foundation.dart';
import 'dart:io';
import 'package:flutter/material.dart';

class Item {

  final String id;
  String name;
  String imageUrl;
  final String keywords;
  File image;
  bool needUpload;
  List<Attrib> _attributes = [];

  List<Attrib> get attributes {
    return [..._attributes];
  }

  //for ListTiles Icon display---
  ImageProvider get icon { 
    return Image.network(imageUrl).image;
  }
  //init-------------------------
  Item({
    @required this.id,
    @required this.name,
    @required this.imageUrl,
    this.keywords = '',
    this.needUpload  = false
  });
  //------------------------------

  // Score Getter-----------------
   int get score {
    int sum = 0;
    _attributes.forEach((atrib){
        sum += atrib.weight * atrib.val;
    });
    return sum;
  }
  //-------------------------------


//mmmmmmmmmmmmmmmmm Add Attribute or Update Existing one if name founded
  void addAttrib(String name , String weight , String val){
    try{
    int w = int.parse(weight.trim());
    int v = int.parse(val.trim());  
    name = name.trim();
    if(name.isEmpty)
    return;
    if(_attributes.where((at)=>at.name == name).length > 0)
    {
        int indx = _attributes.indexOf(_attributes.firstWhere((at)=>at.name == name));
        var id = _attributes.firstWhere((at)=>at.name == name).id;
        _attributes.removeAt(indx);
        _attributes.insert(indx, Attrib(id: id, name: name, weight: w, val: v));
    }
    else
    _attributes.add(Attrib(id: DateTime.now().millisecondsSinceEpoch.toString(), name: name.trim(), weight: w, val: v));
    }
    catch(error){
      //int parse errors so ignore adding
    }
  }
//mmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmm
  void addAttribObj(Attrib atr){
  _attributes.add(atr);
  }
//mmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmm
  void delAttrib(String id)
  {
    _attributes.removeWhere((at)=>at.id == id);
  }
//mmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmm
  void updateAttrib(Attrib atrb)
  {
    final index = _attributes.indexWhere((at) => at.id == atrb.id);
    _attributes[index] = atrb;
  }
//mmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmm
}


/////////////////////////////////////////////////////
////      
////          Attribute Class
////////////////////////////////////////////////////
class Attrib{
  final String id;
  final String name;
  final int weight; // 1 - 5
  final int val; // 0 - 10

  Attrib({
    @required this.id,
    @required this.name,
    @required this.weight,
    @required this.val,
  });
////////////////////////////////////////////////////
  
}
