import '../main.dart';
import 'detailpage.dart';
import 'package:path/path.dart';
import 'package:flutter/material.dart';
import 'package:kf_drawer/kf_drawer.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:modmet/readdata/getusername.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:form_field_validator/form_field_validator.dart';
class Friendspage extends KFDrawerContent {
  Friendspage({Key? key});

  @override
  State<Friendspage> createState() => _FriendspageState();
}

class _FriendspageState extends State<Friendspage> {
  final String userid = FirebaseAuth.instance.currentUser!.uid;
  List<String> alldata =[];
  final formKey = GlobalKey<FormState>();

  void initState(){
    
            print("allData = $alldata");
    Future<QuerySnapshot?> getData() async {
        FirebaseFirestore.instance
            .collection('users')
            .get()
            .then((QuerySnapshot? querySnapshot) {
          querySnapshot!.docs.forEach((doc) {
            alldata = doc["item_text_"];
            print("allData = $alldata");
            //  print("getData = ${doc["item_text_"]}");
          });
        });
      }
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    String friendId = '';
    return Scaffold(body: SafeArea(
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
            Text("Friends",style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            SizedBox(height: 30,),
          ],
        ),
            Expanded(
              child: 
            Container(
              child: getFriendsList(documentId: userid)),
            ),
        // Expanded(child: Column(mainAxisAlignment: MainAxisAlignment.center,children: [Text('Friends')],))
      ],
      ),
      ),

    ),floatingActionButton: FloatingActionButton(
        onPressed: () {
          
            showDialog(
                context: context,
                builder: (BuildContext context) {
                  return LoaderOverlay(
                useDefaultLoading: false,
                overlayWidget: Center(
                  child: 
                  SpinKitCubeGrid(
                    color: Colors.red[300],
                    size: 50.0,
                  ),
                ),
                    child: AlertDialog(
                      backgroundColor: Color.fromRGBO(253, 248, 241, 1),
                      // backgroundColor: Color.fromRGBO(252, 252, 252, 1),
                      iconColor: Colors.black87,
                      iconPadding: EdgeInsets.only(top: 30.0,bottom: 0),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
                      icon: Icon(Icons.person_add,size: 40,),
                      content: Stack(
                        // overflow: Overflow.visible,
                        children: <Widget>[
                          Form(
                            key:formKey,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[

                                SizedBox(height: 40,child: Center(child: Text("Add Friend",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold,color: Colors.grey[850]),),),),
                                Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: 
                                  Container(
                      decoration: BoxDecoration(
                        
                        color: Colors.grey[200],
                        border: Border.all(color: Colors.white),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 20.0),
                        child: TextFormField(
                            validator: RequiredValidator(errorText: "Please field your your friendID",),
                            onChanged: (String friendId_) => friendId = friendId_,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: 'Mod-ID',),
                              ),
                      ))
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: ElevatedButton(

                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color.fromRGBO(247,110,17,1),
                              foregroundColor: Color.fromRGBO(251, 157, 150, 1),
                              shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(12))),
                              shadowColor: Colors.white,
                            ),
                                      // color: Colors.white,
                                      
                                      child: Text("Add",style: TextStyle(color: Colors.white),),
                                      onPressed: () async{
                                        if (formKey.currentState!.validate()) {
                                        context.loaderOverlay.show();
                                          formKey.currentState?.save();
                                        FirebaseFirestore.instance
                                        .collection('users')
                                        .doc(userid)
                                        .get()
                                        .then((DocumentSnapshot documentSnapshot) async {
                                          if (documentSnapshot.exists) {
                                            // setState(() {
                                            List<dynamic> allfriend =[];
                                            allfriend.addAll(documentSnapshot.get(FieldPath(['friends'])));
                                            allfriend.add(friendId);
                                            print(allfriend[0]);                                        
                                            await FirebaseFirestore.instance.collection("users").doc(userid).update({
                                                                              "friends" : allfriend,
                                                                            })
                                                                            .then((value){
                                        FirebaseFirestore.instance
                                        .collection('users')
                                        .doc(friendId)
                                        .get()
                                        .then((DocumentSnapshot documentSnapshotFriend) async {
                                          if (documentSnapshotFriend.exists) {
                                            // setState(() {
                                            List<dynamic> allfriend =[];
                                            allfriend.addAll(documentSnapshotFriend.get(FieldPath(['friends'])));
                                            allfriend.add(userid);
                                            print(allfriend[0]);                                        
                                            await FirebaseFirestore.instance.collection("users").doc(friendId).update({
                                                                              "friends" : allfriend,
                                                                            })
                                                                            .then((value){
                                                                              context.loaderOverlay.hide();
                                                                              formKey.currentState?.reset();
                                                                              Fluttertoast.showToast(msg: "Added");
                                                                              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context){
                                          return MainWidgetXpage(initialPage: Friendspage(),);
                                        }));
                                                                            });
                                            print('Document data: ${documentSnapshotFriend.data()}');
                                          } else {
                                            print('Document does not exist on the database');
                                          }
                                        });
                                                                            });
                                            print('Document data: ${documentSnapshot.data()}');
                                          } else {
                                            print('Document does not exist on the database');
                                          }
                                        });
                                          // AddFriend(documentId: userid, friendId: friendId);
                                        }
                                      },
                                    ),
                                  ),
                                
                              ],
                            ),
                          ),
                          Positioned(
                            right: 10.0,
                            top: 3.0,
                            child: InkResponse(
                              onTap: () {
                                Navigator.of(context).pop();
                              },
                              child: CircleAvatar(
                                radius: 10,
                                child: Icon(Icons.close_rounded,size: 24,color: Colors.black38,),
                                backgroundColor: Colors.transparent,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                });
        },
        backgroundColor: Color.fromRGBO(247,110,17,1),
        child: const Icon(Icons.person_add),
      )

    );
  }
}