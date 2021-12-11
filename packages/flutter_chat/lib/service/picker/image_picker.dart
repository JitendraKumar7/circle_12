import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';

class ImageCropPicker {
  final picker = ImagePicker();

  Future<File?> pickImage({required bool isCamera}) async {
    var source = isCamera ? ImageSource.camera : ImageSource.gallery;
    //var device = isCamera ? CameraDevice.rear : CameraDevice.front;
    var pickedFile = await picker.pickImage(source: source);

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
        initAspectRatio: CropAspectRatioPreset.original,
        lockAspectRatio: false,
      ),
      iosUiSettings: IOSUiSettings(
        title: 'Cropper',
      ),
      sourcePath: pickedFile.path,
    );
  }

  Future<File?> pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowedExtensions: ['pdf', '.pdf'],
      type: FileType.custom,
    );

    if (result == null) return null;
    if (result.files.single.path!.endsWith('.pdf'))
      return File(result.files.single.path!);
    return null;
  }
}
