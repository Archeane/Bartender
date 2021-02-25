import 'package:bartender/model/ingredient.dart';
import 'package:bartender/widgets/mybar_cocktail_group.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';


class MyBarCocktailScreen extends StatelessWidget {
  final List<Ingredient> _availableIngredients;

  const MyBarCocktailScreen(this._availableIngredients);

  Future<Map<String, dynamic>> _fetchCalculatedCocktails() async {
    final result = {
      "ready": ["1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12"],
      "one_ingredient": {
        "lemon": ["17", "20", "11", "16"],
        "angostra bitter": ["22", "97"],
        "south side": ["100"],
      },
    };
    return result;
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: FutureBuilder(
        future: _fetchCalculatedCocktails(),
        builder: (context, snapshot) {
          if(snapshot.connectionState != ConnectionState.done) {
            return Center(child: CircularProgressIndicator());
          }
          if(snapshot.hasError) {
            print("error in mybar_screen _fetchIngredients");
            print(snapshot.error);
            return Center(child: Text("An error has occured, please try again later!"));
          }
          final data = snapshot.data;
          final oneIngredientKeys = data["one_ingredient"].keys.toList();
          var oneIngredientValues = [];
          for(var value in data["one_ingredient"].values){
            oneIngredientValues.add(value);
          }

          return SingleChildScrollView(
            child: Column(children: [
              MyBarCocktailGroup(cocktails: data['ready'], enlargeCenter: true),
              Divider(),
              // Expanded(
              //   child: ListView.builder(
              //   itemCount: oneIngredientData.length,
              //   itemBuilder: (BuildContext context, int index) {
              //     String key = oneIngredientData.keys.elementAt(index);
              //     return MyBarCocktailGroup(oneIngredientData[key]);
              //   }),
              // ),
              for(int i = 0; i < oneIngredientValues.length; i++)
                MyBarCocktailGroup(cocktails: oneIngredientValues[i], ingredient: oneIngredientKeys[i])
            ],
          ));
        }
      )
    );
  }
}