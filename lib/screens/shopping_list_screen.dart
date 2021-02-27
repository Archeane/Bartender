import 'package:bartender/model/ingredient.dart';
import 'package:bartender/providers/auth.dart';
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
        actions: [
          IconButton(
            icon: Icon(CupertinoIcons.add),
            onPressed: () {
              authProvider.addShoppingListItem("zUuaPaQSyrX11Y93p6Rz");
              // add shopping list item to firebase
            },
          )
        ],
      ),
      body: Consumer<Auth>(
        builder: (_, user, child) {
          final shoppingList = user.shoppingList;
          print(shoppingList);
          return ListView.builder(
            padding: const EdgeInsets.all(10.0),
            itemCount: shoppingList.length,
            itemBuilder: (ctx, i) => GestureDetector(child: 
              ListTile(
                leading: shoppingList[i].imageUrl == null 
                  ? null
                  : Image.network(shoppingList[i].imageUrl, fit: BoxFit.cover, filterQuality: FilterQuality.none),
                title: Text(shoppingList[i].name),
                trailing: GestureDetector(
                    child: Icon(Icons.remove_circle, color: Colors.greenAccent),
                    onTap: () {
                      authProvider.removeShoppingListItem(shoppingList[i]);
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
