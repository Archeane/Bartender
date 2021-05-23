import 'package:home_bartender/widgets/favorite_cocktail.dart';
import 'package:home_bartender/widgets/ingredient_list.dart';
import 'package:flutter/material.dart';

import 'package:home_bartender/model/cocktail.dart';
import 'package:home_bartender/widgets/cocktail_detail/cocktail_detail_header.dart';
import 'package:home_bartender/widgets/cocktail_detail/cocktail_detail_prep_steps.dart';
import 'package:home_bartender/screens/customize_cocktail_screen.dart';

class CocktailDetailScreen extends StatelessWidget {
  final Cocktail cocktailData;

  CocktailDetailScreen(this.cocktailData);

  @override
  Widget build(BuildContext context) {
    final textThemes = Theme.of(context).textTheme;
    Widget customizeRecipeButton = RaisedButton(
        // padding: EdgeInsets.symmetric(vertical: 5, horizontal: 15),
        child: const Text("Customize Recipe"),
        onPressed: () => Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_){
                return CustomizeCocktailScreen(cocktailData);
            }
          ),
          ),
      );
    return Scaffold(
      appBar: AppBar(
        title: Text(cocktailData.name),
        actions: [
          FavoriteCocktailButton(this.cocktailData.id)
        ],
      ),
      body: 
      SingleChildScrollView(
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CocktailDetailHeader(cocktailData),
              Container(
                margin: const EdgeInsets.only(bottom: 10),
                child: customizeRecipeButton
              ),
              Text("Ingredients", style: textThemes.headline4),
              SizedBox(height: 10,),
              IngredientList(cocktailData.ingredients),
              if(cocktailData.prepSteps != null)
                Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(5), 
                      child: Text("Preparation", style: textThemes.headline4)
                    ),
                    CocktailDetailPrepSteps(cocktailData.prepSteps),
                    const SizedBox(height: 10,),
                  ],
                ), 
              if(cocktailData.about != null)
                Column(children: [
                  Container(
                    child: Text("About", style: textThemes.headline4)
                  ),
                  const SizedBox(height: 5,),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    child: Text(cocktailData.about)
                  ), 
                  const SizedBox(height: 20,),
                ],),
            ],
          ),
        ),
    ));
  }
}
