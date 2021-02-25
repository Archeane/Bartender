import 'package:bartender/model/cocktail.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:carousel_slider/carousel_slider.dart';

// ignore: must_be_immutable
class MyBarCocktailGroup extends StatelessWidget {
  final List<String> cocktails;
  bool enlargeCenter = false;
  final String ingredient;

  MyBarCocktailGroup({
    @required this.cocktails, 
    this.enlargeCenter = false,
    this.ingredient
  });

  @override
  Widget build(BuildContext context) {
    final textThemes = Theme.of(context).textTheme;

    return Container(
      padding: const EdgeInsets.all(5),
      child: Column(children: [
        if(ingredient != null)
          Container(child: Align(
            alignment: Alignment.centerLeft,
            child: Text("$ingredient, ${cocktails.length} cocktails", style: textThemes.bodyText1),
          ),),
        CarouselSlider(
          options: CarouselOptions(height: 240.0, viewportFraction: 0.5, enlargeCenterPage: enlargeCenter),
          items: cocktails.map((i) {
            return Builder(
              builder: (BuildContext context) {
                return Container(
                  width: 160,
                  margin: EdgeInsets.symmetric(horizontal: 5.0),
                  decoration: BoxDecoration(
                    color: Colors.amber
                  ),
                  child: Text('text $i', style: TextStyle(fontSize: 16.0),)
                );
              },
            );
          }).toList(),
        ),
      ])
    );
  }
}
