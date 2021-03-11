import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:bartender/widgets/searchbar.dart';
import 'package:bartender/model/ingredient.dart';

class ShoppingListIngredientListView extends StatefulWidget {
  final List<Ingredient> ingredientList;
  final void Function(String) addIngredientFunc;
  final void Function(String) removeIngredientFunc;

  ShoppingListIngredientListView(this.ingredientList, this.addIngredientFunc, this.removeIngredientFunc);

  @override
  _ShoppingListIngredientListViewState createState() => _ShoppingListIngredientListViewState();
}

class _ShoppingListIngredientListViewState extends State<ShoppingListIngredientListView> {
  List<Ingredient> _cocktailsList;
  List<Ingredient> _filteredList;

  bool loading = false;

  @override
  void initState() {
    super.initState();
    _cocktailsList = widget.ingredientList;
    _filteredList = widget.ingredientList;
  }

  void _resetSearch() {
    setState(() => _filteredList = _cocktailsList);
  }

  Future<List<Ingredient>> _searchCocktails(String searchString) async {
    setState(() => loading = true);
    var regex = new RegExp(".*$searchString?", caseSensitive: false);
    var results = _cocktailsList.where((i) => regex.hasMatch(i.name)).toList();
    results.forEach((result) => print(result.name));
    setState((){ 
      _filteredList = results;
      loading = false;
    });
    return results;
  }

  void _sortCocktails(){
    _filteredList.sort((a,b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
    setState(() => _filteredList = _filteredList);
  }

  void addIngredient(String id, int index) async {
    setState((){
       _filteredList[index].inMyShoppingList = true;
    });
    widget.addIngredientFunc(id);
  }

  void removeIngredient(String id, int index){
    setState(() => _filteredList[index].inMyShoppingList = false);
    widget.removeIngredientFunc(id);
  }
  
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SearchBar(
          onSearch: _searchCocktails,
          onReset: _resetSearch,
          minimumChars: 2,
        ),
        loading
            ? Center(child: CircularProgressIndicator())
            : Container(
              height: 520,
                child: ListView.builder(
                  padding: const EdgeInsets.all(10.0),
                  itemCount: _filteredList.length,
                  itemBuilder: (ctx, i) => GestureDetector(child: 
                    ListTile(
                      leading: _filteredList[i].imageUrl == null 
                        ? null
                        : Image.network(_filteredList[i].imageUrl, fit: BoxFit.cover, filterQuality: FilterQuality.none),
                      title: Text(_filteredList[i].name),
                      trailing: _filteredList[i].inMyShoppingList
                        ? GestureDetector(
                          child: Icon(Icons.check, color: Colors.greenAccent),
                          onTap: () => removeIngredient(_filteredList[i].id, i),
                        )
                        : GestureDetector(
                          child: Icon(CupertinoIcons.add),
                          onTap: () => addIngredient(_filteredList[i].id, i),
                        ),
                    ),
                    onTap: () {},
                  ),
                ),
              )
      ],
    );
  }
}
