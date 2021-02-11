import 'package:flutter/foundation.dart';

class Ingredient {
  String name;
  String unit;
  num amount;

  Ingredient({
    @required this.name,
    this.unit,
    this.amount
  });


}