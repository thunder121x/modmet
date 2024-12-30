import 'lobby.dart';
import 'signup.dart';
import 'signup.dart';
import 'package:modmet/main.dart';
import '../firebase_options.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:modmet/model/profilemodel.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:form_field_validator/form_field_validator.dart';
class Signin extends StatefulWidget {
  const Signin({super.key});

  @override
  State<Signin> createState() => _SigninState();
}

class _SigninState extends State<Signin> {

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
              backgroundColor: Color.fromRGBO(253, 248, 241, 1),
              body: SafeArea(
                child: 
                Center(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.all(32),
                    child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image(image: AssetImage('assets/images/modmet-logo.png'),
                        height: 300.0,
                        fit: BoxFit.cover,
                      ),
                    //Hello again
                    //SizedBox(height: 25,),
                    Text(
                      'Hello Again!',
                      //style: TextStyle(fontSize: 24,fontWeight: FontWeight.bold),
                      style: GoogleFonts.pacifico(fontSize: 40),
                      ),
                    SizedBox(height: 10,),
                    Text(
                      'Welcome back, you\'ve been missed',
                      style: TextStyle(fontSize: 20),
                      ),

                    //email textfield
                    //SizedBox(height: 20,),
                    SizedBox(height: 50,),
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
                    ],)
                    ),

                    // sign in button
                    // SizedBox(height: 10,),

                    // Padding(
                    //   padding: const EdgeInsets.symmetric(horizontal:25.0),
                    //   child: Container(width: double.infinity,
                    //     padding: EdgeInsets.all(20),
                    //     decoration: BoxDecoration(
                    //       color: Color.fromRGBO(250, 66, 56, 1),
                    //       borderRadius: BorderRadius.circular(12)
                    //       ),
                    //     child: Text( 
                    //       'Sign In',
                    //       textAlign: TextAlign.center,
                    //       style: TextStyle(color: Colors.white, fontSize: 18),
                    //     ),
                    //   ),
                    // ),

                    SizedBox(height: 10,),
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
                                  if(formKey.currentState!.validate()){
                                    formKey.currentState!.save();
                                      try{
                                        await FirebaseAuth.instance.signInWithEmailAndPassword(email: profileModel.email, password: profileModel.password)
                                        .then((value) {
                                          formKey.currentState?.reset();
                                          Navigator.pushReplacement(context, 
                                          MaterialPageRoute(builder: (context){
                                            return MainWidget();
                                          }
                                          )
                                          );
                                        },)
                                        ;

                                    }on FirebaseAuthException catch(e){
                                      print(e.code);
                                      print(e.message);
                                      Fluttertoast.showToast(msg: e.message! ,gravity: ToastGravity.CENTER);
                                    }
                                  }
                                },
                              child: Text( 
                                  'Login',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(color: Colors.white, fontSize: 20,fontWeight: FontWeight.bold),
                                  ),
                          ),
                      ),
                    ),

                    //not a member? register now
                    SizedBox(height: 10,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Not a member? '),
                        TextButton(onPressed: () {
                          Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => Signup()), (route) => false);
                        // Navigator.push(context, MaterialPageRoute(
                        //   builder: (context) => Signup()
                        //   )
                        //   );
                          },
                          style: TextButton.styleFrom(
                            backgroundColor: Color.fromRGBO(250, 66, 56, 0.6),
                            // backgroundColor: Colors.white,
                            foregroundColor: Color.fromRGBO(253, 248, 241, 1),
                              disabledBackgroundColor: Color.fromRGBO(253, 248, 241, 1),
                              disabledForegroundColor: Color.fromRGBO(253, 248, 241, 1),

                          ),
                        child: Text('Sign Up, Now',style: TextStyle(color: Color.fromRGBO(250, 66, 56, 0.6),fontWeight: FontWeight.bold),),)
                        
                      ],
                    ),
                    ],
                    ),
                  ),
                ),
              )
              ),
          );
        }
            return const Scaffold(body: Center(child: CircularProgressIndicator()),);
      }
      );
  }
}