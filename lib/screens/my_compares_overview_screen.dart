import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../screens/compare_edit_screen_1.dart';
import '../services/myfirebase.dart';
import '../providers/my_compares.dart';
import '../widgets/compares_grid.dart';
import '../widgets/app_drawer.dart';


class MyComparesOverviewScreen extends StatefulWidget {
  @override
  _MyComparesOverviewScreenState createState() => _MyComparesOverviewScreenState();
}
///////////////////////////////////////////////////
class _MyComparesOverviewScreenState extends State<MyComparesOverviewScreen> {

  var _isInit = true;
  var _isLoading = false;
//======================================


// Init and load compares mmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmm
  @override
  void didChangeDependencies() {
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });    
      MyFireBase.fetchCategories().then(
        (_){
          Provider.of<MyCompares>(context , listen: false).loadMyCompares().then((_)
          {
              setState(() {
                        _isLoading = false;
               });
          });          
        }
      );
    }
    _isInit = false;
    super.didChangeDependencies();
  }
// Init and load compares mmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmm


///////////////////////////// BUILD ////////////////////////////////////
  @override
  Widget build(BuildContext context) {    
    return Scaffold(
      //=========App Bar ======================================
      appBar: AppBar(
        title: Text('Super Versus'),
        actions: <Widget>[      
          IconButton(
              icon: Icon(
                Icons.add,
              ),
              onPressed: () {
                Navigator.of(context).pushNamed(CompareEditScreen1.routeName);
              },
            ),
        ],
      ),
      //========== Drawer ==========================
      drawer: AppDrawer(),
      //========== BODY =============================
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          :ComparesGrid(),
          
    );
  }
}
