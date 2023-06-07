import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_test_noti/pagetwo.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/services.dart';
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

const AndroidNotificationChannel channel = AndroidNotificationChannel(
  'high_importance_channel', // id
  'High Importance Notifications', // title
  description: 'This channel is used for important notifications.', // description
  importance: Importance.max,
);


var url2;

class Pageone extends StatefulWidget {
  Pageone({Key? key}) : super(key: key);

  @override
  State<Pageone> createState() => _PageoneState();
  
}

class _PageoneState extends State<Pageone> {
  String? _verificationCode;
  String? message;
  String channelId = "1000";
  String channelName = "FLUTTER_NOTIFICATION_CHANNEL";
  String channelDescription = "FLUTTER_NOTIFICATION_CHANNEL_DETAIL";
  FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
  FirebaseAuth auth = FirebaseAuth.instance;
   bool otpVisibility = false;

  String verificationID = "";
  TextEditingController phone = TextEditingController();
  @override
  initState() {
    var initializationSettingsAndroid =
        //const AndroidInitializationSettings('notiicon');//@drawable/ic_firebase_notification
    const AndroidInitializationSettings('@drawable/ic_stat_notiicon');

    var initializationSettingsIOS = IOSInitializationSettings(
        onDidReceiveLocalNotification: (id, title, body, payload) async {
      print("onDidReceiveLocalNotification called.");
    });

    var initializationSettings =  InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS);

    flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: (payload) async {
      // when user tap on notification.
      print("onSelectNotification called.");
      setState(() {
        message = payload;
      });
    });
    initFirebaseMessaging();
   // loaddata();
    phone.clear();

    
    super.initState();

  }
  Widget buidphone() => TextField(
      controller: phone,
      decoration: InputDecoration(
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
          ),
          labelText: 'เบอร์โทรศัพท์',
      ),
      maxLength: 10,
      keyboardType: TextInputType.number,
      inputFormatters: <TextInputFormatter>[
   // for below version 2 use this
      FilteringTextInputFormatter.allow(RegExp(r'[0-9]+[0-9]*')), 

  ],
  );
  
  void initFirebaseMessaging() {

FirebaseMessaging.onMessage.listen((RemoteMessage message) {
  RemoteNotification notification = message.notification!;
  AndroidNotification? android = message.notification?.android;

  // If `onMessage` is triggered with a notification, construct our own
  // local notification to show to users using the created channel.
  if (android != null) {
    flutterLocalNotificationsPlugin.show(
        notification.hashCode,
        notification.title,
        notification.body,
        NotificationDetails(
          android: AndroidNotificationDetails(
            channel.id,
            channel.name,
            channelDescription:  channel.description,
            icon: android.smallIcon,
            // other properties...
          ),
        ));
  //   var a = notification.title.toString();
  //   var b = notification.body.toString();
  //  sendNotification(a,b);
  }
 
});

    firebaseMessaging.getToken().then((String? token) {
      assert(token != null);
      print("Token : $token");
    });

 
  }



  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text("The Collect Budget"),
        ),
        body: Container(
          padding: EdgeInsets.all(30),
          
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              //crossAxisAlignment: CrossAxisAlignment.center,
              children: [
               
                const SizedBox(height: 5),
                Image.asset('assets/images/login/LOGO.png'
                ,height: 250,width: 250,
                ),
                const SizedBox(height: 30),
                buidphone(),
                
                ElevatedButton(
                  
                    onPressed: () {
                      
                      if(phone.text.length == 10){
                        
                              if(phone.text[0]=="0"){
                                  String str =  '+66'+phone.text.substring(1);
                                  Navigator.of(context).push(MaterialPageRoute(builder: (context)=> Pagetwo(str,phone.text.toString())));
                                  //Navigator.pushNamed(context, "/pagetest");

                              }else{
                                Fluttertoast.showToast(
                                      msg: "รูปแบบเบอร์โทรศัพท์ไม่ถูกต้อง",
                                      toastLength: Toast.LENGTH_SHORT,
                                      gravity: ToastGravity.BOTTOM,
                                      timeInSecForIosWeb: 3,
                                      backgroundColor: Color.fromARGB(255, 244, 54, 67),
                                      textColor: Color.fromARGB(255, 255, 255, 255),
                                      fontSize: 16.0
                                  );
                              }
                      }else{
                          Fluttertoast.showToast(
                                      msg: "รูปแบบเบอร์โทรศัพท์ไม่ถูกต้อง",
                                      toastLength: Toast.LENGTH_SHORT,
                                      gravity: ToastGravity.BOTTOM,
                                      timeInSecForIosWeb: 3,
                                      backgroundColor: Color.fromARGB(255, 244, 54, 67),
                                      textColor: Color.fromARGB(255, 255, 255, 255),
                                      fontSize: 16.0
                                  );
                      }
                      //Navigator.of(context).push(MaterialPageRoute(builder: (context)=> Pagetwo(phone.text)));

                    },
                    child: const Text('เข้าสู่ระบบ / สมัครสมาชิก \n     โดยเบอร์โทรศัพท์'),
                    
                  ),
              ],
            ),
        ),
      ),
      
    );
  }

  
 void loginWithPhone() async {
  //auth.setSettings(appVerificationDisabledForTesting: true);
    auth.verifyPhoneNumber(
      phoneNumber: '+66929355603',
      verificationCompleted: (PhoneAuthCredential credential) async {
        await auth.signInWithCredential(credential).then((value){
          print("You are logged in successfully");
        });
      },
      verificationFailed: (FirebaseAuthException e) {
        print(e.message);
      },
      codeSent: (String verificationId, int? resendToken) {
        otpVisibility = true;
        verificationID = verificationId;
        setState(() {print("START_SENT");
                    Navigator.pushNamed(context, "/pagetwo");
        });
        
      },
      codeAutoRetrievalTimeout: (String verificationId) {

      },
      
    );
       
  }
  
}
Future loaddata() async{
      final ref = FirebaseStorage.instance.ref().child('test.jpg');
      // no need of the file extension, the name will do fine.
      String url = await ref.getDownloadURL();
      return url;

  }

