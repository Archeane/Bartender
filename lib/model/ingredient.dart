import 'package:flutter/foundation.dart';

class Ingredient {
  String id;
  String name;
  String unit;
  num amount;
  num alcoholContent;
  String type;  // base spirit, bitter, etc
  String imageUrl;
  String about;
  String origin;
  bool _inMybar = false;
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
  }

  Ingredient.fromFirebaseSnapshot(String id, var snapshot){
    this.id = id;
    this.name = snapshot['name'];
    this.type = snapshot.containsKey('type') ? snapshot['type'] : null;
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

  get inMyBar => _inMybar;
  set inMyBar(bool val) => _inMybar = val;
  get inMyShoppingList => _inMyShoppingList;
  set inMyShoppingList(bool val) => _inMyShoppingList = val;

  @override
    String toString() {
      String data = this.id + this.name;
      return data;
    }
}