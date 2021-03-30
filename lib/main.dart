import 'package:bartender/firebase_util.dart';
import 'package:bartender/providers/auth.dart';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:firebase_core/firebase_core.dart';

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
    50: const Color(0xFFFAE7E4),
    100: const Color(0xFFEAE4F1),
    200: const Color(0xFFE4F0E1),
    300: const Color(0xFFEFFBFF),
    400: const Color(0xFFEFFBFF),
    500: const Color(0xFFEFFBFF),
    600: const Color(0xFFEFFBFF),
    700: const Color(0xFFEFFBFF),
    800: const Color(0xFFEFFBFF),
    900: const Color(0xFFEFFBFF),
  },
);

class BartenderApp extends StatelessWidget {

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
            textTheme: TextTheme(
              headline3: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.black),
              headline4: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black),
              headline5: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
              headline6: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
              subtitle1: TextStyle(fontSize: 16, color: Colors.black54),
              subtitle2: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black54),
              bodyText1: TextStyle(fontSize: 8, color: Colors.black54, fontWeight: FontWeight.w100),
              overline: TextStyle(fontSize: 12, color: Colors.black45),
            ),

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
            buttonTheme: ButtonThemeData(
              buttonColor: kPrimaryColor[100],
              textTheme: ButtonTextTheme.primary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
          ),
          home: CommunityCocktailScreen()
        );}
    ));
  }
}
