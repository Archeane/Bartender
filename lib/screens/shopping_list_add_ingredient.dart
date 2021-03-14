import 'package:bartender/firebase_util.dart';
import 'package:bartender/model/ingredient.dart';
import 'package:bartender/providers/auth.dart';
import 'package:bartender/widgets/shoppinglist_ingredient_listview.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ShoppingListAddIngredientScreen extends StatefulWidget {

  final List<String> _originalShoppingList;
  
  ShoppingListAddIngredientScreen(this._originalShoppingList);

  @override
  _ShoppingListAddIngredientScreenState createState() => _ShoppingListAddIngredientScreenState();
}

class _ShoppingListAddIngredientScreenState extends State<ShoppingListAddIngredientScreen> {

  List<String> newList;

  List<Ingredient> _fetchIngredients(Auth authProvider) {
    List<Ingredient> _allIngredients = []..addAll(allIngredients);
    List<String> _shoppingList = authProvider.shoppingList;
    for(var ingredientId in _shoppingList){ 
      int index = _allIngredients.indexWhere((item) => item.id == ingredientId);
      _allIngredients[index].inMyShoppingList = true;
    }
    return _allIngredients;
  }

  void addToShoppingList(String id) {
    newList.add(id);
  }

  void removeFromShoppingList(String id){
    newList.remove(id);
  }

  @override
  Widget build(BuildContext context) {
    newList = widget._originalShoppingList;
    final provider = Provider.of<Auth>(context); 
    return Scaffold(
      appBar: AppBar(actions: [
        TextButton(
          child: const Text("Done"),
          onPressed: () {
            provider.updateShoppingList(newList);
            Navigator.of(context).pop();
          }
        )
      ],),
      body: ShoppingListIngredientListView(_fetchIngredients(provider), addToShoppingList, removeFromShoppingList)
    );
  }
}