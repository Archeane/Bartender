import 'package:bartender/firebase_util.dart';
import 'package:bartender/model/cocktail.dart';
import 'package:bartender/providers/auth.dart';
import 'package:bartender/screens/auth_screen.dart';
import 'package:bartender/screens/collections_screen.dart';
import 'package:bartender/screens/customize_cocktail_screen.dart';
import 'package:bartender/screens/discover_screen.dart';
import 'package:bartender/screens/mybar_screen.dart';
import 'package:bartender/screens/shopping_list_screen.dart';
import 'package:bartender/widgets/auth/auth_form_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:bartender/widgets/cocktail_gridview.dart';
import 'package:provider/provider.dart';

class CommunityCocktailScreen extends StatefulWidget {
  CommunityCocktailScreen({Key key}) : super(key: key);

  @override
  _CommunityCocktailScreenState createState() =>
      _CommunityCocktailScreenState();
}

class _CommunityCocktailScreenState extends State<CommunityCocktailScreen> {

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<Auth>(context);
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            icon: Icon(Icons.search),
            tooltip: "Explore Original Cocktails",
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (_) {
                return DiscoverScreen();
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
                return AuthFormWrapper();
              }),
            ),
          )
        ],
      ),
      body: FutureBuilder(
        future: fetchAllCommunityCocktail(),
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            print("error in community_screen _fetchCollection");
            return Center(
                child: Text("An error has occured, please try again later!"));
          }
          List<CommunityCocktail> data = snapshot.data;

          return CocktailGridView(
            showSearchBar: false,
              cocktailsList: data
                  .where((cocktail) => cocktail.isPublic == true)
                  .toList());
        }),
      // floatingActionButton: FloatingActionButton(
      //   child: Row(children: [
      //     ElevatedButton.icon(onPressed: () {}, icon: Icon(Icons.add), label: const Text("Customized Receipe")),
      //     ElevatedButton.icon(onPressed: () {}, icon: Icon(Icons.home), label: const Text("Your Bar")),
      //   ],)
      // ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Stack(
        children: <Widget>[
          Align(
            alignment: Alignment(0, 1),
            child: Container(
              width: 200.0,
              child: FittedBox(
                child: FloatingActionButton.extended(
                  elevation: 4,
                    backgroundColor: Color(0xFFFAE7E4),
                    icon: Icon(Icons.add),
                    label: const Text("Create a Receipe"),
                    onPressed: () => Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) {
                        return CustomizeCocktailScreen(null);
                      }),
                    ),
                  ),
                ),
              ),
          ),
          Align(
            alignment: Alignment(0, 0.85),
            child: Container(
              width: 200.0,
                child: FloatingActionButton.extended(
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
          ),
        ],
      ) ,
    );
  }
}
