import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ReceipeImagePicker extends StatefulWidget {
  ReceipeImagePicker(this.imagePickFn, this._saveCocktailName);

  final void Function(File pickedImage) imagePickFn;
  final void Function(String name) _saveCocktailName;

  @override
  _ReceipeImagePickerState createState() => _ReceipeImagePickerState();
}

class _ReceipeImagePickerState extends State<ReceipeImagePicker> {
  File _pickedImage;

  void _pickImage() async {
    final pickedImageFile = await ImagePicker.pickImage(
      source: ImageSource.camera,
      imageQuality: 50,
      maxWidth: 150,
    );
    setState(() {
      _pickedImage = pickedImageFile;
    });
    widget.imagePickFn(pickedImageFile);
  }

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      Column(
        children: <Widget>[
          Container(
            child: _pickedImage != null ? Image(image: FileImage(_pickedImage)) : null,
          ),
          FlatButton(
            textColor: Theme.of(context).primaryColor,
            onPressed: _pickImage,
            child: const Text('Add Image'),
          ),
        ],
      ),
      Expanded(
          flex: 2,
          child: TextFormField(
              // initialValue: _customCocktail.name,
              decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Colors.black54),
                      borderRadius:
                          BorderRadius.circular(5)),
                  hintText: "Receipe Name"),
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
