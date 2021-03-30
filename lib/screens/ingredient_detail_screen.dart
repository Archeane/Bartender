import 'package:bartender/firebase_util.dart';
import 'package:bartender/model/ingredient.dart';
import 'package:flutter/material.dart';
import 'package:bartender/widgets/cocktail_detail/cocktail_detail_header.dart';

class IngredientDetailScreen extends StatelessWidget {
  final String ingredientId;
  const IngredientDetailScreen(this.ingredientId);

  @override
  Widget build(BuildContext context) {
    int index = allIngredients.indexWhere((ing) => ing.id == ingredientId);
    Ingredient ingredient = allIngredients[index];
    return Scaffold(
      appBar: AppBar(
        title: Text(ingredient.name),
      ),
      body: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CocktailDetailHeader(ingredient),
              if(ingredient.about != null)
                Column(children: [
                  const SizedBox(height: 10,),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    child: Text(ingredient.about)
                  ), 
                ],),
            ],
          ),
        ),
    );
  }
}