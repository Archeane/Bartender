import 'package:flutter/material.dart';

class CocktailDetailHeader extends StatelessWidget {
  
  final cocktailData;

  CocktailDetailHeader(this.cocktailData);

  @override
  Widget build(BuildContext context) {
    final textThemes = Theme.of(context).textTheme;
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Container(
      padding: const EdgeInsets.all(5),
      child: Column(
        children: [
          if(cocktailData.imageUrl != null)
            Image.network(cocktailData.imageUrl,
              width: width / 3, height: height * 0.28, fit: BoxFit.cover),
          SizedBox(height: 10),
          if(cocktailData.strength != null)
            Text("${cocktailData.strength.toLowerCase()}, ${cocktailData.alcoholContent.toString()}%",
              style: textThemes.subtitle2),
          if(cocktailData.origin != null)
            Text("Originated from ${cocktailData.origin}", style: textThemes.overline),
        ],
      ),
    );
  }
}
