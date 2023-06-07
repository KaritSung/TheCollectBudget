import 'package:flutter/material.dart';
import 'package:flutter_test_noti/internal/provice/telModel.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:provider/provider.dart';
class Confirm_transfer extends StatefulWidget {
  String? _id;
  String? _Userid;
  String? _money;
  String? _date;
  Confirm_transfer(this._id,this._Userid,this._money,this._date);

  @override
  State<Confirm_transfer> createState() => _Confirm_transferState();
}

class _Confirm_transferState extends State<Confirm_transfer> {
  final form = GlobalKey<FormState>();
  String? firstname;
  String? lastname;
  String? tel;
  String? bank;
  String dropdownValue="";
  TextEditingController text = new TextEditingController();
  @override
  void initState() {
    print("confirm");
    loaddata();
    
    super.initState();
    
  }
  @override
  void dispose() {
    
    super.dispose();
  }

  Future loaddata() async{
    
      try {
           final url = Uri.parse('http://apbcm.ddns.net:5000/api/getUserbyID?id='+widget._Userid.toString());
           http.Response response = await http.get(url);
           if(response.statusCode==200){
              var jsonData = json.decode(response.body);
              setState(() {
                firstname = jsonData['user_Firstname'];
                lastname = jsonData['user_Lastname'];
                tel = jsonData['user_Tel'];
                bank = jsonData['user_BankAc'];
                
              });
              
           }

      } catch (e) {
          print('error-sent');
      }
  }
  Future load() async{
    var jsonData;
      try {
           final url = Uri.parse('http://apbcm.ddns.net:5000/api/getUserbyID?id='+widget._Userid.toString());
           http.Response response = await http.get(url);
           if(response.statusCode==200){
              jsonData = json.decode(response.body);
            return jsonData;
           }else{
            return jsonData;
           }
      } catch (e) {
          print('error-sent');
          return null;
      }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
                  
                  appBar: AppBar(
                    
                  title: Text("ยืนยันการโอนเงินผู้ใช้งาน",style: TextStyle(color: Color.fromARGB(255, 255, 255, 255))),
                  leading: IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: const Icon(
                        Icons.arrow_back,
                        color: Color.fromARGB(255, 255, 255, 255),
                      ),),
                  centerTitle: true,
                  backgroundColor: Color.fromARGB(255, 47, 114, 185),
                ),
                body: Card(child: Container(
                  child: ListView(children: [
                    
                    Form(
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    key: form,
                    child:
                    
                    
                     Column(children: [
                      const SizedBox(height: 10,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                      Text("ชื่อ : "+firstname.toString()+" "+lastname.toString(),style: TextStyle(color: Color.fromARGB(255, 16, 16, 16), fontSize: 18.0)),
                    ],),
                     Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                      Text("เบอร์โทร : "+tel.toString(),style: TextStyle(color: Color.fromARGB(255, 16, 16, 16), fontSize: 18.0)),
                    ],),
                     Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                      Text("บัญชี : ",style: TextStyle(color: Color.fromARGB(255, 16, 16, 16), fontSize: 18.0)),
                      FutureBuilder(
                        future: load(),
                        builder: (BuildContext context, AsyncSnapshot snapshot) {
                          if(snapshot.data != null){
                              if(snapshot.data['user_BankId']=="KTB"){
                                return Row(children: [
                                  Image.asset('assets/images/bank/krungthai.png',width: 30.0,),
                                  const SizedBox(width: 10,),
                                  Text("ธนคารกรุงไทย",style: TextStyle(color: Color.fromARGB(255, 16, 16, 16), fontSize: 18.0)),
                                ],);
                                  
                              }else if(snapshot.data['user_BankId']=="KBANK"){
                                  return Row(children: [
                                  Image.asset('assets/images/bank/kasi.png',width: 30.0,),
                                  const SizedBox(width: 10,),
                                  Text("ธนาคารกสิกรไทย",style: TextStyle(color: Color.fromARGB(255, 16, 16, 16), fontSize: 18.0)),],);
                              }else if(snapshot.data['user_BankId']=="BBL"){
                                  return Row(children: [
                                  Image.asset('assets/images/bank/krungthem.png',width: 30.0,),
                                  const SizedBox(width: 10,),
                                  Text("ธนาคารกรุงเทพ",style: TextStyle(color: Color.fromARGB(255, 16, 16, 16), fontSize: 18.0)),],);
                              }else if(snapshot.data['user_BankId']=="SCB"){
                                  return Row(children: [
                                  Image.asset('assets/images/bank/thaipanis.png',width: 30.0,),
                                  const SizedBox(width: 10,),
                                  Text("ธนาคารไทยพาณิชย์",style: TextStyle(color: Color.fromARGB(255, 16, 16, 16), fontSize: 18.0)),],);
                              }else if(snapshot.data['user_BankId']=="PP"){
                                  return Row(children: [
                                  Image.asset('assets/images/bank/pay.png',width: 30.0,),
                                  const SizedBox(width: 10,),
                                  Text("พร้อมเพย์",style: TextStyle(color: Color.fromARGB(255, 16, 16, 16), fontSize: 18.0)),],);
                              }
                              else{
                                return Text("");
                              }
                          }else{
                            return Text("");
                          }
                          

                        },
                      ),
                      
                    ],),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                        Text("หมายเลขบัญชี : "+bank.toString(),style: TextStyle(color: Color.fromARGB(255, 16, 16, 16), fontSize: 18.0)),
                    ],),
                    const SizedBox(height: 15,),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                        Text("จำนวนที่ต้องการแลก(บาท) ",style: TextStyle(color: Color.fromARGB(255, 16, 16, 16), fontSize: 24.0)),
                    ],),
                     Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                        Text(widget._money.toString(),style: TextStyle(color: Color.fromARGB(255, 16, 16, 16), fontSize: 24.0)),
                    ],),
                    Padding(padding: EdgeInsets.all(32),
                     child:dropdown(),
                    ),
                    Padding(padding: EdgeInsets.all(32),
                     child:textbox()
                    ),
                    Padding(padding: EdgeInsets.all(32),
                     child:ElevatedButton(onPressed: (){
              
                        if(form.currentState!.validate()){
                             sendData();
                          
                        }                     
                    }, child:Text("ยืนยันการโอนเงิน")
                    )
                    ),
                    
                    
                  ],
                  ) 
    )],)),
                
    ));
  }

  List<Map> _mystatus = [
  {
      'id':'สำเร็จ'
  },
  {
      'id':'ไม่สำเร็จ'
  },
  
];
  Widget dropdown() => DropdownButtonFormField<String>(
    
  validator: ((value) {
      if(value==null || value.isEmpty){
          return 'กรุณาเลือกสถานะการโอนเงิน';
        }else{
          return null;
        }
      }
  ),    
         decoration: InputDecoration(
          labelText: 'สถานะการโอนเงิน',
         prefixIcon: Icon(Icons.check_circle_outlined),
         ),
         
         hint: Text('สถานะการโอนเงิน'),
         items: _mystatus.map((bankItem) {
         return DropdownMenuItem<String>(
         value: bankItem['id'],
         child: Row(
             mainAxisAlignment: MainAxisAlignment.start,
             children: [
                Text(bankItem['id'])
             ],
         ),
       );
      }).toList(),
     onChanged: (String? val) {

        
        if(val=="สำเร็จ"){
          text.text = "โอนเงินเข้าสู่บัญชีสำเร็จ";
          dropdownValue = "0";
        }else if (val=="ไม่สำเร็จ"){
          text.text = "";
          dropdownValue = "2";
        }

     },
);


