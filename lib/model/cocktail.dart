import 'package:flutter/foundation.dart';

enum Flavor {
  Sweet,
  Sour,
  Spicy,
}

enum Strength {
  Light,
  Medium,
  Strong,
}

class Cocktail {
  String id;
  String imageUrl;
  String name;
  String origin;
  String about;
  num alcoholContent;
  Flavor flavor;
  String baseSpirit;
  List<dynamic> packs;
  List<dynamic> stars;
  Map<String, dynamic> ingredients;
  List<dynamic> equipments;
  List<dynamic> prepSteps;
  List<Cocktail> related;

  Cocktail({
    @required this.id,
    @required this.name,
    this.imageUrl,
    this.prepSteps,
    this.ingredients,
    this.origin,
    this.flavor,
    this.alcoholContent,
    this.about,
    // this.baseSpirit,
    // this.packs,
    // this.equipments,
    // this.related
  });

  int get numLikes {
    return stars.length;
  }

  String get strength {
    if (this.alcoholContent < 10){
      return Strength.Light.toString().split('.').last;
    } else if (this.alcoholContent > 10 && this.alcoholContent < 20){
      return Strength.Medium.toString().split('.').last;
    } else {
      return Strength.Strong.toString().split('.').last;
    }
  }

}