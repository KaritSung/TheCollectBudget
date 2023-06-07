import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:expansion_tile_card/expansion_tile_card.dart';
import 'package:flutter_test_noti/internal/provice/telModel.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';



class User_promoView extends StatefulWidget {
  User_promoView({Key? key}) : super(key: key);

  @override
  State<User_promoView> createState() => _User_promoViewState();
}

class _User_promoViewState extends State<User_promoView> {
  final GlobalKey<ExpansionTileCardState> cardA = new GlobalKey();
  @override
  Widget build(BuildContext context) {
    Future load() async {
      try {
        final url = Uri.parse(
            'http://apbcm.ddns.net:5000/api/getPromotionUser?Tel=' +
                context.read<getTal>().user_tel);
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
        return null;
        print(e);
      }
    }

    return Scaffold(
      appBar: AppBar(

        automaticallyImplyLeading: true,
        title: Text("โปรโมชั่น",
            style: TextStyle(color: Color.fromARGB(255, 255, 255, 255))),
        centerTitle: true,
        backgroundColor: Color.fromARGB(255, 47, 114, 185),
      ),
      body: FutureBuilder(
        future: load(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.data != null) {
            return ExpansionTileCard(
              baseColor: Colors.cyan[50],
              expandedColor: Colors.red[50],
              key: cardA,
              leading: CircleAvatar(
                child: Icon(Icons.campaign),
              ),
              title: Text("โปรโมชั่น"),
              subtitle: Text("โปรโมชั่นสำหรับสมาชิกใหม่"),
              children: <Widget>[
                Divider(
                  thickness: 1.0,
                  height: 1.0,
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16.0,
                      vertical: 8.0,
                    ),
                    child: Text(
                      "จำนวนคงเหลือ: "+snapshot.data['promotion_Bottle'].toString()+' ขวด\n'
                      "ได้รับตัวคูณราคาขวด x"+snapshot.data['promotion_Multi'].toStringAsFixed(1)+' เท่า\n',
                      style: Theme.of(context)
                          .textTheme
                          .bodyText2
                          ?.copyWith(fontSize: 16),
                    ),
                  ),
                ),
                ButtonBar(
                  alignment: MainAxisAlignment.spaceAround,
                  buttonHeight: 52.0,
                  buttonMinWidth: 90.0,
                  children: <Widget>[
                    
                    FlatButton(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4.0)),
                      onPressed: () {cardA.currentState?.collapse();},
                      child: Column(
                        children: <Widget>[
                          Icon(Icons.close),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 2.0),
                          ),
                          Text('ปิด'),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            );
          } else {
            return Center(
              child: Text("ไม่พบโปรโมชั่น"),
            );
          }
        },
      ),
    );
  }
}
