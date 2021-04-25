import 'package:home_bartender/firebase_util.dart';
import 'package:home_bartender/model/cocktail.dart';
import 'package:home_bartender/screens/customize_cocktail_screen.dart';

import 'package:flutter/material.dart';
import 'package:home_bartender/widgets/cocktail_gridview.dart';

class CommunityCocktailScreen extends StatefulWidget {
  CommunityCocktailScreen({Key key}) : super(key: key);

  @override
  _CommunityCocktailScreenState createState() =>
      _CommunityCocktailScreenState();
}

class _CommunityCocktailScreenState extends State<CommunityCocktailScreen> {

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      appBar: AppBar(
        title: const Text("Community Cocktails")
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
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Container(
        width: 200.0,
        margin: const EdgeInsets.only(bottom: 10),
        child: FittedBox(
          child: FloatingActionButton.extended(
            heroTag: "createReceipe",
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
    );
  }
}
