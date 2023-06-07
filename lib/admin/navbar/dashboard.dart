import 'dart:convert';
import 'package:flutter_test_noti/admin/adminnoti.dart';
import 'package:flutter_test_noti/internal/provice/telModel.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test_noti/internal/homepage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_storage/firebase_storage.dart';

class Dashboard extends StatefulWidget {
  String disPhone = "";

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  String? priceS, priceM, priceL;
  String name = "", lastName = "";
  String money = "";
  var mac_status = 0;
  var mac_break = 0;
  var mac_s = 0;
  var mac_m = 0;
  var mac_l = 0;
  bool data = false;

  Future loaddata() async {
    try {
      final url2 = Uri.parse(
          'http://apbcm.ddns.net:5000/api/getUserbyTel?Tel=' +
              context.read<getTal>().Tel);
      http.Response response2 = await http.get(url2);
      if (response2.statusCode == 200) {
        var user = json.decode(response2.body);
        final ref =
            FirebaseStorage.instance.ref("avarta").child(user['user_Avatar']);
        String url = await ref.getDownloadURL();
        return url;
      } else {
        print("Avarta-error");
        return null;
      }
    } catch (e) {
      print("Avarta-error");
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
      final url2 = Uri.parse(
          'http://apbcm.ddns.net:5000/api/getUserbyTel?Tel=' +
              context.read<getTal>().Tel);
      http.Response response2 = await http.get(url2);
      final url3 = Uri.parse('http://apbcm.ddns.net:5000/api/getMac');
      http.Response response3 = await http.get(url3);

      if (response.statusCode == 200 && response2.statusCode == 200&& response3.statusCode == 200) {
        var price = json.decode(response.body);
        var user = json.decode(response2.body);
        var mac_sta = json.decode(response3.body);
        setState(() {
          priceS = price['sizeS']['item_Price'].toString();
          priceM = price['sizeM']['item_Price'].toString();
          priceL = price['sizeL']['item_Price'].toString();
          name = user['user_Firstname'];
          lastName = user['user_Lastname'];
          money = user['user_Money'].toStringAsFixed(3);
          data = false;
          mac_status = mac_sta['mac_Status'];
          mac_break = mac_sta['mac_Break'];
          mac_l = mac_sta['mac_RoomL'];
          mac_m = mac_sta['mac_RoomM'];
          mac_s = mac_sta['mac_RoomS'];
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
                    icon: Icon(
                      Icons.menu_rounded,
                      color: Color.fromARGB(255, 0, 0, 0),
                    ),
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
                  accountName: Text(
                    name + " " + lastName,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  accountEmail:
                      Text(context.read<getTal>().Tel + '\n' + "Admin"),
                  currentAccountPicture: CircleAvatar(
                    child: ClipOval(
                        child: FutureBuilder(
                      future: loaddata(),
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
                  ),
                ),
                ListTile(
                  leading: Icon(Icons.notifications_active_outlined),
                  title: Text('แจ้งเตือน',
                      style: TextStyle(
                          color: Color.fromARGB(255, 0, 0, 0), fontSize: 15.0)),
                  onTap: () {  Navigator.of(context).push(MaterialPageRoute(builder: (context)=> Adminnoti()));},
                ),
                Divider(),
                ListTile(
                  leading: Icon(Icons.login_outlined),
                  title: Text('ออกจากระบบ',
                      style: TextStyle(
                          color: Color.fromARGB(255, 0, 0, 0), fontSize: 15.0)),
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
                      sSize(),
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
                Text("เครื่องแลกขวดพลาสติก",
                    style: TextStyle(color: Colors.white, fontSize: 25.0)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text("รหัสเครื่อง : A01",
                        style: TextStyle(color: Colors.white, fontSize: 20.0)),
                  ],
                ),
                Container(

                    // padding: EdgeInsets.all(5.0),
                    child: SizedBox(
                  child: Card(
                    color: 
                        (() {
                              if(mac_status==0){
                                    return Color.fromARGB(255, 22, 212, 35);
                              }else{
                                    return Color.fromARGB(255, 255, 0, 21);
                              }
                        }()),
                    child: Center(
                        child: Text(
                        (() {
                              if(mac_status==0){
                                    return 'ONLINE';
                              }else{
                                   return 'OFFLINE';
                              }
                        }()),
                            style: TextStyle(
                                color: Colors.white, fontSize: 24.0))),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  width: 150.0,
                  height: 35.0,
                )),
                SizedBox(height: 15.0),
                Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Container(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
            
                        children: [
                          Text("สถานะเครื่องขัดข้อง : ",
                              style: TextStyle(
                                  color: Colors.white, fontSize: 15.0)),
                          SizedBox(
                            child: Card(
                              color: (() {
                              if(mac_break==0 && mac_status==0){
                                    return Color.fromARGB(255, 22, 212, 35);
                              }else{
                                    return Color.fromARGB(255, 255, 0, 21);
                              }
                            }()),
                              child: Center(
                                  child: Text((() {
                              if(mac_break==0 && mac_status==0){
                                    return "ปกติ";
                              }else if(mac_break==0 && mac_status==1){
                                  return "n/a";
                              
                              }else{
                                    return "ขัดข้อง";
                              }
                            }()),
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 15.0))),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            width: 70.0,
                            height: 30.0,
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Text("ความจุห้องขวดขนาดใหญ่ : ",
                              style: TextStyle(
                                  color: Colors.white, fontSize: 15.0)),
                          SizedBox(
                            child: Card(
                              color: (() {
                              if(mac_l==0 && mac_status==0){
                                    return Color.fromARGB(255, 22, 212, 35);
                              }else if(mac_l==1 && mac_status==0){
                                    return Color.fromARGB(255, 244, 152, 3);
                              }else if(mac_l==2 && mac_status==0){
                                    return Color.fromARGB(255, 255, 0, 21);
                              }else{
                                    return Color.fromARGB(255, 255, 0, 21);
                              }

                            }()),
                              child: Center(
                                  child: Text((() {
                              if(mac_l==0 && mac_status==0){
                                    return "ปกติ";
                              }else if(mac_l==1 && mac_status==0){
                                    return "ใกล้เต็ม";
                              }else if (mac_l==2 && mac_status==0){
                                    return "เต็ม";
                              }else{
                                    return "n/a";
                              }
                            }()),
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 15.0))),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            width: 70.0,
                            height: 30.0,
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Text("ความจุห้องขวดขนาดกลาง : ",
                              style: TextStyle(
                                  color: Colors.white, fontSize: 15.0)),
                          SizedBox(
                            child: Card(
                              color: (() {
                              if(mac_m==0 && mac_status==0){
                                    return Color.fromARGB(255, 22, 212, 35);
                              }else if(mac_m==1 && mac_status==0){
                                    return Color.fromARGB(255, 244, 152, 3);
                              }else if(mac_m==2 && mac_status==0){
                                    return Color.fromARGB(255, 255, 0, 21);
                              }else{
                                    return Color.fromARGB(255, 255, 0, 21);
                              }
                            }()),
                              child: Center(
                                  child: Text((() {
                              if(mac_m==0 && mac_status==0){
                                    return "ปกติ";
                              }else if(mac_m==1 && mac_status==0){
                                    return "ใกล้เต็ม";
                              }else if (mac_m==2 && mac_status==0){
                                    return "เต็ม";
                              }else{
                                    return "n/a";
                              }
                            }()),
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 15.0))),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            width: 70.0,
                            height: 30.0,
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Text("ความจุห้องขวดขนาดเล็ก : ",
                              style: TextStyle(
                                  color: Colors.white, fontSize: 15.0)),
                          SizedBox(
                            child: Card(
                              color: (() {
                              if(mac_s==0 && mac_status==0){
                                    return Color.fromARGB(255, 22, 212, 35);
                              }else if(mac_s==1 && mac_status==0){
                                    return Color.fromARGB(255, 244, 152, 3);
                              }else if(mac_s==2 && mac_status==0){
                                    return Color.fromARGB(255, 255, 0, 21);
                              }else{
                                    return Color.fromARGB(255, 255, 0, 21);
                              }
                            }()),
                              child: Center(
                                  child: Text((() {
                              if(mac_s==0 && mac_status==0){
                                    return "ปกติ";
                              }else if(mac_s==1 && mac_status==0){
                                    return "ใกล้เต็ม";
                              }else if (mac_s==2 && mac_status==0){
                                    return "เต็ม";
                              }else{
                                    return "n/a";
                              }
                            }()),
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 15.0))),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            width: 70.0,
                            height: 30.0,
                          ),
                        ],
                      ),
                    ],
                  ))
                ])
              ],
            )),
      );
}
