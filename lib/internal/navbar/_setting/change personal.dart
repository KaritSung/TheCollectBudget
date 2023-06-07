import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_test_noti/internal/homepage.dart';
import 'package:flutter_test_noti/internal/provice/telModel.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
class Personal extends StatefulWidget {
  Personal({Key? key}) : super(key: key);

  @override
  State<Personal> createState() => _PersonalState();
}

class _PersonalState extends State<Personal> {
final personal = GlobalKey<FormState>();
TextEditingController firstname = new TextEditingController();
TextEditingController lastname = new TextEditingController();
TextEditingController bankac = new TextEditingController();
String dropdownValue = '';
var _value ;
@override
void initState() {
  loaddata();
  super.initState();
  
}
Future loaddata() async{
  try{
      final url2 = Uri.parse('http://apbcm.ddns.net:5000/api/getUserbyTel?Tel='+context.read<getTal>().Tel);
      http.Response response2 = await http.get(url2);
      if(response2.statusCode==200){
        
          var user = json.decode(response2.body);
          setState(() {
              _value = user['user_BankId'];
              firstname.text = user['user_Firstname'];
              lastname.text = user['user_Lastname'];
              bankac.text = user['user_BankAc'];
              dropdownValue = user['user_BankId'];
          });
          
          
      }

  }catch(e){

  }
}

Widget firstNamebox() => TextFormField(
      validator: (value) {
          if(value==null||value.isEmpty){
              return "กรุณาใส่ชื่อจริง";
          }else{
            return null;
          }
          
      },
      controller: firstname,
      decoration: InputDecoration(
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
          ),
          labelText: 'ชื่อจริง',
          prefixIcon: Icon(Icons.person),
          contentPadding: EdgeInsets.symmetric(vertical: 15.0),
      ),
      maxLength: 15,
      
      
  );

  Widget lastNamebox() => TextFormField(
      validator: (value) {
           if(value==null||value.isEmpty){
              return "กรุณาใส่นามสกุล";
            }else{
            return null;
          }
      },
      controller: lastname,
      decoration: InputDecoration(
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
          ),
          labelText: 'นามสกุล',
          prefixIcon: Icon(Icons.people_alt_sharp),
          contentPadding: EdgeInsets.symmetric(vertical: 15.0),
      ),
      maxLength: 15,
      
     
  );

  List<Map> _mybank = [
  {
      'id':'KTB',
      'image':'assets/images/bank/krungthai.png',
      'name':'กรุงไทย',
      's':30.00,
      'g':10.00
  },
  {
      'id':'KBANK',
      'image':'assets/images/bank/kasi.png',
      'name':'กสิกร',
      's':30.00,
      'g':10.00
  },
  {
      'id':'BBL',
      'image':'assets/images/bank/krungthem.png',
      'name':'กรุงเทพ',
      's':30.00,
      'g':10.00
  },
  {
      'id':'SCB',
      'image':'assets/images/bank/thaipanis.png',
      'name':'ไทยพาณิชย์',
      's':30.00,
      'g':10.00
  },
  {
      'id':'PP',
      'image':'assets/images/bank/pay.png',
      'name':'พร้อมเพย์',
      's':30.00,
      'g':10.00
  },
];
Widget dropbank() => DropdownButtonFormField<String>(
  validator: ((value) {
      if(value==null || value.isEmpty){
          return 'กรุณาเลือกธนาคาร';
        }else{
          return null;
        }
      }
  ),    
         decoration: InputDecoration(
         prefixIcon: Icon(Icons.account_balance_sharp),
         ),
         hint: Text('กรุณาเลือกบัญชีธนาคาร'),
         value: _value,
         items: _mybank.map((bankItem) {
        
         return DropdownMenuItem<String>(
         value: bankItem['id'],
         child: Row(
             mainAxisAlignment: MainAxisAlignment.start,
             children: [
                Image.asset(bankItem['image'],width: bankItem['s'],),
                SizedBox(width:  bankItem['g'],),
                Text(bankItem['name'])
             ],
         ),
       );
      }).toList(),
     onChanged: (String? val) {
        dropdownValue = val.toString();
     },
);
Widget bankAcc() => TextFormField(
  controller: bankac,
      decoration: InputDecoration(
         
          
          labelText: 'หมายเลขบัญชีธนาคารหรือพร้อมเพย์',
          prefixIcon: Icon(Icons.account_balance_wallet_rounded),
          contentPadding: EdgeInsets.symmetric(vertical: 15.0),
      ),
      maxLength: 10,
      keyboardType: TextInputType.number,
      validator: (val){
        if(val== null || val.isEmpty){
          return 'กรุณาใส่เลขบัญชี';
        }else{
          if(val.length==10){
            return null;
          }else{
            return 'กรุณาใส่เลขบัญชีให้ครบ 10 ตัว';
          }
        }
        
      },
      
  );

  @override
  Widget build(BuildContext context) {
    return WillPopScope(child: 
    Scaffold(
        appBar: AppBar(
          title: const Text("แก้ไขข้อมูลส่วนตัว"),
        ),
        body: Form(
          autovalidateMode: AutovalidateMode.disabled,
          key: personal,
          child: ListView(
          padding: EdgeInsets.all(32),   
                  children: [
                    const SizedBox(height: 10,),
                    firstNamebox(),
                    const SizedBox(height: 10,),
                    lastNamebox(),
                    const SizedBox(height: 10,),
                    dropbank(),
                    const SizedBox(height: 10,),
                    bankAcc(),
                    ElevatedButton(onPressed: (){
              
                        if(personal.currentState!.validate()){
                                 sendData();
                        }                     
                    }, child:Text("บันทึกข้อมูล")
                    )
                  ],
              
          
        ),
        ),
        
      ),onWillPop: () async {
        final shouldPop = await showDialog<bool>(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text('คุณแน่ใจหรือไม่ที่จะออกจากการแก้ไขข้อมูลส่วนตัว'),
              actionsAlignment: MainAxisAlignment.spaceBetween,
              actions: [
                TextButton(
                  onPressed: () {
                    //Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>Homepage(context.read<getTal>().Tel)), (Route<dynamic> route) => false);
                    Navigator.pop(context, false);
                    Navigator.pop(context, false);
                  },
                  child: const Text('ใช่'),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context, false);
                  },
                  child: const Text('ไม่'),
                ),
              ],
            );
          },
        );
        return shouldPop!;
      },
    );

    
  }
  Future sendData() async{
    _fetchData(context);
      try{
      var response = await http.post(
          Uri.parse("http://apbcm.ddns.net:5000/api/updateUser?Tel="+context.read<getTal>().Tel),
          body: {         
            "user_Firstname":firstname.text.toString(),
            "user_Lastname":lastname.text.toString(),
            "user_BankId": dropdownValue.toString(),
            "user_BankAc": bankac.text.toString(),
          }
      );
      
     
      print(response.statusCode);
      if(response.statusCode==200){
        print(response.body);
        print(response.statusCode);
        Navigator.of(context).pop();
        Navigator.of(context).pop();
      
      }else{
        print("error-sent");
      }
  } catch(e){
      print("Error-timeout");
  }
  }

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
    await Future.delayed(const Duration(seconds: 2));

    // Close the dialog programmatically
    //Navigator.of(context).pop();
  }
}