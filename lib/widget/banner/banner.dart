//
//

import 'package:flutter/material.dart';

class ShowMaterialBanner extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    print('ShowMaterialBanner build ');
    var messenger = ScaffoldMessenger.of(context);
    messenger.showMaterialBanner(
      MaterialBanner(
        content: Text('This is a MaterialBanner'),
        actions: <Widget>[
          TextButton(
            child: Text('DISMISS'),
            onPressed: () {
              messenger.removeCurrentMaterialBanner();
            },
          ),
        ],
      ),
    );
    return Container();
  }
}
