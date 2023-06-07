import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:http/http.dart' as http;
class ReportDetail extends StatefulWidget {
  String id;
  String firstname;
  String lastname;
  String date;
  String topic;
  String body;
  String pic;
  String tel;
  ReportDetail(this.id,this.firstname,this.lastname,this.tel,this.date,this.topic,this.body,this.pic);

  @override
  State<ReportDetail> createState() => _ReportDetailState();
}

class _ReportDetailState extends State<ReportDetail> {
  String body ="";
  firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;

  @override
  void initState() {
    body = "เนื้อหา : "+widget.body;
    print(widget.id);
    super.initState();
    
  }
  @override
  void dispose() {
    
    super.dispose();
  }
  Future loaddata()async{
      try{
        if(widget.pic!='n/a'){
          final ref = FirebaseStorage.instance.ref("report").child(widget.pic+".jpg");
          String url = await ref.getDownloadURL();
          return url;
        }else{
          return 'n/a';
        }
      }catch(e){
        return null;
      }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
                  
                  appBar: AppBar(
                    
                  title: Text("รายละเอียดปัญหา",style: TextStyle(color: Color.fromARGB(255, 255, 255, 255))),
                  leading: IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: const Icon(
                        Icons.arrow_back,
                        color: Color.fromARGB(255, 255, 255, 255),
                      ),),
                  centerTitle: true,
                  backgroundColor: Color.fromARGB(255, 47, 114, 185),
                ),
                body: ListView(children: [
                   Column(
                    children: [
                    SizedBox(height: 15.0,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Padding(
                      padding: EdgeInsets.all(10),
                      child: 
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("ผู้แจ้ง : "+widget.firstname+" "+widget.lastname,style: TextStyle(color: Color.fromARGB(255, 0, 0, 0), fontSize: 16.0)),
                                Text("เบอร์โทรผู้แจ้ง : "+widget.tel,style: TextStyle(color: Color.fromARGB(255, 0, 0, 0), fontSize: 16.0)),
                                Text("หัวข้อปัญหา : "+widget.topic,style: TextStyle(color: Color.fromARGB(255, 0, 0, 0), fontSize: 16.0)),
                                
                                     SizedBox(
                                              width: 300,
                                              child: Text(
                                              body.toString(),
                                              ),
                                          ),
                                

                               
                            ],),
                    ),
                    ],),
                    
                    Padding(
                        padding: EdgeInsets.all(10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                              Card(
                                child: Container(
                                  height: 500,
                                  width: 900,
                                  child: FutureBuilder(
                                    future: loaddata(),
                                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                                        if(snapshot.data!=null){
                                          if(snapshot.data!='n/a'){
                                                  print("loadimg:"+snapshot.data);
                                                  return Padding(padding: EdgeInsets.all(10),
                                                  child: Image.network(snapshot.data.toString()),
                                                  );
                                          }else{
                                            return Icon(Icons.no_photography);
                                          }
                                        }else{
                                            return Icon(Icons.no_photography);
                                        }
                                    },
                                  ),  
                                ), 
                              )
                          ]
                          ,),
                        ),
                    
                    ElevatedButton(onPressed: (){
                        _fetchData(context);
                    }, child: Text("ยืนยันการแก้ไขปัญหา")),
                    
                    SizedBox(height: 30.0,),
                  ],) 
                  
    ,]));
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
    //await Future.delayed(const Duration(seconds: 2));

    // Close the dialog programmatically
    //Navigator.of(context).pop();
    try{
         var response = await http.post(
                  Uri.parse("http://apbcm.ddns.net:5000/api/delReport"),
                  body: {
                      "id":widget.id
                  }
                
              );

              if(response.statusCode==200){
                  
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              }
    }catch(e){
        print("error-sent");
    }
  }
}