import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:bartender/model/cocktail.dart';
import 'package:bartender/widgets/cocktail_gridview.dart';

class CollectionGridScreen extends StatelessWidget {
  final collection;

  CollectionGridScreen(this.collection);

  Future<List<Cocktail>> _fetchCollectionItems(CollectionReference collectionRef) async {
    List<Cocktail> _cocktailList = new List();  
    for (var id in collection['items']){
      DocumentSnapshot snapshot = await collectionRef.doc(id).get(); 
      if (snapshot.exists) {
        final data = snapshot.data();
        _cocktailList.add(Cocktail(
          id: id,
          name: data['name'],
          imageUrl: data['imageUrl'],
          alcoholContent: data['alcoholContent'],
          prepSteps: data['prepSteps'],
          ingredients: data['ingredients'],
          about: data['about']
        ));
      }
    }
    return _cocktailList;
  }

  @override
  Widget build(BuildContext context) {
    final collectionRef = FirebaseFirestore.instance.collection('cocktails');
    return Scaffold(
      appBar: AppBar(title: Text("Collection GridView")),
      body: FutureBuilder(
        future: _fetchCollectionItems(collectionRef),
        builder: (context, snapshot) {
          if(snapshot.connectionState != ConnectionState.done) {
            return Center(child: CircularProgressIndicator());
          }
          if(snapshot.hasError) {
            print("error in gridview_screen _fetchCollectionItems");
            return Center(child: Text("An error has occured in the server, please try again later!"));
          }
          List<Cocktail> cocktailsList = snapshot.data;
          return CocktailGridView(cocktailsList);
        }
      ), 
    );
  }
}