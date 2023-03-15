import 'package:cafeteria_official/assistantMethods/cartItemCounter.dart';
import 'package:cafeteria_official/mainScreens/home.dart';
import 'package:cafeteria_official/splash_screen/splash.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:cafeteria_official/global/global.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';



separateOrderItemIDs(orderIDs)
{
  List<String> separateItemIDsList=[], defaultItemList=[];
  int i=0;
  defaultItemList= List<String>.from(orderIDs) ;

  for(i;i<defaultItemList.length;i++)
  {
    String item=defaultItemList[i].toString();
    var pos=item.lastIndexOf(":");
    String getItemId=(pos!= -1)?item.substring(0,pos):item;

    //print("\nTHIS IS ITEMID NOW:$getItemId");

    separateItemIDsList.add(getItemId);

  }

  //print("\nTHIS IS ITEM LIST NOW:$separateItemIDsList");
  return separateItemIDsList;
}


separateItemIDs()
{
  List<String> separateItemIDsList=[], defaultItemList=[];
  int i=0;
  defaultItemList= sharedPreferences!.getStringList("userCart")!;

  for(i;i<defaultItemList.length;i++)
    {
      String item=defaultItemList[i].toString();
      var pos=item.lastIndexOf(":");
      String getItemId=(pos!= -1)?item.substring(0,pos):item;

      //print("\nTHIS IS ITEMID NOW:$getItemId");

      separateItemIDsList.add(getItemId);

    }

  //print("\nTHIS IS ITEM LIST NOW:$separateItemIDsList");
  return separateItemIDsList;
  }





separateOrderItemQuantities(orderIDs)
{
  List<String> separateItemQuantityList=[];
  List<String> defaultItemList=[];
  int i=1;
  defaultItemList=List<String>.from(orderIDs) ;

  for(i;i<defaultItemList.length;i++)
  {
    String item=defaultItemList[i].toString();

    List<String> listItemCharacters=item.split(":").toList();

    var quantityNumber=int.parse(listItemCharacters[1].toString());

    separateItemQuantityList.add(quantityNumber.toString());

  }


  return separateItemQuantityList;
}




separateItemQuantities()
{
  List<int> separateItemQuantityList=[];
  List<String> defaultItemList=[];
  int i=1;
  defaultItemList= sharedPreferences!.getStringList("userCart")!;

  for(i;i<defaultItemList.length;i++)
  {
    String item=defaultItemList[i].toString();

    List<String> listItemCharacters=item.split(":").toList();

    var quantityNumber=int.parse(listItemCharacters[1].toString());

    separateItemQuantityList.add(quantityNumber);

  }


  return separateItemQuantityList;
}




addItemToCart(String foodItemId, BuildContext context,int itemCounter)
{
List<String>? tempList =sharedPreferences!.getStringList("userCart");
tempList!.add("$foodItemId:$itemCounter");

FirebaseFirestore.instance.collection("users").doc(firebaseAuth.currentUser!.uid)
.update({"userCart":tempList,
}).then((value){
  Fluttertoast.showToast(msg: "Item Added Successfully");
  sharedPreferences!.setStringList("userCart", tempList);

  //update the badge
  Provider.of<CartItemCounter>(context,listen: false).displayCartCounter();
});






}


clearCartNow(context)
{
  sharedPreferences!.setStringList("userCart", ['garbageValue']);

  List <String>? emptyList=sharedPreferences!.getStringList("userCart");

  FirebaseFirestore.instance.collection("users").doc(firebaseAuth.currentUser!.uid).update({"userCart": emptyList}).then((value) {
    sharedPreferences!.setStringList("userCart", emptyList!);
    Provider.of<CartItemCounter>(context,listen: false).displayCartCounter();

    Navigator.push(context, MaterialPageRoute(builder: (c)=> MySplashScreen()));

    Fluttertoast.showToast(msg: "Cart has been cleared Successfully ! ");
  });
}