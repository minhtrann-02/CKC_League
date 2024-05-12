import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImagePickerExample extends StatefulWidget {
  @override
  _ImagePickerExampleState createState() => _ImagePickerExampleState();
}

class _ImagePickerExampleState extends State<ImagePickerExample> {
  File? _image;

  Future<void> _pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: source);

    setState(() {
      _image = File(pickedImage!.path);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Image Picker Example'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            if (_image != null) Image.file(_image!),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => _pickImage(ImageSource.camera),
              child: Text('Chụp ảnh'),
            ),
            SizedBox(height: 8),
            ElevatedButton(
              onPressed: () => _pickImage(ImageSource.gallery),
              child: Text('Chọn ảnh từ thư viện'),
            ),
          ],
        ),
      ),
    );
  }
}
