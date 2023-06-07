class Report_model{
  String _id = "";
  String _userid= "";
  String _usertel= "";
  String _topic= "";
  String _body= "";
  String _firstname= "";
  String _lastname= "";
  String _pic= "";
  String _date= "";

String get topic => _topic;
  String get id => _id;
  String get body => _body;
  String get usertel => _usertel;
  String get pic => _pic;
  String get firstname => _firstname;
  String get lastname => _lastname;
  String get date => _date;
  Report_model(this._id,this._userid,this._usertel,this._topic,this._body,this._firstname,this._lastname,this._pic,this._date);
}