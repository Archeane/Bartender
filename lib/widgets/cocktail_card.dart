import 'package:bartender/screens/community_cocktail_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:bartender/model/cocktail.dart';
import 'package:bartender/screens/cocktail_detail_screen.dart';

class CocktailCard extends StatelessWidget {
  final Cocktail data;

  const CocktailCard(this.data);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: GestureDetector(
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (_) {
                if (data is CommunityCocktail) {
                  return CommunityCocktailDetailScreen(data);
                } else {
                  return CocktailDetailScreen(data);
                }
              }),
            );
          },
          child: GridTile(
            child: Card(
              elevation: 3,
              child: Container(
                decoration: BoxDecoration(
                  // border: Border.all(width: 1),
                  image: DecorationImage(
                    image: data.imageUrl == null
                      ? AssetImage('images/default_cocktail.png')
                      : NetworkImage(data.imageUrl),
                    fit: BoxFit.fitWidth, 
                    alignment: Alignment(0.0, -0.75),
                  )
                ),
                  child: Container(
                    padding: const EdgeInsets.all(5),
                    child: Text(data.name, style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                  // padding: const EdgeInsets.only(top: 20),
                ),
              ),
            ),
            // header: Center(child: Text(data.name))
        ),
    );
  }
}
