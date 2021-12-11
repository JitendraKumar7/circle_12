import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';

class ImageCropPicker {
  final picker = ImagePicker();

  Future<File?> pickImage({required bool isCamera}) async {
    var source = isCamera ? ImageSource.camera : ImageSource.gallery;
    //var device = isCamera ? CameraDevice.rear : CameraDevice.front;
    var pickedFile = await picker.pickImage(source: source);

    //sharing -- inside app
    //
    // business whatsapp
    // list share on whats app view list
    //
    // member link share
    /*
       aspectRatioPresets: Platform.isAndroid
          ? [
          CropAspectRatioPreset.square,
          CropAspectRatioPreset.ratio3x2,
          CropAspectRatioPreset.original,
          CropAspectRatioPreset.ratio4x3,
          CropAspectRatioPreset.ratio16x9
          ]
          : [
          CropAspectRatioPreset.original,
          CropAspectRatioPreset.square,
          CropAspectRatioPreset.ratio3x2,
          CropAspectRatioPreset.ratio4x3,
          CropAspectRatioPreset.ratio5x3,
          CropAspectRatioPreset.ratio5x4,
          CropAspectRatioPreset.ratio7x5,
          CropAspectRatioPreset.ratio16x9
          ],
      */
    if (pickedFile == null) return null;
    return await ImageCropper.cropImage(
      aspectRatioPresets: [
        CropAspectRatioPreset.square,
        CropAspectRatioPreset.original,
        CropAspectRatioPreset.ratio3x2,
        CropAspectRatioPreset.ratio4x3,
        CropAspectRatioPreset.ratio16x9
      ],
      androidUiSettings: AndroidUiSettings(
        toolbarTitle: 'Cropper',
        //toolbarColor: Colors.deepOrange,
        //toolbarWidgetColor: Colors.white,
        initAspectRatio: CropAspectRatioPreset.original,
        lockAspectRatio: false,
      ),
      iosUiSettings: IOSUiSettings(
        title: 'Cropper',
      ),
      sourcePath: pickedFile.path,
    );
  }
}

Future<bool> ImagePickerDialog(BuildContext context) async {
  var picker = ImageCropPicker();
  return await showDialog(
    context: context,
    builder: (context) =>
        AlertDialog(content: Text('What Do you want?'), actions: [
      TextButton(
          child: Text('Take From Camera', style: TextStyle(color: Colors.grey)),
          onPressed: () async {
            var file = await picker.pickImage(isCamera: true);
            Navigator.pop(context, file);
          }),
      TextButton(
          child: Text('Take From Gallery', style: TextStyle(color: Colors.blue)),
          onPressed: () async {
            var file = await picker.pickImage(isCamera: false);
            Navigator.pop(context, file);
          })
    ]),
  );
}
