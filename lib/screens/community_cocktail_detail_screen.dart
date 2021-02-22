import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'package:bartender/model/cocktail.dart';
import 'package:bartender/widgets/ingredient_list.dart';
import 'package:bartender/widgets/cocktail_detail/cocktail_detail_header.dart';
import 'package:bartender/widgets/cocktail_detail/cocktail_detail_prep_steps.dart';

class CommunityCocktailDetailScreen extends StatelessWidget {
  final CommunityCocktail cocktailData;

  CommunityCocktailDetailScreen(this.cocktailData);

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    final textThemes = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(title: Text("Cocktail Detail")),
      body: 
      SingleChildScrollView( // make center take up as much height as needed by children
        // child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CocktailDetailHeader(cocktailData),
              Container(
                height: 100,
                width: screenWidth / 2,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black),
                ),
                child: IngredientList(cocktailData.ingredients)
              ),
              Container(
                padding: const EdgeInsets.all(5), 
                child: Text("Prepreation", style: textThemes.headline4)
              ), 
              CocktailDetailPrepSteps(cocktailData.prepSteps),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                // padding: const EdgeInsets.all(5), 
                child: Text(cocktailData.notes)
              ), 
            ],
          ),
        ),
    );
  }
}
