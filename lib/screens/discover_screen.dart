import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:home_bartender/firebase_util.dart';
import 'package:home_bartender/providers/auth.dart';
import 'package:home_bartender/screens/community_cocktail_screen.dart';
import 'package:home_bartender/widgets/cocktail_gridview.dart';
import 'package:home_bartender/screens/auth_screen.dart';
import 'package:home_bartender/screens/collections_screen.dart';
import 'package:home_bartender/widgets/auth/auth_form_wrapper.dart';
import 'package:home_bartender/screens/introduction_screen.dart';
import 'package:home_bartender/screens/mybar_screen.dart';
import 'package:home_bartender/screens/shopping_list_screen.dart';


class DiscoverScreen extends StatefulWidget {
  DiscoverScreen();

  @override
  _DiscoverScreenState createState() => _DiscoverScreenState();
}

class WelcomeDialog extends StatefulWidget {
  WelcomeDialog({
    Key key,
  }) : super(key: key);

  @override
  _WelcomeDialogState createState() => _WelcomeDialogState();
}

class _WelcomeDialogState extends State<WelcomeDialog> {
  int welcomeStep = 0;

  Widget welcomeStepWidget(int welcomeStep) {
    switch (welcomeStep) {
      case 0:
        return Align(
          alignment: Alignment(0, 0.7),
          child: Image(image: AssetImage('images/welcome-1.png'),),
        );
      case 1:
        return Align(
          alignment: Alignment(-0.2, -0.8),
          child: Image(image: AssetImage('images/welcome-2.png'),),
        );
      case 2:
        return Align(
          alignment: Alignment(0.18, -0.8),
          child: Image(image: AssetImage('images/welcome-3.png'),),
        );
        break;
      default:
        return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
        onTap: () {
          setState(() => welcomeStep += 1);
          if(welcomeStep == 3){
            Navigator.pop(context);
          }
      },
      child: welcomeStepWidget(welcomeStep),
    );
  }
}

class _DiscoverScreenState extends State<DiscoverScreen> {
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  Future<void> _falseSharePref(String val) async {
    final SharedPreferences prefs = await _prefs;
    await prefs.setBool(val, false);
  }

  
  void showOverlay(BuildContext context, String screenIdentifier) async {
    final size = MediaQuery.of(context).size;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.transparent,
          contentPadding: EdgeInsets.zero,
          insetPadding: EdgeInsets.zero,
          content: Container(
            height: size.height,
            width: size.width,
            child: WelcomeDialog()
          ),
        );
      }
    );
    await _falseSharePref("showWelcome");
  }

  void initState() {
    super.initState();
    _prefs.then((SharedPreferences prefs) {
      if(prefs.getBool('showWelcome') == null || prefs.getBool('showWelcome') == true){
        WidgetsBinding.instance
          .addPostFrameCallback((_) => showOverlay(context, "welcome1"));
      }
    });
    
  }
  
  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<Auth>(context);
  
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            icon: Icon(Icons.people_outline_rounded),
            tooltip: "Explore Original Cocktails",
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (_) {
                return CommunityCocktailScreen();
              }),
            )),
        actions: [
          IconButton(
            icon: Icon(Icons.favorite, color: Colors.redAccent,), 
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (_) {
                return FavoritesScreen();
              }),
          ),),
          IconButton(
            icon: Icon(Icons.shopping_cart_outlined), 
            onPressed: () { 
              _prefs.then((SharedPreferences prefs) async {
                if(prefs.getBool('showShoppingWelcome') == null || prefs.getBool('showShoppingWelcome') == true){
                  await _falseSharePref('showShoppingWelcome');
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) {
                      return OnBoardingPage();
                    }),
                  );
                } else {
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) {
                        return ShoppingListScreen();
                      }),
                  );
                }
              });
            }),
          auth.isLoggedIn
          ? InkWell(
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute(builder: (_) {
                  return AuthScreen();
                }),
              ),
              child: CircleAvatar(
                radius: 20,
                backgroundColor: Colors.white,
                backgroundImage: auth.profileImage
              ),
            )
          : TextButton(
            child: Text("Login", style: TextStyle(color: Colors.black)),
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (_) {
                return AuthFormWrapper(showScaffold: true,);
              }),
            ),
          )
        ],
      ),
      body: CocktailGridView(cocktailsList: allCocktails),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Container(
              width: 200.0,
              margin: const EdgeInsets.only(bottom: 10),
                child: FloatingActionButton.extended(
                  heroTag: "yourbar",
                  elevation: 4,
                  backgroundColor: Color(0xFFEAE4F1),
                  icon: Icon(Icons.home),
                  label: const Text("Your Bar"),
                  onPressed: () { 
                    _prefs.then((SharedPreferences prefs) async {
                      if(prefs.getBool('showMybarWelcome') == null || prefs.getBool('showMybarWelcome') == true){
                        await _falseSharePref('showMybarWelcome');
                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (_) {
                            return MybarWelcomeScreen();
                          }),
                        );
                      } else {
                        Navigator.of(context).pushNamed(MyBarScreen.routeName,);
                      }
                    });
                  }
                ),
        ),
    );
  }
}