import 'package:flutter/material.dart';

import '../global/global.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: (){
          Navigator.pop(context);
          }, icon: const Icon(Icons.arrow_back_ios_new_outlined),
        ),
        title: const Text("Edit Profile", style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 15,
        ),),

      ),
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            children: [
              SizedBox(
                width: 120,
                height: 120,
                child: CircleAvatar(
                  backgroundImage:  NetworkImage(
                      sharedPreferences!.getString("photoUrl")!
                  ),
                ),
              ),
              const SizedBox(height: 30,),
              Form(child: Column(
                children: [
                  TextFormField(
                    decoration: InputDecoration(
                      label:Text("Full Name"),
                      prefixIcon: Icon(Icons.person),
                      hintText:
                        sharedPreferences!.getString("name")!,

                      ),
                    ),
                  const SizedBox(height: 15,),
                  TextFormField(
                    decoration: InputDecoration(
                      label:Text("Email"),
                      prefixIcon: Icon(Icons.email_outlined),
                      hintText:
                      sharedPreferences!.getString("email")!,

                    ),
                  ),
                  const SizedBox(height: 15,),
                  TextFormField(
                    decoration: InputDecoration(
                      label:Text("Phone"),
                      prefixIcon: Icon(Icons.phone),
                      hintText:
                      sharedPreferences!.getString("phone")!,

                    ),
                  ),
                  const SizedBox(height: 30,),
                  ElevatedButton(onPressed: (){

                  }, child: Text("Update Changges"))
                ],
              ))

            ],
          ),
        ),
      ),
    );
  }
}
