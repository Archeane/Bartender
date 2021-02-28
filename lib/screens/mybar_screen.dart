import 'package:bartender/providers/auth.dart';
import 'package:bartender/widgets/auth/auth_form_wrapper.dart';
import 'package:bartender/widgets/mybar_ingredients_listview.dart';
import 'package:flutter/material.dart';
import 'package:bartender/firebase_util.dart';

import 'package:bartender/model/ingredient.dart';
import 'package:provider/provider.dart';

class MyBarScreen extends StatefulWidget {
  @override
  _MyBarScreenState createState() => _MyBarScreenState();
}

class _MyBarScreenState extends State<MyBarScreen> {

  Future<List<Ingredient>> _fetchIngredients(Auth authProvider) async {
    List<Ingredient> _allIngredients = []..addAll(allIngredients);
    List<String> _mybarIngredients = await authProvider.mybarIngredients;
    for(var ingredientId in _mybarIngredients){ 
      int index = _allIngredients.indexWhere((item) => item.id == ingredientId);
      _allIngredients[index].inMyBar = true;
    }
    return _allIngredients;
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<Auth>(context, listen: false);
    return Consumer<Auth>(
        builder: (ctx, auth, _) => Scaffold(
      appBar: AppBar(),
      body: authProvider.isLoggedIn 
        ? FutureBuilder(
          future: _fetchIngredients(authProvider),
          builder: (context, snapshot) {
            if(snapshot.connectionState != ConnectionState.done) {
              return Center(child: CircularProgressIndicator());
            }
            if(snapshot.hasError) {
              print("error in mybar_screen _fetchIngredients");
              print(snapshot.error);
              return Center(child: Text("An error has occured, please try to relogin!"));
            }
            final data = snapshot.data;
            return MyBarIngredientsListView(data, authProvider.addIngredientToMyBar, authProvider.removeIngredientFromMyBar);
          }
        )
      : AuthFormWrapper()
    ));
  }
}
