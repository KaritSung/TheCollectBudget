
import 'package:flutter/material.dart';
import 'package:flutter_test_noti/admin/navbar/dashboard.dart';
import 'package:flutter_test_noti/admin/navbar/promotion.dart';
import 'package:flutter_test_noti/admin/navbar/tool.dart';
import 'package:flutter_test_noti/internal/provice/telModel.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
class Adminpage extends StatefulWidget  {
  
  String? disPhone;
  Adminpage(this.disPhone);

  @override
  State<Adminpage> createState() => _AdminpageState();
}

class _AdminpageState extends State<Adminpage> {
  List pages = [Dashboard(),Promo(),Tool()] ;
 
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
            icon: Icon(Icons.campaign),
            label: 'โปรโมชั่น',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.other_houses_outlined),
            label: 'อื่นๆ',
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
                    print("exit-logout");
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