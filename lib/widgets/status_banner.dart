import 'package:cafeteria_official/mainScreens/home.dart';
import 'package:flutter/material.dart';

class StatusBanner extends StatelessWidget {
 final bool? status;
 final String? orderStatus;

 StatusBanner({this.status,this.orderStatus});

  @override
  Widget build(BuildContext context)
  {
    String? message;
  IconData? iconData;

  status! ? iconData=Icons.done :iconData=Icons.cancel;
  status! ?message="Successful":message="Unsuccessful";

    return Container(
      height: 40,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: ()
      {
        Navigator.push(context, MaterialPageRoute(builder: (c)=>const HomeScreen()));
      },
            child: const Icon(
              Icons.arrow_back,
              color: Colors.blue,
            ),
          ),
         const SizedBox(width: 20,),
          Text(
            orderStatus=="ended"? "Order Ready $message" :"Order Placed $message",
            style: TextStyle(
              fontSize: 16
            ),
          ),
          const SizedBox(width: 5,),
          CircleAvatar(radius: 8,backgroundColor: Colors.grey,
          child: Center(
            child: Icon(
              iconData,
              color: Colors.teal[900],
            ),
          ),
          )
        ],
      ),
    );
  }
}
