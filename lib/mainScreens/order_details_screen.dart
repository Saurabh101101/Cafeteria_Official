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
      appBar: AppBar(
        title: Text("O R D E R   D E T A I L S",
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
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 10,),
                  StatusBanner(status: dataMap!["isSuccess"],orderStatus: orderStatus,),
                    const SizedBox(height: 10,),
                    Text("Total Amount : Rs "+dataMap["totalAmount"].toString(),style: TextStyle(
                      fontWeight: FontWeight.bold,color: Colors.teal,fontSize: 17,fontStyle: FontStyle.italic
                    ),),
                    SizedBox(height: 10,),
                    Text( "Order Id :"+widget.orderId!,style: TextStyle(
                        fontWeight: FontWeight.bold,color: Colors.teal,fontSize: 17,fontStyle: FontStyle.italic
                    ),),
                    SizedBox(height: 10,),
                    Text("Order Time : ${DateFormat("dd MMMM, yyyy - hh:mm aa")
                        .format(DateTime.fromMillisecondsSinceEpoch(int.parse(dataMap["orderTime"])))}",style: TextStyle(
                        fontWeight: FontWeight.bold,color: Colors.teal,fontSize: 17,fontStyle: FontStyle.italic
                    ),),
                    const SizedBox(height: 10,),
                    Text("Order Pickup Time : "+dataMap["pickUpTime"].toString(),style: TextStyle(
                        fontWeight: FontWeight.bold,color: Colors.teal,fontSize: 17,fontStyle: FontStyle.italic
                    ),),
                    SizedBox(height: 10,),
                    Divider(thickness: 2,color: Colors.red,),
                    SizedBox(height: 10,),


                    Center(child: orderStatus=="normal"?Image.asset("assets/images/placed.png"):orderStatus=="ready"?Image.asset("assets/images/ready1.jpg"):Image.asset("assets/images/picked.png")),
                    SizedBox(height: 50,),

                    Center(
                      child: InkWell(
                        onTap: ()
                        {
                          Navigator.pop(context);
                        },
                        child: Container(
                          decoration: BoxDecoration(

                            color: Colors.teal,
                          ),

                          height:50 ,
                          width: MediaQuery.of(context).size.width-40,
                          child: Center(
                            child: Text(" GO BACK",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 18),),
                          ),
                        ),
                      )
                    )

                  ],
                ),
              ),
            )
                :Center(child:circularProgress(),);
          },
      ),
      ));
  }
}
