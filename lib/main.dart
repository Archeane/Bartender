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


class BartenderApp extends StatelessWidget {

  TextTheme materialTextThemes = new TextTheme(
    headline3: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.black),
    headline4: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
    subtitle1: TextStyle(fontSize: 16, color: Colors.black54),
    subtitle2: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black54),
    bodyText1: TextStyle(fontSize: 18),
    overline: TextStyle(fontSize: 12, color: Colors.black45),
  );

  @override
  Widget build(BuildContext context) {
    // CollectionReference cocktails = FirebaseFirestore.instance.collection('cocktails');
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: Auth()),
      ],
      child: MaterialApp(
          title: 'Bartender',
          theme: ThemeData(
            primarySwatch: Colors.pink,
            textTheme: materialTextThemes,
            backgroundColor: Colors.pink,
            accentColor: Colors.deepPurple,
            accentColorBrightness: Brightness.dark,
          ),
          home: CupertinoTabScaffold(
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
                  icon: Icon(CupertinoIcons.person_3_fill),
                  label: "Community",
                ),
                BottomNavigationBarItem(
                  icon: Icon(CupertinoIcons.person),
                  label: "Account",
                ),
                BottomNavigationBarItem(
                  icon: Icon(CupertinoIcons.add),
                  label: "My Bar",
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
                    return CommunityCocktailScreen();
                  case 3:
                    return AuthScreen();
                  case 4: 
                    return MyBarScreen();
                  default:
                    return DiscoverScreen();
                }
              },);
            }
          ),
        )
    );
  }
}
