import 'package:bartender/model/ingredient.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:dropdown_search/dropdown_search.dart';

class IngredientsInputList extends StatelessWidget {
  final List<String> dropdownList = [
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
              ];
  final List<Ingredient> _ingredientsList;
  final Function _addIngredient;
  final Function _deleteIngredient;
  
  IngredientsInputList(this._ingredientsList, this._deleteIngredient, this._addIngredient);

  @override
  Widget build(BuildContext context) {
    final textThemes = Theme.of(context).textTheme;
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.symmetric(vertical: 15),
          child:
              Text("Ingredients", style: textThemes.headline4)),
        Container(
          height: 50.0 * _ingredientsList.length,
          margin: const EdgeInsets.symmetric(vertical: 4),
          child: ListView.builder(
            itemCount: _ingredientsList.length,
            itemBuilder: (context, index) => Container(
              margin: const EdgeInsets.only(top: 5),
              child: Row(
                mainAxisSize: MainAxisSize.min, 
                children: [
                  Expanded(
                      flex: 4,
                      child: Container(
                        height: 45,
                        child: DropdownSearch<String>(
                          showSelectedItem: true,
                          items: dropdownList,
                          onChanged: print,
                          selectedItem: _ingredientsList[index].name,
                          onSaved: (value) {
                            _ingredientsList[index].name = value.toString();
                          },
                        ),
                      )),
                  SizedBox(width: 10),
                  Expanded(
                      flex: 1,
                      child: Container(
                        height: 45,
                        alignment: Alignment.center,
                        child: TextFormField(
                          textAlign: TextAlign.center,
                          decoration: InputDecoration(contentPadding: EdgeInsets.zero),
                          keyboardType: TextInputType.number,
                          initialValue:
                              _ingredientsList[index].amount.toString(), //ingredients[key]['amount'],
                          validator: (value){
                            if(value.isEmpty || value == "0"){
                              return "empty!";
                            }
                            return null;
                          },
                          onSaved: (value) {
                            _ingredientsList[index].amount = value.toString();
                          },
                        ),
                      )),
                  SizedBox(width: 10),
                  Expanded(
                      flex: 1,
                      child: Center(
                        child: CupertinoPicker(
                          diameterRatio: 0.1,
                          offAxisFraction: 0,
                          itemExtent: 36.0,
                          onSelectedItemChanged: (value) {
                            _ingredientsList[index].unit = value.toString();
                          },
                          children: List<Widget>.generate(3, (int index) {
                            return Text(['oz', 'part', 'dash'][index]);
                          }),
                          scrollController: FixedExtentScrollController(initialItem: 1),
                        ),
                      ))
                ]
              ),
            ),
          )
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FlatButton.icon(
              icon: Icon(Icons.delete),
              label: Text("Remove Ingredient"),
              onPressed: _deleteIngredient,
            ),
            FlatButton.icon(
              icon: Icon(Icons.add),
              label: Text("Add Ingredient"),
              onPressed: _addIngredient,
            ),
          ],
        )
                
      ],
    );
  }
}