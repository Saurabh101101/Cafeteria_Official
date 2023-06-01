import 'package:cafeteria_official/assistantMethods/cartItemCounter.dart';
import 'package:cafeteria_official/assistantMethods/total_amount.dart';
import 'package:cafeteria_official/authentication/login.dart';
import 'package:cafeteria_official/authentication/signup.dart';
import 'package:cafeteria_official/global/global.dart';
import 'package:cafeteria_official/splash_screen/splash.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

Future <void> main() async  {
  WidgetsFlutterBinding.ensureInitialized();

  sharedPreferences= await SharedPreferences.getInstance();
  await Firebase.initializeApp();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
      ChangeNotifierProvider(create: (c)=>CartItemCounter()),
        ChangeNotifierProvider(create: (c)=>TotalAmount()),
      ],
      child: MaterialApp(
        title: 'Cafeteria',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          // This is the theme of your application.
          //
          // Try running your application with "flutter run". You'll see the
          // application has a blue toolbar. Then, without quitting the app, try
          // changing the primarySwatch below to Colors.green and then invoke
          // "hot reload" (press "r" in the console where you ran "flutter run",
          // or simply save your changes to "hot reload" in a Flutter IDE).
          // Notice that the counter didn't reset back to zero; the application
          // is not restarted.
          primarySwatch: Colors.blue,

        ),
        home: const MySplashScreen(),
      ),
    );
  }
}
