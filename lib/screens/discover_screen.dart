import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:home_bartender/firebase_util.dart';
import 'package:home_bartender/providers/auth.dart';
import 'package:home_bartender/screens/community_cocktail_screen.dart';
import 'package:home_bartender/widgets/cocktail_gridview.dart';
import 'package:home_bartender/screens/auth_screen.dart';
import 'package:home_bartender/screens/collections_screen.dart';
import 'package:home_bartender/screens/shopping_list_screen.dart';
import 'package:home_bartender/widgets/auth/auth_form_wrapper.dart';
import 'package:home_bartender/screens/mybar_screen.dart';


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
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
        onTap: () {
          print("tapped");
          setState(() {
            welcomeStep += 1;
          });
          if(welcomeStep == 2){
            Navigator.pop(context);
          }
      },
      child: Center(
         child: Text(welcomeStep.toString()),
      )
    );
  }
}

class _DiscoverScreenState extends State<DiscoverScreen> {
  bool showAddIngredient = false;
  int welcomeScreenCount = 0;
  
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
  }

  void initState() {
    super.initState();
    WidgetsBinding.instance
        .addPostFrameCallback((_) => showOverlay(context, "welcome1"));
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
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (_) {
                return ShoppingListScreen();
              }),
          ),),
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
                  onPressed: () => Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) {
                      return MyBarScreen();
                    }),
                  ),
                ),
          ),
    );
  }
}