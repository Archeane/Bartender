import 'package:bartender/widgets/ingredients_listview.dart';
import 'package:flutter/material.dart';
import 'package:bartender/firebase_util.dart';
import 'package:bartender/model/ingredient.dart';

class MyBarScreen extends StatefulWidget {
  @override
  _MyBarScreenState createState() => _MyBarScreenState();
}

class _MyBarScreenState extends State<MyBarScreen> {
  // List<Ingredient> _allIngredients;
  // List<Ingredient> _mybarIngredients;

  Future<List<Ingredient>> _fetchIngredients() async {
    List<Ingredient> allIngredients = await fetchAllIngredients();
    List<dynamic> mybarIngredients = await getMyBarIngredients();
    for(var ingredientId in mybarIngredients){ 
      int index = allIngredients.indexWhere((item) => item.id == ingredientId);
      allIngredients[index].inMyBar = true;
    }
    return allIngredients;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: FutureBuilder(
        future: _fetchIngredients(),
        builder: (context, snapshot) {
          if(snapshot.connectionState != ConnectionState.done) {
            return Center(child: CircularProgressIndicator());
          }
          if(snapshot.hasError) {
            print("error in mybar_screen _fetchIngredients");
            print(snapshot.error);
            return Center(child: Text("An error has occured, please try again later!"));
          }
          final data = snapshot.data;
          return IngredientsListView(data);
        }
      ),
    );
  }
}
