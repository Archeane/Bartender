import 'package:bartender/model/cocktail.dart';
import 'package:bartender/model/ingredient.dart';
import 'package:bartender/widgets/checkbox_group.dart';
import 'package:flutter/material.dart';
import 'package:grouped_buttons/grouped_buttons.dart';


class FilterForm extends StatefulWidget {
  final void Function(bool strength, bool name) sort;
  final void Function(List<String> strengths) filter;
  bool isIngredient = false;

  FilterForm(this.sort, this.filter, this.isIngredient);

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
  List<String> _checkedIngType = [];
  
  void _trySubmit() {
    FocusScope.of(context).unfocus();
    if(widget.isIngredient && _checkedIngType.length > 0){
      widget.filter(_checkedIngType);
    } else {
      if(_checkedStrength.length > 0){
        widget.filter(_checkedStrength);
      }
      widget.sort(_sortStrength, _sortName);
    }
  }

  @override
  Widget build(BuildContext context) {
    // final textThemes = Theme.of(context).textTheme;
    // final allSpiritIngredients = allIngredients.where((ing) => ing.type != null && ing.type.toLowerCase() == "spirit");
    // print(allSpiritIngredients.length);
    return SingleChildScrollView(
      padding: EdgeInsets.only(
        top: 10,
        left: 10,
        right: 10,
        bottom: MediaQuery.of(context).viewInsets.bottom + 100,
      ),
      child: widget.isIngredient 
      ? Column(children: [
        const Text("Filter by Ingredient Type"),
        CustomCheckboxGroup(
          orientation: GroupedButtonsOrientation.HORIZONTAL,
          labels: IngredientType.values.map((IngredientType type) => type.toString().split(".").last).toList(),
          onSelected: (List selected) => setState((){_checkedIngType = selected;}),
          checked: _checkedIngType,
        ),
        ElevatedButton(
          child: const Text('Apply Filter'),
          onPressed: _trySubmit
        ),
      ],)
      : Column(
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
          ElevatedButton(
            child: const Text('Apply Filter'),
            onPressed: _trySubmit
          ),
        ],
      ),

    );
  }
}