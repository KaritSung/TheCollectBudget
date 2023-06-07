import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_test_noti/admin/userdata/_model/CM.dart';
import 'package:flutter_test_noti/admin/userdata/_model/Witdraw.dart';
import 'package:flutter_test_noti/admin/userdata/confirm%20transfer.dart';
import 'package:flutter_test_noti/internal/navbar/_ex.dart/_model/withdraw.dart';
import 'package:flutter_test_noti/internal/provice/telModel.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
class Confirmation_history extends StatefulWidget {
  

  @override
  State<Confirmation_history> createState() => _Confirmation_historyState();
}

class _Confirmation_historyState extends State<Confirmation_history> {
  bool data = false;
  var x ;
  @override
  void initState() {
    super.initState();
  }
  @override
  void dispose() {
    
    super.dispose();
  }

  Future<List<CM>> getWithdraw() async{
    List<CM> withdraw = [];
    try{
    final url = Uri.parse('http://apbcm.ddns.net:5000/api/getTransfer');
      http.Response response = await http.get(url);
       
      if(response.statusCode==200){
          print('getW');
          var jsonData = json.decode(response.body);
          var jsonArray = jsonData['data'];
          for(var jsonWit in jsonArray){
            CM wit = CM(jsonWit['UserFName'], jsonWit['UserLName'],jsonWit['AdminFName'],jsonWit['AdminLName'],  jsonWit['Money'],jsonWit['Admin_Date'],jsonWit['User_Date']);
            withdraw.add(wit);
          }
          return withdraw;
      }else{
        return withdraw;
      }
    }catch(e){
      print(e);
      return withdraw;
    }
  }


  Future reload() async {
    setState(() {
    });
  }
  @override
  Widget build(BuildContext context) {
    return data == true
            ? Center(child: CircularProgressIndicator())
            :  Scaffold(
                  
                  appBar: AppBar(
                    
                  title: Text("ประวัติยืนยันการโอนเงิน",style: TextStyle(color: Color.fromARGB(255, 255, 255, 255))),
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

                body:RefreshIndicator(
                onRefresh: reload,
                child:
                 FutureBuilder<List<CM>>(
                  future: getWithdraw(),
                  builder: (context,snapshot){
                    if(snapshot.data==null){
                      return Center(child: CircularProgressIndicator(),);
                    }else if(snapshot.data?.length==0) {
                      return Container(child: ListView(
                        children: [
                              SizedBox(height: 300,width: 300,),
                             Center(child: Text("ไม่พบประวัติยืนยันการโอนเงิน"))
                        ],
                      ));
                      
                    }else{
                      List<CM> Wit = snapshot.data!;
                      return ListView.builder(
                        itemCount: Wit.length,
                        itemBuilder: (context, index){
                          CM info =Wit[index];
                          return Card(
                        child: InkWell(
                          splashColor: Colors.blue.withAlpha(30),
                          onTap: () {
                            debugPrint('Card tapped.');
                          },
                          child: SizedBox(
                            width: 300,
                            height: 120,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [

                                Text('ผู้ยืนยันการโอนเงิน : Admin '+info.Admin_Firstname+" "+info.Admin_Lastname,style: TextStyle(color: Color.fromARGB(255, 0, 0, 0), fontSize: 15.0)),
                                Text('ผู้ร้องขอการโอนเงิน : '+info.Firstname+" "+info.Lastname,style: TextStyle(color: Color.fromARGB(255, 0, 0, 0), fontSize: 15.0)),
                                Text('จำนวนเงิน : '+info.Money,style: TextStyle(color: Color.fromARGB(255, 0, 0, 0), fontSize: 15.0)),
                                Text('วัน-เวลาร้องขอการโอนเงิน : '+info.UserDate,style: TextStyle(color: Color.fromARGB(255, 0, 0, 0), fontSize: 15.0)),
                                Text('วัน-เวลากดยืนยันการโอนเงิน : '+info.AdminDate,style: TextStyle(color: Color.fromARGB(255, 0, 0, 0), fontSize: 15.0)),
                            ],),
                          ),
                        ),
                      );
                                    
                        },
                         /* separatorBuilder: (context, index) {
                          return Divider();
                        },*/
                      );
                    }
                  },
                )));
  }
}