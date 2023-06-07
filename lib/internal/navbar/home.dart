import 'dart:convert';
import 'package:flutter_test_noti/internal/bar/report.dart';
import 'package:flutter_test_noti/internal/navbar/user_promo.dart';
import 'package:flutter_test_noti/internal/navbar/usernoti.dart';
import 'package:flutter_test_noti/internal/provice/telModel.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test_noti/internal/homepage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_storage/firebase_storage.dart';

class home extends StatefulWidget {
 String disPhone = "";
 


  @override
  State<home> createState() => _homeState();
}

class _homeState extends State<home> {
  String? priceS, priceM, priceL;
  String name ="", lastName = "";
  String money="";
  String? multi,bcount,st,ed;
  bool data = false;

  @override
  void dispose() {
    
    super.dispose();
  }

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

  Future loadpromo() async{
      try {
          final url = Uri.parse(
            'http://apbcm.ddns.net:5000/api/getPromotionUser?Tel=' +
                context.read<getTal>().Tel);
        http.Response response = await http.get(url);

        if (response.statusCode == 200) {
          if (response.body == "null") {
            return null;
          } else {
            var jsonData = json.decode(response.body);
            return jsonData;
          }
        } else {
          return null;
        }
      } catch (e) {
        print(e);
      }
  }

