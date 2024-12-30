// ignore_for_file: unnecessary_new

import 'package:flutter/material.dart';

class DetailPage extends StatefulWidget {
  final imgPath;
  const DetailPage({super.key, this.imgPath});

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  bool tempValue = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          // ignore: unnecessary_new
          new Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: 
                    AssetImage(widget.imgPath), 
                    fit: BoxFit.cover
                    )
                    ),
          ),
          // ignore: unnecessary_new
          new Padding(padding: EdgeInsets.only(top: 25),
          // ignore: unnecessary_new
          child: new Row(
            children: <Widget>[
              // ignore: unnecessary_new
              new IconButton(
                icon: Icon(Icons.arrow_back,color: Colors.white,), 
                onPressed: () {
                  Navigator.of(context).pop();
                },
                ),
              Spacer(),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  image: DecorationImage(image: AssetImage('assets/images/profile.jpg'),
                  fit: BoxFit.cover)
                ),
              ),
              SizedBox(width: 15,)

          ],)
          ),
          new Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: 340,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(40),
                  topRight: Radius.circular(40),
                ),
                color: Color.fromRGBO(31, 58, 47, 1.0),
                
                ),
              child: new Column(
                children: <Widget>[
                  SizedBox(height: 20,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0,left: 20,right: 20),
                    child: Divider(color: Colors.white),
                  ),
                  SizedBox(height: 5,),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      children: <Widget>[
                        Text("Text001",style: new TextStyle(color:Colors.white)),
                        Spacer(),
                        Text("Text002",style:  new TextStyle(color: Colors.white),),
                      ],
                    ),
                  ),
                  SizedBox(height: 10,),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      children: <Widget>[
                        Text("Text003",style: new TextStyle(color: Colors.white)),
                        Spacer(),
                        Text("text004",style: new TextStyle(color: Colors.white),),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 5,left: 20,right: 20),
                    child: Divider(color: Colors.white,),
                  ),
                  Row(
                    children: [
                      Text("Text005",style: new TextStyle(color: Colors.white),),
                      Spacer(),
                      Switch(
                        value: tempValue, 
                        onChanged: ((value) {
                          tempValue =value;
                          print(value);
                        }),
                        activeColor: Colors.orangeAccent,
                      )
                    ],
                  )
                ],
              ),
            ),
          )
        ],
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