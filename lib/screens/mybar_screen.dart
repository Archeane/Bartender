import 'package:home_bartender/providers/auth.dart';
import 'package:home_bartender/widgets/auth/auth_form_wrapper.dart';
import 'package:home_bartender/widgets/mybar_ingredients_listview.dart';
import 'package:flutter/material.dart';
import 'package:home_bartender/firebase_util.dart';
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
        : AuthFormWrapper()
    );
  }
}
