import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_test_noti/admin/report_detail.dart';
import 'package:flutter_test_noti/admin/userdata/_model/Report.dart';
import 'package:flutter_test_noti/admin/userdata/_model/Witdraw.dart';
import 'package:flutter_test_noti/admin/userdata/confirm%20transfer.dart';
import 'package:flutter_test_noti/internal/navbar/_ex.dart/_model/withdraw.dart';
import 'package:flutter_test_noti/internal/provice/telModel.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
class ReportList extends StatefulWidget {
  

  @override
  State<ReportList> createState() => _ReportListState();
}

class _ReportListState extends State<ReportList> {
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

  Future<List<Report_model>> getReport() async{
    List<Report_model> report = [];
    try{
    final url = Uri.parse('http://apbcm.ddns.net:5000/api/getReport');
      http.Response response = await http.get(url);
       
      if(response.statusCode==200){
          print('getW');
          var jsonData = json.decode(response.body);
          var jsonArray = jsonData['data'];
          for(var jsonWit in jsonArray){
            Report_model wit = Report_model(jsonWit['report_Id'],jsonWit['user_Id'],jsonWit['user_Tel'],jsonWit['report_Topic'], jsonWit['report_Body'],  jsonWit['user_Firstname'],jsonWit['user_Lastname'],jsonWit['report_Pic'],jsonWit['report_Date']);
            report.add(wit);
          }
          return report;
      }else{
        return report;
      }
    }catch(e){
      print(e);
      return report;
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
                    
                  title: Text("ผู้ใช้งานแจ้งปัญหา",style: TextStyle(color: Color.fromARGB(255, 255, 255, 255))),
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
                 FutureBuilder<List<Report_model>>(
                  future: getReport(),
                  builder: (context,snapshot){
                    if(snapshot.data==null){
                      print(snapshot.data?.length);
                      return Center(child: CircularProgressIndicator(),);
                    }else if(snapshot.data?.length==0) {
                      return Container(child: ListView(
                        children: [
                              SizedBox(height: 300,width: 300,),
                             Center(child: Text("ไม่พบการแจ้งปัญหาของผู้ใช้งาน"))
                        ],
                      ));
                      
                    }else{
                      List<Report_model> Wit = snapshot.data!;
                      return ListView.builder(
                        itemCount: Wit.length,
                        itemBuilder: (context, index){

                          Report_model info =Wit[index];
                          return Container(
                            //width: 150,  
                            //height: 150, 
                            child: 
                           Card(
                            elevation:5 ,
                            child: Padding(padding: EdgeInsets.all(10.0), child: ListTile(
                            horizontalTitleGap: 34.0,
                            leading: Icon(Icons.warning_amber,color: Colors.red,size: 35.0,),
                            title: Text(info.topic,style: TextStyle(color: Color.fromARGB(255, 255, 0, 0), fontSize: 16.0)),
                            subtitle: Text("ผู้แจ้ง "+info.firstname+" "+info.lastname+'\n'+info.date,style: TextStyle(color: Color.fromARGB(255, 117, 121, 117), fontSize: 13.0)),
                            trailing:  Icon(Icons.keyboard_arrow_right),
                            onTap: () async{
                             await Navigator.of(context).push(MaterialPageRoute(builder: (context)=> ReportDetail(info.id,info.firstname,info.lastname,info.usertel,info.date,info.topic,info.body,info.pic)));
                             setState(() {
                               
                             });
                            },

                          ))));
                          }
                        ,
                         /* separatorBuilder: (context, index) {
                          return Divider();
                        },*/
                      );
                    }
                  },
                )));
  }
}