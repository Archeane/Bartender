import 'package:home_bartender/firebase_util.dart';
import 'package:home_bartender/providers/auth.dart';
import 'package:home_bartender/screens/ingredient_detail_screen.dart';
import 'package:home_bartender/screens/shopping_list_add_ingredient.dart';
import 'package:home_bartender/widgets/auth/auth_form_wrapper.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

class ShoppingListScreen extends StatefulWidget {
  
  const ShoppingListScreen();

  @override
  _ShoppingListScreenState createState() => _ShoppingListScreenState();
}

class _ShoppingListScreenState extends State<ShoppingListScreen> {
  bool showSettings = false;

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<Auth>(context);
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(icon: Icon(Icons.home), onPressed: () {
            Navigator.of(context).pushNamed("/");
          }),
        title: const Text("Shopping List"),
        actions: [
          IconButton(
            icon: Icon(CupertinoIcons.settings),
            onPressed: () => setState(() => showSettings = true)
          ),
          IconButton(
            icon: Icon(CupertinoIcons.add),
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => ShoppingListAddIngredientScreen(authProvider.shoppingList))
            ),
          ),
        ],
      ),
      body: Consumer<Auth>(
        builder: (_, auth, child) {
          return auth.isLoggedIn
           ? ListView.separated(
              padding: const EdgeInsets.only(left: 10.0),
              itemCount: auth.shoppingList.length,
              separatorBuilder: (BuildContext context, int index) => Divider(height: 1),
              itemBuilder: (ctx, i){
                final ing = getIngredientById(auth.shoppingList[i]);
                return GestureDetector(child: 
                ListTile(
                  // dense:true,
                  leading: CircleAvatar(
                    backgroundColor: Colors.white,
                    backgroundImage: ing.imageUrl == null 
                      ? AssetImage('images/${ing.type.toString().split('.').last}.jpg')
                      : CachedNetworkImageProvider(ing.imageUrl),
                  ),
                  title: Text(ing.name),
                  trailing: showSettings ?
                    GestureDetector(
                      child: Icon(Icons.remove_circle, color: Colors.redAccent),
                      onTap: () {
                        auth.removeShoppingListItem(auth.shoppingList[i]);
                      },
                    ) 
                    : null
                ),
                onTap: () => Navigator.of(context).push(MaterialPageRoute(
                  builder: (_) => IngredientDetailScreen(auth.shoppingList[i]))),
              );}, 
            )
          : AuthFormWrapper();
        },
      ),
    );
  }
}
