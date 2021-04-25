import 'package:home_bartender/firebase_util.dart';
import 'package:home_bartender/providers/auth.dart';
import 'package:home_bartender/widgets/auth/auth_form_wrapper.dart';
import 'package:home_bartender/widgets/cocktail_gridview.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class FavoritesScreen extends StatelessWidget {

  const FavoritesScreen();

  @override
  Widget build(BuildContext context) {
    return Consumer<Auth>(
      builder: (ctx, auth, _) => Scaffold(
        appBar: AppBar(title: const Text("Favorites")),
        body: auth.isLoggedIn 
          ? FutureBuilder(
            future: findCommunityCocktailByIds(auth.favorites),
            builder: (context, snapshot) {
              if(snapshot.connectionState != ConnectionState.done) {
                return Center(child: CircularProgressIndicator());
              }
              if(snapshot.hasError) {
                print("error in favorites screen findCommunityCocktailByIds");
                print(snapshot.error.toString());
                return Center(child: Text("An error has occured, please try again later!"));
              }
              
              return CocktailGridView(cocktailsList: findCocktailsByIds(auth.favorites) + snapshot.data, showSearchBar: false,);
            }
          )
        : AuthFormWrapper()
    ));
  }
}