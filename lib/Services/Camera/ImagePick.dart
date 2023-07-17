import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class picker extends StatefulWidget {
  const picker({Key? key}) : super(key: key);

  @override
  State<picker> createState() => _pickerState();
}

class _pickerState extends State<picker> {
  File? _imageFile;

  Future<void> _pickImageFromGallery() async {
    final pickedImage = await ImagePicker().getImage(source: ImageSource.gallery);
    setState(() {
      if (pickedImage != null) {
        _imageFile = File(pickedImage.path);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    throw UnimplementedError();
  }
}
