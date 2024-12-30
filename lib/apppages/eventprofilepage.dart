import '../main.dart';
import 'detailpage.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kf_drawer/kf_drawer.dart';
import 'package:geolocator/geolocator.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:modmet/apppages/eventspage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:modmet/readdata/getusername.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:modmet/maps/trackingpagebyevent.dart';
// import 'dart:html';


class EventProfilePage extends KFDrawerContent {
  EventProfilePage({
    Key? key,
    required this.eventid,
  });
  final String eventid;

  @override
  State<EventProfilePage> createState() => _EventProfilePageState();
}

class _EventProfilePageState extends State<EventProfilePage> {
  Future<Position> _determinPosition() async {
    bool serviceEnabled;
    LocationPermission permission;
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location service are disabled');
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permission denied');
      }
    }
    if (permission == LocationPermission.deniedForever) {
      return Future.error('Location permission are permanently denied');
    }
    Position position = await Geolocator.getCurrentPosition();
    return position;
  }

  late String placename;
  late String iconurl;
  List<dynamic> destination = [];
  CollectionReference users = FirebaseFirestore.instance.collection('users');

  List<bool> addMember = [];
  List<dynamic> addMemberId = [];
  final String userid = FirebaseAuth.instance.currentUser!.uid;
  // final String userid = FirebaseAuth.instance.currentUser!.uid;
  
  @override
  void initState() {
    FirebaseFirestore.instance
        .collection('events')
        .doc(widget.eventid)
        .get()
        .then((DocumentSnapshot documentSnapshot_event) async {
      if (documentSnapshot_event.exists) {
        destination.addAll(documentSnapshot_event.get(FieldPath(['location'])));
        placename = documentSnapshot_event.get(FieldPath(['placename']));
      }
    });
    FirebaseFirestore.instance
        .collection('users')
        .doc(userid)
        .get()
        .then((DocumentSnapshot documentSnapshot_user) async {
      if (documentSnapshot_user.exists) {
        iconurl = documentSnapshot_user.get(FieldPath(['imageUrl']));
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    CollectionReference events =
        FirebaseFirestore.instance.collection('events');

    // print(destination);
    return LoaderOverlay(
      useDefaultLoading: false,
      overlayWidget: Center(
        child: SpinKitCubeGrid(
          color: Colors.red[300],
          size: 50.0,
        ),
      ),
      child: SafeArea(
          child: Center(
              child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(32)),
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
              )
            ],
          ),
          Expanded(
            child: FutureBuilder<DocumentSnapshot>(
                future: events.doc(widget.eventid).get(),
                builder: ((context, snapshottwo) {
                  if (snapshottwo.connectionState == ConnectionState.done) {
                    Map<String, dynamic> data =
                        snapshottwo.data!.data() as Map<String, dynamic>;
                    // DateTime dtst = (data['start'] as Timestamp).toDate();
                    // var d24 = DateFormat('dd/MM/yyyy, HH:mm').format(dt); // 31/12/2000, 22:00
                    return Column(
                      children: [
                        Row(
                          children: [
                            SizedBox(
                              width: 25,
                            ),
                            IconButton(
                                onPressed: () =>
                                    Navigator.pushReplacement(context,
                                        MaterialPageRoute(builder: (context) {
                                      return MainWidgetXpage(
                                          initialPage: Eventspage());
                                    })),
                                icon: Icon(Icons.arrow_back)),
                            Text("${data['name']}",
                                style: TextStyle(
                                    fontSize: 24, fontWeight: FontWeight.bold)),
                          ],
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(25.0),
                            child: Container(
                                // color: Color.fromRGBO(253, 248, 241, 1),
                                alignment: Alignment.centerLeft,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Container(
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(32),
                                        // color: Color.fromRGBO(253, 248, 241, 1),
                                        color: Colors.grey[100]),
                                    child: Padding(
                                      padding: const EdgeInsets.all(25.0),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text('Place',
                                              style: TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.grey[700])),
                                          SizedBox(
                                              child: AutoSizeText(
                                                  maxLines: 2,
                                                  '  ${data['placename']}',
                                                  style: TextStyle(
                                                      fontSize: 18,
                                                      color:
                                                          Colors.grey[700]))),
                                          SizedBox(
                                            height: 12,
                                          ),
                                          Text('Detail',
                                              style: TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.grey[700])),
                                          SizedBox(
                                              child: AutoSizeText(
                                                  maxLines: 8,
                                                  '  ${data['detail']}',
                                                  style: TextStyle(
                                                      fontSize: 18,
                                                      color:
                                                          Colors.grey[700]))),
                                          SizedBox(
                                            height: 12,
                                          ),
                                          Text('Date',
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: Colors.grey[700],
                                                fontSize: 18,
                                              )),
                                          Text(
                                              '  Begin on ${DateFormat('E dd/MM/yyyy, HH:mm').format(data['start'].toDate())}',
                                              style: TextStyle(
                                                  fontSize: 18,
                                                  color: Colors.grey[700])),
                                          Text(
                                              '  End on ${DateFormat('E dd/MM/yyyy, HH:mm').format(data['end'].toDate())}',
                                              style: TextStyle(
                                                  fontSize: 18,
                                                  color: Colors.grey[700])),
                                          SizedBox(
                                            height: 12,
                                          ),
                                          Text('Member',
                                              style: TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.grey[700])),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          Expanded(
                                              child: getMemberList(
                                                  eventid: widget.eventid)),
                                          IconButton(
                                              onPressed: () {
                                                showDialog(
                                                    context: context,
                                                    builder:
                                                        (BuildContext context) {
                                                      return LoaderOverlay(
                                                        useDefaultLoading:
                                                            false,
                                                        overlayWidget: Center(
                                                          child:
                                                              SpinKitCubeGrid(
                                                            color:
                                                                Colors.red[300],
                                                            size: 50.0,
                                                          ),
                                                        ),
                                                        child: AlertDialog(
                                                          backgroundColor:
                                                              Color.fromRGBO(
                                                                  253,
                                                                  248,
                                                                  241,
                                                                  1),
                                                          iconPadding:
                                                              EdgeInsets.only(
                                                                  top: 30.0,
                                                                  bottom: 0),
                                                          shape: RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          40)),
                                                          icon: Icon(
                                                            Icons
                                                                .person_add_alt_1,
                                                            size: 40,
                                                          ),
                                                          iconColor:
                                                              Colors.black87,
                                                          content: Stack(
                                                            // overflow: Overflow.visible,
                                                            children: <Widget>[
                                                              Positioned(
                                                                right: 10.0,
                                                                top: 0.0,
                                                                child:
                                                                    InkResponse(
                                                                  onTap: () {
                                                                    Navigator.of(
                                                                            context)
                                                                        .pop();
                                                                  },
                                                                  child:
                                                                      CircleAvatar(
                                                                    radius: 10,
                                                                    child: Icon(
                                                                      Icons
                                                                          .close_rounded,
                                                                      size: 24,
                                                                      color: Colors
                                                                          .black38,
                                                                    ),
                                                                    backgroundColor:
                                                                        Colors
                                                                            .transparent,
                                                                  ),
                                                                ),
                                                              ),
                                                              Column(
                                                                mainAxisSize:
                                                                    MainAxisSize
                                                                        .min,
                                                                children: <
                                                                    Widget>[
                                                                  // SizedBox(height: 30,child: Center(child: Text("Add Friend",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold,color: Colors.black38),),),),

//                               Padding(
//                                 padding: const EdgeInsets.only(bottom: 10.0),
//                                 child:
                                                                  SizedBox(
                                                                    height: 30,
                                                                    child: Text(
                                                                      "Add to member",
                                                                      textAlign:
                                                                          TextAlign
                                                                              .center,
                                                                      style: TextStyle(
                                                                          fontSize:
                                                                              18,
                                                                          fontWeight: FontWeight
                                                                              .bold,
                                                                          color:
                                                                              Colors.grey[850]),
                                                                    ),
                                                                  ),
//                               ),
//                               // Container(child: getFriendsListCheckScrollviewwithoutlist(documentId: userid,))
                                                                  SizedBox(
                                                                      height:
                                                                          400,
                                                                      width: double
                                                                          .maxFinite,
                                                                      child:
                                                                          // getFriendsListToAddMember(documentId: userid,eventId: widget.eventid,),
                                                                          FutureBuilder<
                                                                              DocumentSnapshot>(
                                                                        future: users
                                                                            .doc(userid)
                                                                            .get(),
                                                                        builder:
                                                                            ((context,
                                                                                snapshot) {
                                                                          if (snapshot.connectionState ==
                                                                              ConnectionState.done) {
                                                                            Map<String, dynamic>
                                                                                data =
                                                                                snapshot.data!.data() as Map<String, dynamic>;
                                                                            CollectionReference
                                                                                events =
                                                                                FirebaseFirestore.instance.collection('events');
                                                                            return FutureBuilder<DocumentSnapshot>(
                                                                                future: events.doc(widget.eventid).get(),
                                                                                builder: ((context, snapshot2) {
                                                                                  if (snapshot2.connectionState == ConnectionState.done) {
                                                                                    Map<String, dynamic> data2 = snapshot2.data!.data() as Map<String, dynamic>;
                                                                                    placename = data2['placename'];
                                                                                    destination.addAll(data2['location']);
                                                                                    print(data2['location']);
                                                                                    List<bool> isMember = [];
                                                                                    List<dynamic> enabletoadd = [];

                                                                                    for (var i = 0; i < data['friends'].length; i++) {
                                                                                      for (var j = 0; j < data2['members'].length; j++) {
                                                                                        if (data2['members'][j] == data['friends'][i]) {
                                                                                          isMember.add(true);
                                                                                          break;
                                                                                        }
                                                                                        // print(j+1);
                                                                                        // print(data2['members'].length);
                                                                                        if (j + 1 == data2['members'].length) {
                                                                                          enabletoadd.add(data['friends'][i]);
                                                                                          isMember.add(false);
                                                                                        }
                                                                                      }
                                                                                    }
                                                                                    print(isMember);
                                                                                    print(enabletoadd);
                                                                                    for (var i = 0; i < enabletoadd.length; i++) {
                                                                                      addMember.add(false);
                                                                                    }
                                                                                    addMemberId.addAll(enabletoadd);

                                                                                    return ListView.builder(
                                                                                      itemCount: enabletoadd.length,
                                                                                      itemBuilder: (BuildContext context, int index) => ListTile(
                                                                                        leading: GetUserImage(documentId: enabletoadd[index], cirRadius: 20, sideLenght: 50),
                                                                                        // title: Text('${data['friends'][index]}',style: TextStyle(fontSize: 19, fontWeight: FontWeight.normal,color: Colors.black)),
                                                                                        title: Container(
                                                                                          height: 50,
                                                                                          decoration: BoxDecoration(
                                                                                            borderRadius: BorderRadius.circular(10),
                                                                                            color: Color.fromRGBO(251, 157, 150, 0.4),
                                                                                          ),
                                                                                          child: Padding(
                                                                                            padding: const EdgeInsets.all(10.0),
                                                                                            child: Row(
                                                                                              children: [
                                                                                                StatefulBuilder(builder: (context, setState) {
                                                                                                  return Checkbox(
                                                                                                      value: addMember[index],
                                                                                                      onChanged: (value) {
                                                                                                        setState(() => addMember[index] = !addMember[index]);
                                                                                                      });
                                                                                                }),
                                                                                                Expanded(child: getFullName(documentId: enabletoadd[index], textStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.normal, color: Colors.grey[900])))
                                                                                              ],
                                                                                            ),
                                                                                          ),
                                                                                        ),
                                                                                      ),
                                                                                    );
                                                                                  }
                                                                                  return Text('loading..');
                                                                                }));
                                                                            // return Image.network("${data['imageUrl']}");
                                                                          }
                                                                          return Text(
                                                                              'loading..');
                                                                        }),
                                                                      )),
                                                                  ElevatedButton(
                                                                    onPressed:
                                                                        () {
                                                                      context
                                                                          .loaderOverlay
                                                                          .show();
                                                                      FirebaseFirestore
                                                                          .instance
                                                                          .collection(
                                                                              'events')
                                                                          .doc(widget
                                                                              .eventid)
                                                                          .get()
                                                                          .then((DocumentSnapshot
                                                                              documentSnapshot_event) async {
                                                                        // position = await _determinPosition();
                                                                        // print("positionxxx : ${position.latitude}");
                                                                        if (documentSnapshot_event
                                                                            .exists) {
                                                                          List<dynamic>
                                                                              members =
                                                                              [];
                                                                          members.addAll(documentSnapshot_event.get(
                                                                              FieldPath([
                                                                            'members'
                                                                          ])));
                                                                          for (var i = 0;
                                                                              i < addMember.length;
                                                                              i++) {
                                                                            if (addMember[i] ==
                                                                                true) {
                                                                              FirebaseFirestore.instance.collection('users').doc(addMemberId[i]).get().then((DocumentSnapshot documentSnapshot_member_i) async {
                                                                                if (documentSnapshot_member_i.exists) {
                                                                                  List<dynamic> events = [];
                                                                                  events.addAll(documentSnapshot_member_i.get(FieldPath([
                                                                                    'events'
                                                                                  ])));
                                                                                  events.add(widget.eventid);
                                                                                  FirebaseFirestore.instance.collection('users').doc(addMemberId[i]).update({
                                                                                    'events': events,
                                                                                  });
                                                                                }
                                                                              });
                                                                              members.add(addMemberId[i]);
                                                                            }
                                                                          }
                                                                          await FirebaseFirestore
                                                                              .instance
                                                                              .collection('events')
                                                                              .doc(widget.eventid)
                                                                              .update({
                                                                            'members':
                                                                                members,
                                                                          }).then((value) {
                                                                            context.loaderOverlay.hide();
                                                                            Fluttertoast.showToast(msg: "Added");
                                                                            Navigator.pushReplacement(context,
                                                                                MaterialPageRoute(builder: (context) {
                                                                              return MainWidgetXpage(
                                                                                initialPage: EventProfilePage(
                                                                                  eventid: widget.eventid,
                                                                                ),
                                                                              );
                                                                            }));
                                                                          });
                                                                        }
                                                                      });
                                                                    },
                                                                    child: Text(
                                                                      'Add to Member Event',
                                                                      textAlign:
                                                                          TextAlign
                                                                              .center,
                                                                      style: TextStyle(
                                                                          color: Colors
                                                                              .white,
                                                                          fontSize:
                                                                              14,
                                                                          fontWeight:
                                                                              FontWeight.bold),
                                                                    ),
                                                                    style: ElevatedButton
                                                                        .styleFrom(
                                                                      backgroundColor: Color
                                                                          .fromRGBO(
                                                                              250,
                                                                              66,
                                                                              56,
                                                                              1),
                                                                      foregroundColor: Color.fromRGBO(
                                                                          251,
                                                                          157,
                                                                          150,
                                                                          1),
                                                                      shape: const RoundedRectangleBorder(
                                                                          borderRadius:
                                                                              BorderRadius.all(Radius.circular(12))),
                                                                      shadowColor:
                                                                          Colors
                                                                              .white,
                                                                    ),
                                                                  )
                                                                ],
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      );
                                                    });
                                              },
                                              icon: Icon(
                                                Icons.person_add_alt_1_outlined,
                                                size: 32,
                                              )),
                                          IconButton(
                                              onPressed: () async {
                                                context.loaderOverlay.show();
                                                // var collection = FirebaseFirestore.instance.collection('events');
                                                // var querySnapshot = await collection.get();
                                                // for (var queryDocumentSnapshot in querySnapshot.docs) {
                                                //   Map<String, dynamic> data = queryDocumentSnapshot.data();
                                                //   var name = data['name'];
                                                //   var phone = data['phone'];
                                                // }
                                                // FirebaseFirestore.instance.collection('events').doc(widget.eventid).get().then((DocumentSnapshot documentSnapshot_event) async{
                                                // if(documentSnapshot_event.exists){
                                                //   List<dynamic> destination=[];
                                                //   destination.addAll(documentSnapshot_event.get(FieldPath(['events'])));

                                                // print(destination);
                                                // destination.add(widget.eventid);
                                                // FirebaseFirestore.instance.collection('users').doc(addMemberId[i]).update({
                                                //   'events' : events,
                                                // });
                                                print(destination);
                                                print(placename);
                                                Position position =
                                                    await Geolocator
                                                        .getCurrentPosition();
                                                Navigator.pushReplacement(
                                                    context, MaterialPageRoute(
                                                        builder: (context) {
                                                  context.loaderOverlay.hide();
                                                  return MainWidgetXpage(
                                                      initialPage:
                                                          TrackingEvent(
                                                            eventId: widget.eventid,
                                                            iconurl: iconurl,
                                                    placeName: placename,
                                                    currentUserLocation:
                                                        position,
                                                    destinationLocation:
                                                        destination,
                                                  ));
                                                }));
                                                // }
                                                // });
                                              },
                                              icon: Icon(Icons.map_rounded)),
                                        ],
                                      ),
                                    ),
                                  ),
                                )),
                          ),
                        ),
                      ],
                    );
                  }
                  return Text('loading..', textAlign: TextAlign.left);
                })),
          )
        ],
      ))),
    );
  }
}
