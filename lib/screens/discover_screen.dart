import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:bartender/model/cocktail.dart';
import 'package:bartender/widgets/cocktail_gridview.dart';
import 'package:bartender/widgets/searchbar.dart';

class DiscoverScreen extends StatefulWidget {
  DiscoverScreen({Key key}) : super(key: key);

  @override
  _DiscoverScreenState createState() => _DiscoverScreenState();
}

class _DiscoverScreenState extends State<DiscoverScreen> {

  Future<List<Cocktail>> _fetchCollection() async {
    final snapshot = await FirebaseFirestore.instance.collection('cocktails').get();
    List<Cocktail> _cocktailList = new List();  
    for(var doc in snapshot.docs){
      _cocktailList.add(Cocktail(
          id: doc.id,
          name: doc['name'],
          imageUrl: doc['imageUrl'],
          alcoholContent: doc.data().containsKey("alcoholContent") ? doc['alcoholContent'] : 5,
          prepSteps: doc.data().containsKey("prepSteps") ? doc['prepSteps'] : null,
          ingredients: doc.data().containsKey("ingredients") ? doc['ingredients'] : null,
          about: doc.data().containsKey("ingredients") ? doc['about'] : null,
        ));
    }
    return _cocktailList;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Discover Screen"),),
      body: FutureBuilder(
        future: _fetchCollection(),
        builder: (context, snapshot) {
          if(snapshot.connectionState != ConnectionState.done) {
            return Center(child: CircularProgressIndicator());
          }
          if(snapshot.hasError) {
            print("error in discover_screen _fetchCollection");
            print(snapshot.error);
            return Center(child: Text("An error has occured, please try again later!"));
          }
          return CocktailGridView(snapshot.data);
        }
      ),
    );
  }
}