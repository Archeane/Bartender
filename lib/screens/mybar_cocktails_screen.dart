import 'package:bartender/model/cocktail.dart';
import 'package:bartender/model/ingredient.dart';
import 'package:bartender/providers/auth.dart';
import 'package:bartender/widgets/mybar_cocktail_group.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:tuple/tuple.dart';


import '../firebase_util.dart';


class MyBarCocktailScreen extends StatelessWidget {
  const MyBarCocktailScreen();

  Tuple2<List<Cocktail>, Map<Ingredient, int>> _getCocktails(Auth authProvider) {
    List<Cocktail> availbleCocktails = <Cocktail>[];
    List<String> cocktails = authProvider.mybarCocktails;
    print(cocktails);
    for(String id in cocktails){
      int index = allCocktails.indexWhere((cocktail) => cocktail.id == id);
      availbleCocktails.add(allCocktails[index]);

    }
    Map<Ingredient, int> result = {};
    for(String key in authProvider.missing1Ing.keys){
      Ingredient ing = getIngredientById(key);
      result[ing] = authProvider.missing1Ing[key].length;
    }
    return Tuple2<List<Cocktail>, Map<Ingredient, int>>(availbleCocktails, result);
    // Map<String, List<Cocktail>> result = {};
    // for(String key in authProvider.missing1Ing.keys){
    //   if(!result.containsKey(key)){
    //     result[key] = <Cocktail>[];
    //   }
    //   authProvider.missing1Ing[key].map((cocktailId) {
    //     int index = allCocktails.indexWhere((cocktail) => cocktail.id == cocktailId);
    //     result[key].add(allCocktails[index]);
    //   });
    // }
    // return Tuple2<List<Cocktail>, Map<String, List<Cocktail>>>(availbleCocktails, result);
  }


  @override
  Widget build(BuildContext context) {
    Auth authProvider = Provider.of<Auth>(context);
    final data = _getCocktails(authProvider);
    Map<Ingredient, int> missing1Ing = data.item2;
    return Scaffold(
      appBar: AppBar(title: const Text("Availble cocktails")),
      body: SingleChildScrollView(
            child: Column(children: [
              MyBarCocktailGroup(cocktails: data.item1, enlargeCenter: true),
              Divider(),
              Container(
                child: ListView.builder(
                  itemCount: missing1Ing.length,
                  itemBuilder: (context, index) {
                    Ingredient ing = missing1Ing.keys.elementAt(index);
                    return ListTile(
                      title: Text(ing.name),
                      subtitle: Text(missing1Ing[ing].toString()),
                      trailing: ElevatedButton.icon(label: const Text("Add to shopping list"), icon: Icon(Icons.add), onPressed: (){},),
                    );
                  }
                ),
                height: 500,
              )
              // Expanded(
              //   child: ListView.builder(
              //   itemCount: oneIngredientData.length,
              //   itemBuilder: (BuildContext context, int index) {
              //     String key = oneIngredientData.keys.elementAt(index);
              //     return MyBarCocktailGroup(oneIngredientData[key]);
              //   }),
              // ),
              // for(int i = 0; i < oneIngredientValues.length; i++)
                // MyBarCocktailGroup(cocktails: oneIngredientValues[i], ingredient: oneIngredientKeys[i])
            ],
          )
      )
    );
  }
}