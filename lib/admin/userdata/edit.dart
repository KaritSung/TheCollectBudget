
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test_noti/admin/userdata/usertool.dart';
import 'dart:convert';
import 'package:flutter_test_noti/internal/homepage.dart';
import 'package:flutter_test_noti/internal/provice/telModel.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

class Edit extends StatefulWidget {
  Edit({Key? key}) : super(key: key);

  @override
  State<Edit> createState() => _EditState();
}

class _EditState extends State<Edit> {
  TextEditingController Tel = new TextEditingController();
  final personal = GlobalKey<FormState>();
TextEditingController firstname = new TextEditingController();
TextEditingController lastname = new TextEditingController();
TextEditingController bankac = new TextEditingController();
TextEditingController password = new TextEditingController();
TextEditingController password2 = new TextEditingController();
TextEditingController Money = new TextEditingController();
final focusNode = FocusNode();
String dropdownValue = '';
String dropdownValue2 = '';

String? _value ;
String? _value2 ;
@override
void initState() {
  print("edit");
  loaddata();
  setState(() {
    
  });
  super.initState();
  
}
@override
void dispose() {
  print("dispose-edit");
  super.dispose();
}

Future loaddata() async{
  try{
      final url2 = Uri.parse('http://apbcm.ddns.net:5000/api/getUserbyTel?Tel='+context.read<getTal>().user_tel);
      http.Response response2 = await http.get(url2);
      if(response2.statusCode==200){
        
          var user = json.decode(response2.body);
           dropdownValue2 = user['user_Level'];
           dropdownValue = user['user_BankId'];
          setState(() {
              Tel.text = context.read<getTal>().user_tel;
              Money.text =   user['user_Money'].toStringAsFixed(3); 
              _value = user['user_BankId'];
              _value2 = user['user_Level'];
              firstname.text = user['user_Firstname'];
              lastname.text = user['user_Lastname'];
              password.text = user['user_Password'];
              password2.text = user['user_Password'];
              bankac.text = user['user_BankAc'];
              //
          });
          
          
      }

  }catch(e){

  }
}
Widget tel() => TextFormField(
      validator: (value) {
          if(value==null||value.isEmpty){
              return "กรุณาใส่เบอร์โทรศัพท์";
          }else{
            if(value[0]=="0"){
              if(value.length==10){ 
                return null;
              }else{
                return "รูปแบบเบอร์โทรศัพท์ผิด";
              }
            }else{
              return "รูปแบบเบอร์โทรศัพท์ผิด";
            }
          }
          
      },
      keyboardType: TextInputType.number,
      controller: Tel,
      decoration: InputDecoration(
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
          ),
          labelText: 'เบอร์โทรศัพท์',
          prefixIcon: Icon(Icons.phone),
          contentPadding: EdgeInsets.symmetric(vertical: 15.0),
          
      ),
      maxLength: 10,
      
  );
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
          labelText: 'บัญชีธนาคาร',
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
          labelText: 'รหัส Pin เข้าใช้งาน',
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
          labelText: 'ยืนยันรหัส Pin เข้าใช้งาน',
          prefixIcon: Icon(Icons.password),
          contentPadding: EdgeInsets.symmetric(vertical: 15.0),
      ),
      maxLength: 6,
      keyboardType: TextInputType.number,
  );
  Widget inputbox() => TextFormField(
      validator: (value) {
          if(value==null||value.isEmpty){
              return "กรุณาใส่จำนวนเงิน";
          }else{
              return null;
          }
          
      },
      //style: TextStyle(fontSize: 20),
      focusNode: focusNode,
      controller: Money,
      decoration: InputDecoration(
          labelText: 'ยอดเงินสะสม(บาท)',
          prefixIcon: Icon(Icons.monetization_on),
           contentPadding: EdgeInsets.symmetric(vertical: 15.0),
          
          
      ),
      keyboardType: TextInputType.number, 
      inputFormatters: <TextInputFormatter>[
   // for below version 2 use this
 FilteringTextInputFormatter.allow(RegExp(r'^(\d+)\.?\d{0,3}')), 

  ],
      onEditingComplete: (){
        FocusScope.of(context).unfocus();
          try {
            setState(() {
              var val =  double.parse(Money.text);
              Money.text = val.toStringAsFixed(3);
            });
          } catch (e) {
            print('fied-ex-null');
          }
      },
      
  );

  List<Map> _myroll = [
    {
      "name":"user"
    },
    {
      "name":"admin"
    }
  ];
    Widget droproll() => DropdownButtonFormField<String>(
  validator: ((value) {
      if(value==null || value.isEmpty){
          return 'กรุณาเลือกระดับผู้ใช้งาน';
        }else{
          return null;
        }
      }
  ),    
         decoration: InputDecoration(
          labelText: 'ระดับผู้ใช้งาน',
         prefixIcon: Icon(Icons.admin_panel_settings)
         ),
         hint: Text('กรุณาเลือกระดับผู้ใช้งาน'),
         value: _value2,
         items: _myroll.map((roll) {
        
         return DropdownMenuItem<String>(
         value: roll['name'],
         child: Column(children: [ Row(
             mainAxisAlignment: MainAxisAlignment.start,
             children: [
                Text(roll['name'].toString().toUpperCase())
             ],
         ),
         //Divider(color: Color.fromARGB(255, 96, 99, 96)),
       ],));
      }).toList(),
     onChanged: (String? val) {
        dropdownValue2 = val.toString();
     },
);




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("แก้ไขข้อมูลส่วนตัว",style: TextStyle(color: Color.fromARGB(255, 0, 0, 0))),
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.arrow_back,
              color: Color.fromARGB(255, 0, 0, 0),
            ),),
        centerTitle: true,
        backgroundColor: Color.fromARGB(255, 255, 252, 252),
      ),
      body: Form(
          autovalidateMode: AutovalidateMode.disabled,
          key: personal,
          child: ListView(
          padding: EdgeInsets.all(32),   
                  children: [
                    const SizedBox(height: 10,),
                    tel(),
                    Text("*หมายเหตุ การเปลี่ยนเบอร์โทรศัพท์จะเปลี่ยนเบอร์สำหรับเข้าใช้งาน",style: TextStyle(color: Color.fromARGB(255, 117, 121, 117), fontSize: 13.0)),
                    const SizedBox(height: 40,),
                    passwordbox(),
                    const SizedBox(height: 10,),
                    password2box() ,
                    const SizedBox(height: 10,),
                    firstNamebox(),
                    const SizedBox(height: 10,),
                    lastNamebox(),
                    const SizedBox(height: 10,),
                    dropbank(),
                    const SizedBox(height: 10,),
                    bankAcc(),
                    const SizedBox(height: 10,),
                    inputbox(),
                    const SizedBox(height: 10,),
                    droproll(),
                    const SizedBox(height: 15,),
                    ElevatedButton(onPressed: (){
              
                        if(personal.currentState!.validate()){
                                 sendData();
                        }                     
                    }, child:Text("บันทึกการแก้ไขข้อมูล")
                    )
                  ],
              
          
        ),
        ),);
  }
  Future sendData() async{
    _fetchData(context);
      try{
      if(Tel.text == context.read<getTal>().user_tel){
          var response = await http.post(
          Uri.parse("http://apbcm.ddns.net:5000/api/updateUserAll?Tel="+context.read<getTal>().user_tel),
          body: {         
            "user_Firstname":firstname.text.toString(),
            "user_Lastname":lastname.text.toString(),
            "user_BankId": dropdownValue.toString(),
            "user_BankAc": bankac.text.toString(),
            "user_Password":password.text.toString(),
            "user_Level":dropdownValue2.toString(),
            "user_Money":Money.text.toString()
          }
          
      );
          if(response.statusCode==200){
            print(response.statusCode);
            Navigator.of(context).pop();
            Navigator.of(context).pop();
          }else{
            print("error-sent");
          }
      }else{
          final url = Uri.parse('http://apbcm.ddns.net:5000/api/getUserbyTel?Tel='+Tel.text);
          http.Response res = await http.get(url);

            if(res.statusCode==200){
              if(res.body=="null"){
                    var res2 = await http.post(
                    Uri.parse("http://apbcm.ddns.net:5000/api/updateUserAll?Tel="+context.read<getTal>().user_tel),
                    body: {         
                      "user_Firstname":firstname.text.toString(),
                      "user_Lastname":lastname.text.toString(),
                      "user_BankId": dropdownValue.toString(),
                      "user_BankAc": bankac.text.toString(),
                      "user_Password":password.text.toString(),
                      "user_Level":dropdownValue2.toString(),
                      "user_Money":Money.text.toString()
                    }
                    );
                    var res1 = await http.post(
                    Uri.parse("http://apbcm.ddns.net:5000/api/updateTelUser?Tel="+context.read<getTal>().user_tel),
                    body: {         
                        "user_Tel":Tel.text
                    });
                    if(res1.statusCode==200&&res2.statusCode==200){
                      Navigator.of(context).pop();
                      Navigator.of(context).pop();
                      context.read<getTal>().setUserTel(Tel.text);
                    }

                //save to database
              }else{
                Fluttertoast.showToast(
                msg: "เบอร์โทรศัพท์นี้มีอยู่ในระบบแล้ว",
                toastLength: Toast.LENGTH_LONG,
                gravity: ToastGravity.CENTER,
                timeInSecForIosWeb: 3,
                backgroundColor: Color.fromARGB(255, 244, 54, 67),
                textColor: Color.fromARGB(255, 255, 255, 255),
                fontSize: 16.0
            );
            Navigator.of(context).pop();
            }
      }
      } 
      
  }catch(e){
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