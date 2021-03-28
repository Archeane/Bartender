import 'dart:collection';

import 'package:bartender/model/cocktail.dart';
import 'package:bartender/model/ingredient.dart';
import 'package:bartender/providers/auth.dart';
import 'package:bartender/widgets/mybar_cocktail_group.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';


import '../firebase_util.dart';


class MyBarCocktailScreen extends StatefulWidget {
  const MyBarCocktailScreen();

  @override
  _MyBarCocktailScreenState createState() => _MyBarCocktailScreenState();
}

class _MyBarCocktailScreenState extends State<MyBarCocktailScreen> {
  LinkedHashMap missing1Ing;

  List<Cocktail> _getCocktails(Auth authProvider) {
    List<Cocktail> availbleCocktails = <Cocktail>[];
    List<String> cocktails = authProvider.mybarCocktails;
    for(String id in cocktails){
      int index = allCocktails.indexWhere((cocktail) => cocktail.id == id);
      if(index >= 0){
        availbleCocktails.add(allCocktails[index]);
      } else {
        print("!!!!!!!");
        print(id);
        print(index);
      }
    }
    Map<Ingredient, List<String>> result = {};
    for(String key in authProvider.missing1Ing.keys){
      if(!authProvider.inShoppingList(key)){
        Ingredient ing = getIngredientById(key);
        result[ing] = authProvider.missing1Ing[key];
      }
    }
    var sortedKeys = result.keys.toList(growable:false)
    ..sort((k1, k2) => result[k2].length.compareTo(result[k1].length));
    LinkedHashMap sortedMap = new LinkedHashMap
      .fromIterable(sortedKeys, key: (k) => k, value: (k) => result[k]);

    setState(() => missing1Ing = sortedMap);
    return availbleCocktails;
  }

  String explodeDrinksList(List<String> cocktailNames){
    String x = "";
    cocktailNames.forEach((name) => x += name += ", ");
    return x.length > 50 ? x.substring(0, 50) + "..." : x;
  }

  @override
  Widget build(BuildContext context) {
    Auth authProvider = Provider.of<Auth>(context);
    final cocktails = _getCocktails(authProvider);
    double height = MediaQuery.of(context).size.height;


    return Scaffold(
      appBar: AppBar(title: const Text("Availble cocktails")),
      body: SingleChildScrollView(
            child: Column(children: [
              Container(
                height: 250,
                child: MyBarCocktailGroup(cocktails: cocktails, enlargeCenter: true)
              ),
              Divider(height: 20,),
              Container(
                child: ListView.builder(
                  itemCount: missing1Ing.length,
                  itemBuilder: (context, index) {
                    Ingredient ing = missing1Ing.keys.elementAt(index);
                    return ListTile(
                      title: Text(ing.name, style: TextStyle(color: Colors.black, fontSize: 16)),
                      subtitle: Text("${missing1Ing[ing].length.toString()} drink", style: TextStyle(color: Colors.black54, fontSize: 14)),
                      trailing: ElevatedButton.icon(
                        label: const Text("Shopping List", style: TextStyle(fontSize: 12)), 
                        icon: Icon(Icons.add, size: 18), 
                        onPressed: (){
                          authProvider.addShoppingListItem(ing.id);
                          missing1Ing.remove(ing);
                        },
                      ),
                    );
                  }
                ),
                height: height - 400,
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