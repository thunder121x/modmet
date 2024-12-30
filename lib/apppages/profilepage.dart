import 'package:auto_size_text/auto_size_text.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:kf_drawer/kf_drawer.dart';
import 'detailpage.dart';
import 'package:modmet/readdata/getusername.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
class Profilepage extends KFDrawerContent {
  Profilepage({Key? key});

  @override
  State<Profilepage> createState() => _ProfilepageState();
}

class _ProfilepageState extends State<Profilepage> {
  final String userid = FirebaseAuth.instance.currentUser!.uid;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Center(child: Column(children: <Widget>[
        Row(children: <Widget>[
          ClipRRect(
            borderRadius: BorderRadius.all(Radius.circular(32)),
            child: Material(
              shadowColor: Colors.transparent,
              color:  Colors.transparent,
              child: IconButton(icon: Icon(Icons.menu,color: Colors.black,),
              onPressed: widget.onMenuPressed,
              ),
            ),
          )
        ],),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Profile",style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            SizedBox(height: 30,),
          ],
        ),
        Expanded(
                child: Column(children: [
                  GetUserImage(documentId: userid, cirRadius: 100, sideLenght: 240),
                              
                  Padding(
                    padding: const EdgeInsets.all(25.0),
                    child: Column(children:[
                    // Row(children: [Text("Name: ",style: TextStyle(fontSize: 20),),GetUserData(documentId: userid, field: "name", textStyle: TextStyle(fontSize: 20), maxLines: 1,)],),
                    // SizedBox(height: 10,),
                    // Row(children: [Text("Surname: ",style: TextStyle(fontSize: 20)),GetUserData(documentId: userid, field: "surname", textStyle: TextStyle(fontSize: 20), maxLines: 1,)],),
                    // SizedBox(height: 10,),
                    Row(mainAxisAlignment: MainAxisAlignment.center,children: [GetUserData(documentId: userid, field: "name", textStyle: TextStyle(fontSize: 25,fontWeight: FontWeight.bold), maxLines: 1,),Text(" ",style: TextStyle(fontSize: 25)),GetUserData(documentId: userid, field: "surname", textStyle: TextStyle(fontSize: 25, fontWeight: FontWeight.bold), maxLines: 1,)],),
                    SizedBox(height: 15,),
                    Row(children: [Text("E-mail: ",style: TextStyle(fontSize: 20)),GetUserData(documentId: userid, field: "email", textStyle: TextStyle(fontSize: 20), maxLines: 1,)],),
                    SizedBox(height: 10,),
                    Row(children: [Text("Mod-ID: ",style: TextStyle(fontSize: 20)),Padding(
              padding: const EdgeInsets.symmetric(horizontal :5.0),
              child: new GestureDetector(
                child: new Icon(Icons.copy,size: 16,),
                onTap: () {
                  Clipboard.setData(new ClipboardData(text: userid)).then((value) => 
                                      Fluttertoast.showToast(msg: "Copied" ,gravity: ToastGravity.CENTER))
                  ;
                }
              ),
            ),
                    Expanded(child: AutoSizeText("${userid}",style: TextStyle(fontSize: 18),minFontSize: 14,maxLines: 1,)),


                    ])
                    ]),
                  ),
                ],)
              ),
        // Expanded(child: Column(mainAxisAlignment: MainAxisAlignment.center,children: [Text('Profile')],))
      ],)),
    );
  }
}