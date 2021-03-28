import 'package:bartender/model/cocktail.dart';
import 'package:bartender/widgets/cocktail_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:carousel_slider/carousel_slider.dart';

// ignore: must_be_immutable
class MyBarCocktailGroup extends StatelessWidget {
  final List<Cocktail> cocktails;
  bool enlargeCenter = false;

  MyBarCocktailGroup({
    @required this.cocktails, 
    this.enlargeCenter = false,
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
          options: CarouselOptions(
            viewportFraction: 0.3, 
            enlargeCenterPage: enlargeCenter
          ),
          items: cocktails.map((cocktail) {
            return Builder(
              builder: (BuildContext context) {
                return Container(
                  width: 300,
                  height: 300,
                  child: CocktailCard(cocktail)
                );
              },
            );
          }).toList(),
        ),
      ])
    );
  }
}
