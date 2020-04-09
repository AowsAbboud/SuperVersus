import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/categories.dart';
import 'item_card_left.dart';
import 'item_card_right.dart';
import '../providers/Compare.dart';

class SingleCompare extends StatelessWidget {

  /////////////////// BUILD ///////////////////////////////
  @override
  Widget build(BuildContext context) {
    final compare = Provider.of<Compare>(context, listen: false);

    return Card(    
      color: Color.fromRGBO(240, 240, 240, 1),
      elevation: 8,
      child: ListTile(
        leading: 
        // =============== First item Part =====================
        ItemCardLeft(
          item: compare.items[0],
        ),
        // =============== First item Part =====================


         // ===============Middle Part =====================
        title: Container(
          padding: EdgeInsets.all(8),
          child: Text(
            Categories.findById(compare.categoryId).name,
            textAlign: TextAlign.center,
            style: TextStyle(fontStyle: FontStyle.italic),
          ),
        ),
        subtitle: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              '10',
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
            ),
            Divider(),
            Container(
                margin: EdgeInsets.only(left: 7, right: 2),
                child: Icon(
                  Icons.thumb_up,
                  color: Theme.of(context).accentColor,
                )),
            Container(
               height: 22,
                margin: EdgeInsets.only(right: 7, left: 2),
                child: Icon(
                  Icons.thumb_down,
                  color: Theme.of(context).accentColor,
                )),
            Text(
              '2',
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        // ===============Middle Part =====================



         // ===============Second Item Part =====================
        trailing: ItemCardRight(
          item: compare.items[1],
        ),
        // ===============Second Item Part =====================
      ),
    );
  }
}
