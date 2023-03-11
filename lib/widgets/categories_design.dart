
import 'package:cafeteria_official/mainScreens/items_screen.dart';
import 'package:cafeteria_official/model/categories.dart';
import 'package:flutter/material.dart';



class CategoriesDesignWidget extends StatefulWidget
{
  Categories? model;
  BuildContext? context;

  CategoriesDesignWidget({this.model, this.context});

  @override
  _CategoriesDesignWidgetState createState() => _CategoriesDesignWidgetState();
}



class _CategoriesDesignWidgetState extends State<CategoriesDesignWidget> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (){

        Navigator.push(context, MaterialPageRoute(builder: (c)=>ItemsScreen(model:widget.model)));
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
                widget.model!.menuTitle!,
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
