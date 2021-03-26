import 'package:bartender/model/cocktail.dart';
import 'package:bartender/widgets/cocktail_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:carousel_slider/carousel_slider.dart';

// ignore: must_be_immutable
class MyBarCocktailGroup extends StatelessWidget {
  final List<Cocktail> cocktails;
  bool enlargeCenter = false;
  // final String ingredient;

  MyBarCocktailGroup({
    @required this.cocktails, 
    this.enlargeCenter = false,
    // this.ingredient
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(5),
      child: Column(children: [
        // if(ingredient != null)
        //   Container(child: Align(
        //     alignment: Alignment.centerLeft,
        //     child: Text("$ingredient, ${cocktails.length} cocktails", style: textThemes.bodyText1),
        //   ),),
        CarouselSlider(
          options: CarouselOptions(height: 200.0, viewportFraction: 0.5, enlargeCenterPage: enlargeCenter),
          items: cocktails.map((cocktail) {
            return Builder(
              builder: (BuildContext context) {
                return CocktailCard(cocktail);
              },
            );
          }).toList(),
        ),
      ])
    );
  }
}
