import 'package:flutter/material.dart';
import 'package:bartender/widgets/searchbar.dart';
import 'package:bartender/model/ingredient.dart';

class IngredientsListView extends StatefulWidget {
  final List<Ingredient> ingredientList;

  IngredientsListView(this.ingredientList);

  @override
  _IngredientsListViewState createState() => _IngredientsListViewState();
}

class _IngredientsListViewState extends State<IngredientsListView> {
  List<Ingredient> _cocktailsList;
  List<Ingredient> _filteredList;

  bool loading = false;

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

  
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SearchBar(
          onSearch: _searchCocktails,
          onReset: _resetSearch,
          onSort: _sortCocktails,
          minimumChars: 2,
        ),
        loading
            ? Center(child: CircularProgressIndicator())
            : Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(10.0),
                  itemCount: _filteredList.length,
                  itemBuilder: (ctx, i) => GestureDetector(child: 
                    ListTile(
                      leading: Image.network(
                        _filteredList[i].imageUrl, fit: BoxFit.cover, filterQuality: FilterQuality.none),
                      title: Text(_filteredList[i].name)
                    ),
                    onTap: () {},
                  ),
                ),
              ),
      ],
    );
  }
}
