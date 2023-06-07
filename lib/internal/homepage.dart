import 'package:flutter/material.dart';
import 'package:flutter_test_noti/internal/navbar/exchange.dart';
import 'package:flutter_test_noti/internal/navbar/history.dart';
import 'package:flutter_test_noti/internal/navbar/home.dart';
import 'package:flutter_test_noti/internal/navbar/setting.dart';
import 'package:flutter_test_noti/internal/provice/telModel.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
class Homepage extends StatefulWidget  {
  
  String? disPhone;
  Homepage(this.disPhone);

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  List pages = [home(),history(),ex(),setting()] ;
 
  int _selectedIndex = 0;
  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
      @override
      void initState() { 
        context.read<getTal>().setTel(widget.disPhone.toString());
        super.initState();
      }

  
  void onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
     
       return WillPopScope(child: Scaffold(
     
      body: pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'หน้าหลัก',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.battery_full_outlined),
            label: 'ประวัติ',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.monetization_on_outlined),
            label: 'แลกเงิน',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'บัญชี',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Color.fromARGB(255, 10, 88, 156),
        unselectedItemColor: Color.fromARGB(255, 51, 143, 228),
        onTap: onItemTapped,
      ),
    
    ),onWillPop: () async {
        final shouldPop = await showDialog<bool>(
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
                            "user_Token":'n/a',
                          }
                          );
                          if(res.statusCode==200){
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
        return shouldPop!;
      },
    );
  }

  
}

