import 'package:cafeteria_official/assistantMethods/assistant_methods.dart';
import 'package:cafeteria_official/model/items.dart';
import 'package:cafeteria_official/widgets/app_bar.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:number_inc_dec/number_inc_dec.dart';

class ItemDetailsScreen extends StatefulWidget {
  final Items? model;
  ItemDetailsScreen({this.model});
  @override
  State<ItemDetailsScreen> createState() => _ItemDetailsScreenState();
}

class _ItemDetailsScreenState extends State<ItemDetailsScreen> {

  TextEditingController counterTextEditingController = TextEditingController();
  @override





  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: MyAppBar(sellerUID: widget.model!.sellerUID),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: MediaQuery.of(context).size.height*0.3,
              width: MediaQuery.of(context).size.width,
              child: Image.network(widget.model!.thumbnailUrl.toString(),fit: BoxFit.cover,),
            ),


            Padding(
              padding: const EdgeInsets.all(18.0),
              child: NumberInputPrefabbed.squaredButtons(
                controller: counterTextEditingController,
                incDecBgColor: Colors.amber,
                min: 1,
                max: 25,
                initialValue: 1,
                buttonArrangement: ButtonArrangement.incRightDecLeft,
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                widget.model!.title.toString(),

                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20,color: Colors.teal),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                widget.model!.longDescription.toString(),
                textAlign: TextAlign.justify,
                style: const TextStyle(fontWeight: FontWeight.normal, fontSize: 16),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                widget.model!.price.toString() + " Rs",
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20,color: Colors.teal),
              ),
            ),

            const SizedBox(height: 10,),

            Center(
              child: InkWell(
                onTap: ()
                {
                  int itemCount=int.parse(counterTextEditingController.text);
                  //check if already
                  List<String> separateItemIDsList=separateItemIDs();
                  separateItemIDsList.contains(widget.model!.itemID)?Fluttertoast.showToast(msg: "Item is already present in Cart")
                       :addItemToCart(widget.model!.itemID.toString(),context,itemCount);

                  //add to cart


                },
                child: Container(
                  decoration: const BoxDecoration(
                      color: Colors.teal,
                  ),
                  width: MediaQuery.of(context).size.width - 13,
                  height: 50,
                  child: const Center(
                    child: Text(
                      "Add to Cart",
                      style: TextStyle(color: Colors.white, fontSize: 15),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
