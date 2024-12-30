import 'dart:async';
import 'dart:math';
// import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:loader_overlay/loader_overlay.dart';
import 'constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:kf_drawer/kf_drawer.dart';


class TrackLocationWithFriends extends KFDrawerContent {
  TrackLocationWithFriends({Key? key,
  // required this.currentUserLocation
  });
  // final Position currentUserLocation;

  @override
  State<TrackLocationWithFriends> createState() => _TrackLocationWithFriendsState();
}


class _TrackLocationWithFriendsState extends State<TrackLocationWithFriends> {

Future<Uint8List> getBytesFromCanvas(int width, int height, String nametag) async {
  final ui.PictureRecorder pictureRecorder = ui.PictureRecorder();
  final Canvas canvas = Canvas(pictureRecorder);
  final Paint paint = Paint()..color = Color.fromRGBO(247,110,17,1);
  final Radius radius = Radius.circular(20.0);
  canvas.drawRRect(
      RRect.fromRectAndCorners(
        Rect.fromLTWH(0.0, 0.0, width.toDouble(), height.toDouble()),
        topLeft: radius,
        topRight: radius,
        bottomLeft: radius,
        bottomRight: radius,
      ),
      paint);
  TextPainter painter = TextPainter(textDirection: TextDirection.ltr);
  painter.text = TextSpan(
    text: nametag,
    style: TextStyle(fontSize: 25.0, color: Colors.white),
  );
  painter.layout();
  painter.paint(canvas, Offset((width * 0.5) - painter.width * 0.5, (height * 0.5) - painter.height * 0.5));
  final img = await pictureRecorder.endRecording().toImage(width, height);
  final data = await img.toByteData(format: ui.ImageByteFormat.png);
  return data!.buffer.asUint8List();
  }

  Set<Marker> markers = Set();
  late Uint8List markerIcon ;
      var dataBytes;
  startPin()async{
      var iconurl ='your url';
      // var request = await http.get(Uri.parse(widget.iconurl));
      var request = await http.get(Uri.parse("https://firebasestorage.googleapis.com/v0/b/strange-wharf-368315.appspot.com/o/uploads%2Fprivate%2Fvar%2Fmobile%2FContainers%2FData%2FApplication%2FAC6C6278-A227-4AB9-8036-D357FF58B97B%2Ftmp%2Fimage_picker_CF5F7044-B1CA-49BC-AF8B-71F8091358F9-5797-00000217C9AF6A08.png?alt=media&token=9628b02b-dc95-4a4d-9992-98a9cb0087e6"));
      var bytes = request.bodyBytes;

      // setState(() {
      //   dataBytes = bytes;
      // });

    markers.add(Marker(markerId: MarkerId("source"),
                              icon: BitmapDescriptor.fromBytes(bytes.buffer.asUint8List(), size: Size.fromHeight(3)),
                              // icon: BitmapDescriptor.fromBytes(dataBytes.buffer.getBytesFromCanvas()),
                              // icon: BitmapDescriptor.fromBytes(dataBytes!.buffer.asUint8List(),size: Size.square(0)),
                              position: 
                              LatLng(currentUserLocation.latitude,currentUserLocation.longitude)
                              ));
  }
  test(LatLng location,String name) async{
    print(location);
    markerIcon = await getBytesFromCanvas(200, 100,name);
     markers.add(Marker( //add start location marker
        markerId: MarkerId(name),
        position: location, //position of marker
        infoWindow: InfoWindow( //popup info 
          title: name,
          // snippet: 'Start Marker',
        ),
        icon: BitmapDescriptor.fromBytes(markerIcon),
      ));
  }
  @override
  void initState() {
    startPin();
    FriendsMarker();
    getImage();
    // context.loaderOverlay.show();
    _determinPositionvoid();
    // setCustomMarkerIcon();
    super.initState();
}
  static const CameraPosition initialCameraPosition = CameraPosition(
    target: LatLng(13.6520, 100.4977)
    ,zoom: 14
  );
  final Completer<GoogleMapController> _controller = Completer();
  List<LatLng> polylineCoordinates=[];
  BitmapDescriptor sourceIcon =BitmapDescriptor.defaultMarker;
  // void setCustomMarkerIcon(){
  //   BitmapDescriptor.fromAssetImage(ImageConfiguration.empty, "assets/images/Pin-location.png")
  //   .then((icon) => sourceIcon=icon);
  // }
  Future<Position> _determinPosition() async{
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
    Position position = await Geolocator.getCurrentPosition();
    return position;
  }
  late Position currentUserLocation ;
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
    currentUserLocation = await Geolocator.getCurrentPosition();
    setState(() {
      
    });
    // context.loaderOverlay.hide();
  }
  
      // var dataBytes;
  double? distance;
  final String userid = FirebaseAuth.instance.currentUser!.uid;
  void getImage() async{
      var iconurl ='your url';
      // var request = await http.get(Uri.parse(widget.iconurl));
      var request = await http.get(Uri.parse("https://firebasestorage.googleapis.com/v0/b/strange-wharf-368315.appspot.com/o/uploads%2Fprivate%2Fvar%2Fmobile%2FContainers%2FData%2FApplication%2FAC6C6278-A227-4AB9-8036-D357FF58B97B%2Ftmp%2Fimage_picker_CF5F7044-B1CA-49BC-AF8B-71F8091358F9-5797-00000217C9AF6A08.png?alt=media&token=9628b02b-dc95-4a4d-9992-98a9cb0087e6"));
      var bytes = request.bodyBytes;

      setState(() {
        dataBytes = bytes;
      });
  }
  void UpdateLocation() async{
        await FirebaseFirestore.instance.collection("users").doc(userid).update({
          "currentlocation" : [currentUserLocation.latitude,currentUserLocation.longitude],
          });                 
  }
  void FriendsMarker(){
    FirebaseFirestore.instance
    .collection('users')
    .doc(userid)
    .get()
    .then((DocumentSnapshot documentSnapshot) async {
      if (documentSnapshot.exists) {
        List<dynamic> allfriend =[];
        allfriend.addAll(documentSnapshot.get(FieldPath(['friends'])));
        await FirebaseFirestore.instance.collection("users").doc(userid).update({
          "currentlocation" : [currentUserLocation.latitude,currentUserLocation.longitude],
          })
          .then((value){
            for(var i = 0 ; i < allfriend.length ; i++)
            {
                FirebaseFirestore.instance
                .collection('users')
                .doc(allfriend[i])
                .get()
                .then((DocumentSnapshot documentSnapshotx) async {
                  if (documentSnapshotx.exists) {
                    List<dynamic> friendmarker=[];
                    friendmarker.addAll(documentSnapshotx.get(FieldPath(['currentlocation'])));
                    test(LatLng(friendmarker[0], friendmarker[1]), documentSnapshotx.get(FieldPath(['name'])));
                  }
                }
                );
            setState(() {
              
            });
            }
          }
          );
          }
          }
          );                          
  }
  List<dynamic> friendmarker=[];
