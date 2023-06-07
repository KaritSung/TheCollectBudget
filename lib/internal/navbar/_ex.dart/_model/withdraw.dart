


class Withdraw{
    String _id="";
    String _money='';
    String _date="";
    String _status="";
    String _detail ="";
    Withdraw(this._id,this._money,this._date,this._status,this._detail);

    String get money => _money;
    String get date => _date;
    String get status => _status;
    String get detail => _detail;
}