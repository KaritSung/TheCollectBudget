import 'dart:async';
import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'internal/homepage.dart';


class pagethree extends StatefulWidget {
  final String Tel;
  pagethree(this.Tel);

  @override
  State<pagethree> createState() => _pagethreeState();
}

class _pagethreeState extends State<pagethree> {
  TextEditingController firstname = new TextEditingController();
  TextEditingController lastname = new TextEditingController();
  TextEditingController password = new TextEditingController();
  TextEditingController password2 = new TextEditingController();
  TextEditingController bankac = new TextEditingController();
  final bank = GlobalKey<FormState>();
  FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
  bool isLoading = false;
  String dropdownValue = '';

  @override
  void initState() {
    super.initState();
   
  }

  @override
  Widget build(BuildContext context) {
   

    return WillPopScope(child: MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text("ลงทะเบียน"),
        ),
        body: Form(
          autovalidateMode: AutovalidateMode.always,
          key: bank,
          child: ListView(
          padding: EdgeInsets.all(32),   
                  children: [
                    const SizedBox(height: 10,),
                    firstNamebox(),
                    const SizedBox(height: 10,),
                    lastNamebox(),
                    const SizedBox(height: 10,),
                    passwordbox(),
                    const SizedBox(height: 10,),
                    password2box(),
                    const SizedBox(height: 10,),
                    dropbank(),
                    const SizedBox(height: 5,),
                    bankAcc(),
                    ElevatedButton(onPressed: (){
              
                        if(bank.currentState!.validate()){
                              addUser();
                          
                        }                     
                    }, child:Text("บันทึกข้อมูล")
                    )
                  ],
              
          
        ),
        ),
        
      )
    ),
       onWillPop: () async {
        final shouldPop = await showDialog<bool>(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text('คุณแน่ใจหรือไม่ที่จะออกจากการลงทะเบียน'),
              actionsAlignment: MainAxisAlignment.spaceBetween,
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pushNamedAndRemoveUntil('/', (Route<dynamic> route) => false);
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

  Widget passwordbox() => TextFormField(
      validator: (value) {
         if(value==null||value.isEmpty){
              return "กรุณาใส่รหัสผ่าน";
          }else if(value.length<6){
              return "กรุณาใส่รหัสผ่านให้ครบ 6 ตัว";
          }else{
            return null;
          }
      },
      controller: password,
      obscureText: true,
      decoration: InputDecoration(
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
          ),
          labelText: 'รหัสผ่านเข้าใช้งาน',
          prefixIcon: Icon(Icons.password),
          contentPadding: EdgeInsets.symmetric(vertical: 15.0),
      ),
      maxLength: 6,
      keyboardType: TextInputType.number,
  );
  Widget password2box() => TextFormField(
      validator: (val){
          if(val== null || val.isEmpty){
            return 'กรุณายืนยันรหัสผ่าน';
          }if(val!=password.text){
            return 'รหัสผ่านไม่ตรงกัน';
          }else{
            return null;
          }
      },
      controller: password2,
      obscureText: true,
      decoration: InputDecoration(
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
          ),
          labelText: 'ยืนยันรหัสผ่านเข้าใช้งาน',
          prefixIcon: Icon(Icons.password),
          contentPadding: EdgeInsets.symmetric(vertical: 15.0),
      ),
      maxLength: 6,
      keyboardType: TextInputType.number,
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



Future addUser() async{
  _fetchData(context);
  try{
     var Token = await firebaseMessaging.getToken();
      var response = await http.post(
          Uri.parse("http://apbcm.ddns.net:5000/api/addUser"),
          body: {
            "user_Tel":widget.Tel.toString(),
            "user_Password":password.text.toString(),
            "user_Firstname":firstname.text.toString(),
            "user_Lastname":lastname.text.toString(),
            "user_Money":"0",
            "user_Avatar":"user.png",
            "user_Level":"user",
            "user_BankId": dropdownValue.toString(),
            "user_BankAc": bankac.text.toString(),
            "user_Token":Token.toString()

          }
      );
      
     
      print(response.statusCode);
      if(response.statusCode==200){
        print(response.body);
        print(response.statusCode);
        Navigator.of(context).pop();
        Navigator.of(context).push(MaterialPageRoute(builder: (context)=> Homepage(widget.Tel.toString())));
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





class Item {
  const Item(this.name,this.icon);
  final String name;
  final Icon icon;
}

