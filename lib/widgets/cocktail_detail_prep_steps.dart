import 'package:flutter/material.dart';

class CocktailDetailPrepSteps extends StatelessWidget {
  final prepSteps;

  const CocktailDetailPrepSteps(this.prepSteps);

  @override
  Widget build(BuildContext context) {
    final textThemes = Theme.of(context).textTheme;

    return Column(
      children: prepSteps
        .map<Widget>(
          (step) => Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 1,
                  blurRadius: 1,
                  offset: Offset(0, 1), // changes position of shadow
                ),
              ],
              color: Colors.white,
            ),
            width: double.infinity,
            margin:
              const EdgeInsets.symmetric(vertical: 3, horizontal: 20),
            padding: const EdgeInsets.symmetric(
              vertical: 10, horizontal: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Step #${(prepSteps.indexOf(step)+1).toString()}", style: textThemes.overline),
                SizedBox(height: 5),
                Text(step),
              ])),
        )
        .toList(),
    );
  }
}
