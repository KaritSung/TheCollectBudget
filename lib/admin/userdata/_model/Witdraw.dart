class WitdrawAdmin{
    String _id="";
    String _witId="";
    String _money='';
    String _date="";
    String _Firstname="";
    String _Lastname="";

    
    WitdrawAdmin(this._id,this._witId,this._money,this._date,this._Firstname,this._Lastname);
    
    String get id => _id;
    String get witId => _witId;
    String get money => _money;
    String get date => _date;
    String get firstname => _Firstname;
    String get lastname => _Lastname;
}