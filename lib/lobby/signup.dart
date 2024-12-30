import 'dart:io';
import 'lobby.dart';
import 'signin.dart';
import 'package:modmet/main.dart';
import '../firebase_options.dart';
import 'package:modmet/database.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:avatar_glow/avatar_glow.dart';
import 'package:modmet/apppages/homepage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:modmet/model/profilemodel.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:touchable_opacity/touchable_opacity.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;


// import 'package:firebase_storage/firebase_storage.dart';
class Signup extends StatefulWidget {
  const Signup({super.key});

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> with SingleTickerProviderStateMixin{

  final ImagePicker _picker = ImagePicker();
  XFile? photo;
  void pickImage() async{
    photo = await _picker.pickImage(source: ImageSource.gallery,imageQuality: 25,requestFullMetadata: false);
    setState(() {
      
    });
  }
  late Position currentUserLocation;
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
    // context.loaderOverlay.hide();
  }
  Future<void> uploadPfp() async{
    File uploadFile = File(photo!.path);
    try{
      await firebase_storage.FirebaseStorage.instance.ref('uploads/${uploadFile.path}')
      .putFile(
        uploadFile != null ? uploadFile: File("assets/profile-image.jpg")
      );
    // } on FirebaseException catch(e){print(e);}
    } catch(e){print(e);}
  }
  Future<String> getDownload() async{
    File uploadedFile = File(photo!.path);
    return firebase_storage.FirebaseStorage.instance
    .ref("uploads/${uploadedFile.path}")
    .getDownloadURL();
  } 

