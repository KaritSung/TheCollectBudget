import 'package:flutter/material.dart';
import 'package:flutter_test_noti/admin/userdata/edit.dart';
import 'package:flutter_test_noti/admin/userdata/ex_history.dart';
import 'package:flutter_test_noti/admin/userdata/user_promoView.dart';
import 'dart:io';
import 'package:flutter_test_noti/internal/homepage.dart';
import 'package:flutter_test_noti/internal/navbar/_setting/change%20personal.dart';
import 'package:flutter_test_noti/internal/navbar/_setting/change_pass.dart';
import 'package:flutter_test_noti/internal/navbar/_setting/otp1.dart';
import 'package:flutter_test_noti/internal/navbar/_setting/otp2-1.dart';
import 'package:flutter_test_noti/internal/navbar/_setting/otp3.dart';
import 'package:flutter_test_noti/pageOne.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' ;
import 'package:path/path.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:provider/provider.dart';
import 'package:flutter_test_noti/internal/provice/telModel.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
class Usertool extends StatefulWidget {
  Usertool({Key? key}) : super(key: key);
  @override
  State<Usertool> createState() => _UsertoolState();
}

class _UsertoolState extends State<Usertool> {
  
@override
void initState() {
  print("tool");
  super.initState();
  
}
@override
  void dispose() {
    print('dispose');
    super.dispose();
  }
  firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;

  File? _photo;
  final ImagePicker _picker = ImagePicker();
  String Fname ="";
  String Lname ="";
  String Roll = "";

  @override
  void didUpdateWidget(covariant Usertool oldWidget) {
    print("didUp");
    super.didUpdateWidget(oldWidget);
  }
  
  @override
  Widget build(BuildContext context) {
    
Future loaddataform() async {
  List<String> A ;
  try{
      final url2 = Uri.parse('http://apbcm.ddns.net:5000/api/getUserbyTel?Tel='+context.read<getTal>().user_tel);
      http.Response response2 = await http.get(url2);
      if(response2.statusCode==200){
          var user = json.decode(response2.body);
          
          A =[user['user_Firstname'],user['user_Lastname'],user['user_Level']];
          return A;
      }
  }catch(e){
    return null;
  }
}



Future loaddata() async {

  try{
      final url2 = Uri.parse('http://apbcm.ddns.net:5000/api/getUserbyTel?Tel='+context.read<getTal>().user_tel);
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
      
      final url2 = Uri.parse('http://apbcm.ddns.net:5000/api/getUserbyTel?Tel='+context.read<getTal>().user_tel);
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
        leading: IconButton(
            onPressed: () {
              context.read<getTal>().setUserTel("");
              @override
                      void dispose() {
                        print('dispose');
                        super.dispose();
                      }
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.arrow_back,
              color: Color.fromARGB(255, 255, 255, 255),
            ),),
        title: const Text(
          'จัดการข้อมูลผู้ใช้งาน',
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
            const SizedBox(height: 15,),
            
            FutureBuilder(
              future: loaddataform(),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if(snapshot!=null && snapshot.data!=null){
                  return Column(children: [
                    Text(snapshot.data[0]+" "+snapshot.data[1],style: TextStyle(color: Color.fromARGB(255, 0, 0, 0), fontSize: 18.0)),
                    const SizedBox(height: 5,),
                    Text("เบอร์โทร : "+context.read<getTal>().user_tel,style: TextStyle(color: Color.fromARGB(255, 117, 121, 117), fontSize: 15.0)),
                    Text("ผู้ใช้งานระดับ : "+snapshot.data[2].toUpperCase(),style: TextStyle(color: Color.fromARGB(255, 117, 121, 117), fontSize: 15.0)),
                  ],);
                }else{
                  return Text("data");
                }
              },
            ),
            const SizedBox(height: 30,),
            Divider(color: Color.fromARGB(255, 96, 99, 96),
                thickness: 1.0,),
            ListTile(
                  leading: Icon(Icons.edit),
                  trailing: Icon(Icons.keyboard_arrow_right),
                  title: Text('แก้ไขข้อมูลส่วนตัว',style: TextStyle(color: Color.fromARGB(255, 0, 0, 0), fontSize: 15.0)),
                  onTap: () async{
                      //Navigator.of(context).push(MaterialPageRoute(builder: (context)=> Otp3()));
                     // Navigator.of(context).push(MaterialPageRoute(builder: (context)=> Cpass()));
                    await Navigator.of(context).push(MaterialPageRoute(builder: (context)=> Edit()));
                    setState(() {
                      
                    });
                    
                    
                  },
                ),
            Divider(color: Color.fromARGB(255, 96, 99, 96),
                thickness: 1.0,),
            ListTile(
                  leading: Icon(Icons.manage_search),
                  trailing: Icon(Icons.keyboard_arrow_right),
                  title: Text('ประวัติการใช้งานเครื่องและแลกเงิน ',style: TextStyle(color: Color.fromARGB(255, 0, 0, 0), fontSize: 15.0)),
                  onTap: () async{
                     await Navigator.of(context).push(MaterialPageRoute(builder: (context)=> Ex_history()));
                     setState(() {
                       
                     });
                  },
                ),
                Divider(color: Color.fromARGB(255, 96, 99, 96),
                thickness: 1.0,),
            ListTile(
                  leading: Icon(Icons.campaign),
                  trailing: Icon(Icons.keyboard_arrow_right),
                  title: Text('สิทธิ์โปรโมชันคงเหลือ',style: TextStyle(color: Color.fromARGB(255, 0, 0, 0), fontSize: 15.0)),
                  onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(builder: (context)=> User_promoView())); // main
                     // Navigator.of(context).push(MaterialPageRoute(builder: (context)=> Personal()));

                  },
                ),
            Divider(color: Color.fromARGB(255, 96, 99, 96),
                thickness: 1.0,),
          ],
        ),
      ),
    )));

  



  





  }

}





        