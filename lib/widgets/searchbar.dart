import 'dart:async';

import 'package:flutter/material.dart';
import 'package:bartender/widgets/filter_form.dart';

class SearchBarStyle {
  final Color backgroundColor;
  final EdgeInsetsGeometry padding;
  final BorderRadius borderRadius;

  const SearchBarStyle(
      {this.backgroundColor = const Color.fromRGBO(142, 142, 147, .15),
      this.padding = const EdgeInsets.all(5.0),
      this.borderRadius: const BorderRadius.all(Radius.circular(5.0))});
}

class SearchBar extends StatefulWidget {
  final bool isIngredient;
  final int minimumChars;
  final Future<dynamic> Function(String text) onSearch;
  final void Function() onReset;
  final void Function(bool strength, bool name) onSort;
  final void Function(List<String> strengthFilters) onFilter;

  SearchBar({
    this.onSearch,
    this.onReset,
    this.onSort,
    this.onFilter,
    this.minimumChars = 3,
    this.isIngredient = false,
  });

  @override
  _SearchBarState createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar> {
  bool _animate = false;
  Timer _debounce;
  TextEditingController _searchQueryController = TextEditingController();

  final searchBarStyle = SearchBarStyle();

  @override
  void onLoading() {
    setState(() {
      _animate = true;
    });
  }

  void _cancel() {
    setState(() {
      _searchQueryController.clear();
      _animate = false;
    });
    widget.onReset();
  }

  _onTextChanged(String newText) async {
    if (_debounce?.isActive ?? false) {
      _debounce.cancel();
    }
    _debounce = Timer(const Duration(milliseconds: 100), () async {
      if (newText.length >= widget.minimumChars && widget.onSearch != null) {
        onLoading();
        widget.onSearch(newText);
      } else {
        setState(() {
          _animate = false;
        });
        widget.onReset();
      }
    });
  }

  void _showFilter(BuildContext ctx) {
    showModalBottomSheet(
      context: ctx,
      builder: (_) {
        return GestureDetector(
          onTap: () {},
          behavior: HitTestBehavior.opaque,
          child: FilterForm(
            sort: widget.onSort, 
            filter: widget.onFilter, 
            isIngredient: widget.isIngredient),
        );
      },
    );
  }

  Widget _searchButton(String text){
    return Container(
      // elevation: 2,
      margin: const EdgeInsets.only(left:4, right: 5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4),
        color: Colors.white,
        border: Border.all(width: 0.5, color: Colors.black54, )
      ),
      child: Container(
        height: 47,
        child: Center(child: Text(text, style: TextStyle(color: Colors.black54, fontWeight: FontWeight.w600)))
      )
    );
  } 

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70,
      margin: const EdgeInsets.only(left: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Flexible(
            child: AnimatedContainer(
              height: 50,
              duration: Duration(milliseconds: 200),
              // width: _animate ? widthMax * .8 : widthMax,
              decoration: BoxDecoration(
                borderRadius: searchBarStyle.borderRadius,
                color: searchBarStyle.backgroundColor,
              ),
              child: Padding(
                padding: searchBarStyle.padding,
                child: Theme(
                  child: TextField(
                    autofocus: false,
                    controller: _searchQueryController,
                    onChanged: _onTextChanged,
                    style: const TextStyle(color: Colors.black),
                    decoration: InputDecoration(
                      icon: const Icon(Icons.search),
                      border: InputBorder.none,
                      hintText: widget.isIngredient 
                        ? "Search for ingredient..."
                        : "Search for a receipe...",
                      hintStyle: const TextStyle(
                          color: Color.fromRGBO(142, 142, 147, 1)),
                    ),
                  ),
                  data: Theme.of(context).copyWith(
                    primaryColor: Colors.black,
                  ),
                ),
              ),
            ),
          ),
          
          GestureDetector(
            onTap: _cancel,
            child: AnimatedOpacity(
              opacity: _animate ? 1 : 0,
              duration: Duration(milliseconds: 300),
              curve: Curves.easeIn,
              child: AnimatedContainer(
                duration: Duration(milliseconds: 200),
                width: _animate ? MediaQuery.of(context).size.width * 0.2 : 0,
                child: _searchButton("Cancel")
              )
            ),
          ),
          GestureDetector(
            onTap: () => _showFilter(context),
            child: AnimatedOpacity(
              opacity: _animate ? 0 : 1,
              duration: Duration(milliseconds: 300),
              curve: Curves.easeIn,
              child: AnimatedContainer(
                duration: Duration(milliseconds: 200),
                width: _animate ? 0: MediaQuery.of(context).size.width * 0.2,
                child: _searchButton("Filter")
              )
            ),
          )
        ],
      ),
    );
  }
}
