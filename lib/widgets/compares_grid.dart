import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../screens/compare_edit_screen_1.dart';
import '../services/myfirebase.dart';
import '../providers/my_compares.dart';
import 'single_compare.dart';

class ComparesGrid extends StatelessWidget {

  /////////////////BUILD///////////////////////////////
  @override
  Widget build(BuildContext context) {

    //============= init provider ========================================
    final myComparesProvider = Provider.of<MyCompares>(context,listen: true);


    //=========== check if still loading from net =======================
    if (myComparesProvider.loading)
      return Center(
        child: CircularProgressIndicator(),
      );
    else {
      final comparesData = myComparesProvider.compares;
    //====================================================================

      return myComparesProvider.loading
          //============== loading body ===================
          ? Center(
              child: CircularProgressIndicator(),
            )
          //============== compares list =====================
          : Container(
              padding: EdgeInsets.all(10),
              child: ListView.builder(
                itemCount: comparesData.length,
                itemBuilder: (BuildContext context, int index) {
                  return ChangeNotifierProvider.value(
                    value: comparesData[index],
                    child: 
                    //---------- Wrapped in gesture to enable tabing action for editing ==========
                    GestureDetector(
                      onTap: () => Navigator.of(context).pushNamed(
                          CompareEditScreen1.routeName,
                          arguments: comparesData[index]),
                      child: 
                       //---------- Wrapped in Dismiss to enable deleting action ==========
                      Dismissible(
                          background: Container(
                            padding: EdgeInsets.symmetric(horizontal: 20),
                            color: Colors.red,
                            child: Icon(Icons.delete , color: Colors.white, size: 35,),
                            alignment: Alignment.centerRight,
                          ),
                          direction: DismissDirection.endToStart,
                          onDismissed: (dir) {
                            MyFireBase.deleteCompare(comparesData[index]).then(
                                (_) => myComparesProvider.loadMyCompares());
                          },
                          key: Key(comparesData[index].id),
                          child:
                           //---------- Comapre List item ========== 
                          SingleCompare()),
                           //---------- Comapre List item ========== 

                    ),
                  );
                },
              ),
            );
    }
  }
}
