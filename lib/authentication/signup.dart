
import 'dart:io';
import 'package:cafeteria_official/assistantMethods/notification_services.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:cafeteria_official/widgets/error_dialog.dart';
import 'package:cafeteria_official/widgets/loading_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as fStorage;
import 'package:shared_preferences/shared_preferences.dart';

import '../global/global.dart';
import '../mainScreens/home.dart';
import 'login.dart';


class MySignup extends StatefulWidget {
  const MySignup({Key? key}) : super(key: key);

  @override
  MySignupState createState() => MySignupState();
}

class MySignupState extends State <MySignup> {
   bool _isHidden1=true;
   NotificationServices notificationServices=NotificationServices();

  void _toggle1()
  {
    setState(() {
      _isHidden1=!_isHidden1;
    });
  }
  final GlobalKey<FormState> _formkey=GlobalKey<FormState>();
  TextEditingController nameController =TextEditingController() ;
  TextEditingController phoneController =TextEditingController() ;
  TextEditingController emailController =TextEditingController() ;
  TextEditingController passwordController =TextEditingController() ;
  XFile? imageXFile;
  final ImagePicker _picker=ImagePicker();
  String usersImageUrl="";
  String mtoken="";

  Future<void> _getImage() async
  {
    imageXFile= await _picker.pickImage(source: ImageSource.gallery);
    setState(() {
      imageXFile;
    });
  }

  Future<void> formValidation()async
  {
    if(imageXFile==null)
      {
        showDialog(
          context: context,
          builder:(c)
            {
              return ErrorDialog(message: "Please Select an image",);
            }
        );
      }
    else{
      if(nameController.text.isNotEmpty && phoneController.text.isNotEmpty && emailController.text.isNotEmpty && passwordController.text.isNotEmpty && phoneController.text.length==10 && phoneController.text.contains(RegExp(r'^[0-9]+$')))
      {
        //start upload
        showDialog(context: context, builder: (c)
        {
          return LoadingDialog(
            message: "Signing you up..",
          );
        }
        );
        
        String fileName=DateTime.now().millisecondsSinceEpoch.toString();
        fStorage.Reference reference=fStorage.FirebaseStorage.instance.ref().child("users").child(fileName);
        fStorage.UploadTask uploadTask=reference.putFile(File(imageXFile!.path));
        fStorage.TaskSnapshot taskSnapshot=await uploadTask.whenComplete((){});
        await taskSnapshot.ref.getDownloadURL().then((url) {
          usersImageUrl=url;

          //save info firestore
          authenticateUserAndSignUp();
        });
      }
      else{
        showDialog(
            context: context,
            builder:(c)
            {
              return ErrorDialog(message: "Please fill all required fields correctly",);
            }
        );
      }
    }
  }



   void getToken() async
   {
     final fcmToken=await FirebaseMessaging.instance.getToken();
     setState(() {
       mtoken=fcmToken.toString();
     });
     print(mtoken);
   }

   @override
   void initState()
   {
     super.initState();
     notificationServices.requestNotificationPermission();
     getToken();
   }

  void authenticateUserAndSignUp() async
  {
    User? currentUser;


    await firebaseAuth.createUserWithEmailAndPassword(email: emailController.text.trim(), password: passwordController.text.trim()).then((auth){
      currentUser=auth.user;
    }).catchError((error){
      Navigator.pop(context);
      showDialog(
          context: context,
          builder:(c)
          {
            return ErrorDialog(message:error.message.toString(),
            );
          }
      );
    });

    if(currentUser !=null)
      {
        saveDataToFirestore(currentUser!).then((value){
          Navigator.pop(context);
          //send to home
          Route newRoute=MaterialPageRoute(builder: (c)=>HomeScreen());
          Navigator.pushReplacement(context, newRoute);
        });
      }

  }

  Future saveDataToFirestore(User currentUser) async
  {
    FirebaseFirestore.instance.collection("users").doc(currentUser.uid).set({
      "userUID": currentUser.uid,
      "userEmail": currentUser.email,
      "userName" : nameController.text.trim(),
      "userPhone" : phoneController.text.trim(),
      "userAvatarUrl" : usersImageUrl,
      "status" : "verified",
      "userCart": ['garbageValue'],
      "token":mtoken,
    });

    //save data locally
     sharedPreferences=await SharedPreferences.getInstance();
    await sharedPreferences!.setString("uid", currentUser.uid);
    await sharedPreferences!.setString("name", nameController.text.trim());
    await sharedPreferences!.setString("photoUrl", usersImageUrl);
    await sharedPreferences!.setString("email", currentUser.email.toString());
    await sharedPreferences!.setString("phone", phoneController.text.trim());
    await sharedPreferences!.setStringList("userCart", ['garbageValue']);
  }


