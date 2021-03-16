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
  Map<Ingredient, List<String>> missing1Ing;

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
    // final sorted = Map<Ingredient, int>.from(
    //   result, (key1, key2) => result[key2].compareTo(result[key1]));
    setState(() => missing1Ing = result);
    return availbleCocktails;
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
                      subtitle: Text("${missing1Ing[ing].length.toString()} drink: ${explodeDrinksList(missing1Ing[ing])}", style: TextStyle(color: Colors.black54, fontSize: 14)),
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
                height: height - 300,
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