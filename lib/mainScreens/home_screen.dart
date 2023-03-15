import 'package:cafeteria_official/mainScreens/search_screen.dart';
import 'package:flutter/material.dart';
import 'package:cafeteria_official/global/global.dart';
import 'package:cafeteria_official/model/categories.dart';
import 'package:cafeteria_official/widgets/categories_design.dart';
import 'package:cafeteria_official/widgets/my_drawer.dart';
import 'package:cafeteria_official/widgets/progress_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';



class MyHomeScreen extends StatefulWidget {
  const MyHomeScreen({Key? key}) : super(key: key);

  @override
  State<MyHomeScreen> createState() => _MyHomeScreenState();
}

class _MyHomeScreenState extends State<MyHomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(constraints: BoxConstraints.expand(),
      decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/bg.png'), fit: BoxFit.cover,) ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        drawer: MyDrawer(),
        appBar: AppBar(
          title: Text("C A F E T E R í A",
            style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
                fontFamily: 'Montserrat'
            ), ),
          centerTitle:true ,
          backgroundColor: Colors.teal[900]?.withOpacity(0.85),
          elevation: 0,
          actions: <Widget>[
            Padding(
                padding: const EdgeInsets.only(right: 20),
                child: CircleAvatar(
                  backgroundImage:  NetworkImage(
                      sharedPreferences!.getString("photoUrl")!
                  ),
                  radius: 20,
                )
            ), // avatar added here
          ],
        ),
        // backgroundColor: Colors.transparent,
        body: Stack(
            children: [
        Container(
        child: Padding(
        padding:  EdgeInsets.only(left: 15,right: 15,top:13),
        child: SizedBox(
          height: 50,
          child: ElevatedButton(onPressed: (){
            Navigator.push(context, MaterialPageRoute(builder: (context)=>const SearchScreen()));
          },
            style: ElevatedButton.styleFrom(backgroundColor:Colors.white,shape:StadiumBorder() ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text("Search",style: TextStyle(color:Colors.teal[900],fontSize: 16),),
                SizedBox(width: MediaQuery.of(context).size.width*0.60),
                Icon(Icons.search_outlined,color:Colors.teal[900],size: 28,)
              ],
            ),
          ),
        ),
      ),
    ),
      Padding(
        padding: EdgeInsets.only(top: MediaQuery.of(context).size.height*0.09),
        child: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: ListTile(
                  title: Text("${sharedPreferences!.getString("name")}, what's on your mind?",style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold,color: Colors.white),textAlign: TextAlign.center,),
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
   ]
        ),
      )
    );

  }
}
