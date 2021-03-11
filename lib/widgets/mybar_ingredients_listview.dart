import 'dart:async';

import 'package:bartender/screens/mybar_cocktails_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:bartender/widgets/searchbar.dart';
import 'package:bartender/model/ingredient.dart';

class MyBarIngredientsListView extends StatefulWidget {
  final List<Ingredient> ingredientList;
  final void Function(String) addIngredientFunc;
  final void Function(String) removeIngredientFunc;

  MyBarIngredientsListView(this.ingredientList, this.addIngredientFunc, this.removeIngredientFunc);

  @override
  _MyBarIngredientsListViewState createState() => _MyBarIngredientsListViewState();
}

class _MyBarIngredientsListViewState extends State<MyBarIngredientsListView> {
  List<Ingredient> _cocktailsList;
  List<Ingredient> _filteredList;

  bool loading = false;
  bool _cocktailsLoading = false;
  int _numberCocktails = 10;

  @override
  void initState() {
    super.initState();
    _cocktailsList = widget.ingredientList;
    _filteredList = widget.ingredientList;
  }

  void _resetSearch() {
    setState(() => _filteredList = _cocktailsList);
  }

  Future<List<Ingredient>> _searchCocktails(String searchString) async {
    setState(() => loading = true);
    var regex = new RegExp(".*$searchString?", caseSensitive: false);
    var results = _cocktailsList.where((i) => regex.hasMatch(i.name)).toList();
    results.forEach((result) => print(result.name));
    setState((){ 
      _filteredList = results;
      loading = false;
    });
    return results;
  }

  void _sortCocktails(){
    _filteredList.sort((a,b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
    setState(() => _filteredList = _filteredList);
  }

  void addIngredient(String id, int index) async {
    //change state
    setState((){
       _filteredList[index].inMyBar = true;
       _cocktailsLoading = true;
    });

    widget.addIngredientFunc(id);

    // call calculate cocktails
    await Future.delayed(Duration(seconds: 1), () => print('done'));
    List<String> cocktailIds = ["1CBFexv7aMXxuTh79Joa", "7V2rGzoqQlaX1HU2noKY", "AEpPcl32Hp4m1yEnEB5a", "vyTwCSGtppp4Q4es9JCV"];
    
    setState((){
      _cocktailsLoading = false;
      _numberCocktails = cocktailIds.length;
    });

  }

  void removeIngredient(String id, int index){
    setState(() => _filteredList[index].inMyBar = false);
    widget.removeIngredientFunc(id);
  }
  
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SearchBar(
          onSearch: _searchCocktails,
          onReset: _resetSearch,
          minimumChars: 2,
        ),
        loading
            ? Center(child: CircularProgressIndicator())
            : Container(
              height: 480,
                child: ListView.builder(
                  padding: const EdgeInsets.all(10.0),
                  itemCount: _filteredList.length,
                  itemBuilder: (ctx, i) => GestureDetector(child: 
                    ListTile(
                      leading: _filteredList[i].imageUrl == null 
                        ? null
                        : Image.network(_filteredList[i].imageUrl, fit: BoxFit.cover, filterQuality: FilterQuality.none),
                      title: Text(_filteredList[i].name),
                      trailing: _filteredList[i].inMyBar
                        ? GestureDetector(
                          child: Icon(Icons.check, color: Colors.greenAccent),
                          onTap: () => removeIngredient(_filteredList[i].id, i),
                        )
                        : GestureDetector(
                          child: Icon(CupertinoIcons.add),
                          onTap: () => addIngredient(_filteredList[i].id, i),
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
            onPressed: (){
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => MyBarCocktailScreen(this._filteredList))
              );
            },
          ),
      ],
    );
  }
}
