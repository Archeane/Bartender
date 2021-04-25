import 'package:home_bartender/model/cocktail.dart';
import 'package:home_bartender/widgets/cocktail_card.dart';
import 'package:flutter/material.dart';
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
    return CarouselSlider(
          options: CarouselOptions(
            viewportFraction: 0.3, 
            enlargeCenterPage: enlargeCenter
          ),
          items: cocktails.map((cocktail) {
            return Builder(
              builder: (BuildContext context) {
                return CocktailCard(cocktail);
              },
            );
          }).toList(),
        );
  }
}
