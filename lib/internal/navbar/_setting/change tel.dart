import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test_noti/internal/homepage.dart';
import 'package:flutter_test_noti/internal/navbar/_setting/otp2-2.dart';
import 'package:flutter_test_noti/internal/navbar/menu_setting.dart';
import 'package:flutter_test_noti/internal/provice/telModel.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;


class Ctel extends StatefulWidget {
  Ctel({Key? key}) : super(key: key);

  @override
  State<Ctel> createState() => _CtelState();
}

class _CtelState extends State<Ctel> {
  final personal = GlobalKey<FormState>();

  TextEditingController Tel = new TextEditingController();
  Widget tel() => TextFormField(
      validator: (value) {
          if(value==null||value.isEmpty){
              return "กรุณาใส่เบอร์โทรศัพท์";
          }else{
            if(value[0]=="0" && value.length==10){
              return null;
            }else{
              return "รูปแบบเบอร์โทรศัพท์ผิด";
            }
          }
          
      },
      controller: Tel,
      decoration: InputDecoration(
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
          ),
          labelText: 'เบอร์โทรศัพท์',
          prefixIcon: Icon(Icons.person),
          contentPadding: EdgeInsets.symmetric(vertical: 15.0),
      ),
      maxLength: 10,
      keyboardType: TextInputType.number,
      inputFormatters: <TextInputFormatter>[
   // for below version 2 use this
      FilteringTextInputFormatter.allow(RegExp(r'[0-9]+[0-9]*'))],
      
      
  );

  @override
  Widget build(BuildContext context) {
     return WillPopScope(child: 
    Scaffold(
        appBar: AppBar(
          title: const Text("เปลี่ยนเบอร์โทรศัพท์"),
        ),
        body: Form(
          autovalidateMode: AutovalidateMode.disabled,
          key: personal,
          child: ListView(
          padding: EdgeInsets.all(32),   
                  children: [
                    const SizedBox(height: 10,),
                    tel(),
                    const SizedBox(height: 10,),
                    ElevatedButton(onPressed: (){
                        if(personal.currentState!.validate()){
                              _fetchData(context);
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
              title: const Text('คุณแน่ใจหรือไม่ที่จะออกจากการแก้ไขเบอร์โทรศัพท์'),
              actionsAlignment: MainAxisAlignment.spaceBetween,
              actions: [
                TextButton(
                  onPressed: () {
                    //Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>menuSetting()), (Route<dynamic> route) => false);
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
    //await Future.delayed(const Duration(seconds: 2));
    //Navigator.of(context).push(MaterialPageRoute(builder: (context)=> Otp2_2(Tel.text)));
    try{
      final url = Uri.parse('http://apbcm.ddns.net:5000/api/getUserbyTel?Tel='+Tel.text);
      http.Response response = await http.get(url);

      if(response.statusCode==200){
        Navigator.of(context).pop();
        if(response.body=="null"){
          Navigator.of(context).push(MaterialPageRoute(builder: (context)=> Otp2_2(Tel.text)));
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
        }
        //Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>Homepage(context.read<getTal>().Tel)), (Route<dynamic> route) => false);
      }else{
        print("error-sent");
      }
  } catch(e){
      print("Error-timeout");
  }

    // Close the dialog programmatically
    //Navigator.of(context).pop();
  }

  /*Future sendData() async{
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
        Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>Homepage(context.read<getTal>().Tel)), (Route<dynamic> route) => false);
      }else{
        print("error-sent");
      }
  } catch(e){
      print("Error-timeout");
  }
  }*/
}