  Future load()async{
      try {
        final url3 = Uri.parse('http://apbcm.ddns.net:5000/api/getPromotion');
        http.Response response3 = await http.get(url3);
        if(response3.statusCode==200){
            var data = json.decode(response3.body);
            multi = data['man_Multiply'].toString();
            bcount = data['man_Bottle'].toString();
            st = data['man_RStart'];
            ed = data['man_REnd'];
            final ref = FirebaseStorage.instance.ref("promotion").child(data['man_Pic']+'.jpg');
            String url = await ref.getDownloadURL();
            return url;
        }else{
          return null;
        }
      } catch (e) {
          print(e);
          return null;
      }
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

  @override
  void initState() {
    reload();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            'หน้าหลัก',
            style: TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
          ),
           leading: Builder(
          builder: (context) => IconButton(
            icon: Icon(Icons.menu_rounded,
            color: Color.fromARGB(255, 0, 0, 0),),
            onPressed: () => Scaffold.of(context).openDrawer(),
          )),
          centerTitle: true,
          backgroundColor: Color.fromARGB(255, 255, 252, 252),
        ),
        drawer: Drawer(
          child: Drawer(
            backgroundColor: Color.fromARGB(255, 255, 255, 255),
            child: ListView(
              padding: EdgeInsets.zero,
// ignore: prefer_const_literals_to_create_immutables
              children: <Widget>[
                UserAccountsDrawerHeader(
                  accountName: Text(name+" "+lastName
                  ,style: TextStyle(
                    fontWeight: FontWeight.bold
                  ),),
                  accountEmail: Text(context.read<getTal>().Tel),
                  currentAccountPicture: CircleAvatar(
                    child:ClipOval( child: FutureBuilder(
                  future: loaddata(),
                  builder: (BuildContext context, AsyncSnapshot snapshot){
                      if(snapshot!=null){
                        if(snapshot.connectionState == ConnectionState.done){
                          return Image.network(snapshot.data.toString(),width: 100,
                                  height: 100,
                                  fit: BoxFit.cover,);
                        }else{
                          return Image.asset("assets/images/login/user.png");
                        }
                      }else{
                        return Image.asset("assets/images/login/user.png");
                      }
                  },
                  
                )
                ),
                    backgroundColor: Colors.white,
                  ),
                  
                ),
                ListTile(
                  leading: Icon(Icons.notifications_active_outlined),
                  title: Text('แจ้งเตือน',style: TextStyle(color: Color.fromARGB(255, 0, 0, 0), fontSize: 15.0)),
                  onTap: () {Navigator.of(context).push(MaterialPageRoute(builder: (context)=> Usernoti()));},
                ),
                 Divider(),
                ListTile(
                  leading: Icon(Icons.campaign_outlined),
                  title: Text('โปรโมชั่น',style: TextStyle(color: Color.fromARGB(255, 0, 0, 0), fontSize: 15.0)),
                  onTap: () {Navigator.of(context).push(MaterialPageRoute(builder: (context)=> User_promo()));},
                ),
                Divider(),
                ListTile(
                  leading: Icon(Icons.report_problem_outlined),
                  title: Text('รายงานปัญหา',style: TextStyle(color: Color.fromARGB(255, 0, 0, 0), fontSize: 15.0)),
                  onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(builder: (context)=> Report()));
                  },
                ),
                Divider(),
                ListTile(
                  leading: Icon(Icons.login_outlined),
                  title: Text('ออกจากระบบ',style: TextStyle(color: Color.fromARGB(255, 0, 0, 0), fontSize: 15.0)),
                  onTap: () {
                    showDialog<bool>(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: const Text('คุณแน่ใจหรือไม่ที่จะออกจากระบบ ?'),
                        actionsAlignment: MainAxisAlignment.spaceBetween,
                        actions: [
                          TextButton(
                            onPressed: () async{
                               try {
                                    var res = await http.post(
                                    Uri.parse("http://apbcm.ddns.net:5000/api/updateToken?Tel="+context.read<getTal>().Tel),
                                    body: {
                                      "user_Token":'AAA',
                                    }
                                    );
                                    if(res.statusCode==200){
                                      print("updateToken");
                                        Navigator.of(context).pushNamedAndRemoveUntil('/', (Route<dynamic> route) => false);
                                        
                                    }
                              } catch (e) {

                              }
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
                    //Navigator.of(context).pushNamedAndRemoveUntil('/', (Route<dynamic> route) => false);
                  },
                ),
                
                
                Divider(),
              ],
            ),
          ),
        ),
        body: data == true
            ? Center(child: CircularProgressIndicator())
            : RefreshIndicator(
                onRefresh: reload,
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Color.fromARGB(255, 24, 69, 231),
                        
                        Colors.white,
                        Color.fromARGB(255, 201, 195, 195),
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter
                    ),
                  ),
                  child: ListView(
                    children: [
                      topArea(),
                      SizedBox(height: 20,),
                   
                      FutureBuilder(
                        future: loadpromo(),
                        builder: (BuildContext context, AsyncSnapshot snapshot) {
                         if(snapshot.data!=null){
                            return 
                Padding(
                    padding: EdgeInsets.symmetric(
                        vertical: 0.0, horizontal: 20.0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Container(
                        height: 70,
                        color: Colors.white,
                        child: InkWell(
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(builder: (context)=> User_promo()));
                          },
                          child: 
                         Row(
                          children: <Widget>[
                            Container(
                              color: Color.fromARGB(255, 24, 69, 231),
                              width: 70,
                              height: 70,
                              child: Icon(Icons.campaign, color: Colors.white, size: 37,),
                            ),
                            SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text('การแลกขวดครั้งต่อไปจะได้รับสิทธิคูณราคาขวด'),
                                  
                                ],
                              ),
                            ),
                            Icon(Icons.arrow_forward_ios,
                                color: Colors.blue),
                          ],
                        ),
                      ),
                    ),
                  ));
                         }else{
                            return Text("");
                         }
                        },
                      ),
                      sSize(),
                      
                      FutureBuilder(
                        future: load(),
                        builder: (BuildContext context, AsyncSnapshot snapshot) {
                           if(snapshot.data!=null){
                              return Padding(padding: EdgeInsets.only(
                                  top: 10.0, bottom: 10.0, left: 10.0, right: 10.0),

                                  child:Column(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    //mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      InkWell(
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(8.0),
                                          child: Image.network(snapshot.data.toString(),
                                                          width: 500,
                                                          height: 150,
                                                  ),
                                        )
                                        
                                      
                                      ,onTap: (){
                                          showDialog<String>(
                                          context: context,
                                          builder: (BuildContext context) => AlertDialog(
                                            title: const Text('รายละเอียดโปรโมชั่น'),
                                            content: Wrap(children: [
                                              Text("สมัครสมาชิกใหม่ \nตั้งแต่วันที่ "+st.toString()+" ถึง "+ed.toString()+'\n'+"รับสิทธิโปรโมชั่น อัตราการแลกขวดพลาสติก คูณ "+multi.toString()+" ทุกขนาดจำนวน "+bcount.toString()+" ขวด\nสามารถใช้ได้ตั้งแต่วันที่ลงทะเบียนจนครบสิทธิหากพบปัญหาหรือข้อสงสัยโปรดติดต่อ ผู้ดูแลระบบ"),
                                              //Text("ตั้งแต่วันที่ XXX")
                                            ],),
                                            actions: <Widget>[
                                              TextButton(
                                                onPressed: () => Navigator.pop(context, 'Cancel'),
                                                child: const Text('ตกลง'),
                                              ),
                                              
                                            ],
                                          ),
                                        
                                    
                                      );
                                      },

                                      )
                                      
                                        ],)
                                  
                                  );
                           }else{
                            return Text("");
                           }
                        },
                      ),
                    ],
                  ),
                )));
  }

  Widget sSize() => Container(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
          height: MediaQuery.of(context).size.height * 0.35,
          child: Card(
            color: Colors.transparent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            elevation: 8,
            child: Container(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                        width: 500,
                        height: 40,
                        child: Card(
                          child: Center(child: Text('ราคาขวดวันนี้',style: TextStyle(color: Color.fromARGB(255, 0, 0, 0), fontSize: 20.0)),) ,
                          shape: RoundedRectangleBorder(
                            //borderRadius: BorderRadius.circular(12),
                          ),
                        )),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Icon(Icons.battery_full_rounded),
                        Text("ขวดพลาสติกขนาดเล็ก ขวดละ " +
                            priceS.toString() +
                            ' บาท'
                            ,style: TextStyle(color: Color.fromARGB(255, 0, 0, 0), fontSize: 17.0)),
                      ],
                    ),
                    Row(
                      children: [
                        Icon(Icons.battery_full_rounded),
                        Text("ขวดพลาสติกขนาดกลาง ขวดละ " +
                            priceM.toString() +
                            ' บาท' ,style: TextStyle(color: Color.fromARGB(255, 0, 0, 0), fontSize: 17.0)),
                      ],
                    ),
                    Row(
                      children: [
                        Icon(Icons.battery_full_rounded),
                        Text("ขวดพลาสติกขนาดใหญ่ ขวดละ " +
                            priceL.toString() +
                            ' บาท',style: TextStyle(color: Color.fromARGB(255, 0, 0, 0), fontSize: 17.0)),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );

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
}
