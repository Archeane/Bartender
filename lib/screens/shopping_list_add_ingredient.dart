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

  List<bool> _getInShoppingList(Auth authProvider) {
    List<bool> inShoppingList = List.filled(allIngredients.length, false);
    List<String> _shoppingList = authProvider.shoppingList;
    for(var ingredientId in _shoppingList){ 
      int index = allIngredients.indexWhere((item) => item.id == ingredientId);
      inShoppingList[index] = true;
    }
    return inShoppingList;
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
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        // title: const Text("Add to Shopping List"),
        actions: [
          TextButton(
            child: const Text("Done", style: TextStyle(color: Colors.black87)),
            onPressed: () async {
              await provider.updateShoppingList(newList);
              Navigator.of(context).pop();
            }
          )
      ],),
      body: ShoppingListIngredientListView(allIngredients, _getInShoppingList(provider), addToShoppingList, removeFromShoppingList)
    );
  }
}