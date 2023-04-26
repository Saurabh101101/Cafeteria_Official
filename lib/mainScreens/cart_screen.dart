import 'package:cafeteria_official/assistantMethods/assistant_methods.dart';
import 'package:cafeteria_official/assistantMethods/cartItemCounter.dart';
import 'package:cafeteria_official/assistantMethods/total_amount.dart';
import 'package:cafeteria_official/mainScreens/home.dart';
import 'package:cafeteria_official/mainScreens/placed_order_screen.dart';
import 'package:cafeteria_official/model/items.dart';
import 'package:cafeteria_official/widgets/app_bar.dart';
import 'package:cafeteria_official/widgets/cart_item_design.dart';
import 'package:cafeteria_official/widgets/progress_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

import '../global/global.dart';

class CartScreen extends StatefulWidget {
  final String? sellerUID;

  CartScreen({this.sellerUID});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  List<int>? separateItemQuantityList;
  num totalAmount=0;
  String orderId=DateTime.now().millisecondsSinceEpoch.toString();
  String scheduledTime="";

  @override
  void initState()
  {
    super.initState();

    totalAmount=0;
    Provider.of<TotalAmount>(context,listen: false).displayTotalAmount(0);

    separateItemQuantityList=separateItemQuantities();

    _razorpay=Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }


  late Razorpay _razorpay;

  @override
  void dispose()
  {
    super.dispose();
    _razorpay.clear();
  }


  addOrderDetails(String date)
  {
    writeOrderDetailsForUser({
      "totalAmount":totalAmount,
      "orderBy":sharedPreferences!.getString("uid"),
      "productIDs":sharedPreferences!.getStringList("userCart"),
      "payment": "Cash on Pickup",
      "orderTime":orderId,
      "isSuccess":true,
      "sellerUID": widget.sellerUID,
      "status": "normal",
      "orderId":orderId,
      "pickUpTime":date,

    });


    writeOrderDetailsForSeller({
      "totalAmount":totalAmount,
      "orderBy":sharedPreferences!.getString("uid"),
      "productIDs":sharedPreferences!.getStringList("userCart"),
      "payment": "Cash on Pickup",
      "orderTime":orderId,
      "isSuccess":true,
      "sellerUID": widget.sellerUID,
      "status": "normal",
      "orderId":orderId,
      "pickUpTime":date,



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


    return Scaffold(
      appBar: AppBar(
        leading: IconButton(icon: Icon(Icons.delete_outline_rounded),
          onPressed:
              ()
          {
            clearCartNow(context);
            //Navigator.push(context, MaterialPageRoute(builder: (c)=>HomeScreen()));
          },
        ),
        title: Text("C A F E T E R í A",
          style: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.bold,
              fontFamily: 'Montserrat'
          ), ),
        centerTitle:true ,
        automaticallyImplyLeading: true,
        backgroundColor: Colors.teal[900]?.withOpacity(0.85),
        elevation: 0,

      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [

          Align(
            alignment: Alignment.bottomLeft,
            child: FloatingActionButton.extended(
                onPressed: ()
                async{
                  TimeOfDay? newTime= await showTimePicker(context: context, initialTime: time);
                  if(newTime==null) return;
                  setState(()=>scheduledTime=date+" - "+newTime.format(context).toString(),
                  );


                },
                label: const Text("Schedule"),
              backgroundColor: Colors.teal[900],
              icon: const Icon(Icons.alarm),
              heroTag: "btn1",
            ),
          ),
          Align(
            alignment: Alignment.bottomLeft,
            child: FloatingActionButton.extended(
              onPressed: ()
              {
                var options={
                  "key":"rzp_test_G8ReuFWUGuhFI9",
                  "amount":totalAmount*100,
                  "name":"APCOER",
                  "description":"Payment for Order",
                  "prefill":{
                    "contact":"7558494586",
                    "email":"application.cafeteria@gmail.com",
                  },
                  "external":{
                    "wallets":["paytm"]
                  },
                };
                try{
                  _razorpay.open(options);
                }catch(e)
                {
                  print(e.toString());
                }
                // Navigator.push(context, MaterialPageRoute(builder: (c)=>PlaceOrderScreen(
                //   totalAmount: totalAmount.toDouble(),
                //   sellerUID : widget.sellerUID.toString(),
                // )));
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
      title: Text("MY CART LIST ",style: TextStyle(
        color: Colors.blueGrey,fontWeight: FontWeight.bold,fontSize: 18,
      ),textAlign: TextAlign.center,),
      ),
          ),
          SliverToBoxAdapter(
            child: Consumer2<TotalAmount, CartItemCounter>(builder: (context,amountProvider,cartProvider,c){
              return Padding(padding: EdgeInsets.all(8),
              child: Center(
                child: cartProvider.count==0?Container():Text("Total Price: ${amountProvider.tAmount.toString()}",
                style: const TextStyle(
                  color: Colors.red,
                  fontSize: 20,
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

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    String pickup;
    // Do something when payment succeeds
    if(scheduledTime=="")
      {
        pickup=DateFormat("dd MMMM, yyyy - hh:mm aa")
            .format(DateTime.fromMillisecondsSinceEpoch(int.parse(DateTime.now().millisecondsSinceEpoch.toString())));
      }
    else{
      pickup=scheduledTime;
    }
    // String date=DateTime.now().toString();
    addOrderDetails(pickup);
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    // Do something when payment fails
    Fluttertoast.showToast(msg: "Payment Failed");
    clearCartNow(context);
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    // Do something when an external wallet was selected
    print("external");
  }

}
