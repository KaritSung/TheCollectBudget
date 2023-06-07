import 'package:flutter/material.dart';
import 'package:flutter_test_noti/admin/userdata/his/Etab1.dart';
import 'package:flutter_test_noti/admin/userdata/his/Etab2.dart';
import 'package:flutter_test_noti/internal/homepage.dart';
import 'package:flutter_test_noti/internal/inHistory/tab1.dart';
import 'package:flutter_test_noti/internal/inHistory/tab2.dart';
import 'package:flutter_test_noti/internal/navbar/home.dart';
import 'package:flutter_test_noti/internal/inHistory/tab1.dart';
class Ex_history extends StatefulWidget {
  @override
  State<Ex_history> createState() => _Ex_historyState();
}

class _Ex_historyState extends State<Ex_history> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
              centerTitle: true,
              backgroundColor: Color.fromARGB(255, 47, 114, 185),
              bottom: TabBar(
                  indicatorColor: Color.fromARGB(255, 255, 255, 255),
                  labelColor: Color.fromARGB(255, 255, 255, 255),
                  tabs: [
                    Tab(text: 'การแลกขวด'),
                    Tab(
                      text: 'การแลกเงิน',
                    ),
                  ]),
              title: const Text(
                'ประวัติการใช้งาน',
                style: TextStyle(color: Color.fromARGB(255, 255, 254, 254)),
              ),
             ),
          body: TabBarView(
            // ส่วนของเนื้อหา tab
            children: [
              Etab1(),
              Etab2(),
              ],
          ),
        ));
  }
}
