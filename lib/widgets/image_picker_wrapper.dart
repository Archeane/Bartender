

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImagePickerWrapper extends StatefulWidget {
  final void Function(File pickedImage) imagePickFn;

  ImagePickerWrapper(this.imagePickFn);

  @override
  _ImagePickerWrapperState createState() => _ImagePickerWrapperState();
}

class _ImagePickerWrapperState extends State<ImagePickerWrapper> {

  File _image;

  void _imgFromCamera() async {
    final picker = ImagePicker();
    PickedFile image = await picker.getImage(
      source: ImageSource.camera
    );
    setState(() => _image = File(image.path));
    widget.imagePickFn(_image);
  }

  void _imgFromGallery() async {
    final picker = ImagePicker();
    PickedFile image = await picker.getImage(
      source: ImageSource.gallery
    );
    setState(() => _image = File(image.path));
    widget.imagePickFn(_image);
  }

  void _showPicker(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Container(
              child: new Wrap(
                children: <Widget>[
                  new ListTile(
                      leading: new Icon(Icons.photo_library),
                      title: new Text('Photo Library'),
                      onTap: () {
                        _imgFromGallery();
                        Navigator.of(context).pop();
                      }),
                  new ListTile(
                    leading: new Icon(Icons.photo_camera),
                    title: new Text('Camera'),
                    onTap: () {
                      _imgFromCamera();
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
          );
        }
      );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
       child: Column(
         children: [
           CircleAvatar(
              radius: 80,
              backgroundColor: Colors.white,
              backgroundImage:
                  _image != null ? FileImage(_image) : null,
            ),
            FlatButton.icon(
              onPressed: () => _showPicker(context),
              icon: Icon(Icons.image, color: Colors.black87,),
              label: Text('Add Image', style: TextStyle(color: Colors.black87)),
            ),
         ],
       ),
        
    );
  }
}

