
import 'package:flutter/material.dart';
import 'package:flutter_test_noti/pagethree.dart';

class pagetest extends StatefulWidget {
  pagetest({Key? key}) : super(key: key);

  @override
  State<pagetest> createState() => _pagetestState();
}

class _pagetestState extends State<pagetest> {
  @override
  Widget build(BuildContext context) {
    return Container(
        child: ElevatedButton(onPressed: (){
            
        }, child: Text("TEST")),
    );
  }
}