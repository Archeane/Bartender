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
    final picker = ImagePicker();
    final pickedImageFile = await picker.getImage(
      source: ImageSource.camera,
      // imageQuality: 50,
      maxWidth: 150,
    );
    setState(() {
      _pickedImage = File(pickedImageFile.path);
    });
    widget.imagePickFn(_pickedImage);
  }

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      Column(
        children: <Widget>[
          Container(
            child: CircleAvatar(
              backgroundColor: Colors.white,
              radius: 60,
              child: _pickedImage != null ? Image(image: FileImage(_pickedImage)) : null
            ) 
          ),
          TextButton(
            onPressed: _pickImage,
            child: const Text('Add Image', style: TextStyle(color: Colors.redAccent)),
          ),
        ],
      ),
      SizedBox(width: 10,),
      Expanded(
          child: TextFormField(
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
