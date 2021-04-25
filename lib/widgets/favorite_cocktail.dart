import 'package:home_bartender/providers/auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FavoriteCocktailButton extends StatelessWidget {
  final String cocktailId;

  FavoriteCocktailButton(this.cocktailId);

  @override
  Widget build(BuildContext context) {
    Auth provider = Provider.of<Auth>(context);
    return provider.isLoggedIn 
      ? IconButton(
        color: Colors.redAccent,
        icon: Icon(
          provider.favorites.contains(cocktailId)
          ? Icons.favorite
          : Icons.favorite_border_outlined
        ),
        onPressed: () {
          if(provider.favorites.contains(cocktailId)){
            provider.removeFavorites(cocktailId);
          } else {
            provider.addFavorites(cocktailId);
          }
        })
      : IconButton(
          color: Colors.redAccent,
          icon: Icon(Icons.favorite_border_outlined),
          onPressed: () async {
            await showDialog(
              context: context,
              builder: (ctx) => AlertDialog(
                title: const Text('Cannot Add to Favorites'),
                content: const Text('Please login to add to favorites'),
                actions: <Widget>[
                  TextButton(
                    child: const Text('OK', style: TextStyle(color: Colors.black87)),
                    onPressed: () {
                      Navigator.of(context, rootNavigator: true).pop();
                    },
                  )
                ],
              ),
            );
          },
        );
  }
}