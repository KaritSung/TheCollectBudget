import 'package:flutter/material.dart';
import 'package:flutter_test_noti/internal/homepage.dart';
import 'package:flutter_test_noti/internal/provice/telModel.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;


class Cpass extends StatefulWidget {
  Cpass({Key? key}) : super(key: key);

  @override
  State<Cpass> createState() => _CpassState();
}

class _CpassState extends State<Cpass> {
  final personal = GlobalKey<FormState>();
TextEditingController password = new TextEditingController();
  TextEditingController password2 = new TextEditingController();

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
  @override
  Widget build(BuildContext context) {
     return WillPopScope(child: 
    Scaffold(
        appBar: AppBar(
          title: const Text("แก้ไขรหัส Pin "),
        ),
        body: Form(
          autovalidateMode: AutovalidateMode.disabled,
          key: personal,
          child: ListView(
          padding: EdgeInsets.all(32),   
                  children: [
                    const SizedBox(height: 10,),
                    passwordbox(),
                    const SizedBox(height: 10,),
                    password2box(),
                    const SizedBox(height: 10,),

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
                   // Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>Homepage(context.read<getTal>().Tel)), (Route<dynamic> route) => false);
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


  void _fetchData(BuildContext context) async {
    // show the loading dialog
    showDialog(
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

  Future sendData() async{
    _fetchData(context);
      try{
      var response = await http.post(
          Uri.parse("http://apbcm.ddns.net:5000/api/updatePassUser?Tel="+context.read<getTal>().Tel),
          body: {         
              "user_Password":password.text.toString()
          }
      );
      
     
      if(response.statusCode==200){
        print(response.body);
        print(response.statusCode);
        Navigator.of(context).pop();
        Navigator.of(context).pop();
       // Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>Homepage(context.read<getTal>().Tel)), (Route<dynamic> route) => false);
      }else{
        print("error-sent");
      }
  } catch(e){
      print("Error-timeout");
  }
  }
}