import 'package:bartender/screens/community_cocktail_detail_screen.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:bartender/model/cocktail.dart';
import 'package:bartender/screens/cocktail_detail_screen.dart';

class CocktailCard extends StatelessWidget {
  final Cocktail data;

  const CocktailCard(this.data);

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Container(
      child: GestureDetector(
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (_) {
                if (data is CommunityCocktail) {
                  return CommunityCocktailDetailScreen(cocktailId: data.id, cocktailData: data);
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
                  image: DecorationImage(
                    image: data.imageUrl == null
                      ? AssetImage('images/default_cocktail.png')
                      : CachedNetworkImageProvider(data.imageUrl),
                    fit: BoxFit.fitWidth, 
                    alignment: Alignment(0.0, -0.75),
                  )
                ),
                child: Container(
                  padding: const EdgeInsets.all(5),
                  child: Align(
                    child: Column(
                      children: [
                        Text(data.name, 
                          style: data is CommunityCocktail ? 
                            TextStyle(fontWeight: FontWeight.bold, color: Colors.greenAccent[100])
                            : TextStyle(fontWeight: FontWeight.bold)),
                        if(data.alcoholContent != null)
                          Text(data.alcoholContent.toString()+"%", style: textTheme.overline),
                      ],
                    ),
                    alignment: Alignment(0, -1),
                  ),
                ),
              ),
            ),
            footer: 
            data is CommunityCocktail
            ? Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(bottomLeft: Radius.circular(5), bottomRight: Radius.circular(5)),
                  color: Colors.white,
                ),
                height: 25,
                child: Center(child:
                    Text(
                      "made by ${(data as CommunityCocktail).authorName}", 
                      style: TextStyle(color: Colors.black),
                    ),
                ),
              )
            : null,
          )
        ),
    );
  }
}
