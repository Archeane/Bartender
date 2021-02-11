import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class IngredientSlider extends StatelessWidget {

  final double amount;

  const IngredientSlider(this.amount);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: CupertinoSlider(value: amount,),
    );
  }
}