import '../main.dart';
import 'detailpage.dart';
import '../readdata/getusername.dart';
import 'package:flutter/material.dart';
import 'package:kf_drawer/kf_drawer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:modmet/apppages/profilepage.dart';

class Homepage extends KFDrawerContent {
  Homepage({Key? key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  final String userid = FirebaseAuth.instance.currentUser!.uid;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ListView(
        children: <Widget>[
          Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(32.0)),
                    child: Material(
                      shadowColor: Colors.transparent,
                      color: Colors.transparent,
                      child: IconButton(
                        icon: Icon(
                          Icons.menu,
                          color: Colors.black,
                        ),
                        onPressed: widget.onMenuPressed,
                      ),
                    ),
                  ),
                  Spacer(),
                  MaterialButton(
                    onPressed: () => 
                                            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context){
                                              return MainWidgetXpage(initialPage:  Profilepage());
                                            })),
                    child: GetUserImage(documentId: userid, cirRadius: 20, sideLenght: 40)),
                  SizedBox(width: 15)
                ],
              ),
              Padding(
                padding: EdgeInsets.all(15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Text("Welcome", style: TextStyle(fontSize: 17)),
                      ],
                    ),
                    SizedBox(height: 30),
                    Row(
                      children: [
                          getFullName(documentId: userid,textStyle: TextStyle(fontSize: 19, fontWeight: FontWeight.bold),),
                      ],
                    ),
                    SizedBox(height: 15),
                    Text("Today, You have a meeting at 9 pm."
                        " We recommend you should around in 30 minutes left to be on time.", style: TextStyle(color: Colors.grey,fontSize: 16),),
                    SizedBox(height: 30),
                    Text("Nearly Events", style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold)),
                    // SizedBox(height: 15),
                    // Container(
                    //   alignment: Alignment.topCenter,
                    //   height: 300,
                    //   // width: double.infinity,
                    //   child: SizedBox(height: 250,width: double.infinity, child: getTodayEvent(documentId: userid,)),
                    //   // ListView(
                    //   //   scrollDirection: Axis.horizontal,
                    //   //   children: 
                    //   //   <Widget>[
                    //   //     // listItem('images/picture1.jpg'),
                    //   //     // new SizedBox(width: 15),
                    //   //     // listItem('images/picture1.jpg'),
                    //   //     // new SizedBox(width: 15),
                    //   //     // listItem('images/picture1.jpg'),
                    //   //   ],
                    //   // )
                    // ),
                    // SizedBox(height: 15),
                    // Text("Status friends", style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                height: 1000,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(40),
                    topRight: Radius.circular(40),
                  ),
                  color: Color.fromRGBO(255, 188, 128, 1),
                ),
                child: getTodayEvent(documentId: userid,),
              //   Row(
              //     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              //     children: <Widget>[
                    
              //     ],
              //   ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget listItem(String imgpath){
    return InkWell(
      onTap: (){
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => DetailPage(
                imgPath: imgpath,
                )));
      },
      child: Container(
        width: 325,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25),
          image: DecorationImage(image: AssetImage(imgpath),
          fit: BoxFit.cover
          ),
        ),
      ),
    );
  }


  Widget listItemStats(String imgpath, String name, bool value){
    return Container(
      width: 110,
      height: 150,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25),
          color: value == true ? Colors.white : Color.fromRGBO(75, 97, 88, 1.0)
      ),
      child: Column(
        children: <Widget>[
          SizedBox(height: 20),
          Image(image: AssetImage(imgpath),width: 45,height: 45, color: value == true ? Colors.black : Colors.white),
          SizedBox(height: 15),
          Text(name, style: TextStyle(fontSize: 13, color: value == true ? Colors.black : Colors.white)),
          SizedBox(height: 5),
          Switch(
            value: value,
            onChanged: (newVal){
              setState(() {
                value = newVal;
                print(newVal);
              });
            },
            activeColor: Colors.green,
          )
        ],
      ),
    );
  }
}