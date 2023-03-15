
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
        child:Column(
          children: [

            CircleAvatar(backgroundImage: NetworkImage( widget.model!.thumbnailUrl!),radius: MediaQuery.of(context).size.width*0.15,),
            const SizedBox(height: 3,),
            Text(
              widget.model!.menuTitle!,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
              ),
            ),

          ],
        ),
      ),
    );
  }
}
