import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class MyBarCocktailScreen extends StatelessWidget {
  final List<String> _availableIngredients;

  const MyBarCocktailScreen(this._availableIngredients);

  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        child: Column(children: [

        ],)
      ),
    );
  }
}