import 'package:cafeteria_official/assistantMethods/assistant_methods.dart';
import 'package:cafeteria_official/assistantMethods/cartItemCounter.dart';
import 'package:cafeteria_official/assistantMethods/total_amount.dart';
import 'package:cafeteria_official/mainScreens/placed_order_screen.dart';
import 'package:cafeteria_official/model/items.dart';
import 'package:cafeteria_official/widgets/app_bar.dart';
import 'package:cafeteria_official/widgets/cart_item_design.dart';
import 'package:cafeteria_official/widgets/progress_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CartScreen extends StatefulWidget {
  final String? sellerUID;

  CartScreen({this.sellerUID});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  List<int>? separateItemQuantityList;
  num totalAmount=0;

  @override
  void initState()
  {
    super.initState();
    totalAmount=0;
    Provider.of<TotalAmount>(context,listen: false).displayTotalAmount(0);

    separateItemQuantityList=separateItemQuantities();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(icon: Icon(Icons.arrow_back_ios_new_outlined),
          onPressed:
              ()
          {
            clearCartNow(context);
          },
        ),
        title: const Text("CAFETERIA",style: TextStyle(
          letterSpacing: 3,
        ),),
        centerTitle: true,
        automaticallyImplyLeading: true,

      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Align(
            alignment: Alignment.bottomLeft,
            child: FloatingActionButton.extended(
                onPressed: ()
                {
                clearCartNow(context);
                },
                label: const Text("Clear Cart"),
              backgroundColor: Colors.teal[900],
              icon: const Icon(Icons.clear_all),
              heroTag: "btn1",
            ),
          ),
          Align(
            alignment: Alignment.bottomLeft,
            child: FloatingActionButton.extended(
              onPressed: ()
              {
                Navigator.push(context, MaterialPageRoute(builder: (c)=>PlaceOrderScreen(
                  totalAmount: totalAmount.toDouble(),
                  sellerUID : widget.sellerUID.toString(),
                )));
              },
              label: const Text("Checkout"),
              backgroundColor: Colors.teal[900],
              icon: const Icon(Icons.navigate_next),
              heroTag: "btn2",
            ),
          )
        ],
      ),
      body:  CustomScrollView(
        slivers: [
          //overall total amount
           SliverToBoxAdapter(
      child: ListTile(
      title: Text("MY CART LIST "),
      ),
          ),
          SliverToBoxAdapter(
            child: Consumer2<TotalAmount, CartItemCounter>(builder: (context,amountProvider,cartProvider,c){
              return Padding(padding: EdgeInsets.all(8),
              child: Center(
                child: cartProvider.count==0?Container():Text("Total Price: ${amountProvider.tAmount.toString()}",
                style: const TextStyle(
                  color: Colors.red,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
                ),
              ),);
            }),
          ),
          //display items
          StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection("items")
              .where("itemID", whereIn: separateItemIDs())
              .orderBy("publishedDate", descending: true)
              .snapshots(),
            builder: (context,snapshot)
            {
              return !snapshot.hasData?SliverToBoxAdapter(child: Center(
                child: circularProgress(),
              ),)
                  : snapshot.data!.docs.length==0
                  ?//startbuildingcart()
              Container():SliverList(delegate: SliverChildBuilderDelegate((context,index)
              {
                Items model=Items.fromJson(
                  snapshot.data!.docs[index].data()! as Map<String,dynamic>
                );

                if(index==0)
                  {
                    totalAmount=0;
                    totalAmount=totalAmount+(model.price!*separateItemQuantityList![index]);
                  }
                else{
                  totalAmount=totalAmount+(model.price!*separateItemQuantityList![index]);
                }
                if(snapshot.data!.docs.length-1==index)
                  {
                    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
                      Provider.of<TotalAmount>(context,listen: false).displayTotalAmount(totalAmount.toDouble());
                    });
                  }
                return CartItemDesign(
                  model: model,
                  context: context,
                  quantityNumber:separateItemQuantityList![index],
                );
              },
              childCount: snapshot.hasData? snapshot.data!.docs.length:0,
              ),
              );
            },
          ),


        ],
      ),
    );
  }
}
