import 'package:bartender/widgets/favorite_cocktail.dart';
import 'package:flutter/material.dart';

import 'package:bartender/model/cocktail.dart';
import 'package:bartender/widgets/ingredient_list.dart';
import 'package:bartender/widgets/cocktail_detail/cocktail_detail_header.dart';
import 'package:bartender/widgets/cocktail_detail/cocktail_detail_prep_steps.dart';

class CommunityCocktailDetailScreen extends StatelessWidget {
  final CommunityCocktail cocktailData;

  CommunityCocktailDetailScreen(this.cocktailData);

  @override
  Widget build(BuildContext context) {
    final textThemes = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(cocktailData.name),
        actions: [
          FavoriteCocktailButton(this.cocktailData.id)
        ],
      ), // actions: [FavoriteCocktailButton(cocktailData.id)],),
      body: SingleChildScrollView( // make center take up as much height as needed by children
        // child: Center(
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CocktailDetailHeader(cocktailData),
                Container(
                  child: Text("Created by ${cocktailData.authorName}")
                ),
                IngredientList(cocktailData.ingredients),
                if(cocktailData.prepSteps != null)
                  Container(
                    padding: const EdgeInsets.all(5), 
                    child: Text("Prepreation", style: textThemes.headline4)
                  ), 
                if(cocktailData.prepSteps != null)
                  CocktailDetailPrepSteps(cocktailData.prepSteps),
                if(cocktailData.notes != null && cocktailData.notes.length > 3)
                  Column(
                    children: [
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 20),
                        // padding: const EdgeInsets.all(5), 
                        child: Text("Notes", style: textThemes.headline4)
                      ),
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 20),
                        // padding: const EdgeInsets.all(5), 
                        child: Text(cocktailData.notes)
                      ),
                    ],
                  ), 
              ],
            ),
          ),
        ),
    );
  }
}
