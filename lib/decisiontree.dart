import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:geolocator/geolocator.dart';
import 'apppages/homepage.dart';
import 'lobby/signin.dart';
import 'main.dart';
import 'maps/tracking_page.dart';
import 'testmap.dart';
class DecisionTree extends StatefulWidget {
  const DecisionTree({super.key});

  @override
  State<DecisionTree> createState() => _DecisionTreeState();
}

class _DecisionTreeState extends State<DecisionTree> {
  User? user ;
  @override
  void initState(){
    _determinPositionvoid();
    super.initState();
    onRefresh(FirebaseAuth.instance.currentUser);
  }
  onRefresh(userCred){
    setState(() {
      user = userCred;
    });
  }


  void _determinPositionvoid() async{
    bool serviceEnabled;
    LocationPermission permission;
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if(!serviceEnabled){
      return Future.error('Location service are disabled');
    }
    permission = await Geolocator.checkPermission();
    if(permission==LocationPermission.denied){
      permission = await Geolocator.requestPermission();
      if(permission==LocationPermission.denied){
        return Future.error('Location permission denied');
      }
    }
    if(permission == LocationPermission.deniedForever){
      return Future.error('Location permission are permanently denied');
    }
  }
  @override
  Widget build(BuildContext context) {
    if(user ==null){
      print('to sign in');
      return Signin();
    }
    print('to Main');
    return MainWidget();
  }
}