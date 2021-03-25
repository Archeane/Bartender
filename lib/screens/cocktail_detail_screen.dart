import 'package:bartender/screens/ingredient_detail_screen.dart';
import 'package:bartender/widgets/favorite_cocktail.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'package:bartender/model/cocktail.dart';
import 'package:bartender/widgets/cocktail_detail/cocktail_detail_header.dart';
import 'package:bartender/widgets/cocktail_detail/cocktail_detail_prep_steps.dart';
import 'package:bartender/screens/customize_cocktail_screen.dart';
import 'package:fraction/fraction.dart';

class CocktailDetailScreen extends StatelessWidget {
  final Cocktail cocktailData;

  CocktailDetailScreen(this.cocktailData);


  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    final textThemes = Theme.of(context).textTheme;
    Widget customizeReceipeButton = CupertinoButton(
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
      );
    return Scaffold(
      appBar: AppBar(
        title: Text("Cocktail Detail"),
        actions: [
          FavoriteCocktailButton(this.cocktailData.id)
        ],
      ),
      body: 
      SingleChildScrollView( // make center take up as much height as needed by children
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CocktailDetailHeader(cocktailData),
              Container(
                margin: const EdgeInsets.symmetric(vertical: 15),
                child: customizeReceipeButton
              ),
              Text("Ingredients", style: textThemes.headline4),
              SizedBox(height: 10,),
              SingleChildScrollView(
                child: Container(
                  width: screenWidth * 2/3,
                  child: Card(
                    elevation: 2,
                    // child: IngredientList(cocktailData.ingredients)
                    child: Column(children: cocktailData.ingredients.map((ing) => 
                      Column(
                        children: [
                          if(ing.id != cocktailData.ingredients[0].id)
                            Divider(height: 0),
                          Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: GestureDetector(
                              onTap: (){
                                Navigator.of(context).push(
                                  MaterialPageRoute(builder: (_) => IngredientDetailScreen(ing.id)),
                                );
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(ing.name),
                                  Text("${Fraction.fromDouble(ing.amount).toString()} ${ing.unit}"),
                                ],
                              ),
                            ),
                          ),
                        ]
                      )).toList(),
                    )
                  ),
                ),
              ),

              if(cocktailData.prepSteps != null)
                Container(
                  padding: const EdgeInsets.all(5), 
                  child: Text("Prepreation", style: textThemes.headline4)
                ), 
              if(cocktailData.prepSteps != null)
                CocktailDetailPrepSteps(cocktailData.prepSteps),

              // Container(
              //   padding: const EdgeInsets.only(top: 10),
              //   child: Text("Origin", style: textThemes.headline4),
              // ), 
              if(cocktailData.about != null)
                Column(children: [
                  const SizedBox(height: 5,),
                  Container(
                    child: Text("About", style: textThemes.headline4)
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    // padding: const EdgeInsets.all(5), 
                    child: Text(cocktailData.about)
                  ), 
                  const SizedBox(height: 5,),
                ],),
            ],
          ),
        ),
    ));
  }
}
