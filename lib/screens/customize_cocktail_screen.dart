import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:dropdown_search/dropdown_search.dart';

import 'package:bartender/model/cocktail.dart';

class CustomizeCocktailScreen extends StatelessWidget {
  final Cocktail cocktail;

  CustomizeCocktailScreen(this.cocktail);

  List<Widget> _ingredientsInput(ingredients) {
    List<Widget> ingredientInputs = <Widget>[];
    for (var key in cocktail.ingredients.keys){
      ingredientInputs.add(
      Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Expanded(
            flex: 2,
            child: DropdownSearch<String>(
              mode: Mode.MENU,
              showSelectedItem: true,
              items: ["Brazil", "Italia (Disabled)", "Tunisia", 'Canada'],
              onChanged: print,
              selectedItem: ingredients[key]['name'],
            )
          ),
          SizedBox(width: 20),
          Expanded(
            flex: 1,
            child:TextFormField(
              keyboardType: TextInputType.number,
              initialValue: ingredients[key]['amount'],
            )
          ),
        ]),
      );
    }
    return ingredientInputs;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Customize Cocktail')),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(16),
          child: Form(
            child: Column(
              children: _ingredientsInput(cocktail.ingredients),
            ),)
          ),
        )
      
    );
  }
}