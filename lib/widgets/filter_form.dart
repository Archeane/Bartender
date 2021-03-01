import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class FilterForm extends StatefulWidget {
  final void Function() sort;

  FilterForm(this.sort);

  @override
  _FilterFormState createState() => _FilterFormState();
}

enum SortMethod {
  Alphabetical,
  Strength,
}

enum FilterMethod { // multi selects
  Strength,
  Ingredients,
}

class _FilterFormState extends State<FilterForm> {
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  

  void _trySubmit() {
    final isValid = _formKey.currentState.validate();
    FocusScope.of(context).unfocus();

    if (isValid) {
      _formKey.currentState.save();
      widget.sort();
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Card(
        elevation: 5,
        child: Container(
          padding: EdgeInsets.only(
            top: 10,
            left: 10,
            right: 10,
            bottom: MediaQuery.of(context).viewInsets.bottom + 10,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              TextField(
                decoration: InputDecoration(labelText: 'Title'),
                controller: _titleController,
    
              ),
              TextField(
                decoration: InputDecoration(labelText: 'Amount'),
                controller: _amountController,
                keyboardType: TextInputType.number,
                
              ),
              
              RaisedButton(
                child: Text('Add Transaction'),
                color: Theme.of(context).primaryColor,
                textColor: Theme.of(context).textTheme.button.color,
                onPressed: widget.sort,
              ),
            ],
          ),
        ),
      ),
    );
  }
}