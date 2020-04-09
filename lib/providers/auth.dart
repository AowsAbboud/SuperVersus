import 'dart:async';
import 'package:flutter/widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/http_exception.dart';

class Auth with ChangeNotifier {

  FirebaseAuth _auth;
  DateTime _expiryDate;
  String _userId;
  Timer _authTimer;
//-------------------------------
  bool get isAuth {
    if (_expiryDate != null &&
        _expiryDate.isAfter(DateTime.now()) &&
        _userId != null){
          return true;
        }
    else
    return false;
  }
//-------------------------------
  String get userId {
    return _userId;
  }
//-------------------------------


//mmmmmmm Save Auth Response mmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmm 
  Future<void> saveAuthUser(FirebaseUser user) async {
      if (user == null || user.uid == null) {
        throw HttpException('Register failed!');
      }
      var idToken = await user.getIdToken();
      _userId = user.uid;
      _expiryDate = idToken.expirationTime;
      _autoLogout();
      notifyListeners();     
  }
//mmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmm

 //---------------------------

 //mmmmmmm Sign Up mmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmm 
  Future<void> signup(String email, String password) async {
    try{
    if(_auth == null)
    _auth = FirebaseAuth.instance;
    final FirebaseUser user = (await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    ))
        .user;
      saveAuthUser(user);
    }
    catch(error){
        throw error;
    }
  }
//mmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmm

//------------------------------------

//mmmmmm Login mmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmm
  Future<void> login(String email, String password) async {
    if(_auth == null)
    _auth = FirebaseAuth.instance;
    AuthResult result = await _auth.signInWithEmailAndPassword(
        email: email, password: password);
    FirebaseUser user = result.user;
     saveAuthUser(user);
  }
//mmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmm


//mmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmm
  Future<bool> tryAutoLogin() async {
    if(_auth == null)
    _auth = FirebaseAuth.instance;
    FirebaseUser user = await _auth.currentUser();
    if(user == null || user.uid == null)
    return false;
    else
      {
        var idToken = await user.getIdToken();
            _userId = user.uid;
            _expiryDate = idToken.expirationTime;
            notifyListeners();
            _autoLogout();
      }
    return true;
  }
//mmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmm

//-------------------------------------

//mmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmm
  Future<void> logout() async {
     _auth.signOut();
    _userId = null;
    _expiryDate = null;
    if (_authTimer != null) {
      _authTimer.cancel();
      _authTimer = null;
    }
    notifyListeners();
  }
//mmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmm

//------------------------------------

//mmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmm
  void _autoLogout() {
    if (_authTimer != null) {
      _authTimer.cancel();
    }
    final timeToExpiry = _expiryDate.difference(DateTime.now()).inSeconds;
    _authTimer = Timer(Duration(seconds: timeToExpiry), logout);
  }
//mmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmm

}
