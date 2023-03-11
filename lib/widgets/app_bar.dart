import 'package:cafeteria_official/assistantMethods/cartItemCounter.dart';
import 'package:cafeteria_official/mainScreens/cart_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MyAppBar extends StatefulWidget with PreferredSizeWidget
{
  final PreferredSizeWidget? bottom;
  final String? sellerUID;
  MyAppBar({this.bottom,this.sellerUID});

  @override
  State<MyAppBar> createState() => _MyAppBarState();

  @override
 
  Size get preferredSize => bottom==null?Size(56, AppBar().preferredSize.height):Size(56, 80+AppBar().preferredSize.height);
}

class _MyAppBarState extends State<MyAppBar> {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: IconButton(icon: Icon(Icons.arrow_back),
        onPressed:
            ()
        {
          Navigator.pop(context);
        },
      ),
      title: const Text("CAFETERIA",style: TextStyle(
        letterSpacing: 3,
      ),),
      centerTitle: true,
      automaticallyImplyLeading: true,
      actions: [
        Stack(
          children: [
            IconButton(onPressed: (){
              //send to cart
              Navigator.push(context, MaterialPageRoute(builder: (c)=>CartScreen(sellerUID: widget.sellerUID)));
            }, icon: const Icon(Icons.shopping_bag)),
            Positioned(
              child: Stack(
                children:  [
                 const Icon(Icons.brightness_1),
                  Positioned(top:3,
                    right: 4,
                    child: Center(
                     child: Consumer<CartItemCounter>(
                       builder: (context,counter,c){
                         return Text(
                           counter.count.toString(),
                           style:  const TextStyle(color: Colors.orange,fontWeight: FontWeight.bold,fontSize: 12)
                         );
                       },
                     ),
                    ),
                  ),

                ],
              ),
            ),
          ],
        )
      ],
    );
  }
}
