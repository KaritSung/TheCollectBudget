import 'dart:convert';
import 'package:flutter_test_noti/admin/userdata/usertool.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_test_noti/admin/userdata/_model/user.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:provider/provider.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import '../../internal/provice/telModel.dart';
class Userdata extends StatefulWidget {
  Userdata({Key? key}) : super(key: key);

  @override
  State<Userdata> createState() => _UserdataState();
  
}

class _UserdataState extends State<Userdata> {
  firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;
  final controller = TextEditingController();
  @override
  void initState() {
    controller.text = "";
    super.initState();
    
  }
  @override
  void dispose() {
    
    super.dispose();
  }
  Future<List<User>> getUser(String Q) async{
    List<User> user = [];
    try{
    final url = Uri.parse('http://apbcm.ddns.net:5000/api/getUserSearch?q='+Q);
      http.Response response = await http.get(url);
       
      if(response.statusCode==200){
          print('getW');
          var jsonData = json.decode(response.body);
          var jsonArray = jsonData['data'];
          for(var jsonWit in jsonArray){
            User wit = User(jsonWit['user_Tel'],jsonWit['user_Firstname'], jsonWit['user_Lastname'],  jsonWit['user_Avatar'],jsonWit['user_Level']);
            user.add(wit);
          }
          return user;
      }else{
        return user;
      }
    }catch(e){
      print(e);
      return user;
    }
  }

  Future loaddata(String ava) async {
    try{
    final ref =FirebaseStorage.instance.ref("avarta").child(ava);
        String url = await ref.getDownloadURL();
        return url;
    }catch(e){
        return null;
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("ข้อมูลผู้ใช้งาน",style: TextStyle(color: Color.fromARGB(255, 0, 0, 0))),
        leading: IconButton(
            onPressed: () {
              context.read<getTal>().setUserTel("");
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.arrow_back,
              color: Color.fromARGB(255, 0, 0, 0),
            ),),
        centerTitle: true,
        backgroundColor: Color.fromARGB(255, 255, 252, 252),
      ),
      body: Column(children: [

          Container(
            height: 42,
            margin: const EdgeInsets.fromLTRB(16, 16, 16, 16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: Colors.white,
              border: Border.all(color: Colors.black26),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: TextField(
              
              controller: controller,
              decoration: InputDecoration(
                hintText: "ชื่อจริง นามสกุล เบอร์โทรศัพท์",
                icon: Icon(Icons.search),
                border: InputBorder.none,
              ),
              onChanged: (val) {
                setState(() {
                  
                });
              },
            ),
          ),
          Expanded(child: 
          FutureBuilder<List<User>>(
                  future: getUser(controller.text),
                  builder: (context,snapshot){
                    if(snapshot.data==null){
                      return Center(child: CircularProgressIndicator(),);
                    }else{
                      List<User> Us = snapshot.data!;
                      return ListView.builder(
                        itemCount: Us.length,
                        itemBuilder: (context, index){
                          User us =Us[index];
                          return Card(child: Padding(padding: EdgeInsets.all(10.0), child: ListTile(
                            leading:  Column(
                              children: [
                                CircleAvatar(
                                  radius: 25,
                    child: ClipOval(
                        child: FutureBuilder(
                      future: loaddata(us.Avatar),
                      builder: (BuildContext context, AsyncSnapshot snapshot) {
                        if (snapshot != null) {
                          if (snapshot.connectionState ==
                              ConnectionState.done) {
                            return Image.network(
                              snapshot.data.toString(),
                              width: 100,
                              height: 100,
                              fit: BoxFit.cover,
                            );
                          } else {
                            return Image.asset("assets/images/login/user.png");
                          }
                        } else {
                          return Image.asset("assets/images/login/user.png");
                        }
                      },
                    )),
                    backgroundColor: Colors.white,
                  )
                               //Text("S: "+histo.S.toString()+", M: "+histo.M.toString()+", L: "+histo.L.toString(),style: TextStyle(color: Color.fromARGB(255, 117, 121, 117), fontSize: 15.0)),
                              ],
                            ),
                            title: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                              Text(us.Firstname+" "+us.Lastname,style: TextStyle(color: Color.fromARGB(255, 0, 0, 0), fontSize: 18.0)),
                              Text(us.Tel,style: TextStyle(color: Color.fromARGB(255, 117, 121, 117), fontSize: 15.0)),
                              Text(us.roll.toUpperCase(),style: TextStyle(color: Color.fromARGB(255, 117, 121, 117), fontSize: 14.0)),
                            ],),
                            trailing: Icon(Icons.keyboard_arrow_right),
                            onTap: () async{
                                setState(() {
                                  controller.text = "";
                                });
                                context.read<getTal>().setUserTel(us.Tel);
                                var reload = await Navigator.pushNamed(context, '/usertool');
                                setState(() {
                                  
                                });
                            },
                            )
                            ));
                        
                        },
                         /* separatorBuilder: (context, index) {
                          return Divider();
                        },*/
                      );
                    }
                  },
                )
        
      )],));
    
  }
}
