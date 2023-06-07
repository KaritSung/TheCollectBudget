import 'package:flutter/material.dart';
import 'package:flutter_test_noti/internal/provice/telModel.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:path/path.dart';
import 'dart:io';

import 'package:provider/provider.dart';

class Report extends StatefulWidget {
  Report({Key? key}) : super(key: key);

  @override
  State<Report> createState() => _ReportState();
}

class _ReportState extends State<Report> {
  final form = GlobalKey<FormState>();
  TextEditingController detail = new TextEditingController();
  String ?valdrow;
  firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;
  File? _photo;
  final ImagePicker _picker = ImagePicker();


  @override
  void initState() {
    super.initState();
    
  }
  @override
  void dispose() {
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
                  
                  appBar: AppBar(
                    
                  title: Text("รายงานปัญหา",style: TextStyle(color: Color.fromARGB(255, 255, 255, 255))),
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
                body: ListView(
                  children: [
                    Form(
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    key: form,
                    child: Column(children: [
                       Padding(padding: EdgeInsets.only(
                    top: 32.0, bottom: 10.0, left: 32.0, right: 32.0),
                     child:dropdown(),
                    ),
                    Padding(padding: EdgeInsets.only(
                    top: 32.0, bottom: 10.0, left: 32.0, right: 32.0),
                     child:textbox()
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
                     child:ElevatedButton(onPressed: (){
              
                        if(form.currentState!.validate()){
                            _fetchData(context);
                          
                        }                     
                    }, child:Text("ยืนยันการแจ้งปัญหา")),
                    ),
                   
                ],)
    );
  }
  List<Map> _mystatus = [
  {
      'id':'การแลกเงิน'
  },
  {
      'id':'การแลกขวดพลาสติก'
  },
  {
      'id':'เครื่องขัดข้อง'
  },
  
];
Widget dropdown() => DropdownButtonFormField<String>(
    
  validator: ((value) {
      if(value==null || value.isEmpty){
          return 'กรุณาเลือกหัวข้อการแจ้งปัญหา';
        }else{
          return null;
        }
      }
  ),    
         decoration: InputDecoration(
          labelText: 'หัวข้อการแจ้งปัญหา',
         prefixIcon: Icon(Icons.warning_amber, color: Color.fromARGB(255, 216, 4, 36),),
         ),
         
         hint: Text('เลือกหัวข้อการแจ้งปัญหา'),
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

       valdrow =  val;
       

     },
);
Widget textbox() => TextFormField(
      validator: (value) {
          if(value==null||value.isEmpty){
              return "กรุณาใส่เนื้อหาการแจ้งปัญหา";
          }else{
            return null;
          }
          
      },
      minLines: 4, // any number you need (It works as the rows for the textarea)
       keyboardType: TextInputType.multiline,
      maxLines: null,
      controller: detail,
      decoration: InputDecoration(
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
          ),
          labelText: 'เนื้อหาการแจ้งปัญหา',
          prefixIcon: Icon(Icons.description_outlined),
          contentPadding: EdgeInsets.symmetric(vertical: 15.0),
      ));


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
                  new ListTile(
                    leading: new Icon(Icons.photo_camera),
                    title: new Text('Camera'),
                    onTap: () {
                     imgFromCamera(context);
                    },
                  ),
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
    final destination = 'report';
    
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
        try{
                  
                  var response = await http.post(
                  Uri.parse("http://apbcm.ddns.net:5000/api/putReport"),
                  body: {
                      "tel":context.read<getTal>().Tel,
                      "topic": valdrow.toString(),
                      "body":detail.text,
                      "pic":"0",

                  }
                
              );

              if(response.statusCode==200){
                  var info = await json.decode(response.body);
                  await uploadFile(info['id']);
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              }
        }catch(e){
          print(e);
        }

    }else{
        try{
                  var response = await http.post(
                  Uri.parse("http://apbcm.ddns.net:5000/api/putReport"),
                  body: {
                      "tel":context.read<getTal>().Tel,
                      "topic": valdrow.toString(),
                      "body":detail.text,
                      "pic":"1",
                      
                  }
                
              );

              if(response.statusCode==200){
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              }
        }catch(e){
          print(e);
        }
    }

  }
}