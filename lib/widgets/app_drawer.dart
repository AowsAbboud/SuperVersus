import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth.dart';

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: <Widget>[
          //================= Title ================
          AppBar(
            title: Text('Super Versus'),
            automaticallyImplyLeading: false,
          ),
          //=======================================
          Divider(),
          //=============== Compares Page ==============
          ListTile(
            leading: Icon(Icons.shop),
            title: Text('MyCompares'),
            onTap: () {
              Navigator.of(context).pushReplacementNamed('/');
            },
          ),
          //=======================================
          Divider(),
          //================== Logout ===========
          ListTile(
            leading: Icon(Icons.exit_to_app),
            title: Text('Logout'),
            onTap: () {
              Navigator.of(context).pop();
              Navigator.of(context).pushReplacementNamed('/');
              Provider.of<Auth>(context, listen: false).logout();
            },
          ),
          //=======================================
        ],
      ),
    );
  }
}
