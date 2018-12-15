import 'dart:async';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class DeviceStorage {
  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<File> get _localJson async {
    final path = await _localPath;
    return File('$path/48G1.json');
  }

  Future<String> readJson() async {
    try {
      final file = await _localJson;
      String contents = await file.readAsString();
      return contents;
    } catch (e) {
      return null;
    }
  }

  Future<File> writeJson(String content) async {
    final file = await _localJson;
    return file.writeAsString(content);
  }
}
