import 'package:bartender/widgets/favorite_cocktail.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'package:bartender/model/cocktail.dart';
import 'package:bartender/widgets/ingredient_list.dart';
import 'package:bartender/widgets/cocktail_detail/cocktail_detail_header.dart';
import 'package:bartender/widgets/cocktail_detail/cocktail_detail_prep_steps.dart';
import 'package:bartender/screens/customize_cocktail_screen.dart';

class CocktailDetailScreen extends StatelessWidget {
  final Cocktail cocktailData;

  CocktailDetailScreen(this.cocktailData);

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    final textThemes = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: Text("Cocktail Detail"),
        actions: [
          FavoriteCocktailButton(this.cocktailData.id)
        ],
      ),
      body: 
      SingleChildScrollView( // make center take up as much height as needed by children
        // child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CocktailDetailHeader(cocktailData),
              Container(
                margin: const EdgeInsets.symmetric(vertical: 15),
                child: CupertinoButton(
                  padding: EdgeInsets.symmetric(vertical: 5, horizontal: 15),
                  color: Colors.pink,
                  child: const Text("Customize Receipe"),
                  onPressed: () => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_){
                          return CustomizeCocktailScreen(cocktailData);
                      }
                    ),
                    ),
                ),
              ),
              Container(
                height: 150,
                width: screenWidth * 2/3,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black),
                ),
                child: IngredientList(cocktailData.ingredients)
              ),
              if(cocktailData.prepSteps != null)
                Container(
                  padding: const EdgeInsets.all(5), 
                  child: Text("Prepreation", style: textThemes.headline4)
                ), 
              if(cocktailData.prepSteps != null)
                CocktailDetailPrepSteps(cocktailData.prepSteps),
              Container(
                padding: const EdgeInsets.only(top: 10),
                child: Text("Origin", style: textThemes.headline4),
              ), 
              if(cocktailData.about != null)
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  // padding: const EdgeInsets.all(5), 
                  child: Text(cocktailData.about)
                ), 
            ],
          ),
        ),
    );
  }
}
