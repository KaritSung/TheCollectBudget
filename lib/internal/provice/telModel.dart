import 'package:flutter/material.dart';

class getTal extends ChangeNotifier{
 String Tel = "";
 String _user_tel = "";
 String get tel => Tel;
String get user_tel => _user_tel;
 void setTel(String d){
    Tel = d;
    //notifyListeners();
 }

 void setUserTel(String d){
    _user_tel = d;
    //notifyListeners();
 }
}