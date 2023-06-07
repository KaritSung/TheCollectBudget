import 'dart:ffi';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_test_noti/admin/navbar/editpromotion.dart';
import 'package:flutter_test_noti/internal/provice/telModel.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:path/path.dart';
import 'dart:io';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:expansion_tile_card/expansion_tile_card.dart';
import 'package:fluttertoast/fluttertoast.dart';

class EditPromotion extends StatefulWidget {
  EditPromotion({Key? key}) : super(key: key);

  @override
  State<EditPromotion> createState() => _EditPromotionState();
}


class _EditPromotionState extends State<EditPromotion> {
    @override
  void dispose() {
    
    super.dispose();
  }
  Future load()async{
    
      final url = Uri.parse('http://apbcm.ddns.net:5000/api/getPromotion');
      http.Response response = await http.get(url);
      if(response.statusCode==200){
        var info = json.decode(response.body);
        final ref = FirebaseStorage.instance.ref("promotion").child(info['man_Pic'].toString()+".jpg");
        pic_promo = await ref.getDownloadURL();
        id_pic = info['man_Pic'].toString();
        InputS.text = info['man_Bottle'].toString();
        multi.text = info['man_Multiply'].toStringAsFixed(1);
        dateS.text = info['man_Start'].toString();
        dateSSet = info['man_Start'].toString();
        dateE.text = info['man_End'].toString();
        dtest = dateSSet.toString()+' 00:00:00.000';
      }
  }
  Future loadData()async{
    
  try{
      final url = Uri.parse('http://apbcm.ddns.net:5000/api/getPromotion');
      http.Response response = await http.get(url);
      if(response.statusCode==200){
          if(response.body=="null"){
              setState(() {
                Topic = "กำหนดโปรโมชั่น";
              });
              return "null";
          }else{
             var jsonData = json.decode(response.body);
            setState(() {
                Topic = "โปรโมชั่นที่ดำเนินการ";
             });
             promoData = jsonData;
            
              return jsonData;
          }
      }else{
        setState(() {
                Topic = "กำหนดโปรโมชั่น";
              });
        return null;
      }
  }catch(e){
    print(e);
    return null;
  }


}

