import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_test_noti/admin/report_detail.dart';
import 'package:flutter_test_noti/admin/userdata/_model/Report.dart';
import 'package:flutter_test_noti/admin/userdata/_model/Witdraw.dart';
import 'package:flutter_test_noti/admin/userdata/confirm%20transfer.dart';
import 'package:flutter_test_noti/internal/navbar/_ex.dart/_model/withdraw.dart';
import 'package:flutter_test_noti/internal/navbar/model/noti.dart';
import 'package:flutter_test_noti/internal/provice/telModel.dart';
import 'package:http/http.dart' as http;
import 'package:expansion_tile_card/expansion_tile_card.dart';

import 'package:provider/provider.dart';

class Usernoti extends StatefulWidget {
  @override
  State<Usernoti> createState() => _UsernotiState();
}

class _UsernotiState extends State<Usernoti> {
  bool data = false;

  var x;
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<List<Noti>> getNoti() async {
    List<Noti> noti = [];
    try {
      final url = Uri.parse('http://apbcm.ddns.net:5000/api/getNoti?Tel=' +
          context.read<getTal>().Tel);
      http.Response response = await http.get(url);

      if (response.statusCode == 200) {
        print('getW');
        var jsonData = json.decode(response.body);
        var jsonArray = jsonData['data'];
        print(jsonArray);
        for (var jsonWit in jsonArray) {
          Noti wit = Noti(
              jsonWit['noti_Id'], jsonWit['noti_body'], jsonWit['noti_date']);
          noti.add(wit);
        }
        return noti;
      } else {
        return noti;
      }
    } catch (e) {
      print(e);
      return noti;
    }
  }

  Future reload() async {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return data == true
        ? Center(child: CircularProgressIndicator())
        :  Scaffold(
                appBar: AppBar(
                  title: Text("การแจ้งเตือน",
                      style:
                          TextStyle(color: Color.fromARGB(255, 255, 255, 255))),
                  leading: IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(
                      Icons.arrow_back,
                      color: Color.fromARGB(255, 255, 255, 255),
                    ),
                  ),
                  centerTitle: true,
                  backgroundColor: Color.fromARGB(255, 47, 114, 185),
                ),
                body:RefreshIndicator(
            onRefresh: reload,
            child: FutureBuilder<List<Noti>>(
                  future: getNoti(),
                  builder: (context, snapshot) {
                    if (snapshot.data == null) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    } else if(snapshot.data?.length==0) {
                      return Container(child: ListView(
                        children: [
                              SizedBox(height: 300,width: 300,),
                             Center(child: Text("ไม่พบการแจ้งเตือนของท่าน"))
                        ],
                      ));
                    }else{
                      List<Noti> Wit = snapshot.data!;
                      return ListView.builder(
                        itemCount: Wit.length,
                        itemBuilder: (context, index) {
                          Noti info = Wit[index];
                          print(info);
                          if (info.noti_id == "0") {
                            return Card(
                              child: InkWell(child: ListTile(
                                leading: CircleAvatar(
                                  child: Icon(Icons.monetization_on),
                                ),
                                title: Text("การแลกเงิน"),
                                subtitle: Text(info.body + '\n\n' + info.date),
                              ),
                              onTap: (){
                                  
                              },
                            ) ,);
                          } else {
                            return Text("nodata");
                          }
                        },
                        /* separatorBuilder: (context, index) {
                          return Divider();
                        },*/
                      );
                    }
                  },
                )),
                floatingActionButton: FloatingActionButton(
                  onPressed: ()async {
                    try {
                        final url = Uri.parse('http://apbcm.ddns.net:5000/api/delNoti?Tel=' +
                          context.read<getTal>().Tel);
                          http.Response response = await http.get(url);

                          if (response.statusCode == 200) {
                            setState(() {
                              
                            });
                            }
                    } catch (e) {
                      print(e);
                    }
                  },
                  child: const Icon(Icons.delete_forever),
                ));
  }
}
