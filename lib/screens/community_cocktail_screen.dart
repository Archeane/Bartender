
import 'package:bartender/model/ingredient.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:bartender/model/cocktail.dart';
import 'package:bartender/widgets/cocktail_gridview.dart';

class CommunityCocktailScreen extends StatefulWidget {
  CommunityCocktailScreen({Key key}) : super(key: key);

  @override
  _CommunityCocktailScreenState createState() => _CommunityCocktailScreenState();
}

class _CommunityCocktailScreenState extends State<CommunityCocktailScreen> {

  Future<List<CommunityCocktail>> _fetchCollection() async {
    final snapshot = await FirebaseFirestore.instance.collection('community').get();
    List<CommunityCocktail> _cocktailList = new List();  
    for(QueryDocumentSnapshot doc in snapshot.docs){
      print(doc.toString());
      _cocktailList.add(CommunityCocktail(
          id: doc.id,
          name: doc['name'],
          imageUrl: doc['imageUrl'],
          notes: doc.data().containsKey("notes") ? doc['notes'] : null,
          prepSteps: doc.data().containsKey("prepSteps") ? doc['prepSteps'].cast<String>() : null,
          ingredients: doc.data().containsKey("ingredients") ? doc['ingredients'].cast<Ingredient>() : null,
        ));
    }
    return _cocktailList;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Community Screen"),
      ),
      body: FutureBuilder(
        future: _fetchCollection(),
        builder: (context, snapshot) {
          if(snapshot.connectionState != ConnectionState.done) {
            return Center(child: CircularProgressIndicator());
          }
          if(snapshot.hasError) {
            print("error in community_screen _fetchCollection");
            return Center(child: Text("An error has occured, please try again later!"));
          }
          return CocktailGridView(snapshot.data);
        }
      ),
    );
  }
}