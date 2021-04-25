import 'package:home_bartender/widgets/cocktail_card.dart';
import 'package:home_bartender/widgets/searchbar.dart';

import 'package:flutter/material.dart';

import 'package:home_bartender/model/cocktail.dart';


class CocktailGridView extends StatefulWidget {
  final List<Cocktail> cocktailsList;
  final bool showSearchBar;

  CocktailGridView({
    @required this.cocktailsList, 
    this.showSearchBar = true
  });

  @override
  _CocktailGridViewState createState() => _CocktailGridViewState();
}

class _CocktailGridViewState extends State<CocktailGridView> {
  List<Cocktail> _cocktailsList; 
  List<Cocktail> _filteredList;

  bool loading = false;

  @override
  void initState() {
    super.initState();
    _cocktailsList = widget.cocktailsList;
    _filteredList = widget.cocktailsList;
  }

  void _resetSearch() {
    setState(() => _filteredList = _cocktailsList);
  }

  Future<List<Cocktail>> _searchCocktails(String searchString) async {
    setState(() => loading = true);
    var regex = new RegExp(".*$searchString?", caseSensitive: false);
    var results = _cocktailsList.where((i) => regex.hasMatch(i.name)).toList();
    setState((){ 
      _filteredList = results;
      loading = false;
    });
    return results;
  }

  void _sortCocktails(bool strength, bool name){
    if(name){
      _filteredList.sort((a,b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
    }
    if(strength) {
      _filteredList.sort((a,b) => a.alcoholContent.compareTo(b.alcoholContent));
    }
    setState(() => _filteredList = _filteredList);
  }

  void _filterCocktails(List<String> strength){
    final filteredCocktails = _cocktailsList.where((cocktail) => strength.contains(cocktail.strength)).toList();

    setState(() => _filteredList = filteredCocktails);
  }
  
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Column(
      children: [
        if(widget.showSearchBar)
          SearchBar(
            onSearch: _searchCocktails,
            onReset: _resetSearch,
            onSort: _sortCocktails,
            onFilter: _filterCocktails,
            minimumChars: 2,
          ),
        loading
            ? Center(child: CircularProgressIndicator())
            : Expanded(
                child: GridView.builder(
                  padding: const EdgeInsets.all(10.0),
                  itemCount: _filteredList.length,
                  itemBuilder: (ctx, i) => GridTile(
                    child: CocktailCard(_filteredList[i])
                  ),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: screenWidth > 1000 ? 4 : 2,
                    // childAspectRatio: 4 / 3,
                    crossAxisSpacing: 5,
                    mainAxisSpacing: 5,
                  ),
                ),
              ),
      ],
    );
  }
}
