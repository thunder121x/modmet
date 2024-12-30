import 'lobby/lobby.dart';
import 'decisiontree.dart';
import 'firebase_options.dart';
import 'apppages/homepage.dart';
import 'apppages/eventspage.dart';
import 'apppages/profilepage.dart';
import 'apppages/friendspage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:kf_drawer/kf_drawer.dart';
import 'package:modmet/lobby/signin.dart';
import 'package:modmet/maps/tracking_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:modmet/apppages/friendspage.dart';
import 'package:modmet/readdata/getusername.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:modmet/apppages/classbuilder.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:modmet/maps/tracklocationfriends.dart';
import 'package:firebase_storage/firebase_storage.dart';
void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.deepOrange,
      ),
      debugShowCheckedModeBanner: false,
          home: DecisionTree(),
    );
    }
}

class MainWidget extends StatefulWidget {
  const MainWidget({super.key});

  @override
  State<MainWidget> createState() => _MainWidgetState();
}

class _MainWidgetState extends State<MainWidget> {
  
  KFDrawerController? _drawerController;
  final String userid = FirebaseAuth.instance.currentUser!.uid;
  //document IDs
  List<String> docIDs = [];
  //get docIDs
  Future getDocId() async{
    await FirebaseFirestore.instance.collection("users").get()
    .then((snapshot) => snapshot.docs.forEach((document) {
      print(document.reference);
      docIDs.add(document.reference.id);
    }));

  }
  @override
  
  void initState(){
    
    // getDocId();
    super.initState();
    _drawerController = KFDrawerController(
      initialPage: Homepage(),
      items: [
        KFDrawerItem.initWithPage(
          text: Text('Home',style: TextStyle(color: Colors.white,fontSize: 18),),
          icon: Icon(Icons.home,color: Colors.white,),
          page: Homepage(),
        ),
        KFDrawerItem.initWithPage(
          text: Text('Maps',style: TextStyle(color: Colors.white,fontSize: 18),),
          icon: Icon(Icons.map,color: Colors.white,),
          page: TrackLocationWithFriends(),
          // page: TrackingLocation(),
        ),
        KFDrawerItem.initWithPage(
          text: Text('Friends',style: TextStyle(color: Colors.white,fontSize: 18),),
          icon: Icon(Icons.people,color: Colors.white,),
          page: Friendspage(),
        ),
        KFDrawerItem.initWithPage(
          text: Text('Events',style: TextStyle(color: Colors.white,fontSize: 18),),
          icon: Icon(Icons.event,color: Colors.white,),
          page: Eventspage(),
        ),
        KFDrawerItem.initWithPage(
          text: Text('Profile',style: TextStyle(color: Colors.white,fontSize: 18),),
          icon: Icon(Icons.person,color: Colors.white,),
          page: Profilepage(),
        ),
      ],
      );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:  KFDrawer(
        controller: _drawerController!,
        header: Align(alignment: Alignment.centerLeft,
              child: 
              Container(
              padding: EdgeInsets.symmetric(horizontal: 16),
              width: MediaQuery.of(context).size.width*0.8,
              child: Row(
                children: <Widget>[
                  GetUserImage(documentId: userid, cirRadius: 25,sideLenght: 50,),
                  SizedBox(width: 10,),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                          SizedBox(
                            width: MediaQuery.of(context).size.width*0.47,
                            child: getFullName(documentId: userid,textStyle: TextStyle(fontSize: 17,color: Colors.white))),
                      new SizedBox(height: 2,),
                      new Text('status',style: new TextStyle(fontSize: 15, color: Colors.grey),),

                    ],
                  )
                ],
              ),
        ),
        ),
        footer: KFDrawerItem(text: TextButton(onPressed: () {
          FirebaseAuth.instance.signOut().then((value) {
            Navigator.pushReplacement(context, 
              MaterialPageRoute(builder: (context){
                return Signin();
              })
            );
          },
          );},
        child: Row(
          children: [Icon(Icons.logout,color: Colors.grey[300],),
            Text('Logout',style: TextStyle(color: Colors.grey[300],fontSize: 18)),
          ],
        ),
        ),
        ),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.topRight,
            // colors: [Color.fromARGB(255, 15, 13, 11), Color.fromRGBO(247,110,17,1)],
            colors: [Color.fromRGBO(254,109,2,1), Color.fromRGBO(255,178,70,1)],
            // colors: [Color.fromRGBO(247,110,17,1), Color.fromRGBO(247,110,17,1)],
            tileMode: TileMode.repeated,
          )
        ),
      ),
    );
  }
}

