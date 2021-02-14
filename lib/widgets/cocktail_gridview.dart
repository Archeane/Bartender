import 'package:bartender/widgets/searchbar.dart';

import 'package:flutter/material.dart';

import 'package:bartender/model/cocktail.dart';

import 'package:bartender/screens/cocktail_detail_screen.dart';

class CocktailGridView extends StatefulWidget {
  final List<Cocktail> cocktailsList;

  CocktailGridView(this.cocktailsList);

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
                child: GridView.builder(
                  padding: const EdgeInsets.all(10.0),
                  itemCount: _filteredList.length,
                  itemBuilder: (ctx, i) => GridTile(
                    child: GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (_) {
                            return CocktailDetailScreen(_filteredList[i]);
                          }),
                        );
                      },
                      child: Image.network(_filteredList[i].imageUrl,
                          fit: BoxFit.cover, filterQuality: FilterQuality.none),
                    ),
                  ),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 4 / 3,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                  ),
                ),
              ),
      ],
    );
  }
}
