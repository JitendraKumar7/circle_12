import 'dart:io';

import 'package:excel/excel.dart';
import 'package:file_picker/file_picker.dart';

class ExcelPicker {
  Future<FilePickerResult?> filePicker() async =>
      await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowMultiple: true,
        allowedExtensions: ['xlsx', 'csv', 'xls'],
        onFileLoading: (value) => print('status $value'),
      );

  Future<List<Map<String, dynamic>>> excelToJson() async {
    var result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['xlsx', 'csv', 'xls'],
    );
    if (result != null && result.files.isNotEmpty) {
      var fileBytes = result.files.single.bytes;
      fileBytes ??= File(result.files.single.path!).readAsBytesSync();
      var excel = Excel.decodeBytes(fileBytes);
      int i = 0;
      List keys = [];
      List<Map<String, dynamic>> json = [];
      for (var table in excel.tables.keys) {
        for (var row in excel.tables[table]?.rows ?? []) {
          try {
            if (i == 0) {
              keys = row;
              i++;
            } else {
              var temp = <String, dynamic>{};
              int j = 0;
              String tk = '';
              for (var key in keys) {
                tk = key.value;
                temp[tk.trim()] = (row[j].runtimeType == String)
                    ? '\u201C' + row[j].value + '\u201D'
                    : row[j].value;
                j++;
              }
              json.add(temp);
            }
          } catch (ex) {
            print(ex);
          }
        }
      }
      return json;
    }
    return [];
  }

  Future<List<Map<String, dynamic>>> fileToJson(PlatformFile file) async {
    var fileBytes = file.bytes;
    fileBytes ??= File(file.path!).readAsBytesSync();
    var excel = Excel.decodeBytes(fileBytes);
    int i = 0;
    List keys = [];
    List<Map<String, dynamic>> json = [];
    for (var table in excel.tables.keys) {
      for (var row in excel.tables[table]?.rows ?? []) {
        try {
          if (i == 0) {
            keys = row;
            i++;
          } else {
            var temp = <String, dynamic>{};
            int j = 0;
            String tk = '';
            for (var key in keys) {
              tk = key.value;
              temp[tk] = (row[j].runtimeType == String)
                  ? '\u201C' + row[j].value + '\u201D'
                  : row[j].value;
              j++;
            }
            json.add(temp);
          }
        } catch (ex) {
          print(ex);
        }
      }
    }
    return json;
  }
}
