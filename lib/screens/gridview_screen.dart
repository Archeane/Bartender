import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:bartender/model/cocktail.dart';

import 'package:bartender/screens/cocktail_detail_screen.dart';

class GridViewScreen extends StatelessWidget {
  final collection;

  GridViewScreen(this.collection);

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
    print(_cocktailList);
    return _cocktailList;
  }

  @override
  Widget build(BuildContext context) {
    final collectionRef = FirebaseFirestore.instance.collection('cocktails');
    print(collection);
    // print(collectionRef.doc(collection.items[0]).get());
    return Scaffold(
      appBar: AppBar(title: Text("Grid View")),
      body: FutureBuilder(    // get collection.items
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
          return GridView.builder(
            padding: const EdgeInsets.all(10.0),
            itemCount: cocktailsList.length,
            itemBuilder: (ctx, i) => GridTile(
              child: GestureDetector(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_){
                        return CocktailDetailScreen(cocktailsList[i]);
                      }
                    ),
                  );
                },
                child:Image.network(cocktailsList[i].imageUrl, fit: BoxFit.cover),
              ),
            ),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 4 / 3,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
            ),
          );
        })
    );
  }
}