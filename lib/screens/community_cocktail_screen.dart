
import 'package:bartender/firebase_util.dart';
import 'package:bartender/model/cocktail.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:bartender/widgets/cocktail_gridview.dart';

class CommunityCocktailScreen extends StatefulWidget {
  CommunityCocktailScreen({Key key}) : super(key: key);

  @override
  _CommunityCocktailScreenState createState() => _CommunityCocktailScreenState();
}

class _CommunityCocktailScreenState extends State<CommunityCocktailScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Community Screen"),
      ),
      body: FutureBuilder(
        future: fetchAllCommunityCocktail(),
        builder: (context, snapshot) {
          if(snapshot.connectionState != ConnectionState.done) {
            return Center(child: CircularProgressIndicator());
          }
          if(snapshot.hasError) {
            print("error in community_screen _fetchCollection");
            return Center(child: Text("An error has occured, please try again later!"));
          }
          List<CommunityCocktail> data = snapshot.data;
          
          return CocktailGridView(cocktailsList: data.where((cocktail) => cocktail.isPublic == true).toList());
        }
      ),
    );
  }
}