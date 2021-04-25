import 'package:home_bartender/firebase_util.dart';
import 'package:home_bartender/model/ingredient.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/services.dart';
import 'dart:math';

class DecimalTextInputFormatter extends TextInputFormatter {
  DecimalTextInputFormatter({this.decimalRange})
      : assert(decimalRange == null || decimalRange > 0);

  final int decimalRange;

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue, // unused.
    TextEditingValue newValue,
  ) {
    TextSelection newSelection = newValue.selection;
    String truncated = newValue.text;

    if (decimalRange != null) {
      String value = newValue.text;

      if (value.contains(".") &&
          value.substring(value.indexOf(".") + 1).length > decimalRange) {
        truncated = oldValue.text;
        newSelection = oldValue.selection;
      } else if (value == ".") {
        truncated = "0.";

        newSelection = newValue.selection.copyWith(
          baseOffset: min(truncated.length, truncated.length + 1),
          extentOffset: min(truncated.length, truncated.length + 1),
        );
      }

      return TextEditingValue(
        text: truncated,
        selection: newSelection,
        composing: TextRange.empty,
      );
    }
    return newValue;
  }
}

class IngredientsInputList extends StatelessWidget {
  final List<String> dropdownList = allIngredients.map((ing) => ing.name).toList();
  final List<Ingredient> _ingredientsList;
  final Function _addIngredient;
  final Function _deleteIngredient;
  final List<String> units = ['oz', 'part', 'dash', 'tsp', 'cube', 'whole', 'wedge'];
  
  IngredientsInputList(this._ingredientsList, this._deleteIngredient, this._addIngredient);

  @override
  Widget build(BuildContext context) {
    final textThemes = Theme.of(context).textTheme;
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.symmetric(vertical: 15),
          child:
              Text("Ingredients", style: textThemes.headline6)),
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
                          // mode: Mode.MENU,
                          showSelectedItem: true,
                          showSearchBox: true,
                          searchBoxDecoration: InputDecoration(icon: Icon(Icons.search), hintText: "Search for ingredient..."),
                          items: dropdownList,
                          selectedItem: _ingredientsList[index].name,
                          onSaved: (value) {
                            _ingredientsList[index].name = value.toString();
                          },
                          validator: (String item) {
                            if (item == null)
                              return "Required field";
                            else
                              return null;
                          },
                        ),
                      )),
                  SizedBox(width: 5),
                  Expanded(
                      flex: 1,
                      child: Container(
                        height: 45,
                        alignment: Alignment.center,
                        child: TextFormField(
                          textAlign: TextAlign.center,
                          cursorColor: Colors.black,
                          decoration: InputDecoration(contentPadding: EdgeInsets.zero),
                          inputFormatters: [DecimalTextInputFormatter(decimalRange: 2)],
                          keyboardType: TextInputType.numberWithOptions(decimal: true),
                          initialValue:
                              _ingredientsList[index].amount.toString(), //ingredients[key]['amount'],
                          validator: (value){
                            if(value.isEmpty || value == "0"){
                              return "empty!";
                            }
                            return null;
                          },
                          onSaved: (value) {
                            _ingredientsList[index].amount = double.parse(value);
                          },
                        ),
                      )),
                  SizedBox(width: 5),
                  Expanded(
                      flex: 1,
                      child: Center(
                        child: CupertinoPicker(
                          diameterRatio: 0.1,
                          offAxisFraction: 0,
                          itemExtent: 40.0,
                          onSelectedItemChanged: (value) {
                            _ingredientsList[index].unit = units[value];
                          },
                          children: List<Widget>.generate(units.length, (int index) {
                            return Text(units[index]);
                          }),
                          scrollController: FixedExtentScrollController(initialItem: units.indexOf(_ingredientsList[index].unit)),
                        ),
                      ))
                ]
              ),
            ),
          )
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TextButton.icon(
              icon: Icon(Icons.delete),
              label: Text("Remove Ingredient", style: TextStyle(color: Colors.black87)),
              onPressed: _deleteIngredient,
            ),
            RaisedButton.icon(
              color: Color(0xFFE4F0E1),
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

