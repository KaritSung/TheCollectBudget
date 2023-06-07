import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test_noti/internal/navbar/_setting/change%20personal.dart';
import 'package:flutter_test_noti/internal/navbar/menu_setting.dart';
import 'package:flutter_test_noti/internal/provice/telModel.dart'; 
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_test_noti/pagethree.dart';
import 'package:pinput/pinput.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
FirebaseAuth auth = FirebaseAuth.instance;


class Otp1 extends StatefulWidget {

  @override
  State<Otp1> createState() => _Otp1State();
} 

class _Otp1State extends State<Otp1> {
  String verificationID = "";
  int? _resendToken;
  TextEditingController _controller = TextEditingController();
  final controller = TextEditingController();
  final focusNode = FocusNode();
  bool showError = false;
  initState() {
    controller.text = "";
    loginWithPhone("+66"+context.read<getTal>().Tel.substring(1));
    
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
    return MaterialApp(
      home: Scaffold(
        body: Container(
          child:Center(
              child: Column(
                children: [
                  const SizedBox(height: 60),
                  Text(
                        'ยืนยันรหัสด้วย OTP',
                        style: GoogleFonts.poppins(
                          fontSize: 24,
                          fontWeight: FontWeight.w700,
                          color: Color.fromRGBO(30, 60, 87, 1),
                        ),
                      ),
                      const SizedBox(height: 24),
                      Text(
                        'กรุณาใส่รหัส OTP เพื่อดำเนินการต่อ',
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          color: Color.fromRGBO(133, 153, 170, 1),
                        ),
                      ),
                      
                      
                      const SizedBox(height: 15),
                      Text(
                        context.read<getTal>().Tel.toString(),
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
                            obscureText: false,
                            obscuringCharacter: '*',
                            length: length,
                            controller: controller,
                            focusNode: focusNode,
                            defaultPinTheme: defaultPinTheme,
                            onCompleted: (pin) {
                             verifyOTP(context); 
                             
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
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                              Text(
                                "ยังไม่ได้รับ OTP Code",
                                  style: GoogleFonts.poppins(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w700,
                                  color: Color.fromRGBO(133, 153, 170, 1),
                              )),
                              
                              TextButton(onPressed: (){
                                  loginWithPhone(context.read<getTal>().Tel.toString());
                              }, child: Text(
                                "กดที่นี่",
                                  style: GoogleFonts.poppins(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w700,
                                  color: Color.fromARGB(255, 222, 55, 55),
                              )))

                          ],
                        ),
                
                ],
              ),
          )
        )
      )
    );
  }

  void verifyOTP(BuildContext context) async {
    try{
    PhoneAuthCredential credential = PhoneAuthProvider.credential(verificationId: verificationID, smsCode: controller.text);

    await auth.signInWithCredential(credential).then((value){
      print("You are logged in successfully");
      Fluttertoast.showToast(
          msg: "OTP ถูกต้อง",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Color.fromARGB(255, 54, 244, 111),
          textColor: Color.fromARGB(255, 255, 255, 255),
          fontSize: 16.0
      );
      
      _fetchData(context);
    });
    }catch(error){
      print("OTP code is wrong!!!!!");
      print(error);
      Fluttertoast.showToast(
          msg: "รหัส OTP ไม่ถูกต้องกรุณาลองใหม่",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 3,
          backgroundColor: Color.fromARGB(255, 244, 54, 67),
          textColor: Color.fromARGB(255, 255, 255, 255),
          fontSize: 16.0
      );
    } 
  }



void loginWithPhone(String phone) async {
  print("begin otp metode");
  print("+66"+context.read<getTal>().Tel.substring(1));
    auth.verifyPhoneNumber(
      phoneNumber: "+66"+context.read<getTal>().Tel.substring(1),
      timeout: const Duration(seconds: 30,),
      verificationCompleted: (PhoneAuthCredential credential) async {
        await auth.signInWithCredential(credential).then((value){
          print("You are logged in successfully");
        });
      },
      verificationFailed: (FirebaseAuthException e) {
        print(e.message);
      },
      codeSent: (String verificationId, int? resendToken) {
        print("OTP IS SENT NOW!");
        verificationID = verificationId;
        _resendToken = resendToken;
      },
      codeAutoRetrievalTimeout: (String verificationId) {
       // verificationId = verificationID;
       verificationID = 'null';
        print("auto-timeout");
      },
      forceResendingToken: _resendToken,

      
    );
       print(verificationID);
  
       
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
    Navigator.of(context).push(MaterialPageRoute(builder: (context)=> menuSetting()));
    
  }
}

  