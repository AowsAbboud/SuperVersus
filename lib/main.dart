import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './screens/compare_edit_screen_1.dart';
import './screens/compare_edit_screen_3.dart';
import './screens/compare_edit_screen_2.dart';
import './providers/my_compares.dart';
import './screens/splash_screen.dart';
import './screens/my_compares_overview_screen.dart';
import './providers/auth.dart';
import './screens/auth_screen.dart';


void main() => runApp(MyApp());

class MyApp extends StatelessWidget {

  ///////////////// BUILD ////////////////////////////////////////////
  @override
  Widget build(BuildContext context) {
    return MultiProvider(


      //======================= init Providers ==================================
      providers: [
        ChangeNotifierProvider<Auth>(
          create: (_) => Auth(),
          lazy: false,
        ),
      //----------------------------
        ChangeNotifierProxyProvider<Auth, MyCompares>(
          lazy: false,
          create: (_)=> MyCompares(
                null,
                [] ,
              ),
          update: (ctx, auth, previousMyCompares) => MyCompares(
                auth.userId,
                previousMyCompares == null ? [] : previousMyCompares.compares,
              ),
        ),
      ],
       //======================= init Providers ==================================



      child: Consumer<Auth>(
        builder: (ctx, auth, _) => 
        // ================ App ================================
        MaterialApp(
              title: 'Super Versus',
              theme: ThemeData(
                primarySwatch: Colors.purple,
                accentColor: Colors.deepOrange,
                fontFamily: 'Lato',
              ),
              //============ Body ========================================
              home: auth.isAuth
                  ? MyComparesOverviewScreen()
                  : FutureBuilder(
                      future: auth.tryAutoLogin(),
                      builder: (ctx, authResultSnapshot) =>
                          authResultSnapshot.connectionState ==
                                  ConnectionState.waiting
                              ? SplashScreen()
                              : AuthScreen(),
                    ),


              //=============== Routes ======================================
              routes: {
                CompareEditScreen1.routeName: (ctx) => CompareEditScreen1(),
                CompareEditScreen2.routeName: (ctx) => CompareEditScreen2(),
                CompareEditScreen3.routeName: (ctx) => CompareEditScreen3(),
              },
              //=============== Routes ======================================

            ),
      ),
    );
  }
}
