import 'package:bartender/firebase_util.dart';
import 'package:bartender/providers/auth.dart';
import 'package:bartender/screens/shopping_list_screen.dart';
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


class CollectionsScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<Auth>(context);
    return Consumer<Auth>(
        builder: (ctx, auth, _) => Scaffold(
      appBar: AppBar(title: Text("Collections")),
      body: provider.isLoggedIn ? 
        ListView.separated(
          itemCount: provider.collections.length,
          separatorBuilder: (_, __) => const Divider(),
          itemBuilder: (context, idx) => ListTile(
            leading: Icon(IconData(provider.collections[idx]['icon'], fontFamily: 'MaterialIcons'), 
                      color: provider.collections[idx]['icon'] == 62607 ? Colors.yellow : Colors.pink),
            title: Text(provider.collections[idx]['name']),
            onTap: (){
              switch(provider.collections[idx]['name']){
                case "shopping":
                  return Navigator.of(context).push(MaterialPageRoute(builder: (_) => ShoppingListScreen()));
                case "favorites":
                  return Navigator.of(context).push(MaterialPageRoute(builder: (_) => FavoritesScreen()));
                case "custom":
                  return Navigator.of(context).push(MaterialPageRoute(builder: (_) => CustomCollectionScreen()));
              }
            },
          )
        )
      : AuthFormWrapper()
    ));
  }
}
// FutureBuilder<DocumentSnapshot>(
    //     future: users.doc(user.uid).get(),
    //     builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
    //       if (snapshot.connectionState == ConnectionState.waiting) {
    //         return Text("Loading");
    //       }
    //       final data = snapshot.data.data();
    //       if(!data.containsKey('collections')){
    //         return Center(child: const Text("You do not have any collections at the moment"),);
    //       } 
    //       final collections = data['collections'];