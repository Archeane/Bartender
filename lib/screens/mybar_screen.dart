import 'package:bartender/providers/auth.dart';
import 'package:bartender/widgets/auth/auth_form_wrapper.dart';
import 'package:bartender/widgets/mybar_ingredients_listview.dart';
import 'package:flutter/material.dart';
import 'package:bartender/firebase_util.dart';
import 'package:provider/provider.dart';

class MyBarScreen extends StatefulWidget {
  @override
  _MyBarScreenState createState() => _MyBarScreenState();
}

class _MyBarScreenState extends State<MyBarScreen> {

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<Auth>(context);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(title: const Text("My Bar Ingredients"),),
      body: authProvider.isLoggedIn
        ? MyBarIngredientsListView(allIngredients)
        // FutureBuilder(
        //   future: _fetchIngredients(authProvider),
        //   builder: (context, snapshot) {
        //     if(snapshot.connectionState != ConnectionState.done) {
        //       return Center(child: CircularProgressIndicator());
        //     }
        //     if(snapshot.hasError) {
        //       print("error in mybar_screen _fetchIngredients");
        //       print(snapshot.error);
        //       return Center(child: Text("An error has occured, please try to relogin!"));
        //     }
        //     final data = snapshot.data;
        //     return MyBarIngredientsListView(data, authProvider.addIngredientToMyBar, authProvider.removeIngredientFromMyBar);
        //   }
        // )
      : AuthFormWrapper()//_setIsLoggedIn)
    );
  }
}
