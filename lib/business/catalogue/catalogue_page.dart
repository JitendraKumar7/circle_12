import 'package:circle/app/app.dart';
import 'package:circle/modal/modal.dart';
import 'package:circle/photo/photo_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CataloguePage extends StatefulWidget {
  @override
  State<CataloguePage> createState() => _CataloguePageState();
}

class _CataloguePageState extends State<CataloguePage> {
  List<String> businessCatalogue = [];

  @override
  void initState() {
    super.initState();

    Future.delayed(Duration.zero, () {
      var args = ModalRoute.of(context)?.settings.arguments;
      businessCatalogue = args as List<String>;
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    var profile = context.read<ProfileModal>();
    return Scaffold(
      appBar: AppBar(title: Text('Catalogue'.toUpperCase())),
      body: Column(children: [
        Expanded(
            child: GridView(
                padding: EdgeInsets.all(12),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisSpacing: 6,
                    mainAxisSpacing: 6,
                    crossAxisCount: 3,
                    childAspectRatio: 0.9),
                children: [
              ...businessCatalogue
                  .map((src) => src == 'loading'
                      ? Center(child: CupertinoActivityIndicator())
                      : Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(6),
                              border: Border.all()),
                          clipBehavior: Clip.hardEdge,
                          alignment: Alignment.center,
                          child: Stack(children: [
                            InkWell(
                                onTap: () => Navigator.push(
                                    context, PhotoViewer.page(src)),
                                child: Image.network(src, fit: BoxFit.contain)),
                            Positioned.fill(
                                child: Align(
                              alignment: Alignment.topRight,
                              child: InkWell(
                                onTap: () => setState(
                                    () => businessCatalogue.remove(src)),
                                child: Icon(
                                  Icons.delete,
                                  color: Colors.blue,
                                ),
                              ),
                            ))
                          ]),
                        ))
                  .toList()
            ])),
        if (9 > businessCatalogue.length)
          Container(
            alignment: Alignment.centerRight,
            padding: EdgeInsets.only(right: 12),
            child: ElevatedButton(
              onPressed: () async {
                var picker = ImageCropPicker();
                var file = await picker.pickImage(isCamera: false);
                if (file != null) {
                  setState(() => businessCatalogue.add('loading'));
                  var storage = StorageService();
                  var photo = await storage.uploadImage(
                    upload: Upload.CATALOGUE,
                    path: profile.id,
                    file: file,
                  );
                  businessCatalogue.removeWhere((e) => e == 'loading');
                  businessCatalogue.add(photo);
                  setState(() => print('done'));
                }
              },
              style: ElevatedButton.styleFrom(
                  textStyle: const TextStyle(fontSize: 18),
                  padding: EdgeInsets.all(12),
                  shape: CircleBorder(),
                  primary: Colors.orange),
              child: Icon(Icons.add),
            ),
          ),
        Container(
          padding: EdgeInsets.all(12),
          child: ElevatedButton(
            onPressed: () => Navigator.pop(context, businessCatalogue),
            style: ElevatedButton.styleFrom(
                textStyle: const TextStyle(fontSize: 18),
                padding: EdgeInsets.all(12),
                minimumSize: Size(180, 45),
                primary: Colors.blue[300]),
            child: Text('UPDATE'),
          ),
        ),
      ]),
    );
  }
}
