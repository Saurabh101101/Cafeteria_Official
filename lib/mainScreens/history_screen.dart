import 'package:cafeteria_official/assistantMethods/assistant_methods.dart';
import 'package:cafeteria_official/global/global.dart';
import 'package:cafeteria_official/widgets/order_card.dart';
import 'package:cafeteria_official/widgets/progress_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({Key? key}) : super(key: key);

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(child: Scaffold(
      appBar: AppBar(
        title: const Text("MY HISTORY",style: TextStyle(
          letterSpacing: 3,
        ),),
        centerTitle: true,
        automaticallyImplyLeading: true,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection("users")
            .doc(sharedPreferences!.getString("uid"))
            .collection("orders")
            .where("status", isEqualTo: "picked" )
            .orderBy("orderTime", descending: true)
            .snapshots(),
        builder: (c,snapshot){
          return snapshot.hasData? ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (c,index){
              return FutureBuilder<QuerySnapshot>(
                future: FirebaseFirestore.instance
                    .collection("items")
                    .where("itemID", whereIn: separateOrderItemIDs((snapshot.data!.docs[index].data()! as Map<String, dynamic>) ["productIDs"]))
                    .where("orderBy", whereIn: (snapshot.data!.docs[index].data()! as Map<String, dynamic>)["uid"])
                    .orderBy("publishedDate", descending: true)
                    .get(),
                builder: (c,snap){
                  return snap.hasData? OrderCard(
                    itemCount: snap.data!.docs.length,
                    data:snap.data!.docs,
                    orderId: snapshot.data!.docs[index].id,
                    separateQuantityList: separateOrderItemQuantities((snapshot.data!.docs[index].data()as  Map<String,dynamic>)["productIDs"] ),
                  )
                      :Center(child: circularProgress());
                },
              );
            },

          ): Center(child: circularProgress(),
          );
        },
      ),
    ),
    );
  }
}
