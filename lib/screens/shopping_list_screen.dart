import 'package:bartender/providers/auth.dart';
import 'package:bartender/screens/shopping_list_add_ingredient.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

class ShoppingListScreen extends StatelessWidget {
  
  const ShoppingListScreen();

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<Auth>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Shopping List"),
        actions: [
          IconButton(
            icon: Icon(CupertinoIcons.add),
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => ShoppingListAddIngredientScreen(authProvider.shoppingList))
            ),
          )
        ],
      ),
      body: Consumer<Auth>(
        builder: (_, auth, child) {
          final shoppingList = auth.shoppingList;
          return ListView.builder(
            padding: const EdgeInsets.all(10.0),
            itemCount: shoppingList.length,
            itemBuilder: (ctx, i) => GestureDetector(child: 
              ListTile(
                // leading: shoppingList[i].imageUrl == null 
                //   ? null
                //   : Image.network(shoppingList[i].imageUrl, fit: BoxFit.cover, filterQuality: FilterQuality.none),
                title: Text(shoppingList[i]),
                trailing: GestureDetector(
                    child: Icon(Icons.remove_circle, color: Colors.greenAccent),
                    onTap: () {
                      auth.removeShoppingListItem(shoppingList[i]);
                    },
                  )
              ),
              onTap: () {},
            ),
          );
        },
      ),
    );
  }
}
