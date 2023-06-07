import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_test_noti/internal/inHistory/model/History.dart';
import 'package:flutter_test_noti/internal/navbar/_ex.dart/_model/withdraw.dart';
import 'package:flutter_test_noti/internal/provice/telModel.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
class tabTwo extends StatefulWidget {
  

  @override
  State<tabTwo> createState() => _tabTwoState();
}

class _tabTwoState extends State<tabTwo> {
  bool data = false;
  var x ;
  @override
  void initState() {
    super.initState();
  }

  Future<List<Withdraw>> getWithdraw() async{
    List<Withdraw> withdraw = [];
    try{
    final url = Uri.parse('http://apbcm.ddns.net:5000/api/getWithdraw?Tel='+context.read<getTal>().Tel+'&status=all');
      http.Response response = await http.get(url);
       
      if(response.statusCode==200){
          print('getW');
          var jsonData = json.decode(response.body);
          var jsonArray = jsonData['data'];
          for(var jsonWit in jsonArray){
            Withdraw wit = Withdraw(jsonWit['withdraw_Id'],jsonWit['withdraw_Money'].toStringAsFixed(2), jsonWit['withdraw_Date'],  jsonWit['withdraw_Status'],jsonWit['withdraw_Detail']);
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
            : RefreshIndicator(
                onRefresh: reload,
                child: FutureBuilder<List<Withdraw>>(
                  future: getWithdraw(),
                  builder: (context,snapshot){
                    if(snapshot.data==null){
                      return Center(child: CircularProgressIndicator(),);
                    }else if(snapshot.data?.length==0) {
                      return Container(child: ListView(
                        children: [
                              SizedBox(height: 300,width: 300,),
                             Center(child: Text("ไม่พบประวัติการแลกเงิน"))
                        ],
                      ));
                      
                    }else{
                      List<Withdraw> Wit = snapshot.data!;
                      return ListView.builder(
                        itemCount: Wit.length,
                        itemBuilder: (context, index){
                          Withdraw info =Wit[index];
                          return Container(
                            //width: 150,  
                            //height: 150, 
                            child: 
                           Card(
                            elevation:3 ,
                            child: Padding(padding: EdgeInsets.all(10.0), child: ListTile(
                            horizontalTitleGap: 24.0,
                            leading:  Column(
                              children: [
                                Text("การแลกเงิน",style: TextStyle(color: Color.fromARGB(255, 16, 16, 16), fontSize: 18.0)),
                                Text("- "+info.money.toString()+" บาท",style: TextStyle(color: Color.fromARGB(255, 233, 25, 25), fontSize: 18.0)),
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
                                    FutureBuilder(
                                  future: getWithdraw(),
                                  builder: (BuildContext context, AsyncSnapshot snapshot){
                                      if(snapshot!=null){
                                          if(info.status=='1'){
                                            return Text("รอตรวจสอบ",style: TextStyle(color: Color.fromARGB(255, 167, 173, 2),fontSize: 16.0));
                                          }else if(info.status=='0'){
                                            return Text("โอนเงินสำเร็จ",style: TextStyle(color: Color.fromARGB(255, 5, 106, 33),fontSize: 16.0));
                                          }else{
                                            return Text("โอนเงินไม่สำเร็จ",style: TextStyle(color: Color.fromARGB(255, 206, 1, 1),fontSize: 16.0));
                                          }
                                      }else{
                                        return Text("รอตรวจสอบ",style: TextStyle(color: Color.fromARGB(255, 167, 173, 2),fontSize: 16.0));
                                      }
                                  }
                                  ),
                                  const SizedBox(height: 5,),
                                  Text(info.date,style: TextStyle(color: Color.fromARGB(255, 117, 121, 117), fontSize: 15.0)),
                                 
                                ],),
                                
                                ],),
                                
                                
                                  
                                
                                //const SizedBox(height: 5,),
                                
                              ],
                            ),
                            trailing: Icon(Icons.keyboard_arrow_right),
                            onTap: (){
                              showDialog<String>(
                                          context: context,
                                          builder: (BuildContext context) => AlertDialog(
                                            title: const Text('หมายเหตุการแลกเงิน'),
                                            content: Wrap(children: [ Text(info.detail.toString())],),
                                            actions: <Widget>[
                                              TextButton(
                                                onPressed: () => Navigator.pop(context, 'Cancel'),
                                                child: const Text('ตกลง'),
                                              ),
                                              
                                            ],
                                          ),
                                        
                                    
                                      );
                            },

                          ))));
                        
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