  void initState() {
    load();

  super.initState();
  
}
 Widget inputboxS() => TextFormField(
      validator: (value) {
          if(value==null||value.isEmpty){
              return "กรุณาใส่จำนวนขวด";
          }else{
              var val =  double.parse(value);
              if(val>=1 && val <= 100){
                  if(val>double.parse(value)){
                    return 'รูปแบบไม่ถูกต้อง หรือ จำนวนขวดเกิน 100 ขวด';
                  }else{
                    return null;
                  }
              }else{
                  return 'รูปแบบไม่ถูกต้อง หรือ จำนวนขวดเกิน 100 ขวด';
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
          labelText: 'จำนวนขวดโปรโมชัน',
          prefixIcon: Icon(Icons.monetization_on),
          contentPadding: EdgeInsets.only(
                    top: 15.0, bottom: 15.0, left: 10.0, right: 10.0)
          
          
      ),
      keyboardType: TextInputType.number, 
      textAlign: TextAlign.start,
      maxLength: 3,
      inputFormatters: <TextInputFormatter>[
   // for below version 2 use this
      FilteringTextInputFormatter.allow(RegExp(r'[0-9]')), 

  ],
      
      
  );

  Widget inputboxmulti() => TextFormField(
      validator: (value) {
          if(value==null||value.isEmpty){
              return "กรุณาใส่ตัวคูณโปรโมชั่น";
              
          }else{
              var val =  double.parse(value);
              if(val>1 && val <= 3){
                  if(val>double.parse(value)){
                    return 'จำนวนตัวคูณไม่เกิน x3.0';
                  }else{
                    return null;
                  }
              }else{
                  return 'จำนวนตัวคูณไม่เกิน x3.0';
              }
              
          }
          
      },
      style: TextStyle(fontSize: 15),
      focusNode: focusNode2,
      controller: multi,
      decoration: InputDecoration(
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
          ),
          labelText: 'ตัวคูณโปรโมชั่น',
          prefixIcon: Icon(Icons.monetization_on),
          contentPadding: EdgeInsets.only(
                    top: 15.0, bottom: 15.0, left: 10.0, right: 10.0)
          
          
      ),
      maxLength: 3,
      keyboardType: TextInputType.number, 
      textAlign: TextAlign.start,
      inputFormatters: <TextInputFormatter>[
   // for below version 2 use this
      FilteringTextInputFormatter.allow(RegExp(r'[0-9]+[.]{0,1}[0-9]*')), 

  ],
      
      
  );
  String ?pic_promo;
  final focusNode = FocusNode();
  final focusNode2 = FocusNode();
  final GlobalKey<ExpansionTileCardState> cardA = new GlobalKey();
  TextEditingController InputS = new TextEditingController();
  TextEditingController multi = new TextEditingController();
  TextEditingController dateS = new TextEditingController();
  TextEditingController dateE = new TextEditingController();
  final form = GlobalKey<FormState>();
  var date = new DateTime.now();
  var dateStart ;
  var dateEnd ;
  var promoData;
  var dateSSet;
  var dtest;
  var id_pic;
  bool ena = false;
  String Topic = "";
  TextEditingController detail = new TextEditingController();
  String ?valdrow;
  
  File? _photo;
  final ImagePicker _picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    Widget dates() => TextFormField(
      validator: (value) {
          if(value==null||value.isEmpty){
              return "กรุณาใส่วันที่เริ่มต้นโปรโมชั่น";
              
          }else{
              return null;
              
          }
          
      },
      style: TextStyle(fontSize: 15),
      readOnly: true,

      controller: dateS,
      decoration: InputDecoration(
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
          ),
          labelText: 'วันที่เริ่มต้นโปรโมชั่น',
          prefixIcon: Icon(Icons.date_range),
          contentPadding: EdgeInsets.only(
                    top: 15.0, bottom: 15.0, left: 10.0, right: 10.0)
          
          
      ),
      textAlign: TextAlign.start,
      onTap: ()async{ 
        ena = false;
        dateE.text="";
        dateS.text="";
                               dateStart = await showDatePicker(
                                        context: context,
                                        initialDate: date,
                                        firstDate: new DateTime.now(),
                                        lastDate: DateTime(2100)
                                      );
                                      if(dateStart!=null){
                                        
                                        print(dateStart);
                                        ena = true;
                                        setState(() {
                                          
                                        });
                                        //String dtest = dateSSet.toString()+' 00:00:00.000';
                                        //DateTime dt = DateTime.parse(dtest);
                                        //print(dtest);
                                        String formattedDate = DateFormat('yyyy-MM-dd').format(dateStart);
                                        dateS.text=formattedDate.toString();
                                        dtest = formattedDate.toString();
                                      }
      },
  );
   Widget datee() => TextFormField(
      validator: (value) {
          if(value==null||value.isEmpty){
              return "กรุณาใส่วันที่สิ้นสุดโปรโมชั่น";
              
          }else{
              return null;
              
          }
          
      },
      style: TextStyle(fontSize: 15),
      readOnly: true,

      controller: dateE,
      decoration: InputDecoration(
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
          ),
          labelText: 'วันที่สิ้นสุดโปรโมชั่น',
          prefixIcon: Icon(Icons.date_range),
          contentPadding: EdgeInsets.only(
                    top: 15.0, bottom: 15.0, left: 10.0, right: 10.0)
          
          
      ),
      textAlign: TextAlign.start,
      enabled: true,
      onTap: ()async{ 
                               dateEnd = await showDatePicker(
                                        context: context,
                                        initialDate: DateTime.parse(dtest),
                                        firstDate: DateTime.parse(dtest),
                                        lastDate: DateTime(2100)
                                      );
                                      if(dateEnd!=null){
                                        print(dateEnd);
                                        String formattedDate = DateFormat('yyyy-MM-dd').format(dateEnd);
                                        dateE.text=formattedDate.toString();
                                      }
      },
  );


    return Scaffold(
      appBar: AppBar(
        title: Text("แก้ไขโปรโมชั่น",style: TextStyle(color: Color.fromARGB(255, 255, 255, 255))),
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
      body: FutureBuilder(
                  future: loadData(),
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    if(snapshot.data!=null && pic_promo!=null){
                     
                        


                          return ListView(
                                children: [
                                  Form(
                                  autovalidateMode: AutovalidateMode.onUserInteraction,
                                  key: form,
                                  child: Column(children: [
                                    Padding(padding: EdgeInsets.only(
                                  top: 32.0, bottom: 10.0, left: 32.0, right: 32.0),
                                  child:inputboxS(),
                                  ),
                                  Padding(padding: EdgeInsets.only(
                                  top: 25.0, bottom: 10.0, left: 32.0, right: 32.0),
                                  child:inputboxmulti()
                                  ),
                                  Padding(padding: EdgeInsets.only(
                                  top: 25.0, bottom: 10.0, left: 32.0, right: 32.0),
                                  child: dates()
                                  ),
                                  Padding(padding: EdgeInsets.only(
                                  top: 25.0, bottom: 10.0, left: 32.0, right: 32.0),
                                  child: datee()
                                  ),
                                  
                                  ],)
                                  
                                  ),
                                _photo != null ? 
                                Padding(padding: EdgeInsets.only(
                                  top: 10.0, bottom: 10.0, left: 10.0, right: 10.0),

                                  child:Column(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    //mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Image.file(_photo!,width: 300,height: 300,),
                                      ElevatedButton(onPressed: (){
                                          _showPicker(context); 
                                      }, child: Text("แก้ไขรูปภาพ"))
                                  ],)
                                  
                                  )
                                :
                                
                                Padding(padding: EdgeInsets.only(
                                  top: 10.0, bottom: 10.0, left: 10.0, right: 10.0),

                                  child:Column(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    //mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Image.network(pic_promo.toString(),width: 300,height: 200,),
                                      ElevatedButton(onPressed: (){
                                          _showPicker(context); 
                                      }, child: Text("แก้ไขรูปภาพ"))
                                  ],)
                                  
                                  ),
                                Padding(padding: EdgeInsets.only(
                                  top: 5.0, bottom: 10.0, left: 32.0, right: 32.0),
                                  child: Text("*หมายเหตุ รูปภาพโปรโมชั่นควรมีขนาด 917 x 315 pixels",style: TextStyle(color: Color.fromARGB(255, 101, 98, 98),fontSize: 14))),
                                Padding(padding: EdgeInsets.only(
                                  top: 5.0, bottom: 10.0, left: 32.0, right: 32.0),
                                  child:ElevatedButton(onPressed: (){
           
                                      if(form.currentState!.validate()){
                                        
                                            _fetchData(context);  
                                            
                                          
                                          
                                      }                     
                                  }, child:Text("บันทึกการแก้ไขข้อมูล")),
                                  ),
                                
                              ],);
                      
                    }else{
                          
                        return Center(child: CircularProgressIndicator(),);
                    }
                  },
                ));

    
  }
  void _showPicker(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Container(
              child: new Wrap(
                children: <Widget>[
                  new ListTile(
                      leading: new Icon(Icons.photo_library),
                      title: new Text('Gallery'),
                      onTap: () {
                        imgFromGallery(context);
                      }),
                ],
              ),
            ),
          );
        });    

}
Future uploadFile(var id) async {
    print("uploadFile");
    if (_photo == null) return;
    final fileName = basename(_photo!.path);
    final destination = 'promotion';
    
    try {
        final ref = firebase_storage.FirebaseStorage.instance
          .ref(destination)
          .child(id.toString()+".jpg");
        await ref.putFile(_photo!);
        setState(() {
          
        });

    } catch (e) {
      print('error occured');
    }
  }

