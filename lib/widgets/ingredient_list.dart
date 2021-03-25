import 'dart:core';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:fraction/fraction.dart';

class IngredientList extends StatefulWidget {
  final ingredients;

  IngredientList(this.ingredients);

  @override
  _IngredientListState createState() => _IngredientListState();
}

class _IngredientListState extends State<IngredientList> {

  @override
  Widget build(BuildContext context) {
    final ingreidentsList = widget.ingredients;  
    return Container(
      padding: const EdgeInsets.all(10),
      child: ListView.separated(
        separatorBuilder: (context, index) {
          return Divider();
        },
        itemCount: ingreidentsList.length,
        itemBuilder: (ctx, idx) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(ingreidentsList[idx].name),
              Text("${Fraction.fromDouble(ingreidentsList[idx].amount).toString()} ${ingreidentsList[idx].unit}"),
            ],
          );
        },           
      ),
    );
      // }
    // );
  }
}