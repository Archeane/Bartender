import 'dart:async';

import 'package:flutter/material.dart';

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
  final int minimumChars;
  final Future<dynamic> Function(String text) onSearch; 
  final void Function() onReset; 

  SearchBar({
    this.onSearch,
    this.onReset,
    this.minimumChars = 3,
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

  @override
  Widget build(BuildContext context) {
    final widthMax = MediaQuery.of(context).size.width;
    return Container(
      height: 80,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Flexible(
            child: AnimatedContainer(
              duration: Duration(milliseconds: 200),
              width: _animate ? widthMax * .8 : widthMax,
              decoration: BoxDecoration(
                borderRadius: searchBarStyle.borderRadius,
                color: searchBarStyle.backgroundColor,
              ),
              child: Padding(
                padding: searchBarStyle.padding,
                child: Theme(
                  child: TextField(
                    controller: _searchQueryController,
                    onChanged: _onTextChanged,
                    style: const TextStyle(color: Colors.black),
                    decoration: InputDecoration(
                      icon: const Icon(Icons.search),
                      border: InputBorder.none,
                      hintText: "Search for a receipe...",
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
              opacity: _animate ? 1.0 : 0,
              curve: Curves.easeIn,
              duration: Duration(milliseconds: _animate ? 500 : 0),
              child: AnimatedContainer(
                duration: Duration(milliseconds: 100),
                width: _animate ? MediaQuery.of(context).size.width * .2 : 0,
                child: Container(
                  color: Colors.transparent,
                  child: Center(
                    child: const Text("Cancel"),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
