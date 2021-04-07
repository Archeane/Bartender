import 'package:flutter/material.dart';

class PrepstepInputList extends StatelessWidget {
  final List<String> _prepStepsList;
  final Function _deleteStep;
  final Function _addPrepStep;

  const PrepstepInputList(this._prepStepsList, this._deleteStep, this._addPrepStep);

  @override
  Widget build(BuildContext context) {
    final textThemes = Theme.of(context).textTheme;

    return Column(
      children: [
        Container(
          margin: const EdgeInsets.symmetric(vertical: 10),
          child: Text("Prepreation Steps",
              style: textThemes.headline6)),
        Container(
          height: 50.0 * _prepStepsList.length,
          child: ListView.builder(
            itemCount: _prepStepsList.length,
            itemBuilder: (context, index) => Container(
              constraints: BoxConstraints(maxHeight: 40, minHeight: 20),
              margin: const EdgeInsets.symmetric(vertical: 5),
              child: Row(
                children: [
                  Text("#${(index+1).toString()}"),
                  SizedBox(width: 6,),
                  Expanded(
                    child: TextFormField(
                      initialValue: _prepStepsList[index],
                      cursorColor: Colors.black,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                        hintText: "Add a step...",
                        border: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.black54),
                            borderRadius: BorderRadius.circular(5)),
                      ),
                      style: TextStyle(fontSize: 16),
                      validator: (value){
                          if(value.isEmpty){
                            return "Please provide a value";
                          }
                          return null;
                        },
                      onSaved: (value) {
                        _prepStepsList[index] = value;
                      },
                    ),
                  ),
                ]
              ),
            )
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
          TextButton.icon(
            icon: Icon(Icons.delete),
            label: Text("Remove Step", style: TextStyle(color: Colors.black87)),
            onPressed: _deleteStep,
          ),
          RaisedButton.icon(
            color: Color(0xFFE4F0E1),
            icon: Icon(Icons.add),
            label: Text("Add Step"),
            onPressed: _addPrepStep,
          ),
        ],)
      ],
    );
  }
}