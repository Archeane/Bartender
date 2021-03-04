import 'package:bartender/firebase_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
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
    print(allCocktails);
    return Scaffold(
      appBar: AppBar(title: const Text("Discover Screen")),
      body: CocktailGridView(allCocktails));
  }
}

    // Future<List<Cocktail>> _fetchCollection() async {
    //   final snapshot = await FirebaseFirestore.instance.collection('cocktails').get();
    //   List<Cocktail> _cocktailList = new List();
    //   for(var doc in snapshot.docs){
    //     _cocktailList.add(Cocktail(
    //         id: doc.id,
    //         name: doc['name'],
    //         imageUrl: doc['imageUrl'],
    //         about: doc.data().containsKey("ingredients") ? doc['about'] : null,
    //         prepSteps: doc.data().containsKey("prepSteps") ? doc['prepSteps'] : null,
    //         flavor: doc.data().containsKey("flavor") ? doc['flavor'] : null,
    //         alcoholContent: doc.data().containsKey("alcoholContent") ? doc['alcoholContent'] : null,
    //         ingredients: doc.data().containsKey("ingredients") ? doc['ingredients'] : null,
    //       ));
    //   }
    //   return _cocktailList;
    // }

    //   FutureBuilder(
    //     future: _fetchCollection(),
    //     builder: (context, snapshot) {
    //       if(snapshot.connectionState != ConnectionState.done) {
    //         return Center(child: CircularProgressIndicator());
    //       }
    //       if(snapshot.hasError) {
    //         print("error in discover_screen _fetchCollection");
    //         return Center(child: Text("An error has occured, please try again later!"));
    //       }
    //       return CocktailGridView(snapshot.data);
    //     }
    //   ),
    // );