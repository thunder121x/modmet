import 'detailpage.dart';
import 'package:path/path.dart';
import 'package:modmet/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:kf_drawer/kf_drawer.dart';
import 'package:modmet/maps/constants.dart';
import 'package:modmet/model/eventmodel.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:modmet/readdata/getusername.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_places_flutter/model/prediction.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:omni_datetime_picker/omni_datetime_picker.dart';
import 'package:auto_size_text_field/auto_size_text_field.dart';
import 'package:google_places_flutter/google_places_flutter.dart';
class Eventspage extends KFDrawerContent {
  Eventspage({Key? key});

  @override
  State<Eventspage> createState() => _EventspageState();
}

class _EventspageState extends State<Eventspage> {

  TextEditingController controllergg = TextEditingController();
  final String userid = FirebaseAuth.instance.currentUser!.uid;
  late Prediction _prediction;
  final formKey = GlobalKey<FormState>();
  void initState(){
    super.initState();
    }
  EventModel eventModel = EventModel();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(253, 253, 253,1),
      body: SafeArea(
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
            Text("Events",style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            SizedBox(height: 30,),
          ],
        ),
            Expanded(
              child: 
            Container(
              child: getEventsListPlus(documentId: userid),
              // child: getFriendsList(documentId: userid)),
            ),
        // Expanded(child: Column(mainAxisAlignment: MainAxisAlignment.center,children: [Text('Friends')],)
        )
      ],
      ),
      ),

    ),floatingActionButton: FloatingActionButton(
        onPressed: () async {
          List<DateTime>? dateTimeList = [DateTime.now(),DateTime.now()];
          List<DateTime>? dateTimeListNew = await showOmniDateTimeRangePicker(context: context,
                    type: OmniDateTimePickerType.dateAndTime,
                    // primaryColor: Colors.deepOrange,
                    // backgroundColor: Color.fromRGBO(253, 248, 241, 1),
                    // calendarTextColor: Colors.grey[700],
                    // tabTextColor: Colors.red[700],
                    // unselectedTabBackgroundColor: Color.fromARGB(255, 227, 177, 164),
                    // unselectedTabTextColor: Color.fromARGB(255, 106, 83, 76),
                    // buttonTextColor: Colors.red[400],
                    // timeSpinnerTextStyle:
                    //     const TextStyle(color: Colors.deepOrangeAccent, fontSize: 18),
                    // timeSpinnerHighlightedTextStyle:
                    //     const TextStyle(color: Colors.deepOrange, fontSize: 24),
                    is24HourMode: true,
                    isShowSeconds: false,
                    startInitialDate: DateTime.now(),
                    startFirstDate:
                        DateTime(1600).subtract(const Duration(days: 3652)),
                    startLastDate: DateTime.now().add(
                      const Duration(days: 3652),
                    ),
                    endInitialDate: DateTime.now(),
                    endFirstDate:
                        DateTime(1600).subtract(const Duration(days: 3652)),
                    endLastDate: DateTime.now().add(
                      const Duration(days: 3652),
                    ),
                    borderRadius: BorderRadius.circular(16),).then((timevaluenew){
                                                          setState(() {
                                                            // print(timevaluenew);
                                                            dateTimeList =timevaluenew!;
                                                          });
                                                        });
          print(dateTimeList);
            showDialog(
                context: context,
                builder: (context) {
                  return StatefulBuilder(
                    builder: (context,setState) {
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
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
                          icon: Icon(Icons.event,size: 40,),
                          iconColor: Colors.black87,
                          iconPadding: EdgeInsets.only(top:30,bottom: 0),
                          backgroundColor: Color.fromRGBO(253, 248, 241, 1),
                          content: Stack(
                            
                            // overflow: Overflow.visible,
                            children: <Widget>[
                              Form(
                                key:formKey,
                                child: SingleChildScrollView(
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                              Padding(
                                  padding: const EdgeInsets.only(bottom: 10.0),
                                  child: SizedBox(height: 30,child: Text("New Event",textAlign: TextAlign.center,style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.grey[850]),),),
                              ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 5.0),
                                        child: Container(
                                           decoration: BoxDecoration(
                                            color: Colors.grey[200],
                                            border: Border.all(color: Colors.white),
                                            borderRadius: BorderRadius.circular(12),
                                            ),
                                            child: Padding(
                                              padding: EdgeInsets.only(left: 10.0),
                                              child: TextFormField(
                                                validator: RequiredValidator(errorText: "Please field Event name",),
                                                onChanged: (String eventname) => eventModel.eventname = eventname,
                                                decoration: InputDecoration(
                                                  border: InputBorder.none,
                                                  hintText: 'Event Name',),
                                                  ),
                                                  ),
                                                  ),
                                                  ),
                                                  SizedBox(height: 5,),
                                                  Padding(
                                                    padding: const EdgeInsets.symmetric(horizontal: 5.0),
                                                    child: Container(
                                                    decoration: BoxDecoration(
                                                      color: Colors.grey[200],
                                                      border: Border.all(color: Colors.white),
                                                      borderRadius: BorderRadius.circular(12),
                                                      ),
                                                      child: Padding(padding: EdgeInsets.only(left: 10,),
                                                      child:  GooglePlaceAutoCompleteTextField(
                                                        
                                                        textEditingController: controllergg,
                                                        googleAPIKey: google_api_key,
                                                        inputDecoration: InputDecoration(
                                                          border: InputBorder.none,
                                                          hintText: "Search Your Destination"),
                                                        debounceTime: 800,
                                                        countries: ["th"],
                                                        isLatLngRequired: true,
                                                        getPlaceDetailWithLatLng: (Prediction prediction) {
                                                          print("placeDetails (" + prediction.lat.toString()+","+prediction.lng.toString()+")");
                                                        },
                                                        itemClick: (Prediction prediction) {
                                                          controllergg.text = prediction.description!;
                                                          _prediction=prediction;
                                                          // eventModel.latlng?.add(double.parse(prediction.lat.toString()));
                                                          // eventModel.latlng?.add(double.parse(prediction.lng.toString()));
                                                          // eventModel.placename=prediction.description!;
                                // print("PLACEXXX : ${eventModel.placename} at (${eventModel.latlng![0]},${eventModel.latlng![1]})");

                                                          controllergg.selection = TextSelection.fromPosition(
                                                              TextPosition(offset: prediction.description!.length));
                                                        }
                                                        // default 600 ms ,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(height: 5,),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 5.0),
                                        child: Container(
                                          height: 100,
                                           decoration: BoxDecoration(
                                            color: Colors.grey[200],
                                            border: Border.all(color: Colors.white),
                                            borderRadius: BorderRadius.circular(12),
                                            ),
                                            child: Padding(
                                              padding: EdgeInsets.only(left: 10.0),
                                              child: TextFormField(
                                                maxLines: 4,
                                                validator: RequiredValidator(errorText: "Please field Event detail",),
                                                onChanged: (String eventdetail) => eventModel.detail = eventdetail,
                                                decoration: InputDecoration(
                                                  border: InputBorder.none,
                                                  hintText: 'Detail',),
                                                  ),
                                                  ),
                                                  ),
                                                  ),
                                                  SizedBox(height: 10,),
                                              Padding(
                                                padding: const EdgeInsets.symmetric(horizontal: 5.0),
                                                child: Container(
                                                  width: double.infinity,
                                                  decoration: BoxDecoration(
                                                    color: Colors.grey[200],
                                                    border: Border.all(color: Colors.white),
                                                    borderRadius: BorderRadius.circular(12),
                                                    ),
                                                    child: Padding(
                                                      padding: EdgeInsets.symmetric(horizontal: 8.0),
                                                      child: MaterialButton(
                                                          onPressed: (() async { List<DateTime>? dateTimeListNew = await showOmniDateTimeRangePicker(context: context,
                                                          type: OmniDateTimePickerType.dateAndTime,
                                                          // primaryColor: Colors.deepOrange,
                                                          // backgroundColor: Color.fromRGBO(253, 248, 241, 1),
                                                          // calendarTextColor: Colors.grey[700],
                                                          // tabTextColor: Colors.red[700],
                                                          // unselectedTabBackgroundColor: Color.fromARGB(255, 227, 177, 164),
                                                          // unselectedTabTextColor: Color.fromARGB(255, 106, 83, 76),
                                                          // buttonTextColor: Colors.red[400],
                                                          // timeSpinnerTextStyle:
                                                          //     const TextStyle(color: Colors.deepOrangeAccent, fontSize: 18),
                                                          // timeSpinnerHighlightedTextStyle:
                                                          //     const TextStyle(color: Colors.deepOrange, fontSize: 24),
                                                          is24HourMode: true,
                                                          isShowSeconds: false,
                                                          startInitialDate: DateTime.now(),
                                                          startFirstDate:
                                                              DateTime(1600).subtract(const Duration(days: 3652)),
                                                          startLastDate: DateTime.now().add(
                                                            const Duration(days: 3652),
                                                          ),
                                                          endInitialDate: DateTime.now(),
                                                          endFirstDate:
                                                              DateTime(1600).subtract(const Duration(days: 3652)),
                                                          endLastDate: DateTime.now().add(
                                                            const Duration(days: 3652),
                                                          ),
                                                          borderRadius: BorderRadius.circular(16),).then((timevaluenew){
                                                            setState(() {
                                                              // print(timevaluenew);
                                                              dateTimeList =timevaluenew!;
                                                            });
                                                          })
                                                          ;}
                                                          )
                                                          , 
                                                          child: Row(mainAxisAlignment: MainAxisAlignment.center,
                                                            children: [ Icon(Icons.calendar_month,color: Colors.grey[600],),
                                                        Padding(
                                                          padding: const EdgeInsets.only(left:8.0),
                                                          child: Text("${dateTimeList![0].day}/${dateTimeList![0].month}/${dateTimeList![0].year} ${dateTimeList![0].hour}:${dateTimeList![0].minute}",style: TextStyle(fontSize: 16,color: Colors.grey[700]),),
                                                        ),
                                                          ]),
                                                          )
                                                      ),
                                                      ),
                                                      ),
                                                      SizedBox(height: 5,),
                                                      Text("to",style: TextStyle(color: Colors.grey[600]),),
                                                      SizedBox(height: 5,),
                                              Padding(
                                                padding: const EdgeInsets.symmetric(horizontal: 5.0),
                                                child: Container(
                                                  width: double.infinity,
                                                  decoration: BoxDecoration(
                                                    color: Colors.grey[200],
                                                    border: Border.all(color: Colors.white),
                                                    borderRadius: BorderRadius.circular(12),
                                                    ),
                                                      child: Padding(
                                                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                                        child: MaterialButton(
                                                            onPressed: (() async { List<DateTime>? dateTimeListNew = await showOmniDateTimeRangePicker(context: context,
                                                            type: OmniDateTimePickerType.dateAndTime,
                                                            // primaryColor: Colors.deepOrange,
                                                            // backgroundColor: Color.fromRGBO(253, 248, 241, 1),
                                                            // calendarTextColor: Colors.grey[700],
                                                            // tabTextColor: Colors.red[700],
                                                            // unselectedTabBackgroundColor: Color.fromARGB(255, 227, 177, 164),
                                                            // unselectedTabTextColor: Color.fromARGB(255, 106, 83, 76),
                                                            // buttonTextColor: Colors.red[400],
                                                            // timeSpinnerTextStyle:
                                                            //     const TextStyle(color: Colors.deepOrangeAccent, fontSize: 18),
                                                            // timeSpinnerHighlightedTextStyle:
                                                            //     const TextStyle(color: Colors.deepOrange, fontSize: 24),
                                                            is24HourMode: true,
                                                            isShowSeconds: false,
                                                            startInitialDate: dateTimeList![0],
                                                            startFirstDate:
                                                                DateTime(1600).subtract(const Duration(days: 3652)),
                                                            startLastDate: DateTime.now().add(
                                                              const Duration(days: 3652),
                                                            ),
                                                            endInitialDate: dateTimeList![1],
                                                            endFirstDate:
                                                                DateTime(1600).subtract(const Duration(days: 3652)),
                                                            endLastDate: DateTime.now().add(
                                                              const Duration(days: 3652),
                                                            ),
                                                            borderRadius: BorderRadius.circular(16),).then((timevaluenew){
                                                            setState(() {
                                                              // print(timevaluenew);
                                                              dateTimeList =timevaluenew!;
                                                            });
                                                          })
                                                          ;}
                                                            )
                                                            , 
                                                            child: Row(mainAxisAlignment: MainAxisAlignment.center,
                                                            // verticalDirection: VerticalDirection.up,
                                                              children: [ Icon(Icons.calendar_month,color: Colors.grey[600],),
                                                          Padding(
                                                            padding: const EdgeInsets.only(left:8.0),
                                                            child: Text("${dateTimeList![1].day}/${dateTimeList![1].month}/${dateTimeList![1].year} ${dateTimeList![1].hour}:${dateTimeList![1].minute}",style: TextStyle(fontSize: 16,color: Colors.grey[700]),),
                                                          ),
                                                            ]),
                                                            ),
                                                      )
                                                      ),
                                                      ),
                      SizedBox(height: 10,),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal:25.0),
                        child: SizedBox(width: double.infinity,height: 50,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color.fromRGBO(247,110,17,1),
                              foregroundColor: Color.fromRGBO(251, 157, 150, 1),
                              shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(12))),
                              shadowColor: Colors.white,
                            ),
                              onPressed: ()async{
                                // print("PLACEXXX : ${eventModel.placename} at (${eventModel.latlng![0]},${eventModel.latlng![1]})");
                                      if(formKey.currentState!.validate()){
                                      context.loaderOverlay.show();
                                        formKey.currentState!.save();
                                              await FirebaseFirestore.instance.collection("events").doc("${userid}_${eventModel.eventname}").set({
                                                "name" : eventModel.eventname,
                                                "detail" : eventModel.detail,
                                                "members" : [userid],
                                                "start" : dateTimeList![0],
                                                "end" : dateTimeList![1],
                                                "done" : false,
                                                "placename" : _prediction.description.toString(),
                                                "location" : [double.parse(_prediction.lat.toString()),double.parse(_prediction.lng.toString())],
                                              })
                                              .then((value) {
                                            FirebaseFirestore.instance
                                            .collection('users')
                                            .doc(userid)
                                            .get()
                                            .then((DocumentSnapshot documentSnapshot) async {
                                              if (documentSnapshot.exists) {
                                                List<dynamic> userevent=[];
                                                userevent.addAll(documentSnapshot.get(FieldPath(['events'])));
                                                userevent.add("${userid}_${eventModel.eventname}");
                                                await FirebaseFirestore.instance.collection("users").doc(userid).update({
                                                  "events" : userevent,
                                                }).then((value) {

                                                  context.loaderOverlay.hide();
                                                Fluttertoast.showToast(msg: "Created ${eventModel.eventname}");
                                                formKey.currentState?.reset();
                                                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context){
                                                  return MainWidgetXpage(initialPage: Eventspage(),);
                                                }));
                                              });
                                              }
                                              else {
                                                print('Document does not exist on the database at ');
                                              }
                                              });
                                              });
                                            // }on FirebaseFirestore catch(e)
                                            // {
                                            //   print(e);
                                            // }
                                            }
                                            else{

                                            }
                              },
                                  child: Text( 
                                      'Create Event',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(color: Colors.white, fontSize: 16,fontWeight: FontWeight.bold),
                                      ),
                          ),
                        ),
                      ),
                                      // Padding(
                                      //   padding: const EdgeInsets.all(8.0),
                                      //   child: 
                                      //   ElevatedButton(
                                      //     child: Text("Create"),
                                      //     onPressed: () async{
                                      //       context.loaderOverlay.show();
                                      //       if (formKey.currentState!.validate()) {
                                      //         formKey.currentState?.save();
                                      //       FirebaseFirestore.instance
                                      //       .collection('users')
                                      //       .doc(userid)
                                      //       .get()
                                      //       .then((DocumentSnapshot documentSnapshot) async {
                                      //         if (documentSnapshot.exists) {
                                      //           // setState(() {
                                      //           List<dynamic> userEvents =[];
                                      //           userEvents.addAll(documentSnapshot.get(FieldPath(['event'])));
                                      //           userEvents.add(eventname);
                                      //           print(userEvents[0]);                                        
                                      //           await FirebaseFirestore.instance.collection("users").doc(FirebaseAuth.instance.currentUser!.uid).update({
                                      //                                             "events" : userEvents,
                                      //                                           })
                                      //                                           .then((value){
                                      //                                             context.loaderOverlay.hide();
                                      //                                             formKey.currentState?.reset();
                                      //                                             Fluttertoast.showToast(msg: "Created");
                                      //                                           });
                                      //           print('Document data: ${documentSnapshot.data()}');
                                      //         } else {
                                      //           print('Document does not exist on the database');
                                      //         }
                                      //       });
                                      //         // AddFriend(documentId: userid, friendId: friendId);
                                      //       }
                                      //     },
                                      //   ),
                                      // )
                                    ],
                                  ),
                                ),
                              ),
                          Positioned(
                            right: 10.0,
                            top: 0.0,
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
                    }
                  );
                });
        },
        backgroundColor: Color.fromRGBO(247,110,17,1),
        child: const Icon(Icons.add_card),
      )

    );
  }

  placesAutoCompleteTextField() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: GooglePlaceAutoCompleteTextField(
          textEditingController: controllergg,
          googleAPIKey: google_api_key,
          inputDecoration: InputDecoration(hintText: "Search your location"),
          debounceTime: 800,
          countries: ["th"],
          isLatLngRequired: true,
          getPlaceDetailWithLatLng: (Prediction prediction) {
            print("placeDetails" + prediction.lng.toString());
          },
          itemClick: (Prediction prediction) {
            controllergg.text = prediction.description!;

            controllergg.selection = TextSelection.fromPosition(
                TextPosition(offset: prediction.description!.length));
          }
          // default 600 ms ,
          ),
    );
  }
}