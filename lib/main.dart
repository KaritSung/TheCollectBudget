import 'package:flutter/material.dart';
import 'package:flutter_test_noti/admin/userdata/usertool.dart';
import 'package:flutter_test_noti/internal/navbar/menu_setting.dart';
import 'package:flutter_test_noti/pageOne.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_test_noti/pagethree.dart';
import 'package:flutter_test_noti/test.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_test_noti/pagetwo.dart';
import 'package:provider/provider.dart';
import 'internal/homepage.dart';
import 'package:flutter_test_noti/internal/provice/telModel.dart';




Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  await Firebase.initializeApp();

  print("Handling a background message: ${message.messageId}");
}



void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  Provider.debugCheckInvalidValueType = null;
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Provider(create: (context)=>getTal(),
    child: MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => Pageone(),
        '/pagethree': (context) => pagethree('n/a') ,
        '/homepage' : (context) => Homepage('n/a') ,
        '/usertool': (context) => Usertool() ,
        '/menusetting' :(context) => menuSetting()
        
        
        
      },
    )
    );
  }

  MaterialApp buildMaterialApp() {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => Pageone(),
        '/pagethree': (context) => pagethree('n/a') ,
        '/homepage' : (context) => Homepage('n/a') ,
        
        
        
      },
    );
  }
}
