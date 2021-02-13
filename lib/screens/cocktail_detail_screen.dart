import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'package:bartender/model/cocktail.dart';
import 'package:bartender/widgets/ingredient_list.dart';
import 'package:bartender/widgets/cocktail_detail_header.dart';
import 'package:bartender/widgets/cocktail_detail_prep_steps.dart';
import 'package:bartender/screens/customize_cocktail_screen.dart';

class CocktailDetailScreen extends StatefulWidget {
  Cocktail cocktailData;

  CocktailDetailScreen(this.cocktailData);

  @override
  _CocktailDetailScreenState createState() => _CocktailDetailScreenState();
}

class _CocktailDetailScreenState extends State<CocktailDetailScreen> {

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    final textThemes = Theme.of(context).textTheme;

    final cocktail = widget.cocktailData;

    return Scaffold(
      appBar: AppBar(title: Text("Cocktail Detail")),
      body: 
      SingleChildScrollView( // make center take up as much height as needed by children
        // child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CocktailDetailHeader(cocktail),
              Container(
                margin: const EdgeInsets.symmetric(vertical: 15),
                child: CupertinoButton(
                  padding: EdgeInsets.symmetric(vertical: 5, horizontal: 15),
                  color: Colors.pink,
                  child: const Text("Customize Receipe"),
                  onPressed: () => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_){
                          return CustomizeCocktailScreen(cocktail);
                      }
                    ),
                    ),
                ),
              ),
              Container(
                height: 100,
                width: screenWidth / 2,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black),
                ),
                child: IngredientList(cocktail.ingredients)
              ),
              Container(
                padding: const EdgeInsets.all(5), 
                child: Text("Prepreation", style: textThemes.headline4)
              ), 
              CocktailDetailPrepSteps(cocktail.prepSteps),
              Container(
                padding: const EdgeInsets.only(top: 10),
                child: Text("Origin", style: textThemes.headline4),
              ), 
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                // padding: const EdgeInsets.all(5), 
                child: Text(cocktail.about)
              ), 
            ],
          ),
        ),
    );
  }
}
