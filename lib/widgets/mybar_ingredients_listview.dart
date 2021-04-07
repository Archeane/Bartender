import 'dart:async';

import 'package:bartender/providers/auth.dart';
import 'package:bartender/screens/mybar_cocktails_screen.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:bartender/widgets/searchbar.dart';
import 'package:bartender/model/ingredient.dart';
import 'package:provider/provider.dart';

class MyBarIngredientsListView extends StatefulWidget {
  final List<Ingredient> ingredientList;
  MyBarIngredientsListView(this.ingredientList);

  @override
  _MyBarIngredientsListViewState createState() => _MyBarIngredientsListViewState();
}

class _MyBarIngredientsListViewState extends State<MyBarIngredientsListView> {
  List<Ingredient> _cocktailsList;
  List<Ingredient> _filteredList;

  bool loading = false;
  bool _cocktailsLoading = false;
  int _numberCocktails = 0;

  @override
  void initState() {
    super.initState();
    _cocktailsList = widget.ingredientList;
    _filteredList = widget.ingredientList;
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Auth tempAuthProvider = Provider.of<Auth>(context, listen: false);
      tempAuthProvider.initMybarCocktails();
      setState(() => _numberCocktails = tempAuthProvider.mybarCocktails.length);
    });
    
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

  void addIngredient(String id, int index, Auth authProvider) async {
    setState((){
       _cocktailsLoading = true;
    });
    
    await authProvider.addIngredientToMyBar(id);
    
    setState((){
      _cocktailsLoading = false;
      _numberCocktails = authProvider.mybarCocktails.length;
    });

  }

  void removeIngredient(String id, int index, Auth authProvider) async {
    setState((){
       _cocktailsLoading = true;
    });
    await authProvider.removeIngredientFromMyBar(id);
    setState((){
      _cocktailsLoading = false;
      _numberCocktails = authProvider.mybarCocktails.length;
    });
  }

  void _filterIngredients(List<String> types){
    List<IngredientType> filteredTypes = types.map((type) => IngredientType.values.firstWhere((e) => describeEnum(e) == type)).toList();
    final filteredCocktails = _cocktailsList.where((ingredient) => filteredTypes.contains(ingredient.type)).toList();
    setState(() => _filteredList = filteredCocktails);
  }
  
  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<Auth>(context);
    double height = MediaQuery.of(context).size.height;
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
            : Container(
                height: height * 0.65,
                  child: ListView.builder(
                    padding: const EdgeInsets.all(10.0),
                    itemCount: _filteredList.length,
                    itemBuilder: (ctx, i) => GestureDetector(child: 
                      ListTile(
                        leading: _filteredList[i].imageUrl == null 
                          ? null
                          : CircleAvatar(
                          backgroundImage: CachedNetworkImageProvider(_filteredList[i].imageUrl),
                          backgroundColor: Colors.white,
                        ),
                        title: Text(_filteredList[i].name),
                        trailing: authProvider.mybarIngredients.contains(_filteredList[i].id)
                          ? GestureDetector(
                            child: Icon(Icons.check, color: Colors.greenAccent),
                            onTap: () => removeIngredient(_filteredList[i].id, i, authProvider)
                          )
                          : GestureDetector(
                            child: Icon(CupertinoIcons.add),
                            onTap: () => addIngredient(_filteredList[i].id, i, authProvider),
                          ),
                      ),
                      onTap: () {},
                    ),
                  ),
                ),
          RaisedButton(
            child: Container(
              width: 200,
              child: Row(children:[
                const Text("You can make "), 
                _cocktailsLoading
                  ? Container(child: CircularProgressIndicator(), height: 20, width: 20)
                  : Text(_numberCocktails.toString()),
                const Text(" Cocktails")
              ]),
            ),
            onPressed: _numberCocktails == 0 
              ? null 
              : (){
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => MyBarCocktailScreen())
              );
            },
          ),
      ],
    );
  }
}
