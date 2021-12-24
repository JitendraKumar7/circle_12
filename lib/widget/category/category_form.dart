import 'dart:convert';

import 'package:circle/app/app.dart';
import 'package:circle/business/profile.dart';
import 'package:circle/modal/modal.dart';
import 'package:circle/widget/future/widget_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CategoryForm extends StatefulWidget {
  final ValueChanged<String?> onChanged;
  final String? selectedItem;

  final double top;
  final double left;
  final double right;
  final double bottom;
  final bool editable;

  CategoryForm({
    Key? key,
    this.top = 0.0,
    this.left = 12.0,
    this.right = 12.0,
    this.bottom = 18.0,
    this.selectedItem,
    this.editable = false,
    required this.onChanged,
  }) : super(key: key);

  @override
  State<CategoryForm> createState() => _CategoryState();
}

class _CategoryState extends State<CategoryForm> {
  @override
  void initState() {
    super.initState();

    Future.delayed(Duration.zero, () async {
      final response = await rootBundle.loadString('assets/json/category.json');
      List<String> _options =
          (jsonDecode(response) as List).map<String>((e) => e).toList();
      setState(() => print('assets/json/category.json'));

      await Future.forEach(_options, (String e) async {
        // var id = e.replaceAll('/', '-');
        // await db.category.doc(id).set(CategoryModal(e));
      });
    });
  }

  String? result;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        result = widget.editable
            ? await Navigator.push(context, AddCategoryPage.page())
            : null;
        if (result != null) {
          widget.onChanged(result);
          setState(() => print('$result'));
        }
      },
      child: EditTextForm(
        'Business Category',
        result ?? widget.selectedItem,
        onChanged: widget.onChanged,
        bottom: widget.bottom,
        right: widget.right,
        left: widget.left,
        top: widget.top,
        readOnly: true,
        decoration: widget.editable
            ? InputDecoration(
                suffixIcon: Icon(Icons.arrow_drop_down),
                labelText: 'Business Category',
                helperText: '',
                filled: true,
                fillColor: Colors.blue[50],
              )
            : null,
      ),
    );
  }
}

class AddCategoryPage extends StatelessWidget {
  static Route<String> page() {
    return MaterialPageRoute(builder: (_) => AddCategoryPage());
  }

  final controller = TextEditingController();
  final db = FirestoreService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Search Category')),
      body: FutureWidgetBuilder(
        future: db.category.get(),
        builder: (QuerySnapshot<CategoryModal>? snapshot) {
          List<String> list2 =
              snapshot!.docs.map((e) => e.get('name') as String).toList();
          var list1 = list2;
          return StatefulBuilder(builder: (_, setState) {
            return Column(children: [
              Container(
                child: TextFormField(
                  controller: controller,
                  decoration: InputDecoration(hintText: 'Search...'),
                  onChanged: (value) {
                    list1 = [];
                    if (value.isEmpty) {
                      list1 = list2;
                    }
                    // search offers
                    else {
                      list2.forEach((e) {
                        bool name =
                            e.toLowerCase().contains(value.toLowerCase());

                        if (name) list1.add(e);
                      });
                    }
                    setState(() => print('category'));
                  },
                ),
                padding: EdgeInsets.all(12),
              ),
              list1.isEmpty
                  ? Container(
                      child: ElevatedButton(
                        onPressed: () async {
                          var text = controller.text;
                          if (text.isNotEmpty) {
                            var id = text.replaceAll('/', '-');
                            await db.category.doc(id).set(CategoryModal(text));
                            Navigator.pop(context, '$text');
                          }
                        },
                        child: Text('Add'),
                      ),
                    )
                  : Expanded(
                      child: ListView(
                          children: list1
                              .map((name) => Column(children: [
                                    ListTile(
                                      onTap: () =>
                                          Navigator.pop(context, '$name'),
                                      title: Text('$name'),
                                    ),
                                    Divider(thickness: 1),
                                  ]))
                              .toList()),
                    ),
            ]);
          });
        },
      ),
    );
  }
}
