import 'package:cafeteria_official/global/global.dart';
import 'package:flutter/cupertino.dart';

class CartItemCounter extends ChangeNotifier
{
  int cartItemCounter=sharedPreferences!.getStringList("userCart")!.length-1;

  int get count => cartItemCounter;

  Future<void> displayCartCounter() async{

    cartItemCounter=sharedPreferences!.getStringList("userCart")!.length-1;
    await Future.delayed(const Duration(milliseconds: 100),(){
      notifyListeners();
    });
  }



}