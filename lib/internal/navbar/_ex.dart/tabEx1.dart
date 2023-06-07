import 'package:flutter/material.dart';
import 'package:flutter_test_noti/internal/navbar/_ex.dart/pin.dart';
import 'dart:convert';
import 'package:flutter_test_noti/internal/provice/telModel.dart';
import 'package:provider/provider.dart';
import 'package:flutter_test_noti/internal/homepage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/services.dart';
class Ex1 extends StatefulWidget {
  Ex1({Key? key}) : super(key: key);

  @override
  State<Ex1> createState() => _Ex1State();
}

class _Ex1State extends State<Ex1> {
String? priceS, priceM, priceL;
String name ="", lastName = "";
String money="";
String pin ="";
bool data = false;
final focusNode = FocusNode();
TextEditingController Input = new TextEditingController();
final page = GlobalKey<FormState>();
@override
  void initState() {
    reload();
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return data == true
            ? Center(child: CircularProgressIndicator())
            : RefreshIndicator(
                onRefresh: reload,
                child:
    Container(
                  child:Form(
                    autovalidateMode: AutovalidateMode.always,
                    key: page,
                    child: ListView(
                      //padding: EdgeInsets.all(32),
                    children: [
                      topArea(),
                      Container(
                        padding: EdgeInsets.all(32),
                        child: inputbox(),
                      ),
                      Container(
                        padding: EdgeInsets.only(
                    top: 15.0, bottom: 20.0, left: 60.0, right: 60.0),
                        child: ElevatedButton(onPressed: (){
              
                        if(page.currentState!.validate()){
                          var val =  double.parse(Input.text); 
                          Navigator.of(context).push(MaterialPageRoute(builder: (context)=> Pinpage(pin,val)));
                           setState(() {
                            Input.text = "";
                          });
                        }                     
                    }, child:Text("ยืนยัน")
                    )
                      ),
                      
                      
                    ],
                  )
                  )));
  }
  Future reload() async {
    setState(() {
      data = true;
    });
    print("reload");
    try {
      final url = Uri.parse('http://apbcm.ddns.net:5000/api/getPrice');
      http.Response response = await http.get(url);
      final url2 = Uri.parse('http://apbcm.ddns.net:5000/api/getUserbyTel?Tel='+context.read<getTal>().Tel);
      http.Response response2 = await http.get(url2);
      if (response.statusCode == 200 && response2.statusCode==200) {
        var price = json.decode(response.body);
        var user = json.decode(response2.body);
        setState(() {
          priceS = price['sizeS']['item_Price'].toString();
          priceM = price['sizeM']['item_Price'].toString();
          priceL = price['sizeL']['item_Price'].toString();
          pin = user['user_Password'];
          name = user['user_Firstname'];
          lastName = user['user_Lastname'];
          money = user['user_Money'].toStringAsFixed(3);
          data = false;
        });
      } else {
        print("error-req");
      }
    } catch (e) {
      print("error-req-catch");
      print(e);
    }
  }
  Card topArea() => Card(
        margin: EdgeInsets.all(10.0),
        elevation: 1.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Container(
            decoration: BoxDecoration(
                gradient: RadialGradient(
                    colors: [Color(0xFF015FFF), Color(0xFF015FFF)])),
            padding: EdgeInsets.all(5.0),
            // color: Color(0xFF015FFF),
            child: Column(
              children: <Widget>[
                 Text("คุณ "+name+" "+lastName,
                        style: TextStyle(color: Colors.white, fontSize: 25.0)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text("ยอดเงินสะสม(บาท)",
                        style: TextStyle(color: Colors.white, fontSize: 20.0)),
                  ],
                ),
                Center(
                  child: Padding(
                    padding: EdgeInsets.all(5.0),
                    child: Text(money.toString(),
                        style: TextStyle(color: Colors.white, fontSize: 24.0)),
                  ),
                ),
                SizedBox(height: 35.0),
              ],
            )),
      );


      Widget inputbox() => TextFormField(
      validator: (value) {
          if(value==null||value.isEmpty){
              return "กรุณาใส่จำนวนเงิน";
          }else{
              var val =  double.parse(value);
              if(val>double.parse(money)){
                 
                    return 'ยอดเงินของท่านไม่เพียงพอกับจำนวนนี้';
                  
                    
                  
              }else{
                   // 
                   if(val<0.01){
                       return 'รูปแบบจำนวนเงินไม่ถูกต้อง';
                   }else{
                    if(val>100){
                      return 'ไม่สามารถแลกเงินจำนวนเงินมากกว่า 100 บาทต่อครั้ง';
                    }else{
                       
                          return null;
                       
                      
                    }
                      
                   }
              }
              
              /*else if(val>100){
                  return 'ไม่สามารถแลกเงินจำนวนเงินมากกว่า 100 บาทต่อครั้ง';
              }else if(val<0.01){
                  return 'รูปแบบจำนวนเงินไม่ถูกต้อง';
              }else{
                  return 'ยอดเงินของท่านไม่เพียงพอกับจำนวนนี้';
              }*/
          }
          
      },
      style: TextStyle(fontSize: 20),
      focusNode: focusNode,
      controller: Input,
      decoration: InputDecoration(
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
          ),
          labelText: 'จำนวนเงินที่แลก',
          prefixIcon: Icon(Icons.monetization_on),
          contentPadding: EdgeInsets.only(
                    top: 20.0, bottom: 20.0, left: 10.0, right: 10.0)
          
          
      ),
      keyboardType: TextInputType.number, 
      maxLength: 10,
      textAlign: TextAlign.right,
      inputFormatters: <TextInputFormatter>[
   // for below version 2 use this
 FilteringTextInputFormatter.allow(RegExp(r'^([0-9]+)\.?\d{0,2}')), 

  ],
      onEditingComplete: (){
        FocusScope.of(context).unfocus();
          try {
            setState(() {
              var val =  double.parse(Input.text);
              Input.text = val.toStringAsFixed(2);
            });
          } catch (e) {
            print('fied-ex-null');
          }
      },
      
  );
}