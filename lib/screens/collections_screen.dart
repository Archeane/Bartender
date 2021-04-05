import 'package:bartender/firebase_util.dart';
import 'package:bartender/providers/auth.dart';
import 'package:bartender/widgets/auth/auth_form_wrapper.dart';
import 'package:bartender/widgets/cocktail_gridview.dart';
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

class CustomCollectionScreen extends StatelessWidget {

  const CustomCollectionScreen();

  @override
  Widget build(BuildContext context) {
    return Consumer<Auth>(
      builder: (ctx, auth, _) => Scaffold(
        appBar: AppBar(title: const Text("Custom Receipes")),
        body: FutureBuilder(
          future: findCommunityCocktailByIds(auth.custom),
          builder: (context, snapshot) {
            if(snapshot.connectionState != ConnectionState.done) {
              return Center(child: CircularProgressIndicator());
            }
            if(snapshot.hasError) {
              print("error in collection screen findCommunityCocktailByIds");
              print(snapshot.error.toString());
              return Center(child: Text("An error has occured, please try again later!"));
            }
            return CocktailGridView(cocktailsList: snapshot.data, showSearchBar: false,);
          }
        )
    ));
  }
}