late GoogleMapController googleMapController;

  @override
  Widget build(BuildContext context) {
    return LoaderOverlay(
                useDefaultLoading: false,
                overlayWidget: Center(
                  child: 
                  SpinKitCubeGrid(
                    color: Colors.red[300],
                    size: 50.0,
                  ),
                ),
      child: Scaffold(
        floatingActionButton: FloatingActionButton(
        child: Icon(Icons.update),
        onPressed: () async{
          // Position position = await _determinPosition();  
          // print(position);      
          // googleMapController.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(zoom: 15,target: LatLng(position.latitude,position.longitude))));
          // markers.clear();
          startPin();
          FriendsMarker();
          // // print("postionxxx : ${position.latitude}");
          // marker.add(Marker(markerId: const MarkerId("currentLocation"),position: LatLng(position.latitude,position.longitude)));
          setState(() {
          //   // currentUserLocation=LatLng(position.latitude,position.longitude);
          //   // widget.currentUserLocation=position;
          });
        },),
        body: 
            SafeArea(
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
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12.0),
                      child: Text("Maps & Friends",style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700)),
                    ),
                    SizedBox(height: 10,),
                  ],
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: ui.Color.fromRGBO( 240, 231, 226,1),
                                border: Border.all(color: ui.Color.fromRGBO( 240, 231, 226,1),width: 5),
                                // borderRadius: BorderRadius.circular(30),
                      ),
                        child: 
                         currentUserLocation == null 
                        ? Text("loading..")
                        : 
                        Stack(
                          children:  <Widget>[

                       
                            GoogleMap(
                              initialCameraPosition: CameraPosition(
                                target: LatLng(currentUserLocation.latitude,currentUserLocation.longitude)
                                ,zoom: 14
                              ),
                              // initialCameraPosition,
                            mapType: MapType.normal,
                            zoomControlsEnabled: false,
                            onMapCreated: (GoogleMapController controller) => googleMapController = controller,

                            polylines: {
                              Polyline(polylineId: PolylineId("route"),
                              points: polylineCoordinates,
                              color: primaryColor,
                              width: 6
                              ),
                              },
                            markers: markers,

                            ),
                  //   Positioned(
                  //     bottom: 0,
                  //     left: 0,
                  //     child: Container( 
                  //      child: Card( 
                  //       color: ui.Color.fromRGBO( 240, 231, 226,1),
                  //          child: Container(
                  //             padding: EdgeInsets.all(20),
                  //             child: distance==null
                  //             ? Text("loading")
                  //             : Text("Total Distance: " + distance!.toStringAsFixed(2)! + " KM",
                  //                          style: TextStyle(fontSize: 20, fontWeight:FontWeight.w600,color: Colors.black87))
                  //          ),
                  //      )
                  //     )
                  //  ),
                          ],
                        ),
                    ),
                  ),
                )
              ]
              )
              )
            ),
      ),
    );
  }
}
