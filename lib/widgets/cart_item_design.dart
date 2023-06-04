import 'package:cafeteria_official/model/items.dart';
import 'package:flutter/material.dart';

class CartItemDesign extends StatefulWidget {
  final Items? model;
  BuildContext? context;
  final int? quantityNumber;

  CartItemDesign({
    this.model,this.context,this.quantityNumber
});

  @override
  State<CartItemDesign> createState() => _CartItemDesignState();
}

class _CartItemDesignState extends State<CartItemDesign> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashColor: Colors.cyan,
      child: Padding(
        padding:const EdgeInsets.all(6),
        child: Container(
          height: 150,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            border:Border.all(width: 2,color: Colors.white)

          ),
          child: Row(
            children: [
              Image.network(widget.model!.thumbnailUrl!,width: 140, height: 120,),
              const SizedBox(width: 6,),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(widget.model!.title!,style: const TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),),
                    const SizedBox(height: 5,),
                    Text("Rs "+widget.model!.price!.toString(),style: const TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),),
                    const SizedBox(height: 5,),
                    Row(
                      children: [
                        const Text("x ",style: TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),),
                        Text(widget.quantityNumber.toString(),style: const TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),),
                      ],
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
