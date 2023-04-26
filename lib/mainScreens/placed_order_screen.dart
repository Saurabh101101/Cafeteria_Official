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

  addOrderDetails(String pickup)
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
      "Pickup Time":pickup,


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
      "Pickup Time":pickup,



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

  bool? check1 = false;
  TimeOfDay time=TimeOfDay(hour: 10, minute: 30);

  String date= "${DateTime.now().day} / ${DateTime.now().month} / ${DateTime.now().year}  ";




  Widget build(BuildContext context) {
    String scheduledTime=date+time.format(context).toString();

    return Material(
      child: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              children: [
                Checkbox(
                    value: check1, //set variable for value
                    onChanged: (bool? value) {
                      setState(() {
                        check1 = value;
                      });
                    }),
                Text("Check This to Schedule Order"),
              ],
            ),
            Row(children: [
              Text("Set Time :"),
              check1==true?
              IconButton(onPressed: ()async{
                TimeOfDay? newTime= await showTimePicker(context: context, initialTime: time);
                if(newTime==null) return;
                setState(()=>time=newTime,
                );


              }, icon: Icon(Icons.alarm)):
              Icon(Icons.alarm)
            ],),
        FloatingActionButton.extended(
          onPressed: ()
          {
            addOrderDetails(scheduledTime);
          },
          label: const Text("Place Order"),
          backgroundColor: Colors.teal[900],
          icon: const Icon(Icons.confirmation_number_outlined),
        ),
            Text(date+time.format(context).toString()),


          ],
        ),
      ),
    );
  }
}
