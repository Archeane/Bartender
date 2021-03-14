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
              if(data is CommunityCocktail){
                return CommunityCocktailDetailScreen(data);
              }else{
                return CocktailDetailScreen(data);
              }
            }),
          );
        },
        child: GridTile(
          child: data.imageUrl == null 
            ? Image(image: AssetImage('images/default_cocktail.png'))
            : Image.network(data.imageUrl,
            fit: BoxFit.cover, filterQuality: FilterQuality.none),
          footer: Text(data.name)
        )
      ),
    );
  }
}