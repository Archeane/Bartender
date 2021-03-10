import 'package:bartender/model/ingredient.dart';
import 'package:bartender/firebase_util.dart';

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
  String about;
  int alcoholContent;
  String flavor;
  List<Ingredient> ingredients = new List<Ingredient>();
  List<String> prepSteps;
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
    List<dynamic> prepSteps,
    int alcoholContent,
    Map ingredients,
  }){
    if(prepSteps != null){
      this.prepSteps = prepSteps.map((s) => s as String).toList();
    }
    if(alcoholContent == null) this.alcoholContent = 5;
    else this.alcoholContent = alcoholContent;
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
    this.prepSteps = snapshot.containsKey("prepSteps") ? snapshot['prepSteps'].cast<String>() : null;
    this.flavor = snapshot.containsKey("flavor") ? snapshot['flavor'] : null;
    this.alcoholContent = snapshot.containsKey("alcoholContent") ? snapshot['alcoholContent'] : null;
    final snapshotIngredients = snapshot.containsKey("ingredients") ? snapshot['ingredients'] : null;
    if(snapshotIngredients != null){
      snapshotIngredients.forEach((id, amount) {
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
  }

}

class CommunityCocktail extends Cocktail{
  String id;
  String name;
  String originalCocktailId;
  String notes;
  bool isPublic;
  List<Ingredient> ingredients;
  List<String> prepSteps;
  String imageUrl;
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

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = name;
    data['originalCocktailId'] = originalCocktailId;
    data['notes'] = notes;
    data['public'] = isPublic;
    data['imageUrl'] = imageUrl;
    data['prepSteps'] = List<String>.generate(prepSteps.length, (i) => prepSteps[i]);
    data['ingredients'] = [];
    for(var ing in ingredients){
      data['ingredients'].add(ing.toJson());
    }
    return data;
  } 
}