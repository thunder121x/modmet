// import 'dart:async';
// import 'package:geolocator/geolocator.dart';

// import 'constants.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_polyline_points/flutter_polyline_points.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:kf_drawer/kf_drawer.dart';
// class TrackingLocation extends KFDrawerContent {
//   TrackingLocation({Key? key});
//   @override
//   State<TrackingLocation> createState() => _TrackingLocationState();
// }

// class _TrackingLocationState extends State<TrackingLocation> {
//   late Future<Position> currentUserLocationx;
//   static const LatLng sourceLocation = LatLng(13.6520, 100.4977);
//   static const LatLng destinationLocation = LatLng(13.6504, 100.4981);
//   static LatLng currentUserLocation
//   = LatLng(13.6520, 100.4977)
//   ;
//   // static const LatLng sourceLocation = LatLng(37.33500926, -122.03272188);
//   // static const LatLng destinationLocation = LatLng(37.33500926, -122.03272188);
//   static const CameraPosition initialCameraPosition = CameraPosition(
//     target: LatLng(13.6520, 100.4977)
//     ,zoom: 14
//   );
//   Set<Marker> marker={
//                     Marker(markerId: MarkerId("source"),
//                     position: currentUserLocation
//                     ),
//                     Marker(markerId: MarkerId("destination"),
//                     position: destinationLocation
//                     )
//   };
//   final Completer<GoogleMapController> _controller = Completer();
//   List<LatLng> polylineCoordinates=[];
//   // Position? currentUserLocation;
//   Future<Position> _determinPosition() async{
//     bool serviceEnabled;
//     LocationPermission permission;
//     serviceEnabled = await Geolocator.isLocationServiceEnabled();
//     if(!serviceEnabled){
//       return Future.error('Location service are disabled');
//     }
//     permission = await Geolocator.checkPermission();
//     if(permission==LocationPermission.denied){
//       permission = await Geolocator.requestPermission();
//       if(permission==LocationPermission.denied){
//         return Future.error('Location permission denied');
//       }
//     }
//     if(permission == LocationPermission.deniedForever){
//       return Future.error('Location permission are permanently denied');
//     }
//     Position position = await Geolocator.getCurrentPosition();
//     return position;
  
//   }
//   void _determinPositionvoid() async{
//     bool serviceEnabled;
//     LocationPermission permission;
//     serviceEnabled = await Geolocator.isLocationServiceEnabled();
//     if(!serviceEnabled){
//       return Future.error('Location service are disabled');
//     }
//     permission = await Geolocator.checkPermission();
//     if(permission==LocationPermission.denied){
//       permission = await Geolocator.requestPermission();
//       if(permission==LocationPermission.denied){
//         return Future.error('Location permission denied');
//       }
//     }
//     if(permission == LocationPermission.deniedForever){
//       return Future.error('Location permission are permanently denied');
//     }
//     Position position;
//     Geolocator.getCurrentPosition().then((position) => currentUserLocation=LatLng(position.latitude, position.longitude) );
  
//   }
  
//   void getPolyPoint() async{
//     PolylinePoints polylinePoints = PolylinePoints();
//     PolylineResult polylineResult = await polylinePoints.getRouteBetweenCoordinates(
//       google_api_key, 
//       PointLatLng(currentUserLocation!.latitude,currentUserLocation!.longitude), 
//       PointLatLng(destinationLocation.latitude, destinationLocation.longitude));
//     if(polylineResult.points.isNotEmpty){
//       polylineResult.points.forEach((PointLatLng point) {
//         polylineCoordinates.add(LatLng(point.latitude,point.longitude));
//        });
//        setState(() {
         
//        });
//     }
//   }
  

//   @override
//   void initState() {
//     super.initState();
    
