import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
class SetPrice extends StatefulWidget {
  SetPrice({Key? key}) : super(key: key);

  @override
  State<SetPrice> createState() => _SetPriceState();
}

class _SetPriceState extends State<SetPrice> {
  bool data = true;
  final form = GlobalKey<FormState>();
  final focusNode = FocusNode();
  TextEditingController InputS = new TextEditingController();
  final focusNodeM = FocusNode();
  TextEditingController InputM = new TextEditingController();
  final focusNodeL = FocusNode();
  TextEditingController InputL = new TextEditingController();
  @override
  void initState() {
    reload();
    super.initState();
    
  }
  
  Future reload() async {
   try{
     final url = Uri.parse('http://apbcm.ddns.net:5000/api/getPrice');
     http.Response response = await http.get(url);
      
      if(response.statusCode==200){
        print("getP");
        var price = json.decode(response.body);
        setState(() {
          data = false;
           InputS.text = price['sizeS']['item_Price'].toStringAsFixed(3);
          InputM.text = price['sizeM']['item_Price'].toStringAsFixed(3);
          InputL.text = price['sizeL']['item_Price'].toStringAsFixed(3);
        });
        return 0;
      }else{
        return null;
      }
   }catch(e){
      print(e);
      return null;
   }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("กำหนดราคาขวดพลาสติก",
              style: TextStyle(color: Color.fromARGB(255, 255, 255, 255))),
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.arrow_back,
              color: Color.fromARGB(255, 255, 255, 255),
            ),
          ),
          centerTitle: true,
          backgroundColor: Color.fromARGB(255, 47, 114, 185),
        ),
        body: data == true
            ? Center(child: CircularProgressIndicator())
            : RefreshIndicator(
                onRefresh: reload,
                child: Form(
                      autovalidateMode: AutovalidateMode.disabled,
                      key: form,
                      child: ListView(
                      padding: EdgeInsets.all(32),
                      children: [
                        inputboxS(),
                         SizedBox(height: 20,),
                        inputboxM(),
                        SizedBox(height: 20,),
                        inputboxL(),
                        SizedBox(height: 20,),
                        Text('*หมายเหตุ การกำหนดราคาขวดพลาสติกต้องมี    จำนวน มากกว่าเท่ากับ 0.001 บาท และ น้อยกว่าเท่ากับ 100 บาท / ขวด',style: TextStyle(color: Color.fromARGB(133, 73, 72, 72), fontSize: 15.0)),
                        Container(
                        padding: EdgeInsets.only(
                    top: 15.0, bottom: 20.0, left: 60.0, right: 60.0),
                        child: ElevatedButton(onPressed: (){
              
                        if(form.currentState!.validate()) {
                             var val =  double.parse(InputS.text);
                            InputS.text = val.toStringAsFixed(3);
                            var val2 =  double.parse(InputM.text);
                            InputM.text = val2.toStringAsFixed(3);
                            var val3 =  double.parse(InputL.text);
                            InputL.text = val3.toStringAsFixed(3);
 //                            Future.delayed(const Duration(seconds: 2));
                            _fetchData(context);
                        }                     
                    }, child:Center(child:  Row(children: [
                        Icon(Icons.save_as_sharp),
                        SizedBox(width: 10,),
                        Text("บันทึกการแก้ไขราคา")
                    ],))
                    )
                      ),
                      ],

                ),
              )));
  }
  Widget inputboxS() => TextFormField(
      validator: (value) {
          if(value==null||value.isEmpty){
              return "กรุณาใส่จำนวนเงิน";
          }else{
              var val =  double.parse(value);
              if(val>=0.001 && val <= 100){
                  if(val>double.parse(value)){
                    return 'รูปแบบ หรือ จำนวนเงินไม่ถูกต้อง';
                  }else{
                    return null;
                  }
              }else{
                  return 'รูปแบบ หรือ จำนวนเงินไม่ถูกต้อง';
              }
          }
          
      },
      style: TextStyle(fontSize: 15),
      focusNode: focusNode,
      controller: InputS,
      decoration: InputDecoration(
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
          ),
          labelText: 'ราคาขวดขนาดเล็ก',
          prefixIcon: Icon(Icons.monetization_on),
          contentPadding: EdgeInsets.only(
                    top: 15.0, bottom: 15.0, left: 10.0, right: 10.0)
          
          
      ),
      keyboardType: TextInputType.number, 
      textAlign: TextAlign.start,
      inputFormatters: <TextInputFormatter>[
   // for below version 2 use this
      FilteringTextInputFormatter.allow(RegExp(r'^(\d+)\.?\d{0,3}')), 

  ],
      onEditingComplete: (){
        FocusScope.of(context).unfocus();
          try {
            setState(() {
              var val =  double.parse(InputS.text);
              InputS.text = val.toStringAsFixed(3);
            });
          } catch (e) {
            print('fied-ex-null');
          }
      },
      
  );

  Widget inputboxM() => TextFormField(
      validator: (value) {
          if(value==null||value.isEmpty){
              return "กรุณาใส่จำนวนเงิน";
          }else{
              var val =  double.parse(value);
              if(val>=0.001 && val <= 100){
                  if(val>double.parse(value)){
                    return 'รูปแบบ หรือ จำนวนเงินไม่ถูกต้อง';
                  }else{
                    return null;
                  }
              }else{
                  return 'รูปแบบ หรือ จำนวนเงินไม่ถูกต้อง';
              }
          }
          
      },
      style: TextStyle(fontSize: 15),
      focusNode: focusNodeM,
      controller: InputM,
      decoration: InputDecoration(
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
          ),
          labelText: 'ราคาขวดขนาดกลาง',
          prefixIcon: Icon(Icons.monetization_on),
          contentPadding: EdgeInsets.only(
                    top: 15.0, bottom: 15.0, left: 10.0, right: 10.0)
          
          
      ),
      keyboardType: TextInputType.number, 
      textAlign: TextAlign.start,
      inputFormatters: <TextInputFormatter>[
   // for below version 2 use this
      FilteringTextInputFormatter.allow(RegExp(r'^(\d+)\.?\d{0,3}')), 

  ],
      onEditingComplete: (){
        FocusScope.of(context).unfocus();
          try {
            setState(() {
              var val =  double.parse(InputM.text);
              InputM.text = val.toStringAsFixed(3);
            });
          } catch (e) {
            print('fied-ex-null');
          }
      },
      
  );

  Widget inputboxL() => TextFormField(
      validator: (value) {
          if(value==null||value.isEmpty){
              return "กรุณาใส่จำนวนเงิน";
          }else{
              var val =  double.parse(value);
              if(val>=0.001 && val <= 100){
                  if(val>double.parse(value)){
                    return 'รูปแบบ หรือ จำนวนเงินไม่ถูกต้อง';
                  }else{
                    return null;
                  }
              }else{
                  return 'รูปแบบ หรือ จำนวนเงินไม่ถูกต้อง';
              }
          }
          
      },
      style: TextStyle(fontSize: 15),
      focusNode: focusNodeL,
      controller: InputL,
      decoration: InputDecoration(
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
          ),
          labelText: 'ราคาขวดขนาดใหญ่',
          prefixIcon: Icon(Icons.monetization_on),
          contentPadding: EdgeInsets.only(
                    top: 15.0, bottom: 15.0, left: 10.0, right: 10.0)
          
          
      ),
      keyboardType: TextInputType.number, 
      textAlign: TextAlign.start,
      inputFormatters: <TextInputFormatter>[
   // for below version 2 use this
      FilteringTextInputFormatter.allow(RegExp(r'^(\d+)\.?\d{0,3}')), 

  ],
      onEditingComplete: (){
        FocusScope.of(context).unfocus();
          try {
            setState(() {
              var val =  double.parse(InputL.text);
              InputL.text = val.toStringAsFixed(3);
            });
          } catch (e) {
            print('fied-ex-null');
          }
      },
      
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
    await Future.delayed(const Duration(seconds: 2));
    try{
      var response = await http.post(
          Uri.parse("http://apbcm.ddns.net:5000/api/updatePrice"),
          body: {
            "S":InputS.text,
            "M":InputM.text,
            "L":InputL.text,
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
      print(e);
  }

  }
}
