import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class CocktailDetailHeader extends StatelessWidget {
  
  final cocktailData;

  CocktailDetailHeader(this.cocktailData);

  @override
  Widget build(BuildContext context) {
    final textThemes = Theme.of(context).textTheme;

    return Container(
      height: 300,
      padding: const EdgeInsets.all(5),
      child: Column(
        children: [
          Image.network(cocktailData.imageUrl,
              width: 150, height: 200, fit: BoxFit.cover),
          SizedBox(height: 10),
          Text(cocktailData.name, style: textThemes.headline3),
          Text("${cocktailData.strength.toLowerCase()}, ${cocktailData.alcoholContent.toString()}%",
              style: textThemes.subtitle2),
        ],
      ),
    );
  }
}
