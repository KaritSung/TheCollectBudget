import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_test_noti/admin/userdata/_model/Witdraw.dart';
import 'package:flutter_test_noti/admin/userdata/confirm%20transfer.dart';
import 'package:flutter_test_noti/internal/navbar/_ex.dart/_model/withdraw.dart';
import 'package:flutter_test_noti/internal/provice/telModel.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
class Userwit extends StatefulWidget {
  

  @override
  State<Userwit> createState() => _UserwitState();
}

class _UserwitState extends State<Userwit> {
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

  Future<List<WitdrawAdmin>> getWithdraw() async{
    List<WitdrawAdmin> withdraw = [];
    try{
    final url = Uri.parse('http://apbcm.ddns.net:5000/api/getWithdraw?Tel=&status=1');
      http.Response response = await http.get(url);
       
      if(response.statusCode==200){
          print('getW');
          var jsonData = json.decode(response.body);
          var jsonArray = jsonData['data'];
          for(var jsonWit in jsonArray){
            WitdrawAdmin wit = WitdrawAdmin(jsonWit['withdraw_Id'],jsonWit['_id'],jsonWit['withdraw_Money'].toStringAsFixed(2), jsonWit['withdraw_Date'],  jsonWit['user_Firstname'],jsonWit['user_Lastname']);
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
                    
                  title: Text("คำสั่งร้องขอการโอนเงิน",style: TextStyle(color: Color.fromARGB(255, 255, 255, 255))),
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
                 FutureBuilder<List<WitdrawAdmin>>(
                  future: getWithdraw(),
                  builder: (context,snapshot){
                    if(snapshot.data==null){
                      return Center(child: CircularProgressIndicator(),);
                    }else if(snapshot.data?.length==0) {
                      return Container(child: ListView(
                        children: [
                              SizedBox(height: 300,width: 300,),
                             Center(child: Text("ไม่พบคำสั่งร้องขอการโอนเงินของผู้ใช้งาน"))
                        ],
                      ));
                      
                    }else{
                      List<WitdrawAdmin> Wit = snapshot.data!;
                      return ListView.builder(
                        itemCount: Wit.length,
                        itemBuilder: (context, index){
                          WitdrawAdmin info =Wit[index];
                          return Container(
                            //width: 150,  
                            //height: 150, 
                            child: 
                           Card(
                            elevation:3 ,
                            child: Padding(padding: EdgeInsets.all(10.0), child: ListTile(
                            horizontalTitleGap: 34.0,
                            leading:  Column(
                              children: [
                                Text("คุณ "+info.firstname,style: TextStyle(color: Color.fromARGB(255, 16, 16, 16), fontSize: 18.0)),
                                Text(info.money.toString()+" บาท",style: TextStyle(color: Color.fromARGB(255, 0, 0, 0), fontSize: 18.0,fontWeight: FontWeight.bold)),
                                //Text("S: "+histo.S.toString()+", M: "+histo.M.toString()+", L: "+histo.L.toString(),style: TextStyle(color: Color.fromARGB(255, 117, 121, 117), fontSize: 15.0)),
                              ],
                            ),
                            title: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              
                              children: [
                                Row(children: [

                                
                                Wrap(
                                  direction: Axis.vertical,
                                  children: [
                                    Text(info.lastname,style: TextStyle(color: Color.fromARGB(255, 16, 16, 16), fontSize: 18.0)),
                                  const SizedBox(height: 5,),
                                  Text(info.date,style: TextStyle(color: Color.fromARGB(255, 117, 121, 117), fontSize: 15.0)),
                                 
                                ],),
                                
                                ],),
                                
                                
                                  
                                
                                //const SizedBox(height: 5,),
                                
                              ],
                            ),
                            trailing: Icon(Icons.keyboard_arrow_right),
                            onTap: () async{
                             await Navigator.of(context).push(MaterialPageRoute(builder: (context)=> Confirm_transfer(info.witId,info.id,info.money,info.date)));
                             setState(() {
                               
                             });
                            },

                          ))));
                        
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