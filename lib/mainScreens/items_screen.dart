import 'package:cafeteria_official/authentication/login.dart';
import 'package:cafeteria_official/global/global.dart';
import 'package:cafeteria_official/model/categories.dart';
import 'package:cafeteria_official/model/items.dart';
import 'package:cafeteria_official/widgets/app_bar.dart';
import 'package:cafeteria_official/widgets/categories_design.dart';
import 'package:cafeteria_official/widgets/items_design.dart';
import 'package:cafeteria_official/widgets/my_drawer.dart';
import 'package:cafeteria_official/widgets/progress_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class ItemsScreen extends StatefulWidget {
  final Categories? model;
  ItemsScreen({ this.model});

  @override
  State<ItemsScreen> createState() => _ItemsScreenState();
}

class _ItemsScreenState extends State<ItemsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: MyAppBar(sellerUID: widget.model!.sellerUID),
      body: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: ListTile(
                title: Text("${sharedPreferences!.getString("name")}, ORDER NOW?",textAlign: TextAlign.center,),
              ),
            ),
            StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance.
                collection("sellers").doc("DpuAj3utfVef9klNf5Pyb3tTwyH3")
                    .collection("categories").doc(widget.model!.menuId).collection("items")
                    .orderBy("publishedDate", descending: true)
                    .snapshots(),
                builder: (context,snapshot) {
                  return !snapshot.hasData
                      ? SliverToBoxAdapter(
                    child: Center(
                      child: circularProgress(),
                    ),
                  )
                      :SliverStaggeredGrid.countBuilder(crossAxisCount: 2, staggeredTileBuilder: (c)=>StaggeredTile.fit(1),
                    itemBuilder: (context, index) {
                      Items model =Items.fromJson(
                        snapshot.data!.docs[index].data()! as Map<String,dynamic>,
                      );
                      return ItemsDesignWidget(
                        model: model,
                        context: context,
                      );
                    },
                    itemCount: snapshot.data!.docs.length,
                  );
                }
            )
          ]

      ),
    );

  }
}

