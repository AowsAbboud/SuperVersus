import 'package:flutter/material.dart';
import '../services/myfirebase.dart';
import 'Compare.dart';

class MyCompares with ChangeNotifier {
  List<Compare> _compares = [];
  final String userId;

  MyCompares(this.userId, this._compares);

  //-------------------------------
  List<Compare> get compares {
    return [..._compares];
  }
  //-------------------------------
  int get count {
    return _compares.length;
  }

  //-------------------------------
  Compare findById(String id) {
    return _compares.firstWhere((cc) => cc.id == id);
  }
  //-------------------------------
  bool _loading = false;
  //-------------------------------
  bool get loading {
    return _loading;
  }
  //-------------------------------
  Future<void> loadMyCompares() async
  {
    _loading = true;
    notifyListeners(); // show loading on home page
    try{
      _compares =  await MyFireBase.fetchMyComapres(userId);
    }
    catch(error)
    {
      _compares = [];
    }
      _loading = false;
      notifyListeners(); //// show compares list
      return true;
  }
  //-------------------------------

}
