import 'package:bartender/model/cocktail.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:grouped_buttons/grouped_buttons.dart';


class FilterForm extends StatefulWidget {
  final void Function(bool strength, bool name) sort;
  final void Function(List<String> strengths) filter;

  FilterForm(this.sort, this.filter);

  @override
  _FilterFormState createState() => _FilterFormState();
}

enum SortMethod {
  Alphabetical,
  Strength,
}

enum FilterMethod { // multi selects
  Strength,
  Ingredients,
}

class _FilterFormState extends State<FilterForm> {
  var _sortStrength = false;
  var _sortName = false;
  List<String> _checkedStrength = [];
  
  void _trySubmit() {
    FocusScope.of(context).unfocus();
    widget.sort(_sortStrength, _sortName);
    if(_checkedStrength.length > 0){
      widget.filter(_checkedStrength);
    }
  }

  @override
  Widget build(BuildContext context) {
    // final textThemes = Theme.of(context).textTheme;
    // final allSpiritIngredients = allIngredients.where((ing) => ing.type != null && ing.type.toLowerCase() == "spirit");
    // print(allSpiritIngredients.length);
    return SingleChildScrollView(
      child: Container(
          height: 350,
          padding: EdgeInsets.only(
            top: 10,
            left: 10,
            right: 10,
            bottom: MediaQuery.of(context).viewInsets.bottom + 10,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              // sorts: strength, name
              Text("Sort by"),
              CheckboxListTile(
                title: const Text("Strength"),
                value: _sortStrength,
                onChanged: (bool val) => setState(() => _sortStrength = val),
                controlAffinity: ListTileControlAffinity.platform,  //  <-- leading Checkbox
              ),
              CheckboxListTile(
                title: Text("Name"),
                value: _sortName,
                onChanged: (bool val) => setState(() => _sortName = val),
                controlAffinity: ListTileControlAffinity.platform,  //  <-- leading Checkbox
              ),
              // filter: strength, spirit, liqueur
              Text("Strength"),
              CheckboxGroup(
                orientation: GroupedButtonsOrientation.HORIZONTAL,
                labels: Strength.values.map((Strength strength) => strength.toString().split(".").last).toList(),
                onSelected: (List selected) => setState((){_checkedStrength = selected;}),
                checked: _checkedStrength,
                itemBuilder: (Checkbox cb, Text txt, int i){
                  return Row(
                    children: [cb,txt],
                  );
                },
              ),
              // Text("Ingredient"),
              // Column(children:[CheckboxGroup(
              //   orientation: GroupedButtonsOrientation.HORIZONTAL,
              //   labels: allSpiritIngredients.map((Ingredient ing) => ing.name.toString()).toList(),
              //   onSelected: (List selected) => setState((){_checkedIngredient = selected;}),
              //   checked: _checkedIngredient,
              //   itemBuilder: (Checkbox cb, Text txt, int i){
              //     return Row(
              //       children: [cb,txt],
              //     );
              //   },
              // )]),
              RaisedButton(
                child: const Text('Apply Filter'),
                color: Theme.of(context).primaryColor,
                textColor: Theme.of(context).textTheme.button.color,
                onPressed: _trySubmit
              ),
            ],
          ),
        ),
    );
  }
}