import 'package:flutter/material.dart';
import 'package:flutter_test_noti/internal/homepage.dart';
import 'package:flutter_test_noti/internal/provice/telModel.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pinput/pinput.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
class Pinpage extends StatefulWidget {
  String?Pin;
  var money;

  Pinpage(this.Pin,this.money);

  @override
  State<Pinpage> createState() => _PinpageState();
}

class _PinpageState extends State<Pinpage> {
  TextEditingController _controller = TextEditingController();
  final controller = TextEditingController();
  final focusNode = FocusNode();
  bool showError = false;

  @override
  void initState() {
    super.initState();
    
  }

  @override
  Widget build(BuildContext context) {
    final length = 6;
    const borderColor = Color.fromRGBO(114, 178, 238, 1);
    const errorColor = Color.fromRGBO(255, 234, 238, 1);
    const fillColor = Color.fromRGBO(222, 231, 240, .57);
    final defaultPinTheme = PinTheme(
      width: 56,
      height: 60,
      textStyle: GoogleFonts.poppins(
        fontSize: 22,
        color: Color.fromRGBO(30, 60, 87, 1),
      ),
      decoration: BoxDecoration(
        color: fillColor,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.transparent),
      ),
    );

    return /*WillPopScope(child :*/ MaterialApp(
      home: Scaffold(
        body: Container(
          child:Center(
              child: Column(
                children: [
                  const SizedBox(height: 60),
                  Text(
                        'รหัสเข้าใช้งาน',
                        style: GoogleFonts.poppins(
                          fontSize: 24,
                          fontWeight: FontWeight.w700,
                          color: Color.fromRGBO(30, 60, 87, 1),
                        ),
                      ),
                      const SizedBox(height: 24),
                      Text(
                        'กรุณาใส่รหัส PIN เข้าใช้งาน',
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          color: Color.fromRGBO(133, 153, 170, 1),
                        ),
                      ),
                      
                      
                      const SizedBox(height: 15),
                      Text(
                       "",
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          color: Color.fromRGBO(30, 60, 87, 1),
                        ),
                      ),
                      const SizedBox(height: 15),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children : [
                        Padding(
                          padding: EdgeInsets.only(left: 30.0),
                          child:SizedBox(
                                height: 100,
                                child: Image.asset('assets/images/login/mobile.png'
                            ),
                          ),
                          ),
                        ], 
                      ),
                      const SizedBox(height: 30),
                      
                  SizedBox(
                          height: 68,
                          child: Pinput(
                            obscureText: true,
                            obscuringCharacter: '●',
                            length: length,
                            controller: controller,
                            focusNode: focusNode,
                            defaultPinTheme: defaultPinTheme,
                            onCompleted: (pin) {
                              checkPin();
                              controller.text = "";
                            },
                            focusedPinTheme: defaultPinTheme.copyWith(
                              height: 68,
                              width: 64,
                              decoration: defaultPinTheme.decoration!.copyWith(
                                border: Border.all(color: borderColor),
                              ),
                            ),
                            errorPinTheme: defaultPinTheme.copyWith(
                              decoration: BoxDecoration(
                                color: errorColor,
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        /*Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                              
                              
                              TextButton(onPressed: (){
    
                              }, child: Text(
                                "กดที่นี่",
                                  style: GoogleFonts.poppins(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w700,
                                  color: Color.fromARGB(255, 222, 55, 55),
                              )))

                          ],
                        ),*/
                
                ],
              ),
          )
        )
      )
    );
    /*onWillPop: () async {
        final shouldPop = await showDialog<bool>(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text('คุณแน่ใจหรือไม่ที่จะออกจากหน้านี้'),
              actionsAlignment: MainAxisAlignment.spaceBetween,
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pushNamedAndRemoveUntil('/', (Route<dynamic> route) => false);
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
      },*/
    

  }

  void checkPin(){
      if(controller.text==widget.Pin){
          Fluttertoast.showToast(
          msg: "รหัส Pin ถูกต้อง",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Color.fromARGB(255, 54, 244, 111),
          textColor: Color.fromARGB(255, 255, 255, 255),
          fontSize: 16.0
      );
      _fetchData(context);
      //Navigator.of(context).push(MaterialPageRoute(builder: (context)=> Homepage(widget.disPhone!)));
      }else{
        Fluttertoast.showToast(
          msg: "รหัส Pin ไม่ถูกต้องกรุณาลองใหม่",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 3,
          backgroundColor: Color.fromARGB(255, 244, 54, 67),
          textColor: Color.fromARGB(255, 255, 255, 255),
          fontSize: 16.0
      );
      }
  }

void _fetchData(BuildContext context) async {
    // show the loading dialog
    showDialog(
        // The user CANNOT close this dialog  by pressing outsite it
        barrierDismissible: false,
        context: context,
        builder: (_) {
          return Dialog(
            // The background color
            backgroundColor: Colors.white,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  // The loading indicator
                  CircularProgressIndicator(),
                  SizedBox(
                    height: 15,
                  ),
                  // Some text
                  Text('Loading...')
                ],
              ),
            ),
          );
        });

    // Your asynchronous computation here (fetching data from an API, processing files, inserting something to the database, etc)
    await Future.delayed(const Duration(seconds: 2));
    try{
      var response = await http.post(
          Uri.parse("http://apbcm.ddns.net:5000/api/updateMoney?Tel="+context.read<getTal>().Tel),
          body: {
            "user_Money":widget.money.toString()
          }
      );
      
     
      print(response.statusCode);
      if(response.statusCode==200){
        print(response.body);
        print(response.statusCode);
        Navigator.of(context).pop();
        Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>Homepage(context.read<getTal>().Tel)), (Route<dynamic> route) => false);
      }else{
        print("error-sent");
      }
  } catch(e){
      print("Error-timeout");
      print(e);
  }

  }

}