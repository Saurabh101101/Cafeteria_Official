import 'package:cafeteria_official/assistantMethods/assistant_methods.dart';
import 'package:cafeteria_official/global/global.dart';
import 'package:cafeteria_official/mainScreens/home.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class PlaceOrderScreen extends StatefulWidget {
  String? sellerUID;
  double? totalAmount;
  PlaceOrderScreen({this.sellerUID,this.totalAmount});

  @override
  State<PlaceOrderScreen> createState() => _PlaceOrderScreenState();
}

class _PlaceOrderScreenState extends State<PlaceOrderScreen> {


  String orderId=DateTime.now().millisecondsSinceEpoch.toString();

  addOrderDetails()
  {
    writeOrderDetailsForUser({
      "totalAmount":widget.totalAmount,
      "orderBy":sharedPreferences!.getString("uid"),
      "productIDs":sharedPreferences!.getStringList("userCart"),
      "payment": "Cash on Pickup",
      "orderTime":orderId,
      "isSuccess":true,
      "sellerUID": widget.sellerUID,
      "status": "normal",
      "orderId":orderId,

    });


    writeOrderDetailsForSeller({
      "totalAmount":widget.totalAmount,
      "orderBy":sharedPreferences!.getString("uid"),
      "productIDs":sharedPreferences!.getStringList("userCart"),
      "payment": "Cash on Pickup",
      "orderTime":orderId,
      "isSuccess":true,
      "sellerUID": widget.sellerUID,
      "status": "normal",
      "orderId":orderId,



    }).whenComplete((){
      clearCartNow(context);
      setState(() {
        orderId="";
        Navigator.push(context, MaterialPageRoute(builder: (context)=>  HomeScreen()));
        Fluttertoast.showToast(msg: "Congrats , Order is placed successfully ! ");
      });
    });
  }

  Future writeOrderDetailsForUser(Map<String,dynamic>data) async
  {
    await FirebaseFirestore.instance.collection("users").doc(sharedPreferences!
        .getString("uid")).collection("orders").doc(orderId).set(data);
  }

  Future writeOrderDetailsForSeller(Map<String,dynamic>data) async
  {
    await FirebaseFirestore.instance.collection("orders").doc(orderId).set(data);
  }


  Widget build(BuildContext context) {
    return Material(
      child: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset("assets/images/google.png"),
        FloatingActionButton.extended(
          onPressed: ()
          {
            addOrderDetails();
          },
          label: const Text("Place Order"),
          backgroundColor: Colors.teal[900],
          icon: const Icon(Icons.confirmation_number_outlined),
        ),
          ],
        ),
      ),
    );
  }
}
