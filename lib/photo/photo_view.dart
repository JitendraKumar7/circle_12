import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

class PhotoViewer extends StatelessWidget {

  static Route<String> page(String url) {
    return MaterialPageRoute(builder: (_) => PhotoViewer(url));
  }

  final String url;

  const PhotoViewer(
    this.url, {
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('View'.toUpperCase())),
        body: PhotoView(
          imageProvider: NetworkImage(url),
        ));
  }
}