Future imgFromGallery(context) async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    Navigator.of(context).pop();
    setState(() {
      if (pickedFile != null) {
        _photo = File(pickedFile.path);
        
      } else {
        print('No image selected.');
      }
    });
  }
  Future imgFromCamera(context) async {
    final pickedFile = await _picker.pickImage(source: ImageSource.camera);
    Navigator.of(context).pop();
    setState(() {
      if (pickedFile != null) {
        _photo = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
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
    //await Future.delayed(const Duration(seconds: 2));

    // Close the dialog programmatically
    //Navigator.of(context).pop();
    if(_photo != null){
      print("sent-data");
        try{
                  
                  var response = await http.post(
                  Uri.parse("http://apbcm.ddns.net:5000/api/updatePromotion"),
                  body: {
                      "bottle": InputS.text.toString(),
                      "multiply":multi.text,
                      "start":dateS.text,
                      "end":dateE.text
                  }
                
              );

              if(response.statusCode==200){
                  
                  await uploadFile(id_pic);
                  _photo = null;
                  InputS.clear();
                  multi.clear();
                  dateS.clear();
                  dateE.clear();
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              }
        }catch(e){
          print(e);
        }

    }else{
      try {
          var response = await http.post(
                  Uri.parse("http://apbcm.ddns.net:5000/api/updatePromotion"),
                  body: {
                      "bottle": InputS.text.toString(),
                      "multiply":multi.text,
                      "start":dateS.text,
                      "end":dateE.text
                  }
                
              );

              if(response.statusCode==200){
                  _photo = null;
                  InputS.clear();
                  multi.clear();
                  dateS.clear();
                  dateE.clear();
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              }
      } catch (e) {
        print(e);
      }
    }

  } 



}