import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:combos/combos.dart';
import '../models/Item.dart';
import '../models/categories.dart';
import '../providers/Compare.dart';
import '../providers/auth.dart';
import '../screens/compare_edit_screen_2.dart';

class CompareEditScreen1 extends StatefulWidget {
  static const routeName = '/edit_compare1';

  @override
  _CompareEditScreenState1 createState() => _CompareEditScreenState1();
}

class _CompareEditScreenState1 extends State<CompareEditScreen1> {

  String _cate; // Category Name to display in the bar
  bool _isInit = true; // to trigger init operations
  Compare _editedCompare; // the loaded compare to edit or a new one to add

  //mmmmmmmmmmmmmmmmmmm Init mmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmm
  @override
  void didChangeDependencies() {
    if (_isInit) {
      setState(() {
        String userid = Provider.of<Auth>(this.context, listen: false).userId;
        _editedCompare = Compare(
            id: DateTime.now().millisecondsSinceEpoch.toString(),
            categoryId: null,
            userId: userid);
        _editedCompare.addItem(Item(id: DateTime.now().millisecondsSinceEpoch.toString(), name: 'Item1 Name', imageUrl: null));
        _editedCompare.addItem(Item(id: (DateTime.now().millisecondsSinceEpoch + 10).toString() , name: 'Item2 Name', imageUrl: null));
      });
    }
    _isInit = false;
    super.didChangeDependencies();
  }
  //mmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmm


///////////// BUILD ////////////////////////////////////////////
  @override
  Widget build(BuildContext context) {

    //========= check for loaded compare in args ================
    var arg = ModalRoute.of(context).settings.arguments;
    if (arg != null) {
      _editedCompare = arg;
      var cat = Categories.findById(_editedCompare.categoryId);
      _cate = cat == null ? null : cat.name;
    }
    
    //===========================================================

    return Scaffold(
      //============ AppBar ==================================
      appBar: AppBar(
        leading: IconButton(
            icon: Icon(FontAwesomeIcons.arrowLeft),
            onPressed: () {
              Navigator.pop(context);
            }),
        title: Text('Versus Settings'),
      ),
      //============== Body ===================================
      body: Builder(
        builder: (context) => Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
               SizedBox(
                height: 70.0,
              ),
              //=============== Category Row ============================
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Container(
                      width: 100,
                      child: Column(
                        children: <Widget>[
                          Align(
                            alignment: Alignment.centerRight,
                            child: Text('Category : ',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 18.0,
                                )),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Container(
                      width: 150,
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: TypeaheadCombo<String>(
                        minTextLength: 2,
                        selected: _cate,
                        getList: (text) async {
                          await Future.delayed(
                              const Duration(milliseconds: 500));
                          return Categories.search(text);
                        },
                        itemBuilder: (context, parameters, item, bol, str) =>
                            ListTile(
                                title: Text(item ?? '<Empty>',
                                    textAlign: TextAlign.center)),
                        onItemTapped: (item) => setState(() => _cate = item),
                        getItemText: (item) => item,
                        decoration: const InputDecoration(
                            hintText: 'Select Category...',
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 10, vertical: 10)),
                        onSelectedChanged: (String value) {
                          setState(() {
                            _editedCompare.categoryId =
                                Categories.getIdByName(value);
                          });
                        },
                      ),
                    ),
                  ),
                ],
              ),
              //=============== Category Row ============================



              SizedBox(
                height: 20.0,
              ),


              //================== Is Private Row ============================
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Container(
                      width: 100,
                      child: Column(
                        children: <Widget>[
                          Align(
                            alignment: Alignment.centerRight,
                            child: Text('Private : ',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 18.0,
                                )),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Align(
                      alignment: Alignment.centerRight,
                      child: Stack(
                        children: <Widget>[
                          Container(
                            width: 150,
                          ),
                          Container(
                            child: Switch(
                                value: _editedCompare.isPrivate,
                                onChanged: (val) {
                                  setState(() {
                                    _editedCompare.setPrivate(val);
                                  });
                                }),
                          )
                        ],
                      )),
                ],
              ),
              //================== Is Private Row ============================


               SizedBox(
                height: 70.0,
              ),



              //======================= Buttons Footer =======================
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  ClipRRect(
                    borderRadius: BorderRadius.circular(40),
                                      child: RaisedButton(
                      color: Theme.of(context).primaryColor,
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      elevation: 4.0,
                      splashColor: Theme.of(context).accentColor,
                      child: Text(
                        'Cancel',
                        style: TextStyle(color: Colors.white, fontSize: 16.0),
                      ),
                    ),
                  ),
                  //- - - - - - - - - - - - - - - - - - - - - - -
                  ClipRRect(
                    borderRadius: BorderRadius.circular(40),
                                      child: RaisedButton(
                      color: Theme.of(context).primaryColor,
                      onPressed: (_editedCompare != null &&
                              _editedCompare.categoryId != null)
                          ? () {
                              Navigator.of(context).pushNamed(
                                  CompareEditScreen2.routeName,
                                  arguments: _editedCompare);
                            }
                          : null,
                      elevation: 4.0,
                      splashColor: Theme.of(context).accentColor,
                      child: Text(
                        'Next',
                        style: TextStyle(color: Colors.white, fontSize: 16.0),
                      ),
                    ),
                  ),
                ],
              ),
             //======================= Buttons Footer =======================




            ],
          ),
        ),
      ),
    );
  }
}
