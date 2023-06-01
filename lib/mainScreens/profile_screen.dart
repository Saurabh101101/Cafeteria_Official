import 'package:cafeteria_official/mainScreens/home.dart';
import 'package:cafeteria_official/widgets/error_dialog.dart';
import 'package:cafeteria_official/widgets/loading_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../global/global.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {

  TextEditingController nameController =TextEditingController() ;
  TextEditingController phoneController =TextEditingController() ;


  Future<void> formValidation()async
  {
    if (nameController.text.isNotEmpty && phoneController.text.isNotEmpty && phoneController.text.length==10 && phoneController.text.contains(RegExp(r'^[0-9]+$'))) {
      showDialog(context: context, builder: (c) {
        return LoadingDialog(
          message: "Updating Changes..",
        );
      }
      );
      FirebaseFirestore.instance.collection("users").doc(
          sharedPreferences!.getString("uid")).update({
        "userName": nameController.text.trim(),
        "userPhone": phoneController.text.trim(),
      });

      sharedPreferences=await SharedPreferences.getInstance();
      await sharedPreferences!.setString("name", nameController.text.trim());
      await sharedPreferences!.setString("phone", phoneController.text.trim());
      Fluttertoast.showToast(msg: "Details saved successfully ! ");
      
      Navigator.pop(context);
      //send to home
      Route newRoute=MaterialPageRoute(builder: (c)=>HomeScreen());
      Navigator.pushReplacement(context, newRoute);

    }
    else{
      showDialog(
          context: context,
          builder:(c)
          {
            return ErrorDialog(message: "Please fill all fields correctly",);
          }
      );
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("E D I T  P R O F I L E",
          style: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.bold,
              fontFamily: 'Montserrat'
          ), ),
        centerTitle:true ,
        automaticallyImplyLeading: false,
        backgroundColor: Colors.teal[900]?.withOpacity(0.85),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Container(

          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(25.0),
                child: SizedBox(
                  width: 120,
                  height: 120,
                  child: CircleAvatar(
                    backgroundImage:  NetworkImage(
                        sharedPreferences!.getString("photoUrl")!
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 30,),
              Form(child: Column(
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
                        child: const Text('Apply Changes',style: TextStyle(fontWeight: FontWeight.bold),)),
                  ),
                ],
              ))

            ],
          ),
        ),
      ),
    );
  }
}
