import 'package:bartender/model/ingredient.dart';
import 'package:bartender/firebase_util.dart';
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

enum DefaultPrepStep {
  Shake,
  Stir,
  Pour,
}


extension DefaultPrepStepExtension on DefaultPrepStep {
  List<String> get value {
    switch (this) {
      case DefaultPrepStep.Shake:
        return [
          "Fill up the Shaker with Ice",
          "Pour everything into the Shaker",
          "Shake well",
          "Strain into the drinking glass"
        ];
      case DefaultPrepStep.Stir:
        return [
          "Fill up the drinking glass with Ice",
          "Pour everything into the drinking glass",
          "Stir together",
        ];
      case DefaultPrepStep.Pour:
        return [
          "Fill up the drinking glass with Ice",
          "Pour everything into the drinking glass",
        ];
      default:
        return [];
    }
  }
}

class Cocktail {
  String id;
  String imageUrl;
  String name;
  String about;
  int alcoholContent;
  String flavor;
  List<Ingredient> ingredients = <Ingredient>[];
  Set<String> ingredientsIds = new Set<String>();
  List<String> prepSteps;
  String origin;
  DefaultPrepStep defaultPrepStep;
  // String baseSpirit;
  // List<dynamic> packs;
  // List<dynamic> stars;
  // List<dynamic> equipments;
  // List<Cocktail> related;

  Cocktail({
    this.id,
    this.name,
    this.imageUrl,
    this.about,
    this.flavor,
    this.origin,
    List<dynamic> prepSteps,
    int alcoholContent,
    Map ingredients,
  }){


    if(prepSteps != null){
      this.prepSteps = prepSteps.map((s) => s as String).toList();
    }
    if(alcoholContent != null) 
      this.alcoholContent = alcoholContent;
    // this.flavor = Flavor.values.firstWhere((e) => e.toString() == 'Flavor.' + flavor);
    if(ingredients != null){
      List<Ingredient> ingredientsBuffer = new List<Ingredient>();
      for(var key in ingredients.keys){
        ingredientsBuffer.add(new Ingredient(
          id: key,
          name: ingredients[key]['name'],
          amount: ingredients[key]['amount'],
          unit: ingredients[key]['unit'],
        ));
      }
      this.ingredients = ingredientsBuffer;
    }
  }
  String get strength {
    if(this.alcoholContent != null){
      if (this.alcoholContent < 10){
        return Strength.Light.toString().split('.').last;
      } else if (this.alcoholContent > 10 && this.alcoholContent < 20){
        return Strength.Medium.toString().split('.').last;
      } else {
        return Strength.Strong.toString().split('.').last;
      }
    }
    return null;
  }

  Cocktail.fromFirebaseSnapshot(String id, var snapshot){
    this.id = id;
    this.name = snapshot['name'];
    this.imageUrl = snapshot.containsKey('imageUrl') ? snapshot['imageUrl'] : null;
    this.about = snapshot.containsKey("about") ? snapshot['about'] : null;
    this.flavor = snapshot.containsKey("flavor") ? snapshot['flavor'] : null;
    this.alcoholContent = snapshot.containsKey("alcoholContent") ? snapshot['alcoholContent'] : 0;
    this.origin = snapshot.containsKey('origin') ? snapshot['origin'] : null;
    
    final snapshotIngredients = snapshot.containsKey("ingredients") ? snapshot['ingredients'] : null;
    if(snapshotIngredients != null){
      snapshotIngredients.forEach((id, amount) {
        this.ingredientsIds.add(id);
        final ingredient = getIngredientById(id);
        final parts = amount.toString().split(' ');
        if(ingredient != null){
          this.ingredients.add(new Ingredient(
            id: id,
            name: ingredient.name,
            amount: double.tryParse(parts[0].trim()),
            unit: parts[1].trim(),
          ));
        }
      });
    }

    if(snapshot.containsKey("prepSteps")){
      this.prepSteps = snapshot['prepSteps'].cast<String>();
    } else {
      if(snapshot.containsKey("defaultPrepStep")){
        this.defaultPrepStep = DefaultPrepStep.values.firstWhere((e) => describeEnum(e) == snapshot['defaultPrepStep']);
        this.prepSteps = this.defaultPrepStep.value;
      } else {
        this.prepSteps = [];
      }
    }

  }
}

class CommunityCocktail extends Cocktail{
  String id;
  String name;
  String originalCocktailId;
  String notes;
  String authorName;
  String authorId;
  bool isPublic;
  List<Ingredient> ingredients = <Ingredient>[];
  List<String> prepSteps;
  String imageUrl;
  DateTime createdAt;
  // int strength;

  CommunityCocktail({
    this.id,
    this.name,
    this.originalCocktailId,
    this.ingredients,
    this.prepSteps,
    this.isPublic = false,
    this.notes = "",
    this.imageUrl,
  });

  CommunityCocktail.fromFirebaseSnapshot(String id, Map<String, dynamic> snapshot){
    this.id = id;
    this.name = snapshot['name'];
    this.imageUrl = snapshot['imageUrl'];
    this.notes = snapshot.containsKey("notes") ? snapshot['notes'] : null;
    this.prepSteps = snapshot.containsKey("prepSteps") ? snapshot['prepSteps'].cast<String>() : null;
    this.authorName = snapshot.containsKey("authorName") ? snapshot['authorName'] : null;
    this.authorId = snapshot.containsKey("authorId") ? snapshot['authorId'] : null;
    this.isPublic = snapshot.containsKey("public") ? snapshot['public'] : false;
    this.createdAt = snapshot.containsKey("createdAt") ? DateTime.parse(snapshot['createdAt']) : DateTime.utc(2021, 4, 1);
    if(snapshot.containsKey("ingredients")){
      final snapshotIngredients = snapshot['ingredients'];
      snapshotIngredients.forEach((ing) {
        Ingredient newIng = new Ingredient(
          id: ing['id'],
          name: ing['name'],
          amount: ing['amount'] is double ? ing['amount'] : double.parse(ing['amount']),
          unit: ing['unit']
        );

        this.ingredients.add(newIng);
      });
    }
    // ingredients: snapshot.containsKey("ingredients") ? snapshot['ingredients'].cast<Ingredient>() : null,
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = name;
    data['originalCocktailId'] = originalCocktailId;
    data['notes'] = notes;
    data['public'] = isPublic;
    data['imageUrl'] = imageUrl;
    data['authorName'] = authorName;
    data['authorId'] = authorId;
    data['createdAt'] = createdAt.toIso8601String();
    if(prepSteps != null){
      data['prepSteps'] = List<String>.generate(prepSteps.length, (i) => prepSteps[i]);
    }
    data['ingredients'] = [];
    for(var ing in ingredients){
      data['ingredients'].add(ing.toJson());
    }
    return data;
  } 

}