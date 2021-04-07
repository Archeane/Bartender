import 'dart:async';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:bartender/widgets/searchbar.dart';
import 'package:bartender/model/ingredient.dart';

class ShoppingListIngredientListView extends StatefulWidget {
  final List<Ingredient> ingredientList;
  final List<bool> inShoppingList;
  final void Function(String) addIngredientFunc;
  final void Function(String) removeIngredientFunc;

  ShoppingListIngredientListView(this.ingredientList, this.inShoppingList, this.addIngredientFunc, this.removeIngredientFunc);

  @override
  _ShoppingListIngredientListViewState createState() => _ShoppingListIngredientListViewState();
}

class _ShoppingListIngredientListViewState extends State<ShoppingListIngredientListView> {
  List<Ingredient> _cocktailsList;
  List<Ingredient> _filteredList;
  List<bool> _inShoppingList;

  bool loading = false;

  @override
  void initState() {
    super.initState();
    _cocktailsList = widget.ingredientList;
    _filteredList = widget.ingredientList;
    _inShoppingList = widget.inShoppingList;
  }

  void _resetSearch() {
    setState(() => _filteredList = _cocktailsList);
  }

  Future<List<Ingredient>> _searchCocktails(String searchString) async {
    setState(() => loading = true);
    var regex = new RegExp(".*$searchString?", caseSensitive: false);
    var results = _cocktailsList.where((i) => regex.hasMatch(i.name)).toList();
    setState((){ 
      _filteredList = results;
      loading = false;
    });
    return results;
  }

  void _filterIngredients(List<String> types){
    List<IngredientType> filteredTypes = types.map((type) => IngredientType.values.firstWhere((e) => describeEnum(e) == type)).toList();
    final filteredCocktails = _cocktailsList.where((ingredient) => filteredTypes.contains(ingredient.type)).toList();
    setState(() => _filteredList = filteredCocktails);
  }

  void addIngredient(String id, int index) async {
    setState((){
       _inShoppingList[index] = true;
    });
    widget.addIngredientFunc(id);
  }

  void removeIngredient(String id, int index){
    setState(() => _inShoppingList[index] = false);
    widget.removeIngredientFunc(id);
  }
  
  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    return Column(
      children: [
        SearchBar(
          onSearch: _searchCocktails,
          onReset: _resetSearch,
          minimumChars: 2,
          onFilter: _filterIngredients,
          isIngredient: true,
        ),
        loading
            ? Center(child: CircularProgressIndicator())
            : GestureDetector(
              onTap: () => FocusScope.of(context).unfocus(),
              child: Container(
                height: screenHeight - 200,
                  child: ListView.builder(
                    padding: const EdgeInsets.all(10.0),
                    itemCount: _filteredList.length,
                    itemBuilder: (ctx, i) => GestureDetector(child: 
                      ListTile(
                        leading: CircleAvatar(
                          backgroundColor: Colors.white,
                          backgroundImage: _filteredList[i].imageUrl == null 
                            ? AssetImage('images/${_filteredList[i].type.toString().split('.').last}.jpg')
                            : CachedNetworkImageProvider(_filteredList[i].imageUrl),
                        ),
                        title: Text(_filteredList[i].name),
                        trailing: _inShoppingList[i]
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
                ),
            )
      ],
    );
  }
}
