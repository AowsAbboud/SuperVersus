import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import '../providers/Compare.dart';
import '../models/Item.dart';
import '../screens/compare_edit_screen_3.dart';

class CompareEditScreen2 extends StatefulWidget {
  static const routeName = '/edit_compare2';

  @override
  _CompareEditScreenState2 createState() => _CompareEditScreenState2();
}
////////////////////////////////////////////////
class _CompareEditScreenState2 extends State<CompareEditScreen2> {
  File _image; // Selected image file from Picker
  bool _editName = false; // item name toggle editing mode
  bool _addAttrib = false; // attrib editing mode
  bool canGoNext = false; // no empty data
  //--------------------------------------
  Compare _parentCompare; // The Compare we belong to
  //----------------------------------------
  TextEditingController _nameController;
  TextEditingController _attribNameController   =  TextEditingController();
  TextEditingController  _attribValueController = TextEditingController();
  TextEditingController  _attribWieghtController = TextEditingController();


  //---- init this item (First Item in compare) -----------------------
  //------will be overwritin by loaded args if the compare is not new  ---------
  Item _item =
      Item(id: DateTime.now().millisecondsSinceEpoch.toString(), name: 'Item Name', imageUrl: null);
  /*--------------------------------------*/

//mmmmmmmm Show Image Picker mmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmm
  Future getImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
    if(image != null)
    setState(() {
      _image = image;
      _item.image = _image;
      _item.needUpload =true;
    });
  }
//mmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmm
  

//mmmmmmmmm Save First item and go to next one mmmmmmmmmmmmmmmmmm
  void saveAndNext (BuildContext ctx)
  {   
    
    _parentCompare.addItem(_item);
    Navigator.of(context).pushNamed(CompareEditScreen3.routeName , arguments: _parentCompare);
  }
//mmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmm


  /////////////////////// BUILD ////////////////////////////////
  @override
  Widget build(BuildContext context) {
    
    //========= try load from args ==============================
    _parentCompare = ModalRoute.of(context).settings.arguments;
    if (_parentCompare.items.length > 0 && _parentCompare.items[0] != null)
      _item = _parentCompare.items[0];
    if(_item.imageUrl != null || _item.image != null)
       canGoNext = true;
    _nameController = TextEditingController(text: _item.name);
    //==========================================================
  
    return Scaffold(
      // =========== App bar ================================
      appBar: AppBar(
        leading: IconButton(
            icon: Icon(FontAwesomeIcons.arrowLeft),
            onPressed: () {
              Navigator.pop(context);
            }),
        title: Text('First Item'),
      ),
       // =========== Body ================================
      body: Builder(
        builder: (context) => Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              SizedBox(
                height: 20.0,
              ),
              //========= Header : Item Image and Next Btn =============================
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[

                        // ------------ image avatar -----------------------
                        Align(
                          alignment: Alignment.center,
                          child: CircleAvatar(
                            radius: 53,
                            backgroundColor: Theme.of(context).primaryColor,
                            child: ClipOval(
                              child: new SizedBox(
                                  width: 100.0,
                                  height: 100.0,
                                  child: (_image != null)
                                      ? Image.file(
                                          _image,
                                          fit: BoxFit.fill,
                                        )
                                      : _item.imageUrl == null
                                          ? Image.asset(
                                              'assets/images/item.png',
                                              fit: BoxFit.cover,
                                            )
                                          : Image.network(_item.imageUrl , fit: BoxFit.cover,)),
                            ),
                          ),
                        ),
                        // ------------------ Image Picker ---------------------
                        Padding(
                          padding: EdgeInsets.only(top: 60.0),
                          child: IconButton(
                            color: Theme.of(context).accentColor,
                            icon: Icon(

                              Icons.camera_alt,
                              size: 30.0,
                            ),
                            onPressed: () {
                              getImage();
                            },
                          ),
                        ),
                      ],
                    ),
                   // -------------- Next Btn ------------------------------------
                    ClipRRect(
                      borderRadius: BorderRadius.circular(40),
                      child: RaisedButton(
                        color: Theme.of(context).primaryColor,
                        onPressed: canGoNext ? () {
                          saveAndNext(context);
                        } : null,
                        elevation: 4.0,
                        splashColor: Colors.blueGrey,
                        child: Text(
                          'Next',
                          style: TextStyle(color: Colors.white, fontSize: 16.0),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              //========= Header : Item Image and Next Btn =============================






              //-----------------------------------------------------
              SizedBox(
                height: 5.0,
              ),


              //=============== Item Name Feild ==============================
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30 ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    _editName
                        ? Container(
                          height: 30,
                          width: 150,
                          margin: EdgeInsets.only(top:10),
                            child: TextField(
                              controller: _nameController,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: 'Item name',
                              ),
                            ),
                          )
                        : Text(_item.name,
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 16.0,
                            )),
                     Container(
                        height: 30,
                        
                        child: IconButton(
                          
                          icon: Icon(
                            
                            _editName
                                ? Icons.save
                                : Icons.edit,
                            color: Theme.of(context).accentColor,
                          ),
                          onPressed: () {
                            setState(() {
                              _editName = !_editName;
                              _item.name =
                                  _nameController.value.text.trim().isNotEmpty
                                      ? _nameController.value.text.trim()
                                      : _item.name;
                              
                            });
                          },
                        ),
                      ),
                   
                  ],
                ),
              ),
              //=============== Item Name Feild ==============================





              //================= Attributes Header : title and icon Btn ===============================
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text('Attributes : ',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 16.0,
                        )),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Container(
                        child: IconButton(
                          icon: Icon(
                            _addAttrib ? FontAwesomeIcons.save : Icons.add,
                            color: Theme.of(context).accentColor,
                          ),
                          onPressed: () {
                            setState(() {
                              if(_addAttrib)
                              {
                                _parentCompare.addAttrib( _attribNameController.value.text , _attribWieghtController.value.text , _attribValueController.value.text);
                                  _attribNameController   =  TextEditingController();
                                  _attribValueController = TextEditingController();
                                  _attribWieghtController = TextEditingController();
                              }
                               _addAttrib = !_addAttrib; 
                            });
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              //================= Attributes Header : title and icon Btn ===============================




              //================= Attrib Feilds : add or edit ============================================
              _addAttrib
                  ? Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Container(
                            width: 150,
                            height: 40,
                            child: TextField(
                              
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 14),
                              controller: _attribNameController,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: 'Attribute Name',
                              ),
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 5),
                            width: 90,
                            height: 40,
                            child: TextField(
                              keyboardType: TextInputType.number,
                              inputFormatters: <TextInputFormatter>[
                                WhitelistingTextInputFormatter.digitsOnly
                              ], //
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 12, fontWeight: FontWeight.bold),
                              controller: _attribWieghtController,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: 'Weight',
                              ),
                            ),
                          ),
                          Container(
                            width: 90,
                            height: 40,
                            child: TextField(
                              keyboardType: TextInputType.number,
                              inputFormatters: <TextInputFormatter>[
                                WhitelistingTextInputFormatter.digitsOnly
                              ],
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 12, fontWeight: FontWeight.bold),
                              controller: _attribValueController,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: 'Value',
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  : Divider(),
              //================= Attrib Feilds : add or edit =====================================================



              SizedBox(
                height: 20.0,
              ),




              //=================== Attributes List ======================================
              _item.attributes.length > 0 ?
              Container(
                height: 200,
                width: 250,
                          child  : ListView.builder(
                    itemBuilder: (ctx, i) {
                      return GestureDetector(
                        onTap: (){
                          setState(() {
                            _attribNameController = TextEditingController(text:_item.attributes[i].name);
                          _attribWieghtController = TextEditingController(text:_item.attributes[i].weight.toString());
                          _attribValueController = TextEditingController(text:_item.attributes[i].val.toString());
                          _addAttrib = true;
                           _parentCompare.delAttrib(_item.attributes[i].id);
                          });
                          
                        },
                                              child: Dismissible(
                                background: Container(
                              padding: EdgeInsets.symmetric(horizontal: 20),
                              color: Colors.red,
                              child: Icon(Icons.delete , color: Colors.white, size: 35,),
                              alignment: Alignment.centerRight,
                            ),
                            direction: DismissDirection.endToStart,

                            onDismissed: (dir) {
                              setState(() {
                                _parentCompare.delAttrib(_item.attributes[i].id);
                              });
                              
                            },
                            key: ValueKey(_item.attributes[i].id),

                                                child: Card(
                                color: Color.fromRGBO(245, 245, 245, 1),
                                elevation: 3,
                                                  child: ListTile(
                                                    
                                title: Text(_item.attributes[i].name + ' [${_item.attributes[i].weight} x ${_item.attributes[i].val}]' , style: TextStyle(fontStyle: FontStyle.italic),),
                            
                                trailing: CircleAvatar(
                                  backgroundColor: Theme.of(context).primaryColor,
                                  child: Text(
                                      '${_item.attributes[i].val * _item.attributes[i].weight}',style: TextStyle(fontWeight: FontWeight.bold , fontSize: 16 , color: Colors.white),),
                                )),
                          ),
                        ),
                      );
                    },
                    itemCount: _item.attributes.length,
                  ),
                
              ) :
              Divider(),
              //=================== Attributes List ======================================


              
            ],
          ),
        ),
      ),
    );
  }
}
