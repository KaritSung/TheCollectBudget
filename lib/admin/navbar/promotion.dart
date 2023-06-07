import 'dart:ffi';
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
class Promo extends StatefulWidget {
  Promo({Key? key}) : super(key: key);

  @override
  State<Promo> createState() => _PromoState();
}
@override





class _PromoState extends State<Promo> {
  @override
  void dispose() {
    
    super.dispose();
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
  bool ena = false;
  String Topic = "";
  TextEditingController detail = new TextEditingController();
  String ?valdrow;
  firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;
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
                                        String formattedDate = DateFormat('yyyy-MM-dd').format(dateStart);
                                        dateS.text=formattedDate.toString();
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
      enabled: ena,
      onTap: ()async{ 
                              
                               dateEnd = await showDatePicker(
                                        context: context,
                                        initialDate: dateStart,
                                        firstDate: dateStart,
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
                  automaticallyImplyLeading: false,
                  title: Text(Topic,style: TextStyle(color: Color.fromARGB(255, 255, 255, 255))),
                  centerTitle: true,
                  backgroundColor: Color.fromARGB(255, 47, 114, 185),
                ),
                body: FutureBuilder(
                  future: loadData(),
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    if(snapshot.data!=null){
                      if(snapshot.data=="null"){
                        
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
                                Card(
                                  child: InkWell(
                                    onTap: () {
                                      _showPicker(context);
                                    },

                                    child: Container(
                                    height: 200,
                                    padding: EdgeInsets.all(30.0),
                                    child: Column(children: [
                                      Icon(Icons.upload_file,size: 100.0,),
                                      Text("เลือกรูปภาพ",style: TextStyle(color: Color.fromARGB(255, 0, 0, 0),fontSize: 20)),
                                    ],)
                                
                                ),
                                  ) 
                                
                                ),
                                Padding(padding: EdgeInsets.only(
                                  top: 5.0, bottom: 10.0, left: 32.0, right: 32.0),
                                  child: Text("*หมายเหตุ รูปภาพโปรโมชั่นควรมีขนาด 917 x 315 pixels",style: TextStyle(color: Color.fromARGB(255, 101, 98, 98),fontSize: 14))),
                                Padding(padding: EdgeInsets.only(
                                  top: 5.0, bottom: 10.0, left: 32.0, right: 32.0),
                                  child:ElevatedButton(onPressed: (){
           
                                      if(form.currentState!.validate()){
                                        if(_photo != null){
                                            _fetchData(context);  
                                        }else{
                                            Fluttertoast.showToast(
                                          msg: "ไม่พบภาพโปรโมชั่นกรุณาใส่รูปภาพ",
                                          toastLength: Toast.LENGTH_LONG,
                                          gravity: ToastGravity.BOTTOM,
                                          timeInSecForIosWeb: 3,
                                          backgroundColor: Color.fromARGB(255, 244, 54, 67),
                                          textColor: Color.fromARGB(255, 255, 255, 255),
                                          fontSize: 16.0
                                      );
                                        }
                                          
                                          
                                      }                     
                                  }, child:Text("ยืนยัน")),
                                  ),
                                
                              ],);
                      }else{
                          
                          return ExpansionTileCard(
  baseColor: Colors.cyan[50],
  expandedColor: Colors.red[50],
  key: cardA,
  leading: CircleAvatar(
      child: Icon(Icons.campaign),),
      title: Text("โปรโมชั่น"),
      subtitle: Text("โปรโมชั่นสำหรับสมาชิกใหม่"),
     children: <Widget>[
    Divider(
      thickness: 1.0,
      height: 1.0,
    ),
    Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 16.0,
          vertical: 8.0,
        ),
        child: Text(
          'จำนวนขวด: '+snapshot.data['man_Bottle'].toString()+'\n'
          'ตัวคูณราคาขวด: x'+snapshot.data['man_Multiply'].toString()+'\n'
          'วันเริ่มต้นโปรโมชั่น: '+snapshot.data['man_RStart'].toString()+'\n'
          'วันสิ้นสุดโปรโมชั่น: '+snapshot.data['man_REnd'].toString()+'\n'
          
          
          ,
          style: Theme.of(context)
              .textTheme
              .bodyText2
              ?.copyWith(fontSize: 16),
        ),
        
      ),
    ),
    ButtonBar(
  alignment: MainAxisAlignment.spaceAround,
  buttonHeight: 52.0,
  buttonMinWidth: 90.0,
  children: <Widget>[
    FlatButton(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4.0)),
      onPressed: () {
        cardA.currentState?.collapse();
      },
      child: Column(
        children: <Widget>[
          Icon(Icons.arrow_upward),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 2.0),
          ),
          Text('ปิด'),
        ],
      ),
    ),
    FlatButton(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4.0)),
      onPressed: () async{
        await Navigator.of(context).push(MaterialPageRoute(builder: (context)=> EditPromotion()));
        setState(() {
           print('reloadPromo');
        });
      },
      child: Column(
        children: <Widget>[
          Icon(Icons.edit),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 2.0),
          ),
          Text('แก้ไขโปรโมชั่น'),
        ],
      ),
    ),
    FlatButton(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4.0)),
      onPressed: () {
        delPromotion(context);
      },
      child: Column(
        children: <Widget>[
          Icon(Icons.delete_forever),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 2.0),
          ),
          Text('ยกเลิกโปรโมชั่น'),
        ],
      ),
    ),
  ],
),
  ],
);
                      }
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
void delPromotion(BuildContext context) async {
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
    try {
      final url = Uri.parse('http://apbcm.ddns.net:5000/api/delPromotion');
      http.Response response = await http.get(url);
       
      if(response.statusCode==200){
       
        final ref = firebase_storage.FirebaseStorage.instance
          .ref('promotion')
          .child(promoData['man_Pic'].toString()+".jpg");
        await ref.delete();
        setState(() {
          
        });
          Navigator.of(context).pop();
      }
    } catch (e) {
      print(e);
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
    //await Future.delayed(const Duration(seconds: 2));

    // Close the dialog programmatically
    //Navigator.of(context).pop();
    if(_photo != null){
      print("sent-data");
        try{
                  
                  var response = await http.post(
                  Uri.parse("http://apbcm.ddns.net:5000/api/insertPromotion"),
                  body: {
                      "bottle": InputS.text.toString(),
                      "multiply":multi.text,
                      "start":dateS.text,
                      "end":dateE.text
                  }
                
              );

              if(response.statusCode==200){
                  var info = await json.decode(response.body);
                  await uploadFile(info['id']);
                  _photo = null;
                  InputS.clear();
                  multi.clear();
                  dateS.clear();
                  dateE.clear();
                Navigator.of(context).pop();
              }
        }catch(e){
          print(e);
        }

    }else{
        
    }

  } 
    
  }

