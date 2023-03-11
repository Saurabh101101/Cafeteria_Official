import 'package:cafeteria_official/global/global.dart';
import 'package:cafeteria_official/mainScreens/home.dart';
import 'package:cafeteria_official/splash_screen/splash.dart';
import 'package:cafeteria_official/widgets/progress_bar.dart';
import 'package:cafeteria_official/widgets/status_banner.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class OrderDetails extends StatefulWidget {
 final String? orderId;
 OrderDetails({this.orderId});

  @override
  State<OrderDetails> createState() => _OrderDetailsState();
}

class _OrderDetailsState extends State<OrderDetails> {

  String orderStatus="";


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: FutureBuilder<DocumentSnapshot>(
        future: FirebaseFirestore.instance
            .collection("users")
        .doc(sharedPreferences!.getString("uid"))
        .collection("orders").doc(widget.orderId!).get(),
          builder: (c,snapshot)
          {
            Map? dataMap;
            if(snapshot.hasData)
              {
                dataMap=snapshot.data!.data()! as Map<String,dynamic>;
                orderStatus=dataMap["status"].toString();
              }
            return snapshot.hasData ? Container(
              child: Column(
                children: [
                StatusBanner(status: dataMap!["isSuccess"],orderStatus: orderStatus,),
                  const SizedBox(height: 10,),
                  Text("Total Amount : Rs"+dataMap["totalAmount"].toString(),style: TextStyle(
                    fontWeight: FontWeight.bold
                  ),),
                  Text( "Order Id :"+widget.orderId!),
                  Text("Order At : ${DateFormat("dd MMMM, yyyy - hh:mm aa")
                      .format(DateTime.fromMillisecondsSinceEpoch(int.parse(dataMap["orderTime"])))}"),
                  Divider(thickness: 4,),
                  orderStatus=="ended"?Image.asset("assets/images/ready.png"):Image.asset("assets/images/placed.webp"),
                  Center(
                    child: InkWell(
                      onTap: ()
                      {
                        Navigator.push(context, MaterialPageRoute(builder: (c)=>const MySplashScreen()));
                      },
                      child: Container(
                        color: Colors.teal,
                        height:50 ,
                        width: MediaQuery.of(context).size.width-40,
                        child: Center(
                          child: Text(" GO BACK"),
                        ),
                      ),
                    )
                  )

                ],
              ),
            )
                :Center(child:circularProgress(),);
          },
      ),
      ));
  }
}
