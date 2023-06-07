import 'package:flutter/material.dart';
import 'package:flutter_test_noti/admin/report_list.dart';
import 'package:flutter_test_noti/admin/set_price.dart';
import 'package:flutter_test_noti/admin/userdata/confirmation%20history.dart';
import 'package:flutter_test_noti/admin/userdata/userdata.dart';
import 'package:flutter_test_noti/admin/userdata/userwit.dart';
import 'dart:io';
import 'package:flutter_test_noti/internal/homepage.dart';
import 'package:flutter_test_noti/internal/navbar/_setting/change%20personal.dart';
import 'package:flutter_test_noti/internal/navbar/_setting/change_pass.dart';
import 'package:flutter_test_noti/internal/navbar/_setting/otp1.dart';
import 'package:flutter_test_noti/internal/navbar/_setting/otp2-1.dart';
import 'package:flutter_test_noti/internal/navbar/_setting/otp3.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' ;
import 'package:path/path.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:provider/provider.dart';
import 'package:flutter_test_noti/internal/provice/telModel.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class Tool extends StatefulWidget {
  @override
  State<Tool> createState() => _ToolState();
}

class _ToolState extends State<Tool> {
  


  firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;

  File? _photo;
  final ImagePicker _picker = ImagePicker();
  
  @override
  Widget build(BuildContext context) {

Future loaddata() async {

  try{
      final url2 = Uri.parse('http://apbcm.ddns.net:5000/api/getUserbyTel?Tel='+context.read<getTal>().Tel);
      http.Response response2 = await http.get(url2);
      if(response2.statusCode==200){
          var user = json.decode(response2.body);
          final ref = FirebaseStorage.instance.ref("avarta").child(user['user_Avatar']);
          String url = await ref.getDownloadURL();
          return url;

      }else{
        print("Avarta-error");
        return null;
      }
  }catch(e){
    print("Avarta-error");
    return null;
  }
}

    Future uploadFile() async {
    print("uploadFile");
    if (_photo == null) return;
    final fileName = basename(_photo!.path);
    final destination = 'avarta';
    
    try {
      
      final url2 = Uri.parse('http://apbcm.ddns.net:5000/api/getUserbyTel?Tel='+context.read<getTal>().Tel);
      http.Response response2 = await http.get(url2);
      var user = json.decode(response2.body);
      var response = await http.post(
          Uri.parse("http://apbcm.ddns.net:5000/api/putAvatar"),
          body: {
            "user_Avatar" : user['_id'].toString()
          }
      );
      if(response.statusCode==200){
        print(response.body);
        final ref = firebase_storage.FirebaseStorage.instance
          .ref(destination)
          .child(user['_id'].toString()+".jpg");
        await ref.putFile(_photo!);
        setState(() {
          
        });
      }else{
        print("sent-error");
        print(response.statusCode);
      }

    } catch (e) {
      print('error occured');
    }
  }


Future imgFromGallery() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _photo = File(pickedFile.path);
        uploadFile();
      } else {
        print('No image selected.');
      }
    });
  }
  Future imgFromCamera() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.camera);

    setState(() {
      if (pickedFile != null) {
        _photo = File(pickedFile.path);
        uploadFile();
      } else {
        print('No image selected.');
      }
    });
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
                        imgFromGallery();
                        Navigator.of(context).pop();
                      }),
                  new ListTile(
                    leading: new Icon(Icons.photo_camera),
                    title: new Text('Camera'),
                    onTap: () {
                      imgFromCamera();
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
          );
        });    

}
    
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Color.fromARGB(255, 47, 114, 185),
        automaticallyImplyLeading: false,
        title: const Text(
          'การจัดการ',
          style: TextStyle(color: Color.fromARGB(255, 255, 254, 254)),
        ),
      ),
      body: Container(
        
        child:Padding(
          padding: EdgeInsets.all(10.0),
          child: Center(child:  Column(
          
          children: [
            
            //const SizedBox(height: 30,),
            Card(child: 
            ListTile(
                  leading: Icon(Icons.person_outline),
                  trailing: Icon(Icons.keyboard_arrow_right),
                  title: Text('ข้อมูลผู้ใช้งาน',style: TextStyle(color: Color.fromARGB(255, 0, 0, 0), fontSize: 15.0)),
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(builder: (context)=> Userdata()));
                  },
                ),),
                
            Card(child:
            ListTile(
                  leading: Icon(Icons.monetization_on_outlined),
                  trailing: Icon(Icons.keyboard_arrow_right),
                  title: Text('คำสั่งร้องขอการโอนเงิน ',style: TextStyle(color: Color.fromARGB(255, 0, 0, 0), fontSize: 15.0)),
                  onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(builder: (context)=> Userwit()));
                  },
                ),),
                Card(child:
            ListTile(
                  leading: Icon(Icons.manage_search),
                  trailing: Icon(Icons.keyboard_arrow_right),
                  title: Text('ประวัติยืนยันการโอนเงิน',style: TextStyle(color: Color.fromARGB(255, 0, 0, 0), fontSize: 15.0)),
                  onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(builder: (context)=> Confirmation_history()));
                  },
                ),),
               Card(child:
                ListTile(
                  leading: Icon(Icons.battery_std_sharp),
                  trailing: Icon(Icons.keyboard_arrow_right),
                  title: Text('กำหนดราคาขวดพลาสติก',style: TextStyle(color: Color.fromARGB(255, 0, 0, 0), fontSize: 15.0)),
                  onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(builder: (context)=> SetPrice()));

                  },
                ),),
            Card(child: 
            ListTile(
                  leading: Icon(Icons.report_problem_outlined),
                  trailing: Icon(Icons.keyboard_arrow_right),
                  title: Text('ผู้ใช้งานแจ้งปัญหา ',style: TextStyle(color: Color.fromARGB(255, 0, 0, 0), fontSize: 15.0)),
                  onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(builder: (context)=> ReportList()));
                  },
                ),),
              // Divider(color: Colors.black,),
           
          
          ],
        ),
      ),
    )));

  



  





  }

}





        