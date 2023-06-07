import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_test_noti/internal/inHistory/model/History.dart';
import 'package:flutter_test_noti/internal/provice/telModel.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
class Etab1 extends StatefulWidget {
  

  @override
  State<Etab1> createState() => _Etab1State();
}

class _Etab1State extends State<Etab1> {
  bool data = false;
  var x ;
  @override
  void initState() {
    super.initState();
  }

  Future<List<History>> getHistory() async{
    List<History> historys = [];
    try{
    final url = Uri.parse('http://apbcm.ddns.net:5000/api/getUserHistory?Tel='+context.read<getTal>().user_tel);
      http.Response response = await http.get(url);
       
      if(response.statusCode==200){
          print('getH');
          var jsonData = json.decode(response.body);
          var jsonArray = jsonData['data'];
          for(var jsonHis in jsonArray){
            History his = History(jsonHis['userHistory_Date'],jsonHis['userHistory_Money'].toStringAsFixed(3), jsonHis['userHistory_S'],  jsonHis['userHistory_M'],  jsonHis['userHistory_L'],jsonHis['userHistory_detail']);
            historys.add(his);
          }
          return historys;
      }else{
        return historys;
      }
    }catch(e){
      print(e);
      return historys;
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
            : RefreshIndicator(
                onRefresh: reload,
                child: FutureBuilder<List<History>>(
                  future: getHistory(),
                  builder: (context,snapshot){
                    if(snapshot.data==null){
                      return Center(child: CircularProgressIndicator(),);
                    }else if(snapshot.data?.length==0) {
                      return Container(child: ListView(
                        children: [
                              SizedBox(height: 300,width: 300,),
                             Center(child: Text("ไม่พบประวัติการแลกขวด"))
                        ],
                      ));
                      
                    }else{
                      List<History> His = snapshot.data!;
                      return ListView.builder(
                        itemCount: His.length,
                        itemBuilder: (context, index){
                          History histo =His[index];
                          return Card(child: Padding(padding: EdgeInsets.all(10.0), child: ListTile(
                            leading:  Column(
                              children: [
                                Text("+ "+histo.sum+" บาท",style: TextStyle(color: Color.fromARGB(255, 2, 110, 10), fontSize: 18.0)),
                                Text("S: "+histo.S.toString()+", M: "+histo.M.toString()+", L: "+histo.L.toString(),style: TextStyle(color: Color.fromARGB(255, 117, 121, 117), fontSize: 15.0)),
                              ],
                            ),
                            trailing: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(histo.date,style: TextStyle(color: Color.fromARGB(255, 117, 121, 117), fontSize: 15.0)),
                                Text("โปรโมชั่น : "+histo.mac.toString(),style: TextStyle(color: Color.fromARGB(255, 117, 121, 117), fontSize: 15.0)),
                              ],
                            ),
                          )));
                        
                        },
                         /* separatorBuilder: (context, index) {
                          return Divider();
                        },*/
                      );
                    }
                  },
                ));
  }
}