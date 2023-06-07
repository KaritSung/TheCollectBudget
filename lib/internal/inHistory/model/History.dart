import 'package:http/http.dart';

class History{
  String _date = "" ;
  String _sum = "n/a" ;
  String _mac = "" ;
  int _S = 0 ;
  int _M = 0 ;
  int _L = 0 ;
  History(this._date,this._sum,this._S,this._M,this._L,this._mac);
  String get date => _date;
  String get sum => _sum;
  String get mac => _mac;
  int get S =>_S;
  int get M =>_M;
  int get L =>_L;
  
}