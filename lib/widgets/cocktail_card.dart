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
                      : CachedNetworkImageProvider(data.imageUrl),
                      // : CachedNetworkImage(
                      //     imageUrl: data.imageUrl,
                      //     progressIndicatorBuilder: (context, url, downloadProgress) => 
                      //           CircularProgressIndicator(value: downloadProgress.progress),
                      //     errorWidget: (context, url, error) => Icon(Icons.error),
                      //   ),
                    fit: BoxFit.fitWidth, 
                    alignment: Alignment(0.0, -0.75),
                  )
                ),
                  child: Container(
                    padding: const EdgeInsets.all(5),
                    child: Align(
                      child: Column(
                        children: [
                          Text(data.name, style: TextStyle(fontWeight: FontWeight.bold)),
                          if(data.alcoholContent != null)
                            Text(data.alcoholContent.toString()+"%", style: textTheme.overline),
                        ],
                      ),
                      alignment: Alignment(0, -1),
                    ),
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
