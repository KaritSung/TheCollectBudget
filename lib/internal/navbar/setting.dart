import 'package:flutter/material.dart';
import 'dart:io';
import 'package:flutter_test_noti/internal/homepage.dart';
import 'package:flutter_test_noti/internal/navbar/_setting/change%20personal.dart';
import 'package:flutter_test_noti/internal/navbar/_setting/change_pass.dart';
import 'package:flutter_test_noti/internal/navbar/_setting/otp1.dart';
import 'package:flutter_test_noti/internal/navbar/_setting/otp2-1.dart';
import 'package:flutter_test_noti/internal/navbar/_setting/otp3.dart';
import 'package:flutter_test_noti/internal/navbar/menu_setting.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' ;
import 'package:path/path.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:provider/provider.dart';
import 'package:flutter_test_noti/internal/provice/telModel.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
class setting extends StatefulWidget {
  @override
  State<setting> createState() => _settingState();
}

class _settingState extends State<setting> {
  


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
          'ข้อมูลส่วนตัว',
          style: TextStyle(color: Color.fromARGB(255, 255, 254, 254)),
        ),
      ),
      body: Container(
        
        child:Padding(
          padding: EdgeInsets.all(10.0),
          child: Center(child:  Column(
          
          children: [
            SizedBox(
              height: 115,
              width: 115,
              child: Stack(
                clipBehavior: Clip.none,
                fit: StackFit.expand,
                children: [
                  FutureBuilder(
                    future: loaddata(),
                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                      if (snapshot != null) {
                        if (snapshot.connectionState == ConnectionState.done) {
                          return SizedBox(
                            height: 115,
                            width: 115,
                            child: Stack(
                              clipBehavior: Clip.none,
                              fit: StackFit.expand,
                              children: [
                                CircleAvatar(
                                  backgroundImage: 
                                  NetworkImage(snapshot.data.toString()),
                                ),
                                Positioned(
                                    bottom: 0,
                                    right: -25,
                                    child: RawMaterialButton(
                                      onPressed: () {
                                        _showPicker(context);
                                      },
                                      elevation: 2.0,
                                      fillColor: Color(0xFFF5F6F9),
                                      child: Icon(
                                        Icons.camera_alt_outlined,
                                        color: Colors.blue,
                                      ),
                                      padding: EdgeInsets.all(15.0),
                                      shape: CircleBorder(),
                                    )),
                              ],
                            ),
                          ); //Image.network(snapshot.data.toString());
                        } else {
                          return SizedBox(
                            height: 115,
                            width: 115,
                            child: Stack(
                              clipBehavior: Clip.none,
                              fit: StackFit.expand,
                              children: [
                                CircleAvatar(
                                  backgroundImage: 
                                  AssetImage("assets/images/login/user.png"),
                                ),
                                Positioned(
                                    bottom: 0,
                                    right: -25,
                                    child: RawMaterialButton(
                                      onPressed: () {

                                      },
                                      elevation: 2.0,
                                      fillColor: Color(0xFFF5F6F9),
                                      child: Icon(
                                        Icons.camera_alt_outlined,
                                        color: Colors.blue,
                                      ),
                                      padding: EdgeInsets.all(15.0),
                                      shape: CircleBorder(),
                                    )),
                              ],
                            ),
                          );
                        }
                      } else {
                        return SizedBox(
                            height: 115,
                            width: 115,
                            child: Stack(
                              clipBehavior: Clip.none,
                              fit: StackFit.expand,
                              children: [
                                CircleAvatar(
                                  backgroundImage: 
                                  AssetImage("assets/images/login/user.png"),
                                ),
                                Positioned(
                                    bottom: 0,
                                    right: -25,
                                    child: RawMaterialButton(
                                      onPressed: () {},
                                      elevation: 2.0,
                                      fillColor: Color(0xFFF5F6F9),
                                      child: Icon(
                                        Icons.camera_alt_outlined,
                                        color: Colors.blue,
                                      ),
                                      padding: EdgeInsets.all(15.0),
                                      shape: CircleBorder(),
                                    )),
                              ],
                            ),
                          );
                      }
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30,),
            Divider(),
            ListTile(
                  leading: Icon(Icons.person),
                  trailing: Icon(Icons.keyboard_arrow_right),
                  title: Text('ตั้งค่าบัญชี ',style: TextStyle(color: Color.fromARGB(255, 0, 0, 0), fontSize: 15.0)),
                  onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(builder: (context)=> Otp1()));
                     // Navigator.of(context).push(MaterialPageRoute(builder: (context)=> Cpass()));
                  },
                ),
            Divider(),
            /*ListTile(
                  leading: Icon(Icons.phone_android),
                  trailing: Icon(Icons.keyboard_arrow_right),
                  title: Text('เปลี่ยนเบอร์โทรศัพท์ ',style: TextStyle(color: Color.fromARGB(255, 0, 0, 0), fontSize: 15.0)),
                  onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(builder: (context)=> Otp2_1()));
                  },
                ),
                Divider(),
            ListTile(
                  leading: Icon(Icons.person),
                  trailing: Icon(Icons.keyboard_arrow_right),
                  title: Text('เปลี่ยนข้อมูลส่วนตัว',style: TextStyle(color: Color.fromARGB(255, 0, 0, 0), fontSize: 15.0)),
                  onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(builder: (context)=> Otp1())); // main
                     // Navigator.of(context).push(MaterialPageRoute(builder: (context)=> Personal()));

                  },
                ),
            Divider(),*/
          ],
        ),
      ),
    )));

  



  





  }

}





        