Widget textbox() => TextFormField(
      validator: (value) {
          if(value==null||value.isEmpty){
              return "กรุณาใส่หมายเหตุการโอนเงิน";
          }else{
            return null;
          }
          
      },
      minLines: 4, // any number you need (It works as the rows for the textarea)
       keyboardType: TextInputType.multiline,
      maxLines: null,
      controller: text,
      decoration: InputDecoration(
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
          ),
          labelText: 'หมายเหตุการโอนเงิน',
          prefixIcon: Icon(Icons.description_outlined),
          contentPadding: EdgeInsets.symmetric(vertical: 15.0),
      ),
      
      
      
  );
  void _fetchData(BuildContext context) async {
    // show the loading dialog
    showDialog(
        // The user CANNOT close this dialog  by pressing outsite it
        barrierDismissible: false,
        context: context,
        builder: (_) {
          return Dialog(
            // The background color
            backgroundColor: Colors.white,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  // The loading indicator
                  CircularProgressIndicator(),
                  SizedBox(
                    height: 15,
                  ),
                  // Some text
                  Text('Loading...')
                ],
              ),
            ),
          );
        });

    // Your asynchronous computation here (fetching data from an API, processing files, inserting something to the database, etc)
    //await Future.delayed(const Duration(seconds: 2));

    // Close the dialog programmatically
    //Navigator.of(context).pop();
  }
  Future sendData()async{
    _fetchData(context);
    try {
        



        var response = await http.post(
          Uri.parse("http://apbcm.ddns.net:5000/api/updateWithdraw?id="+widget._id.toString()),
          body: {
            "withdraw_Status":dropdownValue,
            "withdraw_Detail":text.text,
            "AdminTel":context.read<getTal>().tel,
            "user_tel":tel.toString(),
            "user_name":firstname,
            "last_name":lastname,
            "money":widget._money,
            "user_date": widget._date
          }
        
      );

      if(response.statusCode==200){
        Navigator.of(context).pop();
        Navigator.of(context).pop();
      }
    } catch (e) {
      print("error-send");
    }
  }


}