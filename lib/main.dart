import 'package:bartender/firebase_util.dart';
import 'package:bartender/providers/auth.dart';
import 'package:bartender/screens/auth_screen.dart';
import 'package:bartender/screens/mybar_screen.dart';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:firebase_core/firebase_core.dart';

import 'package:bartender/screens/collections_screen.dart';
import 'package:bartender/screens/discover_screen.dart';
import 'package:bartender/screens/community_cocktail_screen.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(BartenderApp());
}

class CupertinoHomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CupertinoTabScaffold(
      tabBar: CupertinoTabBar(
        items: <BottomNavigationBarItem> [
          BottomNavigationBarItem(icon: Icon(Icons.list)),
          BottomNavigationBarItem(icon: Icon(Icons.local_drink))
        ],
      ),
      tabBuilder: (BuildContext context, int index) {
        return CupertinoTabView(
          builder: (BuildContext context) {
            return CupertinoPageScaffold(
              navigationBar: CupertinoNavigationBar(
                middle: Text('Page 1 of tab $index'),
              ),
              child: Center(
                child: CupertinoButton(
                  child: const Text('Next page'),
                  onPressed: () {
                    Navigator.of(context).push(
                      CupertinoPageRoute<void>(
                        builder: (BuildContext context) {
                          return CupertinoPageScaffold(
                            navigationBar: CupertinoNavigationBar(
                              middle: Text('Page 2 of tab $index'),
                            ),
                            child: Center(
                              child: CupertinoButton(
                                child: const Text('Back'),
                                onPressed: () { Navigator.of(context).pop(); },
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
              ),
            );
          },
        );
      },
    );
  }
}


const MaterialColor kPrimaryColor = const MaterialColor(
  // 0xFFF0F3F5,
  0xFFEFFBFF,
  const <int, Color>{
    50: const Color(0xFF0E7AC7),
    100: const Color(0xFF0E7AC7),
    200: const Color(0xFF0E7AC7),
    300: const Color(0xFF0E7AC7),
    400: const Color(0xFF0E7AC7),
    500: const Color(0xFF0E7AC7),
    600: const Color(0xFF0E7AC7),
    700: const Color(0xFF0E7AC7),
    800: const Color(0xFF0E7AC7),
    900: const Color(0xFF0E7AC7),
  },
);


class BartenderApp extends StatelessWidget {

  TextTheme materialTextThemes = new TextTheme(
    
    headline3: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.black),
    headline4: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
    headline6: TextStyle(fontSize: 20, fontWeight: FontWeight.w500, color: Colors.black87),
    subtitle1: TextStyle(fontSize: 16, color: Colors.black54),
    subtitle2: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black54),
    bodyText1: TextStyle(fontSize: 8, color: Colors.black54, fontWeight: FontWeight.w100),
    overline: TextStyle(fontSize: 12, color: Colors.black45),
  );

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: Auth()),
      ],
      child: FutureBuilder(
        future: init(),
        builder: (ctx, snapshot) {
          if(snapshot.connectionState == ConnectionState.waiting){
            return Center(child: CircularProgressIndicator());
          }
        return MaterialApp(
          title: 'Bartender',
          theme: ThemeData(
            primarySwatch: kPrimaryColor,
            primaryColor: kPrimaryColor,
            backgroundColor: kPrimaryColor,
            scaffoldBackgroundColor: kPrimaryColor,

            fontFamily: 'Open Sans',
            primaryTextTheme: materialTextThemes,

            appBarTheme: AppBarTheme(
              textTheme: ThemeData.light().textTheme.copyWith(
                headline6: TextStyle(
                  color: Colors.black87,
                  fontSize: 20,
                  fontWeight: FontWeight.normal,
                ),
                bodyText1: TextStyle(
                  color: Colors.black87,
                  fontSize: 8,
                  fontWeight: FontWeight.normal
                )
              ),
              elevation: 0,
            ),
            buttonTheme: ButtonTheme.of(context).copyWith(
              buttonColor: Colors.pink,
              textTheme: ButtonTextTheme.primary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          ),
          home: CommunityCocktailScreen()
          /*CupertinoTabScaffold(
            tabBar: CupertinoTabBar(
              items: [
                BottomNavigationBarItem(
                  icon: Icon(Icons.home),
                  label: "Discover",
                ),
                BottomNavigationBarItem(
                  icon: Icon(CupertinoIcons.list_bullet),
                  label: "Collections",
                ),
                BottomNavigationBarItem(
                  icon: Icon(CupertinoIcons.add),
                  label: "My Bar",
                ),
                BottomNavigationBarItem(
                  icon: Icon(CupertinoIcons.person_3_fill),
                  label: "Community",
                ),
                BottomNavigationBarItem(
                  icon: Icon(CupertinoIcons.person),
                  label: "Account",
                ),
              ],
            ),
            tabBuilder: (BuildContext context, int index) {
              return CupertinoTabView(builder: (context){
                switch(index){
                  case 0:
                    return DiscoverScreen();
                  case 1:
                    return CollectionsScreen();
                  case 2:
                    return MyBarScreen();
                  case 3:
                    return AuthScreen();
                  case 4: 
                    return CommunityCocktailScreen();
                  default:
                    return DiscoverScreen();
                }
              },);
            }
          ), */
        );}
    ));
  }
}
