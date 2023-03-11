import 'package:cafeteria_official/authentication/login.dart';
import 'package:cafeteria_official/global/global.dart';
import 'package:cafeteria_official/model/categories.dart';
import 'package:cafeteria_official/widgets/categories_design.dart';
import 'package:cafeteria_official/widgets/my_drawer.dart';
import 'package:cafeteria_official/widgets/progress_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async =>false,
      child: Scaffold(
        drawer: MyDrawer(),
        appBar: AppBar(
          title: const Text("CAFETERIA",style: TextStyle(
            letterSpacing: 3,
          ),),
          centerTitle: true,
          automaticallyImplyLeading: true,

        ),
        body: CustomScrollView(
            slivers: [
               SliverToBoxAdapter(
                child: ListTile(
                  title: Text("${sharedPreferences!.getString("name")}, what's on your mind?",textAlign: TextAlign.center,),
                ),
              ),
              StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance.
                  collection("sellers").doc("DpuAj3utfVef9klNf5Pyb3tTwyH3")
                      .collection("categories").orderBy("publishedDate",descending: true).snapshots(),
                  builder: (context,snapshot) {
                    return !snapshot.hasData
                        ? SliverToBoxAdapter(
                      child: Center(
                        child: circularProgress(),
                      ),
                    )
                        :SliverStaggeredGrid.countBuilder(crossAxisCount: 2, staggeredTileBuilder: (c)=>StaggeredTile.fit(1),
                      itemBuilder: (context, index) {
                        Categories model =Categories.fromJson(
                          snapshot.data!.docs[index].data()! as Map<String,dynamic>,
                        );
                        return CategoriesDesignWidget(
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
      ),
    );

  }
}