//     getPolyPoint();
//     super.initState();
// }
// late GoogleMapController googleMapController;

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       floatingActionButton: FloatingActionButton(onPressed: () async{
//         Position position = await _determinPosition();        
//         googleMapController.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(zoom: 15,target: LatLng(position.latitude,position.longitude))));
//         marker.clear();
//         // print("postionxxx : ${position.latitude}");
//         marker.add(Marker(markerId: const MarkerId("currentLocation"),position: LatLng(position.latitude,position.longitude)));
//         setState(() {
//           currentUserLocation=LatLng(position.latitude,position.longitude);
//         });
//       },),
//       body: SafeArea(
//         child: Center(child: Column(children: <Widget>[
//           Row(children: <Widget>[
//             ClipRRect(
//               borderRadius: BorderRadius.all(Radius.circular(32)),
//               child: Material(
//                 shadowColor: Colors.transparent,
//                 color:  Colors.transparent,
//                 child: IconButton(icon: Icon(Icons.menu,color: Colors.black,),
//                 onPressed: widget.onMenuPressed,
//                 ),
//               ),
//             )
//           ],),
//           Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Text("Friends",style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
//               SizedBox(height: 10,),
//             ],
//           ),
//           Expanded(
//             child: Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: Container(
//                 decoration: BoxDecoration(
//                   color: Colors.black,
//                           border: Border.all(color: Colors.grey,width: 5),
//                           // borderRadius: BorderRadius.circular(30),
//                 ),
//                   child:
//                   //  currentUserLocation==null 
//                   // ? Text("loading..")
//                   // : 
//                   GoogleMap(
//                     initialCameraPosition: initialCameraPosition,
//                   mapType: MapType.normal,
//                   zoomControlsEnabled: false,
//                   onMapCreated: (GoogleMapController controller) => googleMapController = controller,

//                   polylines: {
//                     Polyline(polylineId: PolylineId("route"),
//                     points: polylineCoordinates,
//                     color: primaryColor,
//                     width: 6
//                     ),
//                     },
//                   markers: marker,

//                   ),
//               ),
//             ),
//           )
//         ]
//         )
//         )
//       ),
//     );
//     // return Scaffold(
//     //   appBar: AppBar(title: Text("Tracking",style: TextStyle(color: Colors.black, fontSize: 16),),
//     //   ),
//     //   body: GoogleMap(
//     //     initialCameraPosition: CameraPosition(
//     //       target: sourceLocation,zoom: 14.5),
//     //     markers: {
//     //       Marker(markerId: MarkerId("source"),
//     //       position: sourceLocation
//     //       ),
//     //     },
//     //   ),


//     // );
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:math';
import 'dart:ui' as ui;
import 'package:flutter/services.dart';
import 'package:kf_drawer/kf_drawer.dart';
import 'package:modmet/maps/constants.dart';
class TrackingLocation extends KFDrawerContent{
  @override
  _TrackingLocationState createState() => _TrackingLocationState();
}

class _TrackingLocationState extends State<TrackingLocation> {
Future<Uint8List> getBytesFromCanvas(int width, int height) async {
  final ui.PictureRecorder pictureRecorder = ui.PictureRecorder();
  final Canvas canvas = Canvas(pictureRecorder);
  final Paint paint = Paint()..color = Colors.blue;
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
    text: 'thunder',
    style: TextStyle(fontSize: 25.0, color: Colors.white),
  );
  painter.layout();
  painter.paint(canvas, Offset((width * 0.5) - painter.width * 0.5, (height * 0.5) - painter.height * 0.5));
  final img = await pictureRecorder.endRecording().toImage(width, height);
  final data = await img.toByteData(format: ui.ImageByteFormat.png);
  return data!.buffer.asUint8List();
  }


  GoogleMapController? mapController; //contrller for Google map
  PolylinePoints polylinePoints = PolylinePoints();

  String googleAPiKey = "AIzaSyDma7ThRPGokuU_cJ2Q_qFvowIpK35RAPs";
  
  Set<Marker> markers = Set(); //markers for google map
  Map<PolylineId, Polyline> polylines = {}; //polylines to show direction

  LatLng startLocation = LatLng(27.6683619, 85.3101895);  
  LatLng endLocation = LatLng(27.6875436, 85.2751138); 

  double distance = 0.0;
           
  List<LatLng> polylineCoordinates=[];
  void getPolyPoint() async{
    PolylinePoints polylinePoints = PolylinePoints();
    PolylineResult polylineResult = await polylinePoints.getRouteBetweenCoordinates(
      google_api_key, 
      PointLatLng(27.6683619, 85.3101895), 
      PointLatLng(27.6875436, 85.2751138));
    if(polylineResult.points.isNotEmpty){
      polylineResult.points.forEach((PointLatLng point) {
        polylineCoordinates.add(LatLng(point.latitude,point.longitude));
       });

      double totalDistance = 0;
      for(var i = 0; i < polylineCoordinates.length-1; i++){
           totalDistance += calculateDistance(
                polylineCoordinates[i].latitude, 
                polylineCoordinates[i].longitude, 
                polylineCoordinates[i+1].latitude, 
                polylineCoordinates[i+1].longitude);
      }
      print("total: ${totalDistance}");
       setState(() {
         
       });
    }
    
  }
                   

  @override
  void initState() {
    test();
    //  markers.add(Marker( //add start location marker
    //     markerId: MarkerId(startLocation.toString()),
    //     position: startLocation, //position of marker
    //     infoWindow: InfoWindow( //popup info 
    //       title: 'Starting Point ',
    //       snippet: 'Start Marker',
    //     ),
    //     icon: BitmapDescriptor.fromBytes(markerIcon),
    //   ));

    //   markers.add(Marker( //add distination location marker
    //     markerId: MarkerId(endLocation.toString()),
    //     // icon: BitmapDescriptor.fromBytes(markerIcon),
    //     position: endLocation, //position of marker
    //     infoWindow: InfoWindow( //popup info 
    //       title: 'Destination Point ',
    //       snippet: 'Destination Marker',
    //     ),
    //     icon: BitmapDescriptor.fromBytes(markerIcon), //Icon for Marker
    //   ));
      getPolyPoint();
      // getDirections(); //fetch direction polylines from Google API
      
    super.initState();
  }
  test() async{
    markerIcon = await getBytesFromCanvas(200, 100);
    
     markers.add(Marker( //add start location marker
        markerId: MarkerId(startLocation.toString()),
        position: startLocation, //position of marker
        infoWindow: InfoWindow( //popup info 
          title: 'Starting Point ',
          snippet: 'Start Marker',
        ),
        icon: BitmapDescriptor.fromBytes(markerIcon),
      ));

      markers.add(Marker( //add distination location marker
        markerId: MarkerId(endLocation.toString()),
        // icon: BitmapDescriptor.fromBytes(markerIcon),
        position: endLocation, //position of marker
        infoWindow: InfoWindow( //popup info 
          title: 'Destination Point ',
          snippet: 'Destination Marker',
        ),
        icon: BitmapDescriptor.fromBytes(markerIcon), //Icon for Marker
      ));
  }
  late Uint8List markerIcon ;
  getDirections() async {
      List<LatLng> polylineCoordinates = [];
     
      PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
          googleAPiKey,
          PointLatLng(startLocation.latitude, startLocation.longitude),
          PointLatLng(endLocation.latitude, endLocation.longitude),
          travelMode: TravelMode.driving,
      );

      if (result.points.isNotEmpty) {
            result.points.forEach((PointLatLng point) {
                polylineCoordinates.add(LatLng(point.latitude, point.longitude));
            });
      } else {
         print(result.errorMessage);
      }

      //polulineCoordinates is the List of longitute and latidtude.
      double totalDistance = 0;
      for(var i = 0; i < polylineCoordinates.length-1; i++){
           totalDistance += calculateDistance(
                polylineCoordinates[i].latitude, 
                polylineCoordinates[i].longitude, 
                polylineCoordinates[i+1].latitude, 
                polylineCoordinates[i+1].longitude);
      }
      print(totalDistance);

      setState(() {
         distance = totalDistance;
      });

      //add to the list of poly line coordinates
      // addPolyLine(polylineCoordinates);
  }

  // addPolyLine(List<LatLng> polylineCoordinates) {
  //   PolylineId id = PolylineId("poly");
  //   Polyline polyline = Polyline(
  //     polylineId: id,
  //     color: Colors.deepPurpleAccent,
  //     points: polylineCoordinates,
  //     width: 8,
  //   );
  //   polylines[id] = polyline;
  //   setState(() {});
  // }

  double calculateDistance(lat1, lon1, lat2, lon2){
    var p = 0.017453292519943295;
    var a = 0.5 - cos((lat2 - lat1) * p)/2 + 
          cos(lat1 * p) * cos(lat2 * p) * 
          (1 - cos((lon2 - lon1) * p))/2;
    return 12742 * asin(sqrt(a));
  }
  
  @override
  Widget build(BuildContext context) {
    
    return  Scaffold(
          appBar: AppBar( 
             title: Text("Calculate Distance in Google Map"),
             backgroundColor: Colors.deepPurpleAccent,
          ),
          body: Stack(
            children:[
                GoogleMap( //Map widget from google_maps_flutter package
                        zoomGesturesEnabled: true, //enable Zoom in, out on map
                        initialCameraPosition: CameraPosition( //innital position in map
                          target: startLocation, //initial position
                          zoom: 14.0, //initial zoom level
                        ),
                        markers: markers, //markers to show on map
                        polylines: Set<Polyline>.of(polylines.values), //polylines
                        mapType: MapType.normal, //map type
                        onMapCreated: (controller) { //method called when map is created
                          setState(() {
                            mapController = controller; 
                          });
                        },
                  ),

                  Positioned(
                    bottom: 200,
                    left: 50,
                    child: Container( 
                     child: Card( 
                         child: Container(
                            padding: EdgeInsets.all(20),
                            child: Text("Total Distance: " + distance.toStringAsFixed(2) + " KM",
                                         style: TextStyle(fontSize: 20, fontWeight:FontWeight.bold))
                         ),
                     )
                    )
                 )
            ]
          )
       );
  }
}