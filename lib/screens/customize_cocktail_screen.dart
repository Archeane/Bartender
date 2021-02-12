import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:dropdown_search/dropdown_search.dart';

import 'package:bartender/model/cocktail.dart';

class CustomizeCocktailScreen extends StatelessWidget {
  
  final Cocktail cocktail;

  CustomizeCocktailScreen(this.cocktail);

  List<Map<String, String>> findIngredientSubsitute(ingredientId) {
    //get ingredient type - spirit, bitter etc
    //get list of ingredients id->name of the same type
    //sort the list by name alphbetacally
  }

  List<Widget> _ingredientsInput(ingredients) {
    List<Widget> ingredientInputs = <Widget>[];
    for (var key in cocktail.ingredients.keys) {
      ingredientInputs.add(
        Row(mainAxisSize: MainAxisSize.min, children: [
          Expanded(
              flex: 2,
              child: DropdownSearch<String>(
                showSelectedItem: true,
                items: [
                  'Canada',
                  'us',
                  'china',
                  'uk',
                  'brazil',
                  'japan',
                  'korea',
                  'russia',
                  'africa',
                  'prussia',
                  'Canada',
                  'us',
                  'china',
                  'uk',
                  'brazil',
                  'japan',
                  'korea',
                  'russia',
                  'africa',
                  'prussia'
                ],
                onChanged: print,
                selectedItem: ingredients[key]['name'],
              )),
          SizedBox(width: 20),
          Expanded(
              flex: 1,
              child: TextFormField(
                keyboardType: TextInputType.number,
                initialValue: ingredients[key]['amount'],
              )),
        ]),
      );
    }
    return ingredientInputs;
  }

  @override
  Widget build(BuildContext context) {
    final textThemes = Theme.of(context).textTheme;

    return Scaffold(
        appBar: AppBar(title: Text('Customize Cocktail')),
        body: SingleChildScrollView(
          child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Form(
                child: Column(
                  children: [
                    Container(margin: const EdgeInsets.symmetric(vertical: 15), child: Text("Ingredients", style: textThemes.headline4)),
                    ..._ingredientsInput(cocktail.ingredients),
                    SizedBox(height: 15,),
                    Text("Notes", style: textThemes.headline4),
                    SizedBox(height: 10,),
                    Container(
                      height: 100,
                      child: CupertinoTextField(
                        placeholder: "Add custom notes...",
                        expands: true,
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.black45),
                            borderRadius: BorderRadius.circular(5)),
                        keyboardType: TextInputType.multiline,
                        maxLines: null,
                      ),
                    ),
                    SizedBox(height: 15,),
                    Row(children: [
                      Expanded(child: Text("Allow my reciepe to be shown to the community")),
                      CupertinoSwitch(value: false, onChanged: (_) {},),
                    ]),
                    SizedBox(height: 20,),
                    CupertinoButton(
                      color: Colors.blueAccent,
                      child: Text("Save Custom Receipe"), 
                      onPressed: (){},
                    ),
                  ],
                ),
              )),
        ));
  }
}