  @override
  Widget build(BuildContext context) {
    return Container(constraints: BoxConstraints.expand(),
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/bg.png'), fit: BoxFit.cover,) ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Stack(
          children: [
            Container(
              padding: EdgeInsets.only(left: 35,top:MediaQuery.of(context).size.height*0.1),
              child: Row(
                children: [
                  Text('WELCOME',style: TextStyle(
                    color: Color(0xFFFFFFFF),
                    fontSize: 50,
                  ),),
                      // SizedBox(width: 10),
                      // Icon(Icons.restaurant_outlined, color: Colors.white,size: 45),
                ],
                
              ),
              
            ),
            Padding(
              padding: EdgeInsets.only(left: 35,top:MediaQuery.of(context).size.height*0.18),
              child:Row(
                  children: [
                  Text('Create Account',style: TextStyle(
                      color: Colors.white,
                      fontSize: 25,)),
                      SizedBox(width: 10),
                      Icon(Icons.restaurant_outlined, color: Colors.white,size: 60),
                  ]
              )
              ),
            SingleChildScrollView(

              child: Container(
                padding: EdgeInsets.only(top:MediaQuery.of(context).size.height*0.28,right: 35,left: 35),
                child: Column(
                  children: [
                    InkWell(
                      onTap:()
                  {
                    _getImage();
                  },
                      child: CircleAvatar(
                        radius: MediaQuery.of(context).size.width*0.10,
                        backgroundColor: Colors.white,
                        backgroundImage:imageXFile==null ?null :FileImage(File(imageXFile!.path)) ,
                        child: imageXFile==null? Icon(Icons.add_photo_alternate_rounded,size: MediaQuery.of(context).size.width*0.1,color: Colors.teal[900],):null,
                      ),
                    ),

                    const SizedBox(height: 15),
                    Form(
                        key: _formkey,
                        child: Column(
                          children: [
                            TextField(
                              controller: nameController,
                              decoration: InputDecoration(
                                  prefixIcon: Icon(Icons.person_add_outlined,color: Colors.teal[900]),
                                  fillColor: Colors.white,
                                  filled: true,
                                  hintText:'Enter Name',
                                  hintStyle: TextStyle(color: Colors.teal[900]),
                                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10))
                              ),
                            ),
                            SizedBox(height: 15),
                            TextField(
                              controller: phoneController,
                              decoration: InputDecoration(
                                  prefixIcon: Icon(Icons.call_rounded,color: Colors.teal[900]),
                                  fillColor: Colors.white,
                                  filled: true,
                                  hintText:'Enter Phone Number',
                                  hintStyle: TextStyle(color: Colors.teal[900]),
                                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10))
                              ),
                            ),
                            SizedBox(height: 15),
                            TextField(
                              controller: emailController,

                              decoration: InputDecoration(

                                  prefixIcon: Icon(Icons.mail_sharp,color: Colors.teal[900]),
                                  fillColor: Colors.white,
                                  filled: true,
                                  hintText:'Enter Email',
                                  hintStyle: TextStyle(color: Colors.teal[900]),
                                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10))
                              ),
                            ),
                            SizedBox(height: 15),
                            TextField(
                              controller: passwordController,

                              obscureText: _isHidden1,
                              decoration: InputDecoration(
                                  prefixIcon: Icon(Icons.key_outlined,color: Colors.teal[900]),
                                  fillColor: Colors.white,
                                  filled: true,
                                  hintText:'Enter Password',
                                  hintStyle: TextStyle(color: Colors.teal[900]),
                                  suffix: InkWell(onTap:_toggle1,child: Icon(_isHidden1?Icons.visibility_off:Icons.visibility,color: Colors.teal[900],)),
                                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(15))
                              ),
                            ),
                          ],
                        )),

                    SizedBox(height: 40),
                    SizedBox(
                      height: 45,
                      width: 150,
                      child: ElevatedButton(onPressed: (){
                        formValidation();
                        },

                        style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.teal[900]?.withOpacity(0.8),
                        shape: StadiumBorder(),
                        elevation: 20.0,
                        textStyle: const TextStyle(color:Colors.blueAccent)

                       ),
                       child: const Text('Sign Up',style: TextStyle(fontWeight: FontWeight.bold),)),
                    ),
                    SizedBox(height: 20,),
                    Center(
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children:[

                              Text('Already have an account ?',style: TextStyle(
                                  color:Colors.white,fontSize: 15
                              ),),

                              TextButton(onPressed: (){
                                Navigator.push(context, MaterialPageRoute(builder: (context)=>MyLogin()));
                              },
                                  child: const Text("Sign In",style: TextStyle(color:Colors.tealAccent,fontSize: 15,decoration: TextDecoration.underline),)),
                            ]
                        )
                    ),
          ],
        ),
        )),
        // Padding(
        //   padding:  EdgeInsets.only(top:MediaQuery.of(context).size.height*0.84,left: 100,right: 90),
        //   child: Column(
        //     crossAxisAlignment: CrossAxisAlignment.center,
        //    children:[
        //     SizedBox(height: 25),
        //      Text('Already have an account ?',style: TextStyle(
        //               color: Color(0xFFFFFFFF),
        //               fontSize: 16,
        //               fontWeight: FontWeight.bold,
        //             ),),
        //             SizedBox(height: 15),
        //             SizedBox(
        //               height: 45,
        //               width: 150,
        //               child: ElevatedButton(onPressed: (){
        //                 Navigator.pop(context);
        //               },
        //
        //                 style: ElevatedButton.styleFrom(
        //                 backgroundColor: Colors.teal[900],
        //                 shape: StadiumBorder(),
        //                 elevation: 10.0,
        //                 textStyle: const TextStyle(color:Colors.teal)
        //
        //                ),
        //                child: const Text('Sign in')),
        //             ),
        //    ]
        //   ),
        // )
        ],
        )
        )
        );
  }
}