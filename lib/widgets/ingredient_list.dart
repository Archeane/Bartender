import 'dart:core';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import '../model/ingredient.dart';

class IngredientList extends StatefulWidget {
  final ingredients;

  IngredientList(this.ingredients);

  @override
  _IngredientListState createState() => _IngredientListState();
}

class _IngredientListState extends State<IngredientList> {

  // make a get request for every ingredient and return the concat results as a list
  Future<List<Ingredient>> _fetchIngredients(CollectionReference ingredientsCollection) async {
    List<Ingredient> _ingredientsList = new List();  
    for (var ingredientId in widget.ingredients){
      DocumentSnapshot snapshot = await ingredientsCollection.doc(ingredientId).get(); 
      if (snapshot.exists) {
        _ingredientsList.add(Ingredient(
          name: snapshot.data()['name'],
        ));
      }
    }
    return _ingredientsList;
  }

  @override
  Widget build(BuildContext context) {
    // CollectionReference ingredientsCollection = FirebaseFirestore.instance.collection('ingredients');
  
    final ingreidentsList = widget.ingredients;
    final textThemes = Theme.of(context).textTheme;
    // return FutureBuilder(
    //   future: _fetchIngredients(ingredientsCollection),
    //   builder: (context, snapshot) {
    //     if(snapshot.connectionState != ConnectionState.done) {
    //       return Center(child: CircularProgressIndicator());
    //     }
    //     if(snapshot.hasError) {
    //       print("error in ingredient list _fetchIngredients");
    //       return Text("An error has occured, please try again later!");
    //     }
    //     List<Ingredient> ingreidentsList = snapshot.data;
    
    return Container(
      padding: const EdgeInsets.all(10),
      child: ListView.builder(
        itemCount: ingreidentsList.length,
        itemBuilder: (ctx, idx) {
          final key = ingreidentsList.keys.elementAt(idx);
          final ingredientData = ingreidentsList[key];
          // final ingredient = Ingredient(
          //   name: ingredientData['name'],
          //   unit: ingredientData['unit'],
          //   amount: ingredientData['amount']
          // );

          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(ingredientData['name']),
              Text("${ingredientData['amount']} ${ingredientData['unit']}"),
            ],
          );
        },           
      ),
    );
      // }
    // );
  }
}