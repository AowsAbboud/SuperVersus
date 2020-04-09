import 'package:flutter/material.dart';
import '../models/Item.dart';

class ItemCardRight extends StatelessWidget {
  final Item item;
  ItemCardRight({this.item});


////////////////////////////////////////////////////////
////
////       The second Item in single compare row 
///  
////////////// BUILD ////////////////////////////////////
  @override
  Widget build(BuildContext context) {
    return FittedBox(
      child: Container(
        padding: EdgeInsets.all(10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                FittedBox(
                    child: Text(
                  item.name,
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold , fontStyle: FontStyle.italic) ,
                )),
                Divider(),
                Text(
                  item.score.toString(),
                  style: TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).primaryColor),
                ),
              ],
            ),
            CircleAvatar(
              minRadius: 50,
              backgroundImage: item.icon,
              backgroundColor: Colors.white,
            ),
          ],
        ),
      ),
    );
  }
}
