class CM{
    String _Firstname="";
    String _Lastname="";
    String _Admin_Firstname="";
    String _Admin_Lastname="";
    String _Money="";
    String _AdminDate ="";
    String _UserDate ="";

    String get Admin_Firstname => _Admin_Firstname;
    String get Admin_Lastname => _Admin_Lastname;
    String get Firstname => _Firstname;
    String get Lastname => _Lastname;
    String get Money => _Money;
    String get AdminDate => _AdminDate;
    String get UserDate => _UserDate;

    CM(this._Firstname,this._Lastname,this._Admin_Firstname,this._Admin_Lastname,this._Money,this._AdminDate,this._UserDate);


}