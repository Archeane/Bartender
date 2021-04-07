import 'dart:io';

import 'package:bartender/widgets/image_picker_wrapper.dart';
import 'package:flutter/material.dart';

class ReceipeImagePicker extends StatefulWidget {
  ReceipeImagePicker(this.imagePickFn, this._saveCocktailName);

  final void Function(File pickedImage) imagePickFn;
  final void Function(String name) _saveCocktailName;

  @override
  _ReceipeImagePickerState createState() => _ReceipeImagePickerState();
}

class _ReceipeImagePickerState extends State<ReceipeImagePicker> {

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      ImagePickerWrapper(widget.imagePickFn),
      SizedBox(width: 10,),
      Expanded(
          child: TextFormField(
              cursorColor: Colors.black,
              autocorrect: true,
              // initialValue: _customCocktail.name,
              decoration: InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                  border: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Colors.black87),
                      borderRadius:
                          BorderRadius.circular(5)),
                  hintText: "Add a Name..."),
              validator: (value) {
                if (value.isEmpty) {
                  return 'Please provide a name.';
                }
                return null;
              },
              style: TextStyle(fontSize: 16),
              onSaved: (val) => widget._saveCocktailName(val)
          ),
        ),
    ]);
  }
}
