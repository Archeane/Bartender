import 'package:home_bartender/firebase_util.dart';
import 'package:home_bartender/providers/auth.dart';
import 'package:home_bartender/widgets/favorite_cocktail.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:home_bartender/model/cocktail.dart';
import 'package:home_bartender/widgets/ingredient_list.dart';
import 'package:home_bartender/widgets/cocktail_detail/cocktail_detail_header.dart';
import 'package:home_bartender/widgets/cocktail_detail/cocktail_detail_prep_steps.dart';
import 'package:provider/provider.dart';

class CommunityCocktailDetailScreen extends StatefulWidget {
  static const routeName = '/community-cocktails';

  final String cocktailId;
  final CommunityCocktail cocktailData;

  CommunityCocktailDetailScreen({
    this.cocktailId,
    this.cocktailData,
  });

  @override
  _CommunityCocktailDetailScreenState createState() =>
      _CommunityCocktailDetailScreenState();
}

class _CommunityCocktailDetailScreenState
    extends State<CommunityCocktailDetailScreen> {
  bool showSettings = false;

  Future<void> removeRecipe(BuildContext ctx, Auth auth) async {
    await auth.removeCustom(widget.cocktailId);
    ScaffoldMessenger.of(ctx).showSnackBar(
      SnackBar(
        content: Text("Your custom recipe has been removed"),
        backgroundColor: Theme.of(ctx).errorColor,
      ),
    );

    Navigator.of(context).pushNamed("/");
  }

  Widget communityCocktailScreen(CommunityCocktail cocktailData, Auth auth, TextTheme textThemes, bool showHome){
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: showHome
          ? IconButton(icon: Icon(Icons.home), onPressed: () {
            Navigator.of(context).pushNamed("/");
          })
          : null,
        title: Text(cocktailData.name),
        actions: [
          FavoriteCocktailButton(widget.cocktailId),
          if (auth.isLoggedIn &&
              auth.currentUser.uid == cocktailData.authorId)
            IconButton(
              icon: Icon(CupertinoIcons.settings),
              onPressed: () => setState(() => showSettings = true),
            ),
        ],
      ), 
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: 10,
              ),
              CocktailDetailHeader(cocktailData),
              Container(
                  child: Text(
                      "Created by ${cocktailData.authorName}")),
              SizedBox(height: 10,),
              IngredientList(cocktailData.ingredients),
              if (cocktailData.prepSteps != null)
                Container(
                    padding: const EdgeInsets.all(5),
                    child:
                        Text("Preparation", style: textThemes.headline4)),
              if (cocktailData.prepSteps != null)
                CocktailDetailPrepSteps(cocktailData.prepSteps),
              if (cocktailData.notes != null &&
                  cocktailData.notes.length > 3)
                Column(
                  children: [
                    SizedBox(height: 10,),
                    Container(
                        margin:
                            const EdgeInsets.symmetric(horizontal: 20),
                        child:
                            Text("Notes", style: textThemes.headline4)),
                    Container(
                        margin:
                            const EdgeInsets.symmetric(horizontal: 20),
                        child: Text(cocktailData.notes)),
                  ],
                ),
              SizedBox(height: 10,),
              if (showSettings)
                RaisedButton(
                    onPressed: () => removeRecipe(context, auth),
                    child: const Text("Remove Recipe"),
                    color: Colors.redAccent),
              SizedBox(height: 10,),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final CommunityCocktail args =
        ModalRoute.of(context).settings.arguments as CommunityCocktail;
    final textThemes = Theme.of(context).textTheme;
    final Auth auth = Provider.of<Auth>(context, listen: false);
    if(args != null){
      return communityCocktailScreen(args, auth, textThemes, true);
    }
    if(widget.cocktailData != null){
      return communityCocktailScreen(widget.cocktailData, auth, textThemes, false);
    }
    return FutureBuilder(
      future: findCommunityCocktailById(widget.cocktailId),
      builder: (ctx, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        return communityCocktailScreen(snapshot.data, auth, textThemes, true);
    });
  }
}
