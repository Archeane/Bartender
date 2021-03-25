import 'package:bartender/model/cocktail.dart';
import 'package:flutter/foundation.dart';

enum IngredientType {
  spirit,
  liqueur,
  bitter,
  wine,
  beverage,
  syrup,
  fruit,
  juice,
  basic,
  dairy,
  condiment,
}

class Ingredient {
  String id;
  String name;
  String unit;
  num amount;
  num alcoholContent;
  IngredientType type;  
  String imageUrl;
  String about;
  String origin;
  bool _inMyShoppingList = false; 

  Ingredient({
    @required this.id,
    @required this.name,
    this.type,
    this.imageUrl,
    this.about,
    this.origin,
    this.alcoholContent,
    this.unit,
    this.amount
  });

  Ingredient.shopping(){
    id = "";
    name = "water";
  }

  Ingredient.empty(){
    id = "";
    name = "select ingredient..";
    unit = "oz";
    amount = 0;
    type = null;
  }

  Ingredient.fromFirebaseSnapshot(String id, var snapshot){
    this.id = id;
    this.name = snapshot['name'];
    if(snapshot.containsKey('type')){
      this.type = IngredientType.values.firstWhere((e) => describeEnum(e) == snapshot['type']); //, orElse: () => null);
    }
    this.alcoholContent = snapshot.containsKey('alcoholContent') ? snapshot['alcoholContent'] : null;
    this.origin = snapshot.containsKey('origin') ? snapshot['origin'] : null;
    this.about = snapshot.containsKey('about') ? snapshot['about'] : null;
    this.imageUrl = snapshot.containsKey('imageUrl') ? snapshot['imageUrl'] : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = id;
    data['name'] = name;
    data['unit'] = unit;
    data['amount'] = amount;
    data['type'] = type;
    data['imageUrl'] = imageUrl;
    return data;
  }

  get inMyShoppingList => _inMyShoppingList;
  set inMyShoppingList(bool val) => _inMyShoppingList = val;

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

  @override
    String toString() {
      String data = this.id + this.name;
      return data;
    }
}