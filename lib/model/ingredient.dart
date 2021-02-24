import 'package:flutter/foundation.dart';

class Ingredient {
  String id;
  String name;
  String unit;
  String amount;
  String type;  // base spirit, bitter, etc
  String imageUrl;
  bool _inMybar = false;
  
  Ingredient({
    @required this.id,
    @required this.name,
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
    amount = "0";
  }

  Ingredient.fromFirebaseSnapshot(String id, var snapshot){
    this.id = id;
    this.name = snapshot['name'];
    // this.imageUrl = snapshot['imageUrl'];
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

  @override
    String toString() {
      String data = this.id + this.name;
      return data;
    }
}