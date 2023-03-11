
import 'package:cafeteria_official/mainScreens/item_details_screen.dart';
import 'package:cafeteria_official/mainScreens/items_screen.dart';
import 'package:cafeteria_official/model/categories.dart';
import 'package:cafeteria_official/model/items.dart';
import 'package:flutter/material.dart';



class ItemsDesignWidget extends StatefulWidget
{
  Items? model;
  BuildContext? context;

  ItemsDesignWidget({this.model, this.context});

  @override
  _ItemsDesignWidgetState createState() => _ItemsDesignWidgetState();
}



class _ItemsDesignWidgetState extends State<ItemsDesignWidget> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (){

        Navigator.push(context, MaterialPageRoute(builder: (c)=>ItemDetailsScreen(model:widget.model)));
      },
      splashColor: Colors.amber,
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child:Container(
          height: MediaQuery.of(context).size.height*0.32,
          width: MediaQuery.of(context).size.width*0.48,
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft:Radius.circular(25) ,
                topRight:Radius.zero ,
                bottomLeft:Radius.zero,
                bottomRight: Radius.circular(25),
              )
          ),
          child: Column(
            children: [
              Divider(
                height: 4,
                thickness: 3,
                color: Colors.grey[300],
              ),
              CircleAvatar(backgroundImage: NetworkImage( widget.model!.thumbnailUrl!),radius: MediaQuery.of(context).size.width*0.15,),
              const SizedBox(height: 3,),
              Text(
                widget.model!.title!,
                style: const TextStyle(
                  color: Colors.cyan,
                  fontSize: 20,
                ),
              ),
              const SizedBox(height: 1,),
              Text(
                widget.model!.price!.toString(),
                style: const TextStyle(
                  color: Colors.cyan,
                  fontSize: 20,
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }
}