class MainWidgetXpage extends StatefulWidget {
  const MainWidgetXpage({super.key,required this.initialPage});
  final KFDrawerContent initialPage;
  @override
  State<MainWidgetXpage> createState() => _MainWidgetXpageState();
}

class _MainWidgetXpageState extends State<MainWidgetXpage> {
  KFDrawerController? _drawerController;
  final String userid = FirebaseAuth.instance.currentUser!.uid;
  //document IDs
  List<String> docIDs = [];
  //get docIDs
  Future getDocId() async{
    await FirebaseFirestore.instance.collection("users").get()
    .then((snapshot) => snapshot.docs.forEach((document) {
      print(document.reference);
      docIDs.add(document.reference.id);
    }));

  }
  @override

  void initState(){
    // getDocId();
    super.initState();
  // void start(){
    _drawerController = KFDrawerController(
      initialPage: widget.initialPage,
      items: [
        KFDrawerItem.initWithPage(
          text: Text('Home',style: TextStyle(color: Colors.white,fontSize: 18),),
          icon: Icon(Icons.home,color: Colors.white,),
          page: Homepage(),
        ),
        KFDrawerItem.initWithPage(
          text: Text('Maps',style: TextStyle(color: Colors.white,fontSize: 18),),
          icon: Icon(Icons.map,color: Colors.white,),
          page: TrackLocationWithFriends(),
        ),
        KFDrawerItem.initWithPage(
          text: Text('Friends',style: TextStyle(color: Colors.white,fontSize: 18),),
          icon: Icon(Icons.people,color: Colors.white,),
          page: Friendspage(),
        ),
        KFDrawerItem.initWithPage(
          text: Text('Events',style: TextStyle(color: Colors.white,fontSize: 18),),
          icon: Icon(Icons.event,color: Colors.white,),
          page: Eventspage(),
        ),
        KFDrawerItem.initWithPage(
          text: Text('Profile',style: TextStyle(color: Colors.white,fontSize: 18),),
          icon: Icon(Icons.person,color: Colors.white,),
          page: Profilepage(),
        ),
      ],
      );
  }
  Widget build(BuildContext context) {
   return Scaffold(
      body:  KFDrawer(
        controller: _drawerController!,
        header: Align(alignment: Alignment.centerLeft,
              child: 
              Container(
              padding: EdgeInsets.symmetric(horizontal: 16),
              width: MediaQuery.of(context).size.width*0.8,
              child: Row(
                children: <Widget>[
                  GetUserImage(documentId: userid, cirRadius: 25,sideLenght: 50,),
                  SizedBox(width: 10,),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      SizedBox(
                            width: MediaQuery.of(context).size.width*0.47,
                            child: getFullName(documentId: userid,textStyle: TextStyle(fontSize: 17,color: Colors.white))),
                      new SizedBox(height: 2,),
                      new Text('status',style: new TextStyle(fontSize: 15, color: Colors.grey[300]),),

                    ],
                  )
                ],
              ),
        ),
        ),
        footer: KFDrawerItem(text: TextButton(onPressed: () {
          FirebaseAuth.instance.signOut().then((value) {
            Navigator.pushReplacement(context, 
              MaterialPageRoute(builder: (context){
                return Signin();
              })
            );
          },
          );},
        child: Row(
          children: [Icon(Icons.logout,color: Colors.grey[300],),
            Text('Logout',style: TextStyle(color: Colors.grey[300],fontSize: 18)),
          ],
        ),
        ),
        ),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.topRight,
            // colors: [Color.fromRGBO(247,110,17,1), Color.fromRGBO(247,110,17,1)],

            colors: [Color.fromRGBO(254,109,2,1), Color.fromRGBO(255,178,70,1)],
            // colors: [Color.fromRGBO(250, 66, 56, 1.0), Color.fromRGBO(250, 66, 56, 1.0)],
            tileMode: TileMode.repeated,
          )
        ),
      ),
    );
  }
}