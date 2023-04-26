import 'package:cafeteria_official/model/items.dart';
import 'package:cafeteria_official/widgets/items_design.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {

  Future<QuerySnapshot>? itemList;
  String itemNameText="";

  initSearch(String textEntered)
  {
    itemList=FirebaseFirestore.instance.collection("items").where("title",isGreaterThanOrEqualTo: textEntered)
        .get();
  }
  
  @override
  
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.teal[900]
          ,title: TextField(
        onChanged: (textEntered)
            {

              setState(() {
                itemNameText=textEntered;
              });
              //init search
              initSearch(textEntered);
            },
        decoration: InputDecoration(

          hintText: "Search..",
          hintStyle: TextStyle(color: Colors.white),

          border: InputBorder.none,
          suffixIcon: IconButton(icon: Icon(Icons.search,color: Colors.white,),
          onPressed: (){
            initSearch(itemNameText);
          },
          ),
        ),
        style: const TextStyle(color: Colors.white,fontSize: 18),
      )),
      body: FutureBuilder<QuerySnapshot>(
        future:itemList ,
        builder: (context,snapshot){
          return snapshot.hasData?ListView.builder(
              itemCount:snapshot.data!.docs.length,
              itemBuilder: (context,index){
                Items model= Items.fromJson(
                snapshot.data!.docs[index].data()! as Map<String,dynamic>
                );

                return ItemsDesignWidget(
                  model: model,
                  context: context,
                );
              },
          )
              :Center(child: const Text("No Matches Found"),);
        },
      ),
      
    );
  }
}
