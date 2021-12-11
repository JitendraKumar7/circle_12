import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';

FirebaseStorage _instance = FirebaseStorage.instance;

class StorageService {
  Future<String> uploadImage({
    required File file,
    String? path,
    String? name,
  }) async {
    Reference reference = _instance.ref('Messages');

    var fileName = file.path.split('/').last;
    reference = reference.child(name == null ? fileName : '$name.jpg');

    await reference.putFile(file);
    return await reference.getDownloadURL();
  }

}
