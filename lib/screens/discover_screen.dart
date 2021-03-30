import 'package:bartender/firebase_util.dart';
import 'package:flutter/material.dart';
import 'package:bartender/widgets/cocktail_gridview.dart';

class DiscoverScreen extends StatefulWidget {
  DiscoverScreen();

  @override
  _DiscoverScreenState createState() => _DiscoverScreenState();
}

class _DiscoverScreenState extends State<DiscoverScreen> {
  bool showAddIngredient = false;

  SliverAppBar showSliverAppBar() {
    return SliverAppBar(
      backgroundColor: Colors.purple,
      floating: true,
      pinned: true,
      snap: false,
      bottom: TabBar(
        tabs: [
          Tab(
            icon: Icon(Icons.home),
            text: 'Home',
          ),
          Tab(
            icon: Icon(Icons.settings),
            text: 'Setting',
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Discover")),
      body: CocktailGridView(cocktailsList: allCocktails));
  }
}