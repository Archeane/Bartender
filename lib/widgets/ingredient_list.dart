import 'dart:core';
import 'package:bartender/screens/ingredient_detail_screen.dart';
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
    double screenWidth = MediaQuery.of(context).size.width;
    return SingleChildScrollView(
      child: Container(
        width: screenWidth * 2/3,
        child: Card(
          elevation: 2,
          // child: IngredientList(cocktailData.ingredients)
          child: Column(children: ingreidentsList.map<Widget>((ing) => 
            Column(
              children: [
                if(ing.id != ingreidentsList[0].id)
                  Divider(height: 0),
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: GestureDetector(
                    onTap: (){
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => IngredientDetailScreen(ing.id)),
                      );
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(ing.name),
                        Text("${Fraction.fromDouble(ing.amount).toString()} ${ing.unit}"),
                      ],
                    ),
                  ),
                ),
              ]
            )).toList(),
          )
        ),
      ),
    );
   /* return Container(
      padding: const EdgeInsets.all(10),
      child: ListView.separated(
        separatorBuilder: (context, index) {
          return Divider();
        },
        itemCount: ingreidentsList.length,
        itemBuilder: (ctx, idx) {
          return Card(
            elevation: 2,
            // child: IngredientList(cocktailData.ingredients)
            child: Column(children: ingreidentsList.map((ing) => 
              Column(
                children: [
                  if(ing.id != ingreidentsList[0].id)
                    Divider(height: 0),
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: GestureDetector(
                      onTap: (){
                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (_) => IngredientDetailScreen(ing.id)),
                        );
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(ing.name),
                          Text("${Fraction.fromDouble(ing.amount).toString()} ${ing.unit}"),
                        ],
                      ),
                    ),
                  ),
                ]
              )).toList(),
            )
          );
          
          // Row(
          //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //   children: [
          //     Text(ingreidentsList[idx].name),
          //     Text("${Fraction.fromDouble(ingreidentsList[idx].amount).toString()} ${ingreidentsList[idx].unit}"),
          //   ],
          // );
        },           
      ),
    );
      // }
    // );*/
  }
}