  final formKey = GlobalKey<FormState>();
  ProfileModel profileModel = ProfileModel();
  final Future<FirebaseApp> firebase = Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
    );
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: firebase,
      builder: (context, snapshot){
        if(snapshot.hasError){
          return Scaffold(
            appBar: AppBar(title: Text("Error"),
            ),
            body: Center(child: Text("${snapshot.error}"),),
          );
        }
        if(snapshot.connectionState == ConnectionState.done)
        {
          return Scaffold(
            backgroundColor: Color.fromRGBO(253, 248, 241, 1),
            body: SafeArea(
              child: 
              LoaderOverlay(
                useDefaultLoading: false,
                overlayWidget: Center(
                  child: 
                  SpinKitCubeGrid(
                    color: Colors.red[300],
                    size: 50.0,
                  ),
                ),
                child: Center(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.all(32),
                    child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image(image: AssetImage('assets/images/modmet-logo.png'),
                        height: 150.0,
                        fit: BoxFit.cover,
                      ),
                    //Hello again
                    //SizedBox(height: 25,),
                    Text(
                      'Welcome!',
                      //style: TextStyle(fontSize: 24,fontWeight: FontWeight.bold),
                      style: GoogleFonts.pacifico(fontSize: 40),
                      ),
                    SizedBox(height: 10,),
                    Text(
                      'Let\'s hangout with friends',
                      style: TextStyle(fontSize: 20),
                      ),
                    
                    //image picker
                    GestureDetector(
                      onTap: (){
                        pickImage();
                      },
                      child: AvatarGlow(
                        glowColor: Color.fromRGBO(251, 157, 150, 1),
                        showTwoGlows: true,
                        repeat: true,
                        endRadius: 90,
                        child: Material(
                          shape: const CircleBorder(),
                          elevation: 90,
                          child:
                        CircleAvatar(
                          radius: 50,
                          backgroundImage: photo!=null
                          ? FileImage(File(photo!.path))
                          : null,
                          backgroundColor: Color.fromRGBO(250, 66, 56, 0.6),
                          child: photo==null
                          ? const Icon(
                            Icons.person,
                            color: Colors.white,
                            size: 60,
                            )
                          :null
                          ),
                        )
                          ),
                      ),
                      photo==null?
                    Text('add profile picture\n',style: TextStyle(fontWeight: FontWeight.w500,fontSize: 18,color: Colors.black26),
                      )
                      :


                    // TouchableOpacity(child: Text("x"),
                    // onTap: () async{
                    //   if(formKey.currentState!.validate()==true){
                    //     setState(() {
                    //       // isLoading = true;
                    //     });
                    //     await uploadPfp().then((value) async{});
                    //     String value = await getDownload();
                    //     try{
                    //       await Authent().
                    //     }
                    //   }
                    // },
                    
                    // ),


                    //email textfield
                    //SizedBox(height: 20,),
                    SizedBox(height: 30,),
                    Form(
                        key: formKey,child:
                        Column(children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25.0),
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
                            keyboardType: TextInputType.emailAddress,
                            onChanged: (String email) => profileModel.email = email,
                            validator: MultiValidator([
                              RequiredValidator(errorText: "Please field E-mail",),
                              EmailValidator(errorText: "Incorrect form of E-mail")
                            ]),
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: 'E-mail',
                            ),
                          ),
                        ),
                      ),
                    ),
                    //password textfield
                    SizedBox(height: 10,),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25.0),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          border: Border.all(color: Colors.white),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 20.0),
                          child: TextFormField(
                            validator: RequiredValidator(errorText: "Please field password",),
                            obscureText: true,
                            onChanged: (String password) => profileModel.password = password,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: 'Password',
                            ),
                          ),
                        ),
                      ),
                    ),

                    //name textfield
                    SizedBox(height: 10,),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25.0),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          border: Border.all(color: Colors.white),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 20.0),
                          child: TextFormField(
                            validator: RequiredValidator(errorText: "Please field your name",),
                            onChanged: (String name) => profileModel.name = name,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: 'Name',
                            ),
                          ),
                        ),
                      ),
                    ),

                    //surname textfield
                    SizedBox(height: 10,),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25.0),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          border: Border.all(color: Colors.white),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 20.0),
                          child: TextFormField(
                            validator: RequiredValidator(errorText: "Please field your surname",),
                            onChanged: (String surname) => profileModel.surname = surname,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: 'Surname',
                            ),
                          ),
                        ),
                      ),
                    ),



                    ],)
                    ),
                    //button

                    SizedBox(height: 15,),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal:25.0),
                      child: SizedBox(width: double.infinity,height: 60,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color.fromRGBO(250, 66, 56, 1),
                            foregroundColor: Color.fromRGBO(251, 157, 150, 1),
                            shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(12))),
                            shadowColor: Colors.white,
                          ),
                            onPressed: ()async{
                              _determinPositionvoid();
                                  if(formKey.currentState!.validate()){
                                  context.loaderOverlay.show();
                                    formKey.currentState!.save();
                                    try{
                                    await uploadPfp().then((newVal) async{});
                                    String newVal = await getDownload();
                                      try{
                                      await FirebaseAuth.instance.createUserWithEmailAndPassword(
                                        email: profileModel.email,
                                        password: profileModel.password
                                        ).then((value) async {
                                          // try{
                                          await FirebaseFirestore.instance.collection("users").doc(FirebaseAuth.instance.currentUser!.uid).set({
                                            "email" : profileModel.email,
                                            "name" : profileModel.name,
                                            "surname" : profileModel.surname,
                                            "imageUrl" : (newVal!=null) ? newVal : '',
                                            "friends" : [],
                                            "events" : [],
                                            "currentLocation" : [currentUserLocation.latitude,currentUserLocation.longitude],
                                          })
                                          .then((value){
                                            context.loaderOverlay.hide();
                                          // ignore: avoid_print
                                          print("email = ${profileModel.email} password = ${profileModel.password}");
                                          formKey.currentState?.reset();
                                          Fluttertoast.showToast(msg: "Sign up successful");
                                          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context){
                                            return MainWidget();
                                          }));
                                          });
                                        // }on FirebaseFirestore catch(e)
                                        // {
                                        //   print(e);
                                        // }
                                        });
                                    }on FirebaseAuthException catch(e){
                                            context.loaderOverlay.hide();
                                      // print(e.code);
                                      // print(e.message);
                                      Fluttertoast.showToast(msg: e.message! ,gravity: ToastGravity.CENTER);
                                    }
                                    } catch(e){
                                      context.loaderOverlay.hide();
                                      Fluttertoast.showToast(msg: "Please fill your image profile" ,gravity: ToastGravity.CENTER);
                                    }
                                  }
                                },
                              child: Text( 
                                  'Sign Up',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(color: Colors.white, fontSize: 20,fontWeight: FontWeight.bold),
                                  ),
                          ),
                      ),
                    ),

                    //already have a member? Login now
                    SizedBox(height: 10,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('already have a member? '),
                        TextButton(onPressed: () {
                        Navigator.push(context, MaterialPageRoute(
                          builder: (context) => Signin()
                          )
                          );
                          },
                          style: TextButton.styleFrom(
                            backgroundColor: Color.fromRGBO(250, 66, 56, 0.6),
                            // backgroundColor: Colors.white,
                            foregroundColor: Color.fromRGBO(253, 248, 241, 1),
                              disabledBackgroundColor: Color.fromRGBO(253, 248, 241, 1),
                              disabledForegroundColor: Color.fromRGBO(253, 248, 241, 1),

                          ),
                        child: Text('Sign In, Now',style: TextStyle(color: Color.fromRGBO(250, 66, 56, 0.6),fontWeight: FontWeight.bold),),)
                        
                      ],
                    ),
                    ],
                    ),
                  ),
                ),
              ),
            )
            );
        }
            return const Scaffold(body: Center(child: CircularProgressIndicator()),);
      }
      );
  }
}