import 'package:bartender/providers/auth.dart';
import 'package:bartender/widgets/favorite_cocktail.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:bartender/model/cocktail.dart';
import 'package:bartender/widgets/ingredient_list.dart';
import 'package:bartender/widgets/cocktail_detail/cocktail_detail_header.dart';
import 'package:bartender/widgets/cocktail_detail/cocktail_detail_prep_steps.dart';
import 'package:provider/provider.dart';

class CommunityCocktailDetailScreen extends StatefulWidget {
  final CommunityCocktail cocktailData;

  CommunityCocktailDetailScreen(this.cocktailData);

  @override
  _CommunityCocktailDetailScreenState createState() => _CommunityCocktailDetailScreenState();
}

class _CommunityCocktailDetailScreenState extends State<CommunityCocktailDetailScreen> {
  bool showSettings = false;

  @override
  Widget build(BuildContext context) {
    final textThemes = Theme.of(context).textTheme;
    final Auth auth = Provider.of<Auth>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.cocktailData.name),
        actions: [
          FavoriteCocktailButton(this.widget.cocktailData.id),
          if(auth.isLoggedIn && auth.currentUser.uid == widget.cocktailData.authorId)
            IconButton(
              icon: Icon(CupertinoIcons.settings),
              onPressed: () => setState(() => showSettings = true),
            ),
        ],
      ), // actions: [FavoriteCocktailButton(cocktailData.id)],),
      body: SingleChildScrollView( // make center take up as much height as needed by children
        // child: Center(
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 10,),
                CocktailDetailHeader(widget.cocktailData),
                Container(
                  child: Text("Created by ${widget.cocktailData.authorName}")
                ),
                IngredientList(widget.cocktailData.ingredients),
                if(widget.cocktailData.prepSteps != null)
                  Container(
                    padding: const EdgeInsets.all(5), 
                    child: Text("Prepreation", style: textThemes.headline4)
                  ), 
                if(widget.cocktailData.prepSteps != null)
                  CocktailDetailPrepSteps(widget.cocktailData.prepSteps),
                if(widget.cocktailData.notes != null && widget.cocktailData.notes.length > 3)
                  Column(
                    children: [
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 20),
                        // padding: const EdgeInsets.all(5), 
                        child: Text("Notes", style: textThemes.headline4)
                      ),
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 20),
                        // padding: const EdgeInsets.all(5), 
                        child: Text(widget.cocktailData.notes)
                      ),
                    ],
                  ),
                if(showSettings)
                  RaisedButton(
                    onPressed: () {}, 
                    child: const Text("Remove Receipt"), color: Colors.redAccent
                  ) 
              ],
            ),
          ),
        ),
    );
  